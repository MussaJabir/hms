import 'package:freezed_annotation/freezed_annotation.dart';

part 'scheduled_notification.freezed.dart';
part 'scheduled_notification.g.dart';

@freezed
abstract class ScheduledNotification with _$ScheduledNotification {
  const ScheduledNotification._();

  const factory ScheduledNotification({
    required String id,
    required String type, // NotificationType.id value
    required String title,
    required String body,
    required DateTime scheduledAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String updatedBy,
    @Default(false) bool isRead,
    @Default(false) bool isDismissed,
    String? targetRoute, // GoRouter route for deep navigation e.g., "/rent"
    String? targetId, // optional entity ID for deep navigation
    @Default(1) int schemaVersion,
  }) = _ScheduledNotification;

  factory ScheduledNotification.fromJson(Map<String, dynamic> json) =>
      _$ScheduledNotificationFromJson(json);

  bool get isActive => !isRead && !isDismissed;
}
