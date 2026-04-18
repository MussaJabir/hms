import 'package:hms/features/dashboard/models/monthly_report.dart';
import 'package:hms/features/electricity/services/electricity_summary_service.dart';
import 'package:hms/features/rent/services/rent_summary_service.dart';

/// Generates the monthly financial report.
///
/// Rent data is sourced from [RentSummaryService].
/// Electricity data is sourced from [ElectricitySummaryService].
/// Other modules (expenses, budgets, stock) still use mock data until their
/// phases are built.
class MonthlyReportService {
  const MonthlyReportService(
    this._rentSummaryService,
    this._electricitySummaryService,
  );

  final RentSummaryService _rentSummaryService;
  final ElectricitySummaryService _electricitySummaryService;

  /// Returns the report for [period] in "yyyy-MM" format.
  /// [groundId] filters by ground when non-null.
  Future<MonthlyReport> getReport(String period, {String? groundId}) async {
    final rentExpected = await _rentSummaryService.getCurrentMonthExpected(
      groundId: groundId,
    );
    final rentCollected = await _rentSummaryService.getCurrentMonthCollected(
      groundId: groundId,
    );

    final electricityUnits = await _electricitySummaryService
        .getCurrentMonthTotalUnits(groundId: groundId);
    final electricityEstimatedCost = await _electricitySummaryService
        .getCurrentMonthEstimatedCost(groundId: groundId);

    // Non-rent income/expense data is mock until Phase 7 (Finance).
    // totalIncome = collected rent + other mock income (200k placeholder).
    const otherIncome = 200000.0;
    final totalIncome = rentCollected + otherIncome;
    // Estimated electricity cost is included in total expenses.
    final totalExpenses = 440000.0 + electricityEstimatedCost;

    return MonthlyReport(
      period: period,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      rentExpected: rentExpected,
      rentCollected: rentCollected,
      electricityUnits: electricityUnits,
      electricityEstimatedCost: electricityEstimatedCost,
      topExpenses: const [
        ExpenseCategory(name: 'Water Bills', amount: 120000),
        ExpenseCategory(name: 'Maintenance', amount: 95000),
        ExpenseCategory(name: 'Groceries', amount: 85000),
        ExpenseCategory(name: 'School Fees', amount: 60000),
        ExpenseCategory(name: 'Other', amount: 80000),
      ],
      overdueItems: const [],
      // Per-ground breakdowns require Finance data; kept as mock for now.
      mainGroundIncome: totalIncome * 0.63,
      mainGroundExpenses: totalExpenses * 0.61,
      minorGroundIncome: totalIncome * 0.37,
      minorGroundExpenses: totalExpenses * 0.39,
    );
  }
}
