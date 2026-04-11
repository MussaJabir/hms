// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meter_reading.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MeterReading _$MeterReadingFromJson(Map<String, dynamic> json) =>
    _MeterReading(
      id: json['id'] as String,
      groundId: json['groundId'] as String,
      unitId: json['unitId'] as String,
      meterId: json['meterId'] as String,
      reading: (json['reading'] as num).toDouble(),
      previousReading: (json['previousReading'] as num).toDouble(),
      unitsConsumed: (json['unitsConsumed'] as num).toDouble(),
      readingDate: DateTime.parse(json['readingDate'] as String),
      isMeterReset: json['isMeterReset'] as bool? ?? false,
      notes: json['notes'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      updatedBy: json['updatedBy'] as String,
      schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$MeterReadingToJson(_MeterReading instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groundId': instance.groundId,
      'unitId': instance.unitId,
      'meterId': instance.meterId,
      'reading': instance.reading,
      'previousReading': instance.previousReading,
      'unitsConsumed': instance.unitsConsumed,
      'readingDate': instance.readingDate.toIso8601String(),
      'isMeterReset': instance.isMeterReset,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'updatedBy': instance.updatedBy,
      'schemaVersion': instance.schemaVersion,
    };
