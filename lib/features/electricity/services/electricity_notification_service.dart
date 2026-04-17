import 'package:hms/core/models/notification_type.dart';
import 'package:hms/core/services/notification_service.dart';
import 'package:hms/core/widgets/alert_severity.dart';
import 'package:hms/features/electricity/models/consumption_warning.dart';
import 'package:hms/features/electricity/services/consumption_alert_service.dart';

/// Handles scheduling and cancelling local notifications for electricity
/// consumption warnings.
///
/// Notification ID strategy (deterministic, avoids collisions with rent IDs):
///   - base  = (meterId.hashCode.abs() % 5_000_000) + 20_000_000
///   - warning/info notification ID  = base * 2
///   - critical notification ID      = base * 2 + 1
class ElectricityNotificationService {
  ElectricityNotificationService(this._notificationService, this._alertService);

  final NotificationService _notificationService;
  final ConsumptionAlertService _alertService;

  // ---------------------------------------------------------------------------
  // Scheduling
  // ---------------------------------------------------------------------------

  /// Schedules immediate notifications for all active consumption warnings.
  /// Call on app startup and after every new meter reading is recorded.
  Future<void> scheduleConsumptionAlerts({required String userId}) async {
    final warnings = await _alertService.getActiveWarnings();
    for (final warning in warnings) {
      await scheduleWarningNotification(warning: warning, userId: userId);
    }
  }

  /// Shows an immediate notification for a single consumption warning.
  Future<void> scheduleWarningNotification({
    required ConsumptionWarning warning,
    required String userId,
  }) async {
    final type = warning.severity == AlertSeverity.critical
        ? NotificationType.electricityHigh
        : NotificationType.electricityHigh;

    final id = warning.severity == AlertSeverity.critical
        ? _criticalId(warning.meterId)
        : _warningId(warning.meterId);

    final percentOver = warning.percentOverThreshold.toStringAsFixed(0);
    final severityLabel = switch (warning.severity) {
      AlertSeverity.critical => 'Critical',
      AlertSeverity.warning => 'High',
      _ => 'Above Threshold',
    };

    await _notificationService.showImmediateNotification(
      notificationId: id,
      type: type,
      title: '$severityLabel Consumption — ${warning.unitName}',
      body:
          '${warning.actualConsumption.toStringAsFixed(1)} units used '
          '($percentOver% over ${warning.threshold.toStringAsFixed(0)} unit threshold)',
      targetRoute: '/electricity/warnings',
      userId: userId,
    );
  }

  // ---------------------------------------------------------------------------
  // Cancellation
  // ---------------------------------------------------------------------------

  /// Cancels all pending electricity-related notifications.
  Future<void> cancelAllElectricityNotifications() async {
    await _notificationService.cancelAllOfType(
      NotificationType.electricityHigh,
    );
  }

  // ---------------------------------------------------------------------------
  // ID helpers
  // ---------------------------------------------------------------------------

  static int _base(String meterId) =>
      (meterId.hashCode.abs() % 5000000) + 20000000;

  static int _warningId(String meterId) => _base(meterId) * 2;

  static int _criticalId(String meterId) => _base(meterId) * 2 + 1;
}
