import 'package:hms/features/dashboard/models/monthly_report.dart';
import 'package:hms/features/electricity/services/electricity_summary_service.dart';
import 'package:hms/features/finance/models/expense_category.dart' as fin;
import 'package:hms/features/finance/services/budget_service.dart';
import 'package:hms/features/finance/services/expense_service.dart';
import 'package:hms/features/finance/services/financial_summary_service.dart';
import 'package:hms/features/finance/services/income_service.dart';
import 'package:hms/features/rent/services/rent_summary_service.dart';
import 'package:hms/features/water/services/water_summary_service.dart';

/// Generates the monthly financial report by aggregating real data from every
/// module: income, expenses, rent, electricity, water, and budgets.
class MonthlyReportService {
  const MonthlyReportService(
    this._rentSummaryService,
    this._electricitySummaryService,
    this._waterSummaryService,
    this._incomeService,
    this._expenseService,
    this._financialSummaryService,
    this._budgetService,
  );

  final RentSummaryService _rentSummaryService;
  final ElectricitySummaryService _electricitySummaryService;
  final WaterSummaryService _waterSummaryService;
  final IncomeService _incomeService;
  final ExpenseService _expenseService;
  final FinancialSummaryService _financialSummaryService;
  final BudgetService _budgetService;

  /// Returns the report for [period] in "yyyy-MM" format.
  /// [groundId] filters by ground when non-null.
  Future<MonthlyReport> getReport(String period, {String? groundId}) async {
    final results = await Future.wait([
      _incomeService.getTotalForPeriod(period, groundId: groundId),
      _expenseService.getTotalForPeriod(period, groundId: groundId),
      _rentSummaryService.getCurrentMonthExpected(groundId: groundId),
      _rentSummaryService.getCurrentMonthCollected(groundId: groundId),
      _electricitySummaryService.getCurrentMonthTotalUnits(groundId: groundId),
      _electricitySummaryService.getCurrentMonthEstimatedCost(
        groundId: groundId,
      ),
      _waterSummaryService.getCurrentMonthCost(groundId: groundId),
      _waterSummaryService.getCurrentMonthContributionsCollected(
        groundId: groundId,
      ),
      _waterSummaryService.getCurrentMonthSurplusDeficit(groundId: groundId),
    ]);

    final totalIncome = results[0];
    final totalExpenses = results[1];
    final rentExpected = results[2];
    final rentCollected = results[3];
    final electricityUnits = results[4];
    final electricityEstimatedCost = results[5];
    final waterBillTotal = results[6];
    final waterContributionsCollected = results[7];
    final waterSurplusDeficit = results[8];

    final topExpenses = await _topExpenses(period, groundId);
    final overdueItems = await _overdueItems(period, groundId);
    final perGround = await _financialSummaryService.getPerGroundComparison(
      period,
    );

    final main = perGround.isNotEmpty ? perGround[0] : null;
    final minor = perGround.length > 1 ? perGround[1] : null;

    return MonthlyReport(
      period: period,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      rentExpected: rentExpected,
      rentCollected: rentCollected,
      electricityUnits: electricityUnits,
      electricityEstimatedCost: electricityEstimatedCost,
      waterBillTotal: waterBillTotal,
      waterContributionsCollected: waterContributionsCollected,
      waterSurplusDeficit: waterSurplusDeficit,
      topExpenses: topExpenses,
      overdueItems: overdueItems,
      mainGroundIncome: main?.income ?? 0,
      mainGroundExpenses: main?.expenses ?? 0,
      minorGroundIncome: minor?.income ?? 0,
      minorGroundExpenses: minor?.expenses ?? 0,
    );
  }

  /// Top 5 expense categories for the period, mapped to display rows.
  Future<List<ExpenseCategory>> _topExpenses(
    String period,
    String? groundId,
  ) async {
    final top = await _expenseService.getTopCategories(
      period,
      top: 5,
      groundId: groundId,
    );
    return top
        .map(
          (e) => ExpenseCategory(
            name: fin.ExpenseCategory.fromString(e.key).label,
            amount: e.value,
          ),
        )
        .toList();
  }

  /// Aggregates overdue items across rent, water, and over-budget categories.
  Future<List<OverdueItem>> _overdueItems(
    String period,
    String? groundId,
  ) async {
    final now = DateTime.now();
    final items = <OverdueItem>[];

    final overdueRent = await _rentSummaryService.getOverdueRecords(
      groundId: groundId,
    );
    for (final r in overdueRent) {
      items.add(
        OverdueItem(
          title: r.linkedEntityName,
          module: 'Rent',
          daysOverdue: now.difference(r.dueDate).inDays.clamp(0, 9999),
        ),
      );
    }

    final overdueWater = await _waterSummaryService.getOverdueBills(
      groundId: groundId,
    );
    for (final b in overdueWater) {
      items.add(
        OverdueItem(
          title: 'Water bill — ${b.billingPeriod}',
          module: 'Water',
          daysOverdue: now.difference(b.dueDate).inDays.clamp(0, 9999),
        ),
      );
    }

    final overBudgets = await _budgetService.getOverBudgets(period);
    for (final budget in overBudgets) {
      items.add(
        OverdueItem(
          title:
              '${fin.ExpenseCategory.fromString(budget.category).label} '
              'over budget',
          module: 'Budget',
          daysOverdue: 0,
        ),
      );
    }

    return items;
  }
}
