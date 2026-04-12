import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_consumption.freezed.dart';
part 'monthly_consumption.g.dart';

@freezed
abstract class MonthlyConsumption with _$MonthlyConsumption {
  const factory MonthlyConsumption({
    required String period, // "2026-03"
    required double unitsConsumed,
    required double estimatedCost,
  }) = _MonthlyConsumption;

  factory MonthlyConsumption.fromJson(Map<String, dynamic> json) =>
      _$MonthlyConsumptionFromJson(json);
}
