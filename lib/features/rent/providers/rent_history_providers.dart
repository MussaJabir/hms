import 'package:hms/core/models/recurring_record.dart';
import 'package:hms/core/services/firestore_service_provider.dart';
import 'package:hms/features/rent/services/rent_history_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rent_history_providers.g.dart';

@riverpod
RentHistoryService rentHistoryService(Ref ref) {
  return RentHistoryService(ref.watch(firestoreServiceProvider));
}

/// Streams all payment records for a tenant in real-time.
@riverpod
Stream<List<RecurringRecord>> tenantHistory(
  Ref ref,
  String groundId,
  String unitId,
  String tenantId,
) {
  return ref
      .watch(rentHistoryServiceProvider)
      .streamTenantHistory(
        groundId: groundId,
        unitId: unitId,
        tenantId: tenantId,
      );
}

/// Total amount paid by a tenant across all time.
@riverpod
Future<double> tenantTotalPaid(
  Ref ref,
  String groundId,
  String unitId,
  String tenantId,
) {
  return ref
      .watch(rentHistoryServiceProvider)
      .getTotalPaidByTenant(
        groundId: groundId,
        unitId: unitId,
        tenantId: tenantId,
      );
}

/// Number of fully paid months for a tenant.
@riverpod
Future<int> tenantPaidMonths(
  Ref ref,
  String groundId,
  String unitId,
  String tenantId,
) {
  return ref
      .watch(rentHistoryServiceProvider)
      .getPaidMonthsCount(
        groundId: groundId,
        unitId: unitId,
        tenantId: tenantId,
      );
}

/// Number of unpaid / overdue months for a tenant.
@riverpod
Future<int> tenantOutstandingMonths(
  Ref ref,
  String groundId,
  String unitId,
  String tenantId,
) {
  return ref
      .watch(rentHistoryServiceProvider)
      .getOutstandingMonthsCount(
        groundId: groundId,
        unitId: unitId,
        tenantId: tenantId,
      );
}
