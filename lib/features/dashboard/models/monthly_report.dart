import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_report.freezed.dart';

@freezed
abstract class MonthlyReport with _$MonthlyReport {
  const MonthlyReport._();

  const factory MonthlyReport({
    required String period, // "2026-03" format
    @Default(0) double totalIncome,
    @Default(0) double totalExpenses,
    @Default(0) double rentExpected,
    @Default(0) double rentCollected,
    @Default([]) List<ExpenseCategory> topExpenses,
    @Default([]) List<OverdueItem> overdueItems,
    @Default(0) double mainGroundIncome,
    @Default(0) double mainGroundExpenses,
    @Default(0) double minorGroundIncome,
    @Default(0) double minorGroundExpenses,
  }) = _MonthlyReport;

  double get netPosition => totalIncome - totalExpenses;
  bool get isPositive => netPosition >= 0;
  double get rentCollectionRate =>
      rentExpected > 0 ? (rentCollected / rentExpected * 100) : 0;
}

@freezed
abstract class ExpenseCategory with _$ExpenseCategory {
  const factory ExpenseCategory({
    required String name,
    required double amount,
  }) = _ExpenseCategory;
}

@freezed
abstract class OverdueItem with _$OverdueItem {
  const factory OverdueItem({
    required String title,
    required String module,
    required int daysOverdue,
  }) = _OverdueItem;
}
