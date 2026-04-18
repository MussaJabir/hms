import 'package:hms/core/services/services.dart';
import 'package:hms/features/water/models/water_bill.dart';
import 'package:hms/features/water/services/water_bill_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'water_bill_providers.g.dart';

@riverpod
WaterBillService waterBillService(Ref ref) {
  return WaterBillService(
    ref.watch(firestoreServiceProvider),
    ref.watch(activityLogServiceProvider),
  );
}

@riverpod
Stream<List<WaterBill>> waterBills(Ref ref, String groundId) {
  return ref.watch(waterBillServiceProvider).streamBills(groundId);
}

@riverpod
Future<WaterBill?> latestBill(Ref ref, String groundId) {
  return ref.watch(waterBillServiceProvider).getLatestBill(groundId);
}

@riverpod
Future<List<WaterBill>> unpaidBills(Ref ref, String groundId) {
  return ref.watch(waterBillServiceProvider).getUnpaidBills(groundId);
}

@riverpod
Future<double> averageMonthlyBill(Ref ref, String groundId) {
  return ref.watch(waterBillServiceProvider).getAverageMonthlyBill(groundId);
}
