import 'package:hms/features/electricity/models/monthly_consumption.dart';
import 'package:hms/features/electricity/models/unit_consumption.dart';
import 'package:hms/features/electricity/models/weekly_consumption.dart';
import 'package:hms/features/electricity/services/meter_reading_service.dart';
import 'package:hms/features/electricity/services/meter_service.dart';
import 'package:hms/core/models/app_config.dart';
import 'package:hms/features/electricity/services/tariff_service.dart';
import 'package:hms/features/grounds/services/rental_unit_service.dart';
import 'package:hms/features/grounds/services/tenant_service.dart';

class ConsumptionAnalyticsService {
  ConsumptionAnalyticsService(
    this._meterReadingService,
    this._tariffService,
    this._meterService,
    this._rentalUnitService,
    this._tenantService,
  );

  final MeterReadingService _meterReadingService;
  final TariffService _tariffService;
  final MeterService _meterService;
  final RentalUnitService _rentalUnitService;
  final TenantService _tenantService;

  // ---------------------------------------------------------------------------
  // Weekly
  // ---------------------------------------------------------------------------

  /// Returns weekly totals for the last [weeks] calendar weeks (Mon–Sun),
  /// oldest first. Weeks with no readings are included with 0 consumption.
  Future<List<WeeklyConsumption>> getWeeklyConsumption({
    required String groundId,
    required String unitId,
    required String meterId,
    int weeks = 12,
  }) async {
    final now = DateTime.now();
    final thisWeekStart = _weekStart(now);
    final rangeStart = thisWeekStart.subtract(Duration(days: (weeks - 1) * 7));

    final readings = await _meterReadingService.getReadingsInRange(
      groundId: groundId,
      unitId: unitId,
      meterId: meterId,
      start: rangeStart,
      end: now,
    );

    final tiers = await _effectiveTiers();

    // Build bucket map: weekStart → totalUnits
    final buckets = <DateTime, double>{};
    for (int i = 0; i < weeks; i++) {
      final ws = thisWeekStart.subtract(Duration(days: (weeks - 1 - i) * 7));
      buckets[ws] = 0;
    }

    for (final r in readings) {
      final ws = _weekStart(r.readingDate);
      if (buckets.containsKey(ws)) {
        buckets[ws] = buckets[ws]! + r.unitsConsumed;
      }
    }

    final sorted = buckets.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return sorted.map((e) {
      return WeeklyConsumption(
        weekStart: e.key,
        unitsConsumed: e.value,
        estimatedCost: _tariffService.calculateCostWithTiers(
          unitsConsumed: e.value,
          tiers: tiers,
        ),
      );
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // Monthly
  // ---------------------------------------------------------------------------

  /// Returns monthly totals for the last [months] calendar months,
  /// oldest first. Months with no readings are included with 0 consumption.
  Future<List<MonthlyConsumption>> getMonthlyConsumption({
    required String groundId,
    required String unitId,
    required String meterId,
    int months = 6,
  }) async {
    final now = DateTime.now();
    final rangeStart = _subtractMonths(now, months - 1);

    final readings = await _meterReadingService.getReadingsInRange(
      groundId: groundId,
      unitId: unitId,
      meterId: meterId,
      start: rangeStart,
      end: now,
    );

    final tiers = await _effectiveTiers();

    // Build bucket map: period ("YYYY-MM") → totalUnits
    final buckets = <String, double>{};
    for (int i = months - 1; i >= 0; i--) {
      final d = _subtractMonths(now, i);
      buckets[_period(d)] = 0;
    }

    for (final r in readings) {
      final p = _period(r.readingDate);
      if (buckets.containsKey(p)) {
        buckets[p] = buckets[p]! + r.unitsConsumed;
      }
    }

    final sorted = buckets.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return sorted.map((e) {
      return MonthlyConsumption(
        period: e.key,
        unitsConsumed: e.value,
        estimatedCost: _tariffService.calculateCostWithTiers(
          unitsConsumed: e.value,
          tiers: tiers,
        ),
      );
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // Averages
  // ---------------------------------------------------------------------------

  /// Returns the mean weekly consumption over the last 12 weeks.
  /// Returns 0.0 if there are no readings.
  Future<double> getAverageWeeklyConsumption({
    required String groundId,
    required String unitId,
    required String meterId,
  }) async {
    final weekly = await getWeeklyConsumption(
      groundId: groundId,
      unitId: unitId,
      meterId: meterId,
    );
    if (weekly.isEmpty) return 0;
    final total = weekly.fold<double>(0, (sum, w) => sum + w.unitsConsumed);
    return total / weekly.length;
  }

  // ---------------------------------------------------------------------------
  // Ground comparison
  // ---------------------------------------------------------------------------

  /// Returns consumption per unit in [groundId] for the given date range.
  /// Units without an active meter are omitted. Result sorted by consumption
  /// descending.
  Future<List<UnitConsumption>> getGroundConsumption({
    required String groundId,
    required DateTime start,
    required DateTime end,
  }) async {
    final units = await _rentalUnitService.getAllUnits(groundId);
    final tiers = await _effectiveTiers();
    final results = <UnitConsumption>[];

    for (final unit in units) {
      final meter = await _meterService.getActiveMeter(groundId, unit.id);
      if (meter == null) continue;

      final consumed = await _meterReadingService.getTotalConsumption(
        groundId: groundId,
        unitId: unit.id,
        meterId: meter.id,
        start: start,
        end: end,
      );

      final tenant = await _tenantService.getCurrentTenant(groundId, unit.id);

      results.add(
        UnitConsumption(
          unitId: unit.id,
          unitName: unit.name,
          tenantName: tenant?.fullName ?? '',
          unitsConsumed: consumed,
          estimatedCost: _tariffService.calculateCostWithTiers(
            unitsConsumed: consumed,
            tiers: tiers,
          ),
        ),
      );
    }

    results.sort((a, b) => b.unitsConsumed.compareTo(a.unitsConsumed));
    return results;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<List<TanescoTier>> _effectiveTiers() async {
    final tiers = await _tariffService.getCurrentTariffs();
    return tiers.isEmpty ? _tariffService.getDefaultTariffs() : tiers;
  }

  /// Returns the Monday of the week containing [date].
  DateTime _weekStart(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return DateTime(date.year, date.month, date.day - daysFromMonday);
  }

  /// Returns a "YYYY-MM" period string for [date].
  String _period(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}';

  /// Returns a [DateTime] that is [months] months before [date], always day 1.
  DateTime _subtractMonths(DateTime date, int months) {
    int year = date.year;
    int month = date.month - months;
    while (month <= 0) {
      month += 12;
      year--;
    }
    return DateTime(year, month, 1);
  }
}
