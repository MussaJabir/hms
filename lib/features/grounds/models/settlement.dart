import 'package:freezed_annotation/freezed_annotation.dart';

part 'settlement.freezed.dart';
part 'settlement.g.dart';

@freezed
abstract class Settlement with _$Settlement {
  const Settlement._();

  const factory Settlement({
    required String id,
    required String groundId,
    required String unitId,
    required String tenantId,
    required String tenantName,
    required DateTime moveOutDate,
    @Default(0) double outstandingRent,
    @Default(0) double outstandingWater,
    @Default(0) double otherCharges,
    @Default('') String notes,
    required String status, // "settled", "pending", "waived"
    required DateTime createdAt,
    required DateTime updatedAt,
    required String updatedBy,
    @Default(1) int schemaVersion,
  }) = _Settlement;

  factory Settlement.fromJson(Map<String, dynamic> json) =>
      _$SettlementFromJson(json);

  double get totalOutstanding =>
      outstandingRent + outstandingWater + otherCharges;
  bool get isSettled => status == 'settled';
  bool get isPending => status == 'pending';
  bool get isWaived => status == 'waived';
}
