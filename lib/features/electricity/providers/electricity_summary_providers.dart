import 'package:hms/core/providers/providers.dart';
import 'package:hms/features/electricity/providers/alert_providers.dart';
import 'package:hms/features/electricity/providers/meter_providers.dart';
import 'package:hms/features/electricity/providers/meter_reading_providers.dart';
import 'package:hms/features/electricity/providers/tariff_providers.dart';
import 'package:hms/features/electricity/services/electricity_summary_service.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';
import 'package:hms/features/grounds/providers/rental_unit_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'electricity_summary_providers.g.dart';

@riverpod
ElectricitySummaryService electricitySummaryService(Ref ref) {
  return ElectricitySummaryService(
    ref.watch(meterServiceProvider),
    ref.watch(meterReadingServiceProvider),
    ref.watch(consumptionAlertServiceProvider),
    ref.watch(tariffServiceProvider),
    ref.watch(groundServiceProvider),
    ref.watch(rentalUnitServiceProvider),
  );
}

@riverpod
Future<double> currentWeekUnits(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(electricitySummaryServiceProvider)
      .getCurrentWeekTotalUnits(groundId: groundId);
}

@riverpod
Future<double> currentMonthUnits(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(electricitySummaryServiceProvider)
      .getCurrentMonthTotalUnits(groundId: groundId);
}

@riverpod
Future<double> currentWeekCost(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(electricitySummaryServiceProvider)
      .getCurrentWeekEstimatedCost(groundId: groundId);
}

@riverpod
Future<double> currentMonthCost(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(electricitySummaryServiceProvider)
      .getCurrentMonthEstimatedCost(groundId: groundId);
}

@riverpod
Future<int> activeMetersCount(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(electricitySummaryServiceProvider)
      .getActiveMetersCount(groundId: groundId);
}

@riverpod
Future<int> electricityPendingReadingsCount(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(electricitySummaryServiceProvider)
      .getPendingReadingsCount(groundId: groundId);
}

@riverpod
Future<int> electricityWarningCount(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(electricitySummaryServiceProvider)
      .getWarningCount(groundId: groundId);
}

@riverpod
Future<double> weekOverWeekTrend(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(electricitySummaryServiceProvider)
      .getWeekOverWeekTrend(groundId: groundId);
}
