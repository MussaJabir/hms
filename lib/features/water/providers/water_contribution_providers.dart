import 'package:hms/core/models/recurring_record.dart';
import 'package:hms/core/services/services.dart';
import 'package:hms/features/water/models/water_surplus_deficit.dart';
import 'package:hms/features/water/providers/water_bill_providers.dart';
import 'package:hms/features/water/services/water_contribution_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'water_contribution_providers.g.dart';

@riverpod
WaterContributionService waterContributionService(Ref ref) {
  return WaterContributionService(
    ref.watch(firestoreServiceProvider),
    ref.watch(recurringTransactionServiceProvider),
    ref.watch(waterBillServiceProvider),
    ref.watch(activityLogServiceProvider),
  );
}

@riverpod
Stream<List<RecurringRecord>> currentMonthContributions(
  Ref ref,
  String groundId,
) {
  return ref
      .watch(waterContributionServiceProvider)
      .streamCurrentMonthRecords(groundId);
}

@riverpod
Stream<List<RecurringRecord>> monthContributions(
  Ref ref,
  String groundId,
  String period,
) {
  return ref
      .watch(waterContributionServiceProvider)
      .streamMonthRecords(groundId, period);
}

@riverpod
Future<WaterSurplusDeficit> surplusDeficit(
  Ref ref,
  String groundId,
  String period,
) {
  return ref
      .watch(waterContributionServiceProvider)
      .calculateSurplusDeficit(groundId: groundId, period: period);
}

@riverpod
Future<double> defaultContributionAmount(Ref ref) {
  return ref.watch(waterContributionServiceProvider).getDefaultAmount();
}
