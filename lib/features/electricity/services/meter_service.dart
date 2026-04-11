import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/electricity/models/electricity_meter.dart';

class MeterService {
  MeterService(this._firestore, this._activityLog);

  final FirestoreService _firestore;
  final ActivityLogService _activityLog;

  static String _col(String groundId, String unitId) =>
      'grounds/$groundId/rental_units/$unitId/meter_registry';

  static String _unitCol(String groundId) => 'grounds/$groundId/rental_units';

  // ---------------------------------------------------------------------------
  // Write operations
  // ---------------------------------------------------------------------------

  /// Registers a new meter for a unit. Only one active meter per unit is
  /// allowed — any existing active meter is deactivated first.
  Future<String> registerMeter(
    String groundId,
    String unitId,
    ElectricityMeter meter,
    String userId,
  ) async {
    // Deactivate any existing active meter.
    final existing = await getActiveMeter(groundId, unitId);
    if (existing != null) {
      await _firestore.update(
        collectionPath: _col(groundId, unitId),
        documentId: existing.id,
        data: {'isActive': false},
        userId: userId,
      );
    }

    final id = await _firestore.create(
      collectionPath: _col(groundId, unitId),
      data: {
        'groundId': groundId,
        'unitId': unitId,
        'meterNumber': meter.meterNumber,
        'initialReading': meter.initialReading,
        'currentReading': meter.initialReading,
        'weeklyThreshold': meter.weeklyThreshold,
        'isActive': true,
        if (meter.lastReadingDate != null)
          'lastReadingDate': meter.lastReadingDate!.toIso8601String(),
      },
      userId: userId,
    );

    // Sync meterId on the unit document.
    await _firestore.update(
      collectionPath: _unitCol(groundId),
      documentId: unitId,
      data: {'meterId': id},
      userId: userId,
    );

    await _activityLog.log(
      userId: userId,
      action: 'create',
      module: 'electricity',
      description: 'Registered meter "${meter.meterNumber}" for unit $unitId',
      documentId: id,
      collectionPath: _col(groundId, unitId),
    );

    return id;
  }

  /// Updates fields on an existing meter document.
  Future<void> updateMeter(
    String groundId,
    String unitId,
    String meterId,
    Map<String, dynamic> updates,
    String userId,
  ) async {
    await _firestore.update(
      collectionPath: _col(groundId, unitId),
      documentId: meterId,
      data: updates,
      userId: userId,
    );

    await _activityLog.log(
      userId: userId,
      action: 'update',
      module: 'electricity',
      description: 'Updated meter $meterId for unit $unitId',
      documentId: meterId,
      collectionPath: _col(groundId, unitId),
    );
  }

  /// Replaces an old meter with a new one:
  /// 1. Marks the old meter inactive (history preserved).
  /// 2. Registers the new meter as active.
  Future<String> replaceMeter(
    String groundId,
    String unitId,
    String oldMeterId,
    ElectricityMeter newMeter,
    String userId,
  ) async {
    // Mark old meter inactive.
    await _firestore.update(
      collectionPath: _col(groundId, unitId),
      documentId: oldMeterId,
      data: {'isActive': false},
      userId: userId,
    );

    // Register the new meter.
    final newId = await _firestore.create(
      collectionPath: _col(groundId, unitId),
      data: {
        'groundId': groundId,
        'unitId': unitId,
        'meterNumber': newMeter.meterNumber,
        'initialReading': newMeter.initialReading,
        'currentReading': newMeter.initialReading,
        'weeklyThreshold': newMeter.weeklyThreshold,
        'isActive': true,
        if (newMeter.lastReadingDate != null)
          'lastReadingDate': newMeter.lastReadingDate!.toIso8601String(),
      },
      userId: userId,
    );

    // Sync meterId on the unit document.
    await _firestore.update(
      collectionPath: _unitCol(groundId),
      documentId: unitId,
      data: {'meterId': newId},
      userId: userId,
    );

    await _activityLog.log(
      userId: userId,
      action: 'replace',
      module: 'electricity',
      description:
          'Replaced meter $oldMeterId with "${newMeter.meterNumber}" for unit $unitId',
      documentId: newId,
      collectionPath: _col(groundId, unitId),
    );

    return newId;
  }

  /// Updates the weekly consumption alert threshold.
  Future<void> updateThreshold(
    String groundId,
    String unitId,
    String meterId,
    double threshold,
    String userId,
  ) async {
    await updateMeter(groundId, unitId, meterId, {
      'weeklyThreshold': threshold,
    }, userId);
  }

  // ---------------------------------------------------------------------------
  // Read operations
  // ---------------------------------------------------------------------------

  /// Returns the currently active meter for a unit, or null if none.
  Future<ElectricityMeter?> getActiveMeter(
    String groundId,
    String unitId,
  ) async {
    final all = await getAllMeters(groundId, unitId);
    try {
      return all.firstWhere((m) => m.isActive);
    } catch (_) {
      return null;
    }
  }

  /// Streams the active meter in real time.
  Stream<ElectricityMeter?> streamActiveMeter(String groundId, String unitId) {
    return _firestore.stream(collectionPath: _col(groundId, unitId)).map((
      list,
    ) {
      final meters = list
          .map((d) => ElectricityMeter.fromJson(_normalize(d)))
          .toList();
      try {
        return meters.firstWhere((m) => m.isActive);
      } catch (_) {
        return null;
      }
    });
  }

  /// Returns all meters (including inactive history) for a unit.
  Future<List<ElectricityMeter>> getAllMeters(
    String groundId,
    String unitId,
  ) async {
    final results = await _firestore.getAll(
      collectionPath: _col(groundId, unitId),
    );
    final meters = results
        .map((d) => ElectricityMeter.fromJson(_normalize(d)))
        .toList();
    // Sort newest first in memory to avoid Firestore composite index requirements.
    meters.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return meters;
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
