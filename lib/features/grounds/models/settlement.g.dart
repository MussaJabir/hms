// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Settlement _$SettlementFromJson(Map<String, dynamic> json) => _Settlement(
  id: json['id'] as String,
  groundId: json['groundId'] as String,
  unitId: json['unitId'] as String,
  tenantId: json['tenantId'] as String,
  tenantName: json['tenantName'] as String,
  moveOutDate: DateTime.parse(json['moveOutDate'] as String),
  outstandingRent: (json['outstandingRent'] as num?)?.toDouble() ?? 0,
  outstandingWater: (json['outstandingWater'] as num?)?.toDouble() ?? 0,
  otherCharges: (json['otherCharges'] as num?)?.toDouble() ?? 0,
  notes: json['notes'] as String? ?? '',
  status: json['status'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  updatedBy: json['updatedBy'] as String,
  schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$SettlementToJson(_Settlement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groundId': instance.groundId,
      'unitId': instance.unitId,
      'tenantId': instance.tenantId,
      'tenantName': instance.tenantName,
      'moveOutDate': instance.moveOutDate.toIso8601String(),
      'outstandingRent': instance.outstandingRent,
      'outstandingWater': instance.outstandingWater,
      'otherCharges': instance.otherCharges,
      'notes': instance.notes,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'updatedBy': instance.updatedBy,
      'schemaVersion': instance.schemaVersion,
    };
