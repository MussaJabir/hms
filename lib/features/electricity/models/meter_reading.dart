import 'package:freezed_annotation/freezed_annotation.dart';

part 'meter_reading.freezed.dart';
part 'meter_reading.g.dart';

@freezed
abstract class MeterReading with _$MeterReading {
  const MeterReading._();

  const factory MeterReading({
    required String id,
    required String groundId,
    required String unitId,
    required String meterId,
    required double reading,
    required double previousReading,
    required double unitsConsumed,
    required DateTime readingDate,
    @Default(false) bool isMeterReset,
    @Default('') String notes,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String updatedBy,
    @Default(1) int schemaVersion,
  }) = _MeterReading;

  factory MeterReading.fromJson(Map<String, dynamic> json) =>
      _$MeterReadingFromJson(json);
}
