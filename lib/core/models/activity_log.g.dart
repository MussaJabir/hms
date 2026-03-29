// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivityLog _$ActivityLogFromJson(Map<String, dynamic> json) => _ActivityLog(
  id: json['id'] as String,
  userId: json['userId'] as String,
  action: json['action'] as String,
  module: json['module'] as String,
  description: json['description'] as String,
  documentId: json['documentId'] as String?,
  collectionPath: json['collectionPath'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$ActivityLogToJson(_ActivityLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'action': instance.action,
      'module': instance.module,
      'description': instance.description,
      'documentId': instance.documentId,
      'collectionPath': instance.collectionPath,
      'createdAt': instance.createdAt.toIso8601String(),
      'schemaVersion': instance.schemaVersion,
    };
