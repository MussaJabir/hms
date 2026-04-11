import 'package:freezed_annotation/freezed_annotation.dart';

part 'electricity_meter.freezed.dart';
part 'electricity_meter.g.dart';

@freezed
abstract class ElectricityMeter with _$ElectricityMeter {
  const ElectricityMeter._();

  const factory ElectricityMeter({
    required String id,
    required String groundId,
    required String unitId,
    required String meterNumber,
    @Default(0) double initialReading,
    @Default(0) double currentReading,
    @Default(0) double weeklyThreshold,
    @Default(true) bool isActive,
    DateTime? lastReadingDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String updatedBy,
    @Default(1) int schemaVersion,
  }) = _ElectricityMeter;

  factory ElectricityMeter.fromJson(Map<String, dynamic> json) =>
      _$ElectricityMeterFromJson(json);

  bool get hasThreshold => weeklyThreshold > 0;
}
