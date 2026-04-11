import 'package:hms/core/models/notification_type.dart';
import 'package:hms/core/models/recurring_record.dart';
import 'package:hms/core/services/notification_service.dart';
import 'package:hms/features/rent/services/rent_summary_service.dart';

/// Handles scheduling, showing, and cancelling local notifications for rent.
///
/// Notification ID strategy (deterministic, avoids collisions):
///   - Due reminder:  (record.id.hashCode.abs() % 10000000) * 2
///   - Overdue alert: (record.id.hashCode.abs() % 10000000) * 2 + 1
class RentNotificationService {
  RentNotificationService(this._notificationService, this._rentSummaryService);

  final NotificationService _notificationService;
  final RentSummaryService _rentSummaryService;

  // ---------------------------------------------------------------------------
  // Overdue notifications
  // ---------------------------------------------------------------------------

  /// Shows immediate overdue notifications for all currently overdue records.
  /// Call on app startup and after any rent payment update.
  Future<void> scheduleOverdueNotifications({required String userId}) async {
    final overdue = await _rentSummaryService.getOverdueRecords();
    final now = DateTime.now();

    for (final record in overdue) {
      final daysOverdue = now.difference(record.dueDate).inDays.abs();
      await _notificationService.showImmediateNotification(
        notificationId: _overdueId(record.id),
        type: NotificationType.rentOverdue,
        title: 'Rent Overdue',
        body:
            '${record.linkedEntityName} — $daysOverdue day${daysOverdue == 1 ? '' : 's'} overdue',
        targetRoute: '/rent',
        userId: userId,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Due reminder
  // ---------------------------------------------------------------------------

  /// Schedules a "rent due tomorrow" notification for a newly generated record.
  /// If the reminder date is already in the past, it is skipped silently.
  Future<void> scheduleRentDueReminder({
    required RecurringRecord rentRecord,
    required String userId,
  }) async {
    // Remind the day before the due date at 09:00.
    final reminderDate = rentRecord.dueDate.subtract(const Duration(days: 1));
    final scheduled = DateTime(
      reminderDate.year,
      reminderDate.month,
      reminderDate.day,
      9,
      0,
    );

    if (scheduled.isBefore(DateTime.now())) return; // already past — skip

    await _notificationService.scheduleNotification(
      notificationId: _dueReminderId(rentRecord.id),
      type: NotificationType.rentDue,
      title: 'Rent Due Tomorrow',
      body:
          '${rentRecord.linkedEntityName} — rent of ${rentRecord.amount.toStringAsFixed(0)} TZS is due tomorrow',
      scheduledDate: scheduled,
      targetRoute: '/rent',
      userId: userId,
    );
  }

  // ---------------------------------------------------------------------------
  // Cancellation
  // ---------------------------------------------------------------------------

  /// Cancels both the due reminder and any overdue notification for [rentRecordId].
  Future<void> cancelRentNotifications(String rentRecordId) async {
    await Future.wait([
      _notificationService.cancelNotification(_dueReminderId(rentRecordId)),
      _notificationService.cancelNotification(_overdueId(rentRecordId)),
    ]);
  }

  // ---------------------------------------------------------------------------
  // Deterministic ID helpers
  // ---------------------------------------------------------------------------

  static int _baseId(String recordId) => recordId.hashCode.abs() % 10000000;

  static int _dueReminderId(String recordId) => _baseId(recordId) * 2;

  static int _overdueId(String recordId) => _baseId(recordId) * 2 + 1;
}
