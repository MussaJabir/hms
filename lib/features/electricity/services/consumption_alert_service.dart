import 'package:hms/core/widgets/alert_severity.dart';
import 'package:hms/features/electricity/models/consumption_warning.dart';
import 'package:hms/features/electricity/services/meter_reading_service.dart';
import 'package:hms/features/electricity/services/meter_service.dart';
import 'package:hms/features/grounds/services/ground_service.dart';
import 'package:hms/features/grounds/services/rental_unit_service.dart';

class ConsumptionAlertService {
  ConsumptionAlertService(
    this._meterService,
    this._meterReadingService,
    this._rentalUnitService,
    this._groundService,
  );

  final MeterService _meterService;
  final MeterReadingService _meterReadingService;
  final RentalUnitService _rentalUnitService;
  final GroundService _groundService;

  // ---------------------------------------------------------------------------
  // Threshold check
  // ---------------------------------------------------------------------------

  /// Returns how many units the latest reading is over the meter's threshold.
  /// Returns 0 if the meter has no threshold or the latest reading is within it.
  Future<double> getOverThreshold({
    required String groundId,
    required String unitId,
    required String meterId,
  }) async {
    final meter = await _meterService.getActiveMeter(groundId, unitId);
    if (meter == null || !meter.hasThreshold) return 0;

    final latest = await _meterReadingService.getLatestReading(
      groundId: groundId,
      unitId: unitId,
      meterId: meterId,
    );
    if (latest == null) return 0;

    final over = latest.unitsConsumed - meter.weeklyThreshold;
    return over > 0 ? over : 0;
  }

  // ---------------------------------------------------------------------------
  // Active warnings across grounds / units
  // ---------------------------------------------------------------------------

  /// Returns all units whose latest reading exceeds their meter's threshold.
  /// Filters to [groundId] when provided; otherwise scans all grounds.
  Future<List<ConsumptionWarning>> getActiveWarnings({String? groundId}) async {
    final groundIds = await _resolveGroundIds(groundId);
    final warnings = <ConsumptionWarning>[];

    for (final gId in groundIds) {
      final units = await _rentalUnitService.getAllUnits(gId);
      for (final unit in units) {
        if (unit.meterId == null) continue;

        final meter = await _meterService.getActiveMeter(gId, unit.id);
        if (meter == null || !meter.hasThreshold) continue;

        final latest = await _meterReadingService.getLatestReading(
          groundId: gId,
          unitId: unit.id,
          meterId: meter.id,
        );
        if (latest == null) continue;
        if (latest.unitsConsumed <= meter.weeklyThreshold) continue;

        final severity = classifySeverity(
          threshold: meter.weeklyThreshold,
          actualConsumption: latest.unitsConsumed,
        );

        warnings.add(
          ConsumptionWarning(
            groundId: gId,
            unitId: unit.id,
            unitName: unit.name,
            meterId: meter.id,
            meterNumber: meter.meterNumber,
            threshold: meter.weeklyThreshold,
            actualConsumption: latest.unitsConsumed,
            readingDate: latest.readingDate,
            severity: severity,
          ),
        );
      }
    }

    // Critical first, then warning, then info.
    warnings.sort(
      (a, b) =>
          _severityOrder(a.severity).compareTo(_severityOrder(b.severity)),
    );
    return warnings;
  }

  // ---------------------------------------------------------------------------
  // Spike detection
  // ---------------------------------------------------------------------------

  /// Returns true when the current week's total consumption is more than 50%
  /// above the average of the preceding weeks (up to 8 weeks of history).
  Future<bool> isConsumptionSpike({
    required String groundId,
    required String unitId,
    required String meterId,
  }) async {
    final now = DateTime.now();
    final nineWeeksAgo = now.subtract(const Duration(days: 63));

    final readings = await _meterReadingService.getReadingsInRange(
      groundId: groundId,
      unitId: unitId,
      meterId: meterId,
      start: nineWeeksAgo,
      end: now,
    );
    if (readings.isEmpty) return false;

    // Sum unitsConsumed per ISO week.
    final weeklyTotals = <String, double>{};
    for (final reading in readings) {
      final key = _isoWeekKey(reading.readingDate);
      weeklyTotals[key] = (weeklyTotals[key] ?? 0) + reading.unitsConsumed;
    }

    final currentKey = _isoWeekKey(now);
    final currentTotal = weeklyTotals[currentKey] ?? 0;
    if (currentTotal == 0) return false;

    final historicalTotals = weeklyTotals.entries
        .where((e) => e.key != currentKey)
        .map((e) => e.value)
        .toList();

    if (historicalTotals.isEmpty) return false;

    final historicalAvg =
        historicalTotals.reduce((a, b) => a + b) / historicalTotals.length;
    if (historicalAvg == 0) return false;

    return currentTotal > historicalAvg * 1.5;
  }

  // ---------------------------------------------------------------------------
  // Severity classification
  // ---------------------------------------------------------------------------

  /// Classifies how severe a threshold breach is.
  ///
  /// - [info]     — 0-20% over threshold
  /// - [warning]  — 20-50% over threshold
  /// - [critical] — > 50% over threshold
  AlertSeverity classifySeverity({
    required double threshold,
    required double actualConsumption,
  }) {
    if (threshold <= 0) return AlertSeverity.info;
    final percentOver = (actualConsumption - threshold) / threshold * 100;
    if (percentOver > 50) return AlertSeverity.critical;
    if (percentOver > 20) return AlertSeverity.warning;
    return AlertSeverity.info;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<List<String>> _resolveGroundIds(String? groundId) async {
    if (groundId != null) return [groundId];
    final grounds = await _groundService.getAllGrounds();
    return grounds.map((g) => g.id).toList();
  }

  /// Returns a stable string key representing the ISO week that [date] falls in.
  static String _isoWeekKey(DateTime date) {
    // Day of year (1-based).
    final doy = date.difference(DateTime(date.year, 1, 1)).inDays + 1;
    // ISO week number (1-based).
    final week = ((doy - date.weekday + 10) / 7).floor();
    return '${date.year}-W$week';
  }

  static int _severityOrder(AlertSeverity s) => switch (s) {
    AlertSeverity.critical => 0,
    AlertSeverity.warning => 1,
    AlertSeverity.info => 2,
    AlertSeverity.success => 3,
  };
}
