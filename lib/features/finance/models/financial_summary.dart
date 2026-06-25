import 'package:freezed_annotation/freezed_annotation.dart';

part 'financial_summary.freezed.dart';

/// A complete financial snapshot for a single "yyyy-MM" period: income and
/// expense totals, their breakdowns, and the budget compliance picture.
@freezed
abstract class FinancialSummary with _$FinancialSummary {
  const FinancialSummary._();

  const factory FinancialSummary({
    required String period,
    required double totalIncome,
    required double totalExpenses,
    required double rentIncome,
    required double otherIncome,
    required Map<String, double> incomeBySource,
    required Map<String, double> expensesByCategory,
    required double budgetComplianceScore,
    required int budgetsOnTrack,
    required int budgetsOverLimit,
  }) = _FinancialSummary;

  double get netPosition => totalIncome - totalExpenses;

  bool get isPositive => netPosition >= 0;

  double get savingsRate =>
      totalIncome > 0 ? (netPosition / totalIncome * 100) : 0;
}
