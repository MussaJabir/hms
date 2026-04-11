// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'electricity_meter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ElectricityMeter _$ElectricityMeterFromJson(Map<String, dynamic> json) =>
    _ElectricityMeter(
      id: json['id'] as String,
      groundId: json['groundId'] as String,
      unitId: json['unitId'] as String,
      meterNumber: json['meterNumber'] as String,
      initialReading: (json['initialReading'] as num?)?.toDouble() ?? 0,
      currentReading: (json['currentReading'] as num?)?.toDouble() ?? 0,
      weeklyThreshold: (json['weeklyThreshold'] as num?)?.toDouble() ?? 0,
      isActive: json['isActive'] as bool? ?? true,
      lastReadingDate: json['lastReadingDate'] == null
          ? null
          : DateTime.parse(json['lastReadingDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      updatedBy: json['updatedBy'] as String,
      schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$ElectricityMeterToJson(_ElectricityMeter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groundId': instance.groundId,
      'unitId': instance.unitId,
      'meterNumber': instance.meterNumber,
      'initialReading': instance.initialReading,
      'currentReading': instance.currentReading,
      'weeklyThreshold': instance.weeklyThreshold,
      'isActive': instance.isActive,
      'lastReadingDate': instance.lastReadingDate?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'updatedBy': instance.updatedBy,
      'schemaVersion': instance.schemaVersion,
    };
