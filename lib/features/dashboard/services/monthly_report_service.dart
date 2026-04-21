import 'package:hms/features/dashboard/models/monthly_report.dart';
import 'package:hms/features/electricity/services/electricity_summary_service.dart';
import 'package:hms/features/rent/services/rent_summary_service.dart';
import 'package:hms/features/water/services/water_summary_service.dart';

/// Generates the monthly financial report.
///
/// Rent, electricity, and water data are sourced from their respective services.
/// Other modules (finance, stock) still use mock data until their phases are built.
class MonthlyReportService {
  const MonthlyReportService(
    this._rentSummaryService,
    this._electricitySummaryService,
    this._waterSummaryService,
  );

  final RentSummaryService _rentSummaryService;
  final ElectricitySummaryService _electricitySummaryService;
  final WaterSummaryService _waterSummaryService;

  /// Returns the report for [period] in "yyyy-MM" format.
  /// [groundId] filters by ground when non-null.
  Future<MonthlyReport> getReport(String period, {String? groundId}) async {
    final results = await Future.wait([
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

    final rentExpected = results[0];
    final rentCollected = results[1];
    final electricityUnits = results[2];
    final electricityEstimatedCost = results[3];
    final waterBillTotal = results[4];
    final waterContributionsCollected = results[5];
    final waterSurplusDeficit = results[6];

    // Non-rent income/expense data is mock until Phase 7 (Finance).
    const otherIncome = 200000.0;
    // Water contributions collected are treated as income (tenant payments).
    final totalIncome =
        rentCollected + waterContributionsCollected + otherIncome;
    // Water bill and electricity cost are included in total expenses.
    final totalExpenses = 440000.0 + electricityEstimatedCost + waterBillTotal;

    // Build top expenses list dynamically, including real water bill if present.
    final topExpenses = [
      if (waterBillTotal > 0)
        ExpenseCategory(name: 'Water Bills', amount: waterBillTotal),
      const ExpenseCategory(name: 'Maintenance', amount: 95000),
      const ExpenseCategory(name: 'Groceries', amount: 85000),
      const ExpenseCategory(name: 'School Fees', amount: 60000),
      const ExpenseCategory(name: 'Other', amount: 80000),
    ];

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
      overdueItems: const [],
      // Per-ground breakdowns require Finance data; kept as mock for now.
      mainGroundIncome: totalIncome * 0.63,
      mainGroundExpenses: totalExpenses * 0.61,
      minorGroundIncome: totalIncome * 0.37,
      minorGroundExpenses: totalExpenses * 0.39,
    );
  }
}
