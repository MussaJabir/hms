import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget.freezed.dart';
part 'budget.g.dart';

/// A monthly spending limit for a single expense category. The [spentAmount] is
/// recalculated from actual expenses for the [period] ("yyyy-MM"), so the
/// progress derived getters always reflect real spending.
@freezed
abstract class Budget with _$Budget {
  const Budget._();

  const factory Budget({
    required String id,
    required String category, // matches ExpenseCategory value
    required double limitAmount, // monthly budget limit in TZS
    required String period, // "2026-03" format
    @Default(0) double spentAmount, // current spend (calculated from expenses)
    required DateTime createdAt,
    required DateTime updatedAt,
    required String updatedBy,
    @Default(1) int schemaVersion,
  }) = _Budget;

  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);

  double get remainingAmount => limitAmount - spentAmount;

  double get spentPercentage =>
      limitAmount > 0 ? (spentAmount / limitAmount * 100).clamp(0, 999) : 0;

  bool get isNearLimit => spentPercentage >= 80 && spentPercentage < 100;

  bool get isOverLimit => spentPercentage >= 100;

  bool get isOnTrack => spentPercentage < 80;

  String get statusLabel => isOverLimit
      ? 'Over Budget'
      : isNearLimit
      ? 'Near Limit'
      : 'On Track';
}
