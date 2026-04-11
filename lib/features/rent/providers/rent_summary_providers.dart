import 'package:hms/core/models/recurring_record.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/services/services.dart';
import 'package:hms/features/rent/providers/rent_config_providers.dart';
import 'package:hms/features/rent/services/rent_income_link_service.dart';
import 'package:hms/features/rent/services/rent_notification_service.dart';
import 'package:hms/features/rent/services/rent_summary_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rent_summary_providers.g.dart';

@riverpod
RentSummaryService rentSummaryService(Ref ref) {
  return RentSummaryService(
    ref.watch(rentConfigServiceProvider),
    ref.watch(recurringTransactionServiceProvider),
  );
}

@riverpod
RentIncomeLinkService rentIncomeLinkService(Ref ref) {
  return RentIncomeLinkService(ref.watch(firestoreServiceProvider));
}

@riverpod
Future<RentNotificationService> rentNotificationService(Ref ref) async {
  final notificationService = await ref.watch(
    notificationServiceProvider.future,
  );
  return RentNotificationService(
    notificationService,
    ref.watch(rentSummaryServiceProvider),
  );
}

/// Current month's total expected rent, filtered by selected ground.
@riverpod
Future<double> currentMonthExpected(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(rentSummaryServiceProvider)
      .getCurrentMonthExpected(groundId: groundId);
}

/// Current month's total collected rent, filtered by selected ground.
@riverpod
Future<double> currentMonthCollected(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(rentSummaryServiceProvider)
      .getCurrentMonthCollected(groundId: groundId);
}

/// Current month's outstanding rent (expected – collected), filtered.
@riverpod
Future<double> currentMonthOutstanding(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(rentSummaryServiceProvider)
      .getCurrentMonthOutstanding(groundId: groundId);
}

/// Rent collection rate as a percentage (0–100), filtered by selected ground.
@riverpod
Future<double> currentMonthCollectionRate(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(rentSummaryServiceProvider)
      .getCurrentMonthCollectionRate(groundId: groundId);
}

/// Count of overdue rent records for the current month, filtered.
@riverpod
Future<int> overdueRentCount(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(rentSummaryServiceProvider)
      .getOverdueCount(groundId: groundId);
}

/// List of overdue rent records for the current month, filtered.
@riverpod
Future<List<RecurringRecord>> overdueRentRecords(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(rentSummaryServiceProvider)
      .getOverdueRecords(groundId: groundId);
}
