import 'package:freezed_annotation/freezed_annotation.dart';

part 'weekly_consumption.freezed.dart';
part 'weekly_consumption.g.dart';

@freezed
abstract class WeeklyConsumption with _$WeeklyConsumption {
  const factory WeeklyConsumption({
    required DateTime weekStart,
    required double unitsConsumed,
    required double estimatedCost,
  }) = _WeeklyConsumption;

  factory WeeklyConsumption.fromJson(Map<String, dynamic> json) =>
      _$WeeklyConsumptionFromJson(json);
}
