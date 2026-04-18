import 'package:freezed_annotation/freezed_annotation.dart';

part 'water_bill.freezed.dart';
part 'water_bill.g.dart';

@freezed
abstract class WaterBill with _$WaterBill {
  const WaterBill._();

  const factory WaterBill({
    required String id,
    required String groundId,
    required String billingPeriod,
    required double previousMeterReading,
    required double currentMeterReading,
    required double totalAmount,
    required DateTime dueDate,
    required String status,
    DateTime? paidDate,
    String? paymentMethod,
    String? rawSmsText,
    @Default('') String notes,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String updatedBy,
    @Default(1) int schemaVersion,
  }) = _WaterBill;

  factory WaterBill.fromJson(Map<String, dynamic> json) =>
      _$WaterBillFromJson(json);

  double get unitsConsumed => currentMeterReading - previousMeterReading;
  bool get isPaid => status == 'paid';
  bool get isUnpaid => status == 'unpaid';
  bool get isOverdue => status == 'overdue';
  bool get isDueSoon =>
      !isPaid &&
      dueDate.difference(DateTime.now()).inDays <= 7 &&
      dueDate.isAfter(DateTime.now());
  bool get hasSmsData => rawSmsText != null && rawSmsText!.isNotEmpty;
}
