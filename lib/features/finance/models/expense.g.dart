// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Expense _$ExpenseFromJson(Map<String, dynamic> json) => _Expense(
  id: json['id'] as String,
  category: json['category'] as String,
  description: json['description'] as String,
  amount: (json['amount'] as num).toDouble(),
  date: DateTime.parse(json['date'] as String),
  groundId: json['groundId'] as String?,
  module: json['module'] as String?,
  linkedDocumentId: json['linkedDocumentId'] as String?,
  isAutoLinked: json['isAutoLinked'] as bool? ?? false,
  notes: json['notes'] as String? ?? '',
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  updatedBy: json['updatedBy'] as String,
  schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$ExpenseToJson(_Expense instance) => <String, dynamic>{
  'id': instance.id,
  'category': instance.category,
  'description': instance.description,
  'amount': instance.amount,
  'date': instance.date.toIso8601String(),
  'groundId': instance.groundId,
  'module': instance.module,
  'linkedDocumentId': instance.linkedDocumentId,
  'isAutoLinked': instance.isAutoLinked,
  'notes': instance.notes,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'updatedBy': instance.updatedBy,
  'schemaVersion': instance.schemaVersion,
};
