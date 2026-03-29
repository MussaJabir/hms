// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduledNotification _$ScheduledNotificationFromJson(
  Map<String, dynamic> json,
) => _ScheduledNotification(
  id: json['id'] as String,
  type: json['type'] as String,
  title: json['title'] as String,
  body: json['body'] as String,
  scheduledAt: DateTime.parse(json['scheduledAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  updatedBy: json['updatedBy'] as String,
  isRead: json['isRead'] as bool? ?? false,
  isDismissed: json['isDismissed'] as bool? ?? false,
  targetRoute: json['targetRoute'] as String?,
  targetId: json['targetId'] as String?,
  schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$ScheduledNotificationToJson(
  _ScheduledNotification instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'title': instance.title,
  'body': instance.body,
  'scheduledAt': instance.scheduledAt.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'updatedBy': instance.updatedBy,
  'isRead': instance.isRead,
  'isDismissed': instance.isDismissed,
  'targetRoute': instance.targetRoute,
  'targetId': instance.targetId,
  'schemaVersion': instance.schemaVersion,
};
