import 'package:hms/features/finance/models/financial_summary.dart';
import 'package:hms/features/finance/models/ground_financial_summary.dart';
import 'package:hms/features/finance/models/monthly_trend.dart';
import 'package:hms/features/finance/services/budget_service.dart';
import 'package:hms/features/finance/services/expense_service.dart';
import 'package:hms/features/finance/services/income_service.dart';
import 'package:hms/features/grounds/services/ground_service.dart';

/// Aggregates income, expense, and budget data into the cross-cutting summaries
/// that power the finance overview, monthly report, and dashboard.
class FinancialSummaryService {
  FinancialSummaryService(
    this._incomeService,
    this._expenseService,
    this._budgetService,
    this._groundService,
  );

  final IncomeService _incomeService;
  final ExpenseService _expenseService;
  final BudgetService _budgetService;
  final GroundService _groundService;

  /// Net position (income − expenses) for [period], optionally scoped to a
  /// ground.
  Future<double> getNetPosition(String period, {String? groundId}) async {
    final income = await _incomeService.getTotalForPeriod(
      period,
      groundId: groundId,
    );
    final expenses = await _expenseService.getTotalForPeriod(
      period,
      groundId: groundId,
    );
    return income - expenses;
  }

  /// Complete financial summary for [period], optionally scoped to a ground.
  Future<FinancialSummary> getSummary(String period, {String? groundId}) async {
    final incomeBySource = await _scopedIncomeBySource(period, groundId);
    final totalIncome = incomeBySource.values.fold<double>(0, (s, v) => s + v);
    final rentIncome = incomeBySource['rent'] ?? 0;

    final expensesByCategory = await _expenseService
        .getExpensesByCategoryForPeriod(period, groundId: groundId);
    final totalExpenses = expensesByCategory.values.fold<double>(
      0,
      (s, v) => s + v,
    );

    final budgets = await _budgetService.getBudgetsForPeriod(period);
    final onTrack = budgets.where((b) => b.isOnTrack).length;
    final overLimit = budgets.where((b) => b.isOverLimit).length;
    final compliance = await _budgetService.getBudgetComplianceScore(period);

    return FinancialSummary(
      period: period,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      rentIncome: rentIncome,
      otherIncome: totalIncome - rentIncome,
      incomeBySource: incomeBySource,
      expensesByCategory: expensesByCategory,
      budgetComplianceScore: compliance,
      budgetsOnTrack: onTrack,
      budgetsOverLimit: overLimit,
    );
  }

  /// Per-ground income vs expenses for [period], one entry per ground.
  Future<List<GroundFinancialSummary>> getPerGroundComparison(
    String period,
  ) async {
    final grounds = await _groundService.getAllGrounds();
    final result = <GroundFinancialSummary>[];
    for (final ground in grounds) {
      final income = await _incomeService.getTotalForPeriod(
        period,
        groundId: ground.id,
      );
      final expenses = await _expenseService.getTotalForPeriod(
        period,
        groundId: ground.id,
      );
      result.add(
        GroundFinancialSummary(
          groundId: ground.id,
          groundName: ground.name,
          income: income,
          expenses: expenses,
        ),
      );
    }
    return result;
  }

  /// Income and expense totals for the last [months] months, oldest first.
  Future<List<MonthlyTrend>> getMonthlyTrends({int months = 6}) async {
    final periods = _recentPeriods(months);
    final trends = <MonthlyTrend>[];
    for (final period in periods) {
      final income = await _incomeService.getTotalForPeriod(period);
      final expenses = await _expenseService.getTotalForPeriod(period);
      trends.add(
        MonthlyTrend(period: period, income: income, expenses: expenses),
      );
    }
    return trends;
  }

  /// Per-category expense totals for the last [months] months, each list
  /// oldest-month first. Only categories with spend in the window are included.
  Future<Map<String, List<double>>> getCategoryTrends({int months = 6}) async {
    final periods = _recentPeriods(months);
    final byCategory = <String, List<double>>{};
    for (var i = 0; i < periods.length; i++) {
      final totals = await _expenseService.getExpensesByCategoryForPeriod(
        periods[i],
      );
      for (final entry in totals.entries) {
        final list = byCategory.putIfAbsent(
          entry.key,
          () => List<double>.filled(periods.length, 0),
        );
        list[i] = entry.value;
      }
    }
    return byCategory;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Income grouped by source for [period]. The service-level helper isn't
  /// ground-scoped, so scope manually when a ground is selected.
  Future<Map<String, double>> _scopedIncomeBySource(
    String period,
    String? groundId,
  ) async {
    if (groundId == null) {
      return _incomeService.getIncomeBySourceForPeriod(period);
    }
    final all = await _incomeService.getIncomeForMonth(period);
    final Map<String, double> totals = {};
    for (final entry in all.where((i) => i.groundId == groundId)) {
      totals[entry.source] = (totals[entry.source] ?? 0) + entry.amount;
    }
    return totals;
  }

  /// The last [months] "yyyy-MM" periods up to and including the current month,
  /// oldest first.
  List<String> _recentPeriods(int months) {
    final now = DateTime.now();
    final periods = <String>[];
    for (var i = months - 1; i >= 0; i--) {
      final d = DateTime(now.year, now.month - i, 1);
      final mm = d.month.toString().padLeft(2, '0');
      periods.add('${d.year}-$mm');
    }
    return periods;
  }
}
