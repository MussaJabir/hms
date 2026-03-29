import 'package:freezed_annotation/freezed_annotation.dart';

part 'ground.freezed.dart';
part 'ground.g.dart';

@freezed
abstract class Ground with _$Ground {
  const factory Ground({
    required String id,
    required String name,
    required String location,
    required int numberOfUnits,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String updatedBy,
    @Default(1) int schemaVersion,
  }) = _Ground;

  factory Ground.fromJson(Map<String, dynamic> json) => _$GroundFromJson(json);
}
