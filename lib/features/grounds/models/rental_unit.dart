import 'package:freezed_annotation/freezed_annotation.dart';

part 'rental_unit.freezed.dart';
part 'rental_unit.g.dart';

@freezed
abstract class RentalUnit with _$RentalUnit {
  const RentalUnit._();

  const factory RentalUnit({
    required String id,
    required String groundId,
    required String name,
    required double rentAmount,
    required String status,
    String? meterId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String updatedBy,
    @Default(1) int schemaVersion,
  }) = _RentalUnit;

  factory RentalUnit.fromJson(Map<String, dynamic> json) =>
      _$RentalUnitFromJson(json);

  bool get isOccupied => status == 'occupied';
  bool get isVacant => status == 'vacant';
}
