// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_consumption.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UnitConsumption _$UnitConsumptionFromJson(Map<String, dynamic> json) =>
    _UnitConsumption(
      unitId: json['unitId'] as String,
      unitName: json['unitName'] as String,
      tenantName: json['tenantName'] as String,
      unitsConsumed: (json['unitsConsumed'] as num).toDouble(),
      estimatedCost: (json['estimatedCost'] as num).toDouble(),
    );

Map<String, dynamic> _$UnitConsumptionToJson(_UnitConsumption instance) =>
    <String, dynamic>{
      'unitId': instance.unitId,
      'unitName': instance.unitName,
      'tenantName': instance.tenantName,
      'unitsConsumed': instance.unitsConsumed,
      'estimatedCost': instance.estimatedCost,
    };
