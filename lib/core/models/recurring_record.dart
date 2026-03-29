import 'package:freezed_annotation/freezed_annotation.dart';

part 'recurring_record.freezed.dart';
part 'recurring_record.g.dart';

@freezed
abstract class RecurringRecord with _$RecurringRecord {
  const RecurringRecord._();

  const factory RecurringRecord({
    required String id,
    required String
    configId, // links back to the RecurringConfig that generated it
    required String type, // "rent", "water_contribution", "school_fee", etc.
    required String linkedEntityId,
    required String linkedEntityName,
    required double amount, // expected amount
    required String period, // "2026-03" format (year-month)
    required String status, // "pending", "paid", "partial", "overdue"
    @Default(0) double amountPaid, // how much has been paid so far
    DateTime? paidDate, // when it was marked paid
    String? paymentMethod, // "cash", "mobile_money", "bank_transfer"
    String? notes,
    required DateTime dueDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String updatedBy,
    @Default(1) int schemaVersion,
  }) = _RecurringRecord;

  factory RecurringRecord.fromJson(Map<String, dynamic> json) =>
      _$RecurringRecordFromJson(json);

  bool get isPaid => status == 'paid';
  bool get isPending => status == 'pending';
  bool get isPartial => status == 'partial';
  bool get isOverdue => status == 'overdue';
  double get remainingAmount => amount - amountPaid;
}
