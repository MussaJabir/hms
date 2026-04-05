// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'communication_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommunicationLog _$CommunicationLogFromJson(Map<String, dynamic> json) =>
    _CommunicationLog(
      id: json['id'] as String,
      tenantId: json['tenantId'] as String,
      note: json['note'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      createdBy: json['createdBy'] as String,
      schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$CommunicationLogToJson(_CommunicationLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenantId': instance.tenantId,
      'note': instance.note,
      'createdAt': instance.createdAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'schemaVersion': instance.schemaVersion,
    };
