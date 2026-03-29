// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecurringConfig _$RecurringConfigFromJson(Map<String, dynamic> json) =>
    _RecurringConfig(
      id: json['id'] as String,
      type: json['type'] as String,
      collectionPath: json['collectionPath'] as String,
      linkedEntityId: json['linkedEntityId'] as String,
      linkedEntityName: json['linkedEntityName'] as String,
      amount: (json['amount'] as num).toDouble(),
      frequency: json['frequency'] as String,
      dayOfMonth: (json['dayOfMonth'] as num?)?.toInt() ?? 1,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      updatedBy: json['updatedBy'] as String,
      schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$RecurringConfigToJson(_RecurringConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'collectionPath': instance.collectionPath,
      'linkedEntityId': instance.linkedEntityId,
      'linkedEntityName': instance.linkedEntityName,
      'amount': instance.amount,
      'frequency': instance.frequency,
      'dayOfMonth': instance.dayOfMonth,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'updatedBy': instance.updatedBy,
      'schemaVersion': instance.schemaVersion,
    };
