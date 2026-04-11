import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/electricity/models/meter_reading.dart';
import 'package:hms/features/electricity/services/meter_service.dart';

/// Thrown when the user submits a reading lower than the previous one without
/// explicitly confirming a meter reset.
class MeterResetRequiredException implements Exception {
  const MeterResetRequiredException({
    required this.newReading,
    required this.previousReading,
  });

  final double newReading;
  final double previousReading;

  @override
  String toString() =>
      'MeterResetRequiredException: $newReading < $previousReading';
}

class MeterReadingService {
  MeterReadingService(
    this._firestoreService,
    this._meterService,
    this._activityLogService,
  );

  final FirestoreService _firestoreService;
  final MeterService _meterService;
  final ActivityLogService _activityLogService;

  static String _col(String groundId, String unitId) =>
      'grounds/$groundId/rental_units/$unitId/meter_readings';

  // ---------------------------------------------------------------------------
  // Write
  // ---------------------------------------------------------------------------

  /// Records a new meter reading, auto-calculating [unitsConsumed].
  ///
  /// Throws [MeterResetRequiredException] when [newReading] is less than the
  /// previous reading and [confirmReset] is false.
  Future<String> recordReading({
    required String groundId,
    required String unitId,
    required String meterId,
    required double newReading,
    required DateTime readingDate,
    required bool confirmReset,
    String notes = '',
    required String userId,
  }) async {
    // 1. Determine previous reading.
    final latest = await getLatestReading(
      groundId: groundId,
      unitId: unitId,
      meterId: meterId,
    );
    double previousReading;
    if (latest != null) {
      previousReading = latest.reading;
    } else {
      final meter = await _meterService.getActiveMeter(groundId, unitId);
      previousReading = meter?.initialReading ?? 0;
    }

    // 2. Handle meter reset case.
    final bool isReset = newReading < previousReading;
    if (isReset && !confirmReset) {
      throw MeterResetRequiredException(
        newReading: newReading,
        previousReading: previousReading,
      );
    }

    // 3. Calculate consumption.
    // On reset, treat the new reading itself as units for this period.
    final double unitsConsumed = isReset
        ? newReading
        : newReading - previousReading;

    // 4. Persist the reading.
    final id = await _firestoreService.create(
      collectionPath: _col(groundId, unitId),
      data: {
        'groundId': groundId,
        'unitId': unitId,
        'meterId': meterId,
        'reading': newReading,
        'previousReading': previousReading,
        'unitsConsumed': unitsConsumed,
        'readingDate': readingDate.toIso8601String(),
        'isMeterReset': isReset,
        'notes': notes,
      },
      userId: userId,
    );

    // 5. Update the meter's currentReading and lastReadingDate.
    await _meterService.updateMeter(groundId, unitId, meterId, {
      'currentReading': newReading,
      'lastReadingDate': readingDate.toIso8601String(),
    }, userId);

    // 6. Log the action.
    await _activityLogService.log(
      userId: userId,
      action: 'create',
      module: 'electricity',
      description:
          'Recorded reading $newReading (${unitsConsumed.toStringAsFixed(1)} units consumed) for meter $meterId',
      documentId: id,
      collectionPath: _col(groundId, unitId),
    );

    return id;
  }

  // ---------------------------------------------------------------------------
  // Read
  // ---------------------------------------------------------------------------

  /// Returns the most recent reading for a meter.
  Future<MeterReading?> getLatestReading({
    required String groundId,
    required String unitId,
    required String meterId,
  }) async {
    final all = await getReadings(
      groundId: groundId,
      unitId: unitId,
      meterId: meterId,
      limit: 1,
    );
    return all.isEmpty ? null : all.first;
  }

  /// Returns all readings for a meter, newest first.
  Future<List<MeterReading>> getReadings({
    required String groundId,
    required String unitId,
    required String meterId,
    int? limit,
  }) async {
    final results = await _firestoreService.getAll(
      collectionPath: _col(groundId, unitId),
    );
    var readings = results
        .map((d) => MeterReading.fromJson(_normalize(d)))
        .where((r) => r.meterId == meterId)
        .toList();
    readings.sort((a, b) => b.readingDate.compareTo(a.readingDate));
    if (limit != null && readings.length > limit) {
      readings = readings.sublist(0, limit);
    }
    return readings;
  }

  /// Streams readings for a meter in real time, newest first.
  Stream<List<MeterReading>> streamReadings({
    required String groundId,
    required String unitId,
    required String meterId,
  }) {
    return _firestoreService.stream(collectionPath: _col(groundId, unitId)).map(
      (list) {
        final readings = list
            .map((d) => MeterReading.fromJson(_normalize(d)))
            .where((r) => r.meterId == meterId)
            .toList();
        readings.sort((a, b) => b.readingDate.compareTo(a.readingDate));
        return readings;
      },
    );
  }

  /// Returns readings within a date range (inclusive).
  Future<List<MeterReading>> getReadingsInRange({
    required String groundId,
    required String unitId,
    required String meterId,
    required DateTime start,
    required DateTime end,
  }) async {
    final all = await getReadings(
      groundId: groundId,
      unitId: unitId,
      meterId: meterId,
    );
    return all
        .where(
          (r) => !r.readingDate.isBefore(start) && !r.readingDate.isAfter(end),
        )
        .toList();
  }

  /// Sums [unitsConsumed] for all readings within a date range.
  Future<double> getTotalConsumption({
    required String groundId,
    required String unitId,
    required String meterId,
    required DateTime start,
    required DateTime end,
  }) async {
    final readings = await getReadingsInRange(
      groundId: groundId,
      unitId: unitId,
      meterId: meterId,
      start: start,
      end: end,
    );
    return readings.fold<double>(0, (sum, r) => sum + r.unitsConsumed);
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _normalize(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is DateTime) return MapEntry(key, value.toIso8601String());
      if (value != null && value.runtimeType.toString() == 'Timestamp') {
        return MapEntry(key, (value as dynamic).toDate().toIso8601String());
      }
      return MapEntry(key, value);
    });
  }
}
