// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Tenant _$TenantFromJson(Map<String, dynamic> json) => _Tenant(
  id: json['id'] as String,
  groundId: json['groundId'] as String,
  unitId: json['unitId'] as String,
  fullName: json['fullName'] as String,
  phoneNumber: json['phoneNumber'] as String,
  nationalId: json['nationalId'] as String?,
  moveInDate: DateTime.parse(json['moveInDate'] as String),
  leaseEndDate: json['leaseEndDate'] == null
      ? null
      : DateTime.parse(json['leaseEndDate'] as String),
  notes: json['notes'] as String? ?? '',
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  updatedBy: json['updatedBy'] as String,
  schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$TenantToJson(_Tenant instance) => <String, dynamic>{
  'id': instance.id,
  'groundId': instance.groundId,
  'unitId': instance.unitId,
  'fullName': instance.fullName,
  'phoneNumber': instance.phoneNumber,
  'nationalId': instance.nationalId,
  'moveInDate': instance.moveInDate.toIso8601String(),
  'leaseEndDate': instance.leaseEndDate?.toIso8601String(),
  'notes': instance.notes,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'updatedBy': instance.updatedBy,
  'schemaVersion': instance.schemaVersion,
};
