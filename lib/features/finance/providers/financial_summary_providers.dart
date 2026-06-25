import 'package:hms/core/providers/providers.dart';
import 'package:hms/features/finance/models/financial_summary.dart';
import 'package:hms/features/finance/models/ground_financial_summary.dart';
import 'package:hms/features/finance/models/monthly_trend.dart';
import 'package:hms/features/finance/providers/budget_providers.dart';
import 'package:hms/features/finance/providers/expense_providers.dart';
import 'package:hms/features/finance/providers/income_providers.dart';
import 'package:hms/features/finance/services/financial_summary_service.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'financial_summary_providers.g.dart';

/// Current calendar month as a "yyyy-MM" period string.
String currentFinancePeriod() {
  final now = DateTime.now();
  final mm = now.month.toString().padLeft(2, '0');
  return '${now.year}-$mm';
}

@riverpod
FinancialSummaryService financialSummaryService(Ref ref) {
  return FinancialSummaryService(
    ref.watch(incomeServiceProvider),
    ref.watch(expenseServiceProvider),
    ref.watch(budgetServiceProvider),
    ref.watch(groundServiceProvider),
  );
}

/// Full financial summary for the current month, scoped to the selected ground.
@riverpod
Future<FinancialSummary> currentMonthSummary(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(financialSummaryServiceProvider)
      .getSummary(currentFinancePeriod(), groundId: groundId);
}

/// Per-ground income vs expenses comparison for a given "yyyy-MM" period.
@riverpod
Future<List<GroundFinancialSummary>> perGroundComparison(
  Ref ref,
  String period,
) {
  return ref
      .watch(financialSummaryServiceProvider)
      .getPerGroundComparison(period);
}

/// Income/expense trend for the last 6 months.
@riverpod
Future<List<MonthlyTrend>> monthlyTrends(Ref ref) {
  return ref.watch(financialSummaryServiceProvider).getMonthlyTrends();
}

/// Net position for a "yyyy-MM" period, scoped to a ground when [groundId] is
/// non-null.
@riverpod
Future<double> netPosition(Ref ref, String period, {String? groundId}) {
  return ref
      .watch(financialSummaryServiceProvider)
      .getNetPosition(period, groundId: groundId);
}
