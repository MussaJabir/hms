// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_consumption.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MonthlyConsumption _$MonthlyConsumptionFromJson(Map<String, dynamic> json) =>
    _MonthlyConsumption(
      period: json['period'] as String,
      unitsConsumed: (json['unitsConsumed'] as num).toDouble(),
      estimatedCost: (json['estimatedCost'] as num).toDouble(),
    );

Map<String, dynamic> _$MonthlyConsumptionToJson(_MonthlyConsumption instance) =>
    <String, dynamic>{
      'period': instance.period,
      'unitsConsumed': instance.unitsConsumed,
      'estimatedCost': instance.estimatedCost,
    };
