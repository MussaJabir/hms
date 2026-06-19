// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Income _$IncomeFromJson(Map<String, dynamic> json) => _Income(
  id: json['id'] as String,
  source: json['source'] as String,
  description: json['description'] as String,
  amount: (json['amount'] as num).toDouble(),
  date: DateTime.parse(json['date'] as String),
  groundId: json['groundId'] as String?,
  linkedTenantId: json['linkedTenantId'] as String?,
  linkedRentRecordId: json['linkedRentRecordId'] as String?,
  isAutoLinked: json['isAutoLinked'] as bool? ?? false,
  notes: json['notes'] as String? ?? '',
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  updatedBy: json['updatedBy'] as String,
  schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$IncomeToJson(_Income instance) => <String, dynamic>{
  'id': instance.id,
  'source': instance.source,
  'description': instance.description,
  'amount': instance.amount,
  'date': instance.date.toIso8601String(),
  'groundId': instance.groundId,
  'linkedTenantId': instance.linkedTenantId,
  'linkedRentRecordId': instance.linkedRentRecordId,
  'isAutoLinked': instance.isAutoLinked,
  'notes': instance.notes,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'updatedBy': instance.updatedBy,
  'schemaVersion': instance.schemaVersion,
};
