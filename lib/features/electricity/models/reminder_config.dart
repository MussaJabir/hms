import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_config.freezed.dart';
part 'reminder_config.g.dart';

@freezed
abstract class ReminderConfig with _$ReminderConfig {
  const ReminderConfig._();

  const factory ReminderConfig({
    required String id,
    @Default(true) bool enabled,
    @Default(7) int dayOfWeek, // 1=Monday, 7=Sunday
    @Default(18) int hour, // 24-hour format
    @Default(0) int minute,
    required DateTime updatedAt,
    required String updatedBy,
    @Default(1) int schemaVersion,
  }) = _ReminderConfig;

  factory ReminderConfig.fromJson(Map<String, dynamic> json) =>
      _$ReminderConfigFromJson(json);

  String get dayName {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[dayOfWeek - 1];
  }

  String get timeFormatted =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
