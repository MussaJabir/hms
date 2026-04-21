import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/services/services.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';
import 'package:hms/features/water/models/water_bill.dart';
import 'package:hms/features/water/providers/water_bill_providers.dart';
import 'package:hms/features/water/providers/water_contribution_providers.dart';
import 'package:hms/features/water/services/water_notification_service.dart';
import 'package:hms/features/water/services/water_summary_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'water_summary_providers.g.dart';

@riverpod
WaterSummaryService waterSummaryService(Ref ref) {
  return WaterSummaryService(
    ref.watch(waterBillServiceProvider),
    ref.watch(waterContributionServiceProvider),
    ref.watch(groundServiceProvider),
  );
}

@riverpod
Future<WaterNotificationService> waterNotificationService(Ref ref) async {
  final notifSvc = await ref.watch(notificationServiceProvider.future);
  return WaterNotificationService(
    notifSvc,
    ref.watch(waterSummaryServiceProvider),
  );
}

@riverpod
Future<double> currentMonthWaterCost(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(waterSummaryServiceProvider)
      .getCurrentMonthCost(groundId: groundId);
}

@riverpod
Future<int> unpaidWaterBillsCount(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(waterSummaryServiceProvider)
      .getUnpaidBillsCount(groundId: groundId);
}

@riverpod
Future<List<WaterBill>> billsDueSoon(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(waterSummaryServiceProvider)
      .getBillsDueSoon(groundId: groundId);
}

@riverpod
Future<List<WaterBill>> overdueWaterBills(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(waterSummaryServiceProvider)
      .getOverdueBills(groundId: groundId);
}

@riverpod
Future<double> currentMonthWaterSurplusDeficit(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(waterSummaryServiceProvider)
      .getCurrentMonthSurplusDeficit(groundId: groundId);
}

@riverpod
Future<int> unpaidContributionsCount(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(waterSummaryServiceProvider)
      .getUnpaidContributionsCount(groundId: groundId);
}
