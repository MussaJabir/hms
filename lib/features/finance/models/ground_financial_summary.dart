import 'package:freezed_annotation/freezed_annotation.dart';

part 'ground_financial_summary.freezed.dart';

/// Income vs expenses for a single ground in a period, used for the per-ground
/// comparison on the monthly report and finance overview.
@freezed
abstract class GroundFinancialSummary with _$GroundFinancialSummary {
  const GroundFinancialSummary._();

  const factory GroundFinancialSummary({
    required String groundId,
    required String groundName,
    required double income,
    required double expenses,
  }) = _GroundFinancialSummary;

  double get netPosition => income - expenses;

  bool get isPositive => netPosition >= 0;
}
