import 'package:hms/features/electricity/services/consumption_alert_service.dart';
import 'package:hms/features/electricity/services/meter_reading_service.dart';
import 'package:hms/features/electricity/services/meter_service.dart';
import 'package:hms/features/electricity/services/tariff_service.dart';
import 'package:hms/features/grounds/services/ground_service.dart';
import 'package:hms/features/grounds/services/rental_unit_service.dart';

class ElectricitySummaryService {
  ElectricitySummaryService(
    this._meterService,
    this._meterReadingService,
    this._alertService,
    this._tariffService,
    this._groundService,
    this._rentalUnitService,
  );

  final MeterService _meterService;
  final MeterReadingService _meterReadingService;
  final ConsumptionAlertService _alertService;
  final TariffService _tariffService;
  final GroundService _groundService;
  final RentalUnitService _rentalUnitService;

  // ---------------------------------------------------------------------------
  // Weekly totals
  // ---------------------------------------------------------------------------

  /// Total units consumed across all active meters in the current ISO week,
  /// filtered to [groundId] when provided.
  Future<double> getCurrentWeekTotalUnits({String? groundId}) async {
    final range = _currentWeekRange();
    return _sumConsumption(start: range.$1, end: range.$2, groundId: groundId);
  }

  /// Estimated cost for all consumption in the current ISO week.
  Future<double> getCurrentWeekEstimatedCost({String? groundId}) async {
    final units = await getCurrentWeekTotalUnits(groundId: groundId);
    return _tariffService.calculateCost(units);
  }

  // ---------------------------------------------------------------------------
  // Monthly totals
  // ---------------------------------------------------------------------------

  /// Total units consumed across all active meters in the current calendar month.
  Future<double> getCurrentMonthTotalUnits({String? groundId}) async {
    final range = _currentMonthRange();
    return _sumConsumption(start: range.$1, end: range.$2, groundId: groundId);
  }

  /// Estimated cost for all consumption in the current calendar month.
  Future<double> getCurrentMonthEstimatedCost({String? groundId}) async {
    final units = await getCurrentMonthTotalUnits(groundId: groundId);
    return _tariffService.calculateCost(units);
  }

  // ---------------------------------------------------------------------------
  // Counts
  // ---------------------------------------------------------------------------

  /// Number of units that have an active meter.
  Future<int> getActiveMetersCount({String? groundId}) async {
    final groundIds = await _resolveGroundIds(groundId);
    int count = 0;
    for (final gId in groundIds) {
      final units = await _rentalUnitService.getAllUnits(gId);
      for (final unit in units) {
        if (unit.meterId == null) continue;
        final meter = await _meterService.getActiveMeter(gId, unit.id);
        if (meter != null) count++;
      }
    }
    return count;
  }

  /// Number of units with an active meter that have not had a reading recorded
  /// during the current ISO week (Mon–Sun).
  Future<int> getPendingReadingsCount({String? groundId}) async {
    final groundIds = await _resolveGroundIds(groundId);
    final range = _currentWeekRange();
    int count = 0;

    for (final gId in groundIds) {
      final units = await _rentalUnitService.getAllUnits(gId);
      for (final unit in units) {
        if (unit.meterId == null) continue;
        final meter = await _meterService.getActiveMeter(gId, unit.id);
        if (meter == null) continue;

        final readings = await _meterReadingService.getReadingsInRange(
          groundId: gId,
          unitId: unit.id,
          meterId: meter.id,
          start: range.$1,
          end: range.$2,
        );
        if (readings.isEmpty) count++;
      }
    }
    return count;
  }

  /// Number of units currently exceeding their consumption threshold.
  Future<int> getWarningCount({String? groundId}) async {
    final warnings = await _alertService.getActiveWarnings(groundId: groundId);
    return warnings.length;
  }

  // ---------------------------------------------------------------------------
  // Trend
  // ---------------------------------------------------------------------------

  /// Percentage change in consumption compared to last week.
  /// Positive = increase, negative = decrease.
  /// Returns 0 when last week had no consumption.
  Future<double> getWeekOverWeekTrend({String? groundId}) async {
    final thisWeek = _currentWeekRange();
    final lastWeek = _lastWeekRange();

    final current = await _sumConsumption(
      start: thisWeek.$1,
      end: thisWeek.$2,
      groundId: groundId,
    );
    final previous = await _sumConsumption(
      start: lastWeek.$1,
      end: lastWeek.$2,
      groundId: groundId,
    );

    if (previous == 0) return 0;
    return (current - previous) / previous * 100;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<double> _sumConsumption({
    required DateTime start,
    required DateTime end,
    String? groundId,
  }) async {
    final groundIds = await _resolveGroundIds(groundId);
    double total = 0;

    for (final gId in groundIds) {
      final units = await _rentalUnitService.getAllUnits(gId);
      for (final unit in units) {
        if (unit.meterId == null) continue;
        final meter = await _meterService.getActiveMeter(gId, unit.id);
        if (meter == null) continue;

        total += await _meterReadingService.getTotalConsumption(
          groundId: gId,
          unitId: unit.id,
          meterId: meter.id,
          start: start,
          end: end,
        );
      }
    }
    return total;
  }

  Future<List<String>> _resolveGroundIds(String? groundId) async {
    if (groundId != null) return [groundId];
    final grounds = await _groundService.getAllGrounds();
    return grounds.map((g) => g.id).toList();
  }

  /// Returns the Monday (inclusive) and Sunday (inclusive) of the current
  /// ISO week at midnight boundaries.
  static (DateTime, DateTime) _currentWeekRange() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final start = DateTime(monday.year, monday.month, monday.day);
    final end = start.add(
      const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
    );
    return (start, end);
  }

  /// Returns the Monday and Sunday of last week.
  static (DateTime, DateTime) _lastWeekRange() {
    final now = DateTime.now();
    final thisMonday = now.subtract(Duration(days: now.weekday - 1));
    final lastMonday = thisMonday.subtract(const Duration(days: 7));
    final start = DateTime(lastMonday.year, lastMonday.month, lastMonday.day);
    final end = start.add(
      const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
    );
    return (start, end);
  }

  /// Returns first and last moment of the current calendar month.
  static (DateTime, DateTime) _currentMonthRange() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(
      now.year,
      now.month + 1,
      1,
    ).subtract(const Duration(seconds: 1));
    return (start, end);
  }
}
