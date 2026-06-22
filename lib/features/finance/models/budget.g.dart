// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Budget _$BudgetFromJson(Map<String, dynamic> json) => _Budget(
  id: json['id'] as String,
  category: json['category'] as String,
  limitAmount: (json['limitAmount'] as num).toDouble(),
  period: json['period'] as String,
  spentAmount: (json['spentAmount'] as num?)?.toDouble() ?? 0,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  updatedBy: json['updatedBy'] as String,
  schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$BudgetToJson(_Budget instance) => <String, dynamic>{
  'id': instance.id,
  'category': instance.category,
  'limitAmount': instance.limitAmount,
  'period': instance.period,
  'spentAmount': instance.spentAmount,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'updatedBy': instance.updatedBy,
  'schemaVersion': instance.schemaVersion,
};
