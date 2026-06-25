import 'package:hms/core/providers/providers.dart';
import 'package:hms/features/dashboard/models/monthly_report.dart';
import 'package:hms/features/dashboard/services/monthly_report_service.dart';
import 'package:hms/features/electricity/providers/electricity_summary_providers.dart';
import 'package:hms/features/finance/providers/budget_providers.dart';
import 'package:hms/features/finance/providers/expense_providers.dart';
import 'package:hms/features/finance/providers/financial_summary_providers.dart';
import 'package:hms/features/finance/providers/income_providers.dart';
import 'package:hms/features/rent/providers/rent_summary_providers.dart';
import 'package:hms/features/water/providers/water_summary_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'monthly_report_provider.g.dart';

@riverpod
MonthlyReportService monthlyReportService(Ref ref) {
  return MonthlyReportService(
    ref.watch(rentSummaryServiceProvider),
    ref.watch(electricitySummaryServiceProvider),
    ref.watch(waterSummaryServiceProvider),
    ref.watch(incomeServiceProvider),
    ref.watch(expenseServiceProvider),
    ref.watch(financialSummaryServiceProvider),
    ref.watch(budgetServiceProvider),
  );
}

/// Returns the report for [period] ("yyyy-MM"). Defaults to current month.
/// Reacts to the selected ground via [currentGroundProvider].
@riverpod
Future<MonthlyReport> monthlyReport(Ref ref, {String? period}) {
  final now = DateTime.now();
  final resolvedPeriod =
      period ?? '${now.year}-${now.month.toString().padLeft(2, '0')}';
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(monthlyReportServiceProvider)
      .getReport(resolvedPeriod, groundId: groundId);
}
