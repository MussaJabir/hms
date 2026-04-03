import 'package:hms/features/dashboard/models/monthly_report.dart';

/// Generates the monthly financial report.
///
/// Each section is independently computable so modules can be wired one by one.
/// Real data will be sourced from the Finance module (Phase 7).
class MonthlyReportService {
  const MonthlyReportService();

  /// Returns the report for [period] in "yyyy-MM" format.
  MonthlyReport getReport(String period) {
    return _mockReport(period);
  }

  // ---------------------------------------------------------------------------
  // Mock data — replace per-section when each module is built
  // ---------------------------------------------------------------------------

  MonthlyReport _mockReport(String period) {
    return MonthlyReport(
      period: period,
      totalIncome: 850000,
      totalExpenses: 620000,
      rentExpected: 750000,
      rentCollected: 650000,
      topExpenses: const [
        ExpenseCategory(name: 'Electricity', amount: 180000),
        ExpenseCategory(name: 'Water Bills', amount: 120000),
        ExpenseCategory(name: 'Maintenance', amount: 95000),
        ExpenseCategory(name: 'Groceries', amount: 85000),
        ExpenseCategory(name: 'School Fees', amount: 60000),
      ],
      overdueItems: const [
        OverdueItem(
          title: 'Unit 4B — Rent Payment',
          module: 'Rent',
          daysOverdue: 5,
        ),
        OverdueItem(
          title: 'TANESCO Bill — Main Ground',
          module: 'Electricity',
          daysOverdue: 2,
        ),
      ],
      mainGroundIncome: 540000,
      mainGroundExpenses: 380000,
      minorGroundIncome: 310000,
      minorGroundExpenses: 240000,
    );
  }
}
