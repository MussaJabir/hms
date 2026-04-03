import 'package:hms/features/dashboard/models/monthly_report.dart';
import 'package:hms/features/dashboard/services/monthly_report_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'monthly_report_provider.g.dart';

@riverpod
MonthlyReportService monthlyReportService(Ref ref) {
  return const MonthlyReportService();
}

/// Returns the report for [period] ("yyyy-MM"). Defaults to current month.
@riverpod
MonthlyReport monthlyReport(Ref ref, {String? period}) {
  final now = DateTime.now();
  final resolvedPeriod =
      period ?? '${now.year}-${now.month.toString().padLeft(2, '0')}';
  return ref.watch(monthlyReportServiceProvider).getReport(resolvedPeriod);
}
