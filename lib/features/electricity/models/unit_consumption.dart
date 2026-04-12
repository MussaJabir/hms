import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit_consumption.freezed.dart';
part 'unit_consumption.g.dart';

@freezed
abstract class UnitConsumption with _$UnitConsumption {
  const factory UnitConsumption({
    required String unitId,
    required String unitName,
    required String tenantName,
    required double unitsConsumed,
    required double estimatedCost,
  }) = _UnitConsumption;

  factory UnitConsumption.fromJson(Map<String, dynamic> json) =>
      _$UnitConsumptionFromJson(json);
}
