import 'package:hms/core/services/activity_log_service_provider.dart';
import 'package:hms/core/services/firestore_service_provider.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recurring_transaction_service_provider.g.dart';

@riverpod
RecurringTransactionService recurringTransactionService(Ref ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  final activityLog = ref.watch(activityLogServiceProvider);
  return RecurringTransactionService(firestore, activityLog);
}
