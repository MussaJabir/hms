import 'package:freezed_annotation/freezed_annotation.dart';

part 'income.freezed.dart';
part 'income.g.dart';

/// A single income entry. Income can be entered manually (freelance, business,
/// gifts, etc.) or created automatically from a rent payment, in which case
/// [isAutoLinked] is true and the entry is read-only from the Finance module.
@freezed
abstract class Income with _$Income {
  const Income._();

  const factory Income({
    required String id,
    required String source, // "rent", "freelance", "business", "bodaboda"...
    required String description, // "Rent from John — Room 3"
    required double amount,
    required DateTime date,
    String? groundId, // associated ground (null for non-property income)
    String? linkedTenantId, // set when source is rent
    String? linkedRentRecordId, // set when source is rent
    @Default(false) bool isAutoLinked, // true if created from a rent payment
    @Default('') String notes,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String updatedBy,
    @Default(1) int schemaVersion,
  }) = _Income;

  factory Income.fromJson(Map<String, dynamic> json) => _$IncomeFromJson(json);

  bool get isRentIncome => source == 'rent';
  bool get hasGround => groundId != null && groundId!.isNotEmpty;
}
