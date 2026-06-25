import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_trend.freezed.dart';

/// Income and expenses for one month, used to plot the multi-month trend chart.
@freezed
abstract class MonthlyTrend with _$MonthlyTrend {
  const MonthlyTrend._();

  const factory MonthlyTrend({
    required String period,
    required double income,
    required double expenses,
  }) = _MonthlyTrend;

  double get netPosition => income - expenses;
}
