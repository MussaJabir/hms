import 'package:hms/features/electricity/models/monthly_consumption.dart';
import 'package:hms/features/electricity/models/unit_consumption.dart';
import 'package:hms/features/electricity/models/weekly_consumption.dart';
import 'package:hms/features/electricity/providers/meter_providers.dart';
import 'package:hms/features/electricity/providers/meter_reading_providers.dart';
import 'package:hms/features/electricity/providers/tariff_providers.dart';
import 'package:hms/features/electricity/services/consumption_analytics_service.dart';
import 'package:hms/features/grounds/providers/rental_unit_providers.dart';
import 'package:hms/features/grounds/providers/tenant_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_providers.g.dart';

@riverpod
ConsumptionAnalyticsService consumptionAnalyticsService(Ref ref) {
  return ConsumptionAnalyticsService(
    ref.watch(meterReadingServiceProvider),
    ref.watch(tariffServiceProvider),
    ref.watch(meterServiceProvider),
    ref.watch(rentalUnitServiceProvider),
    ref.watch(tenantServiceProvider),
  );
}

/// Weekly consumption buckets for a meter over the last 12 weeks.
@riverpod
Future<List<WeeklyConsumption>> weeklyConsumption(
  Ref ref,
  String groundId,
  String unitId,
  String meterId,
) {
  return ref
      .watch(consumptionAnalyticsServiceProvider)
      .getWeeklyConsumption(
        groundId: groundId,
        unitId: unitId,
        meterId: meterId,
      );
}

/// Monthly consumption buckets for a meter over the last 6 months.
@riverpod
Future<List<MonthlyConsumption>> monthlyConsumption(
  Ref ref,
  String groundId,
  String unitId,
  String meterId,
) {
  return ref
      .watch(consumptionAnalyticsServiceProvider)
      .getMonthlyConsumption(
        groundId: groundId,
        unitId: unitId,
        meterId: meterId,
      );
}

/// Average weekly consumption (units) over the last 12 weeks.
@riverpod
Future<double> averageConsumption(
  Ref ref,
  String groundId,
  String unitId,
  String meterId,
) {
  return ref
      .watch(consumptionAnalyticsServiceProvider)
      .getAverageWeeklyConsumption(
        groundId: groundId,
        unitId: unitId,
        meterId: meterId,
      );
}

/// Consumption across all units in a ground for a date range.
@riverpod
Future<List<UnitConsumption>> groundConsumption(
  Ref ref,
  String groundId,
  DateTime start,
  DateTime end,
) {
  return ref
      .watch(consumptionAnalyticsServiceProvider)
      .getGroundConsumption(groundId: groundId, start: start, end: end);
}
