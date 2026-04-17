// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReminderConfig _$ReminderConfigFromJson(Map<String, dynamic> json) =>
    _ReminderConfig(
      id: json['id'] as String,
      enabled: json['enabled'] as bool? ?? true,
      dayOfWeek: (json['dayOfWeek'] as num?)?.toInt() ?? 7,
      hour: (json['hour'] as num?)?.toInt() ?? 18,
      minute: (json['minute'] as num?)?.toInt() ?? 0,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      updatedBy: json['updatedBy'] as String,
      schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$ReminderConfigToJson(_ReminderConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'enabled': instance.enabled,
      'dayOfWeek': instance.dayOfWeek,
      'hour': instance.hour,
      'minute': instance.minute,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'updatedBy': instance.updatedBy,
      'schemaVersion': instance.schemaVersion,
    };
