// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_bill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WaterBill _$WaterBillFromJson(Map<String, dynamic> json) => _WaterBill(
  id: json['id'] as String,
  groundId: json['groundId'] as String,
  billingPeriod: json['billingPeriod'] as String,
  previousMeterReading: (json['previousMeterReading'] as num).toDouble(),
  currentMeterReading: (json['currentMeterReading'] as num).toDouble(),
  totalAmount: (json['totalAmount'] as num).toDouble(),
  dueDate: DateTime.parse(json['dueDate'] as String),
  status: json['status'] as String,
  paidDate: json['paidDate'] == null
      ? null
      : DateTime.parse(json['paidDate'] as String),
  paymentMethod: json['paymentMethod'] as String?,
  rawSmsText: json['rawSmsText'] as String?,
  notes: json['notes'] as String? ?? '',
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  updatedBy: json['updatedBy'] as String,
  schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$WaterBillToJson(_WaterBill instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groundId': instance.groundId,
      'billingPeriod': instance.billingPeriod,
      'previousMeterReading': instance.previousMeterReading,
      'currentMeterReading': instance.currentMeterReading,
      'totalAmount': instance.totalAmount,
      'dueDate': instance.dueDate.toIso8601String(),
      'status': instance.status,
      'paidDate': instance.paidDate?.toIso8601String(),
      'paymentMethod': instance.paymentMethod,
      'rawSmsText': instance.rawSmsText,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'updatedBy': instance.updatedBy,
      'schemaVersion': instance.schemaVersion,
    };
