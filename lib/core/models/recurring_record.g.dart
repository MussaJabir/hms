// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecurringRecord _$RecurringRecordFromJson(Map<String, dynamic> json) =>
    _RecurringRecord(
      id: json['id'] as String,
      configId: json['configId'] as String,
      type: json['type'] as String,
      linkedEntityId: json['linkedEntityId'] as String,
      linkedEntityName: json['linkedEntityName'] as String,
      amount: (json['amount'] as num).toDouble(),
      period: json['period'] as String,
      status: json['status'] as String,
      amountPaid: (json['amountPaid'] as num?)?.toDouble() ?? 0,
      paidDate: json['paidDate'] == null
          ? null
          : DateTime.parse(json['paidDate'] as String),
      paymentMethod: json['paymentMethod'] as String?,
      notes: json['notes'] as String?,
      dueDate: DateTime.parse(json['dueDate'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      updatedBy: json['updatedBy'] as String,
      schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$RecurringRecordToJson(_RecurringRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'configId': instance.configId,
      'type': instance.type,
      'linkedEntityId': instance.linkedEntityId,
      'linkedEntityName': instance.linkedEntityName,
      'amount': instance.amount,
      'period': instance.period,
      'status': instance.status,
      'amountPaid': instance.amountPaid,
      'paidDate': instance.paidDate?.toIso8601String(),
      'paymentMethod': instance.paymentMethod,
      'notes': instance.notes,
      'dueDate': instance.dueDate.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'updatedBy': instance.updatedBy,
      'schemaVersion': instance.schemaVersion,
    };
