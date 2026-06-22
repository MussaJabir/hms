import 'package:hms/core/services/services.dart';
import 'package:hms/features/finance/models/budget.dart';
import 'package:hms/features/finance/providers/expense_providers.dart';
import 'package:hms/features/finance/services/budget_notification_service.dart';
import 'package:hms/features/finance/services/budget_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budget_providers.g.dart';

/// Current calendar month as a "yyyy-MM" period string.
String currentBudgetPeriod() {
  final now = DateTime.now();
  final mm = now.month.toString().padLeft(2, '0');
  return '${now.year}-$mm';
}

@riverpod
BudgetService budgetService(Ref ref) {
  return BudgetService(
    ref.watch(firestoreServiceProvider),
    ref.watch(expenseServiceProvider),
    ref.watch(recurringTransactionServiceProvider),
    ref.watch(activityLogServiceProvider),
  );
}

@riverpod
Future<BudgetNotificationService> budgetNotificationService(Ref ref) async {
  final notifSvc = await ref.watch(notificationServiceProvider.future);
  return BudgetNotificationService(notifSvc, ref.watch(budgetServiceProvider));
}

/// Streams budgets for the current month, ordered by category.
@riverpod
Stream<List<Budget>> currentMonthBudgets(Ref ref) {
  return ref
      .watch(budgetServiceProvider)
      .streamBudgetsForPeriod(currentBudgetPeriod());
}

/// The budget for a category in a given "yyyy-MM" period, or null.
@riverpod
Future<Budget?> budgetForCategory(Ref ref, String category, String period) {
  return ref.watch(budgetServiceProvider).getBudget(category, period);
}

/// Budgets near or over their limit for the current month.
@riverpod
Future<List<Budget>> warningBudgets(Ref ref) {
  return ref
      .watch(budgetServiceProvider)
      .getWarningBudgets(currentBudgetPeriod());
}

/// Budgets over their limit for the current month.
@riverpod
Future<List<Budget>> overBudgets(Ref ref) {
  return ref.watch(budgetServiceProvider).getOverBudgets(currentBudgetPeriod());
}

/// Overall budget compliance score (0–100) for the current month.
@riverpod
Future<double> budgetComplianceScore(Ref ref) {
  return ref
      .watch(budgetServiceProvider)
      .getBudgetComplianceScore(currentBudgetPeriod());
}

/// Total budget limit for a given "yyyy-MM" period.
@riverpod
Future<double> totalBudgetLimit(Ref ref, String period) {
  return ref.watch(budgetServiceProvider).getTotalLimit(period);
}

/// Total recorded spending across all budgets for a given "yyyy-MM" period.
@riverpod
Future<double> totalBudgetSpent(Ref ref, String period) {
  return ref.watch(budgetServiceProvider).getTotalSpent(period);
}
