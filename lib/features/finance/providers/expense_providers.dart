import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/services/services.dart';
import 'package:hms/features/finance/models/expense.dart';
import 'package:hms/features/finance/services/expense_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'expense_providers.g.dart';

/// Current calendar month as a "yyyy-MM" period string.
String currentExpensePeriod() {
  final now = DateTime.now();
  final mm = now.month.toString().padLeft(2, '0');
  return '${now.year}-$mm';
}

@riverpod
ExpenseService expenseService(Ref ref) {
  return ExpenseService(
    ref.watch(firestoreServiceProvider),
    ref.watch(activityLogServiceProvider),
  );
}

/// Streams every expense entry, newest first.
@riverpod
Stream<List<Expense>> allExpenses(Ref ref) {
  return ref.watch(expenseServiceProvider).streamAllExpenses();
}

/// Streams expenses for the current calendar month.
@riverpod
Stream<List<Expense>> currentMonthExpenses(Ref ref) {
  return ref
      .watch(expenseServiceProvider)
      .streamExpensesForMonth(currentExpensePeriod());
}

/// Total expenses for the current month, scoped to the selected ground.
@riverpod
Future<double> currentMonthExpenseTotal(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(expenseServiceProvider)
      .getCurrentMonthTotal(groundId: groundId);
}

/// Expenses grouped by category value for a given "yyyy-MM" period, scoped to
/// the selected ground.
@riverpod
Future<Map<String, double>> expensesByCategory(Ref ref, String period) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(expenseServiceProvider)
      .getExpensesByCategoryForPeriod(period, groundId: groundId);
}

/// Top 5 expense categories for a given "yyyy-MM" period, scoped to the
/// selected ground.
@riverpod
Future<List<MapEntry<String, double>>> topExpenseCategories(
  Ref ref,
  String period,
) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(expenseServiceProvider)
      .getTopCategories(period, top: 5, groundId: groundId);
}
