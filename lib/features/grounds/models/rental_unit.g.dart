// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rental_unit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RentalUnit _$RentalUnitFromJson(Map<String, dynamic> json) => _RentalUnit(
  id: json['id'] as String,
  groundId: json['groundId'] as String,
  name: json['name'] as String,
  rentAmount: (json['rentAmount'] as num).toDouble(),
  status: json['status'] as String,
  meterId: json['meterId'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  updatedBy: json['updatedBy'] as String,
  schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$RentalUnitToJson(_RentalUnit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groundId': instance.groundId,
      'name': instance.name,
      'rentAmount': instance.rentAmount,
      'status': instance.status,
      'meterId': instance.meterId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'updatedBy': instance.updatedBy,
      'schemaVersion': instance.schemaVersion,
    };
