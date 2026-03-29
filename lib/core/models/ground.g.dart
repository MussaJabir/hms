// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ground.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Ground _$GroundFromJson(Map<String, dynamic> json) => _Ground(
  id: json['id'] as String,
  name: json['name'] as String,
  location: json['location'] as String,
  numberOfUnits: (json['numberOfUnits'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  updatedBy: json['updatedBy'] as String,
  schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$GroundToJson(_Ground instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'location': instance.location,
  'numberOfUnits': instance.numberOfUnits,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'updatedBy': instance.updatedBy,
  'schemaVersion': instance.schemaVersion,
};
