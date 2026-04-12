// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_consumption.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WeeklyConsumption _$WeeklyConsumptionFromJson(Map<String, dynamic> json) =>
    _WeeklyConsumption(
      weekStart: DateTime.parse(json['weekStart'] as String),
      unitsConsumed: (json['unitsConsumed'] as num).toDouble(),
      estimatedCost: (json['estimatedCost'] as num).toDouble(),
    );

Map<String, dynamic> _$WeeklyConsumptionToJson(_WeeklyConsumption instance) =>
    <String, dynamic>{
      'weekStart': instance.weekStart.toIso8601String(),
      'unitsConsumed': instance.unitsConsumed,
      'estimatedCost': instance.estimatedCost,
    };
