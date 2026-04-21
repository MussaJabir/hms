import 'package:hms/core/models/notification_type.dart';
import 'package:hms/core/services/notification_service.dart';
import 'package:hms/features/water/models/water_bill.dart';
import 'package:hms/features/water/services/water_summary_service.dart';

/// Handles scheduling and cancelling local notifications for water bills.
///
/// Notification ID strategy (avoids collisions with other modules):
///   base = (billId.hashCode.abs() % 5_000_000) + 30_000_000
///   due-date reminder = base
///   overdue alert     = base + 1
class WaterNotificationService {
  WaterNotificationService(this._notificationService, this._summaryService);

  final NotificationService _notificationService;
  final WaterSummaryService _summaryService;

  static const int _defaultDaysBefore = 3;

  // ---------------------------------------------------------------------------
  // Scheduling
  // ---------------------------------------------------------------------------

  /// Schedules due-date reminders for all bills due soon. Idempotent.
  Future<void> scheduleDueDateReminders({required String userId}) async {
    final bills = await _summaryService.getBillsDueSoon();
    for (final bill in bills) {
      await scheduleBillReminder(
        bill: bill,
        groundName: bill.groundId,
        daysBefore: _defaultDaysBefore,
        userId: userId,
      );
    }
  }

  /// Shows immediate notifications for all overdue bills.
  Future<void> notifyOverdueBills({required String userId}) async {
    final bills = await _summaryService.getOverdueBills();
    for (final bill in bills) {
      final now = DateTime.now();
      final daysOverdue = now.difference(bill.dueDate).inDays;
      await _notificationService.showImmediateNotification(
        notificationId: _overdueId(bill.id),
        type: NotificationType.waterBillDue,
        title: 'Water Bill Overdue',
        body:
            '${bill.groundId} — ${bill.billingPeriod}, '
            '$daysOverdue day${daysOverdue == 1 ? '' : 's'} overdue',
        targetRoute: '/grounds/${bill.groundId}/water/${bill.id}',
        userId: userId,
      );
    }
  }

  /// Schedules a reminder [daysBefore] days before the bill's due date.
  Future<void> scheduleBillReminder({
    required WaterBill bill,
    required String groundName,
    required int daysBefore,
    required String userId,
  }) async {
    final reminderDate = bill.dueDate.subtract(Duration(days: daysBefore));
    if (reminderDate.isBefore(DateTime.now())) return;

    await _notificationService.scheduleNotification(
      notificationId: _dueId(bill.id),
      type: NotificationType.waterBillDue,
      title: 'Water Bill Due Soon',
      body: '$groundName — ${bill.billingPeriod} bill due in $daysBefore days',
      scheduledDate: reminderDate,
      targetRoute: '/grounds/${bill.groundId}/water/${bill.id}',
      userId: userId,
    );
  }

  // ---------------------------------------------------------------------------
  // Cancellation
  // ---------------------------------------------------------------------------

  /// Cancels all pending notifications for a specific bill (on payment).
  Future<void> cancelBillNotifications(String billId) async {
    await _notificationService.cancelNotification(_dueId(billId));
    await _notificationService.cancelNotification(_overdueId(billId));
  }

  // ---------------------------------------------------------------------------
  // ID helpers
  // ---------------------------------------------------------------------------

  static int _base(String billId) =>
      (billId.hashCode.abs() % 5000000) + 30000000;

  static int _dueId(String billId) => _base(billId);

  static int _overdueId(String billId) => _base(billId) + 1;
}
