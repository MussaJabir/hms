import 'package:freezed_annotation/freezed_annotation.dart';

part 'recurring_config.freezed.dart';
part 'recurring_config.g.dart';

@freezed
abstract class RecurringConfig with _$RecurringConfig {
  const factory RecurringConfig({
    required String id,
    required String
    type, // "rent", "water_contribution", "school_fee", "transport_fee", "budget_reset"
    required String collectionPath, // where to write generated records
    required String
    linkedEntityId, // tenant ID, child ID, or budget category ID
    required String
    linkedEntityName, // human-readable: "Room 3 - John", "Ahmad - School Fees"
    required double amount, // recurring amount in TZS
    required String frequency, // "monthly" or "termly"
    @Default(1) int dayOfMonth, // day of month to generate (1-28)
    @Default(true) bool isActive, // deactivated when tenant moves out
    required DateTime createdAt,
    required DateTime updatedAt,
    required String updatedBy,
    @Default(1) int schemaVersion,
  }) = _RecurringConfig;

  factory RecurringConfig.fromJson(Map<String, dynamic> json) =>
      _$RecurringConfigFromJson(json);
}
