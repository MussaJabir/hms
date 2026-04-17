import 'package:hms/core/models/notification_type.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/notification_service.dart';
import 'package:hms/features/electricity/models/reminder_config.dart';
import 'package:hms/features/electricity/services/meter_service.dart';
import 'package:hms/features/grounds/services/ground_service.dart';
import 'package:hms/features/grounds/services/rental_unit_service.dart';

class MeterReminderService {
  MeterReminderService(
    this._firestoreService,
    this._notificationService,
    this._groundService,
    this._rentalUnitService,
    this._meterService,
    this._activityLogService,
  );

  final FirestoreService _firestoreService;
  final NotificationService _notificationService;
  final GroundService _groundService;
  final RentalUnitService _rentalUnitService;
  final MeterService _meterService;
  final ActivityLogService _activityLogService;

  static const String collection = 'app_config';
  static const String docId = 'meter_reminder';

  /// Fixed notification ID — single weekly reminder, cancel/replace by same ID.
  static const int notificationId = 100001;

  // ---------------------------------------------------------------------------
  // Config read
  // ---------------------------------------------------------------------------

  Future<ReminderConfig> getConfig() async {
    final data = await _firestoreService.get(
      collectionPath: collection,
      documentId: docId,
    );
    if (data == null) return getDefaultConfig();
    return ReminderConfig.fromJson(_normalize(data));
  }

  Stream<ReminderConfig> streamConfig() {
    return _firestoreService.stream(collectionPath: collection).map((list) {
      final match = list.where((d) => d['id'] == docId).firstOrNull;
      if (match == null) return getDefaultConfig();
      return ReminderConfig.fromJson(_normalize(match));
    });
  }

  // ---------------------------------------------------------------------------
  // Config write
  // ---------------------------------------------------------------------------

  Future<void> updateConfig({
    required ReminderConfig config,
    required String userId,
  }) async {
    final data = config.toJson()
      ..remove('id')
      ..['updatedAt'] = config.updatedAt.toIso8601String()
      ..['updatedBy'] = userId;

    await _firestoreService.set(
      collectionPath: collection,
      documentId: docId,
      data: data,
      userId: userId,
    );

    await _activityLogService.log(
      userId: userId,
      action: 'update',
      module: 'electricity',
      description:
          'Updated meter reading reminder — ${config.dayName} at ${config.timeFormatted}',
      documentId: docId,
      collectionPath: collection,
    );
  }

  // ---------------------------------------------------------------------------
  // Scheduling
  // ---------------------------------------------------------------------------

  Future<void> scheduleReminder() async {
    // Always cancel first so we don't accumulate stale pending notifications.
    await _notificationService.cancelNotification(notificationId);

    final config = await getConfig();
    if (!config.enabled) return;

    final pending = await getPendingReadingsCount();
    final body = pending > 0
        ? 'Time to check meters — $pending rooms pending'
        : 'Time to record this week\'s meter readings';

    await _notificationService.scheduleWeeklyNotification(
      notificationId: notificationId,
      type: NotificationType.meterReading,
      title: 'Meter Reading Reminder',
      body: body,
      dayOfWeek: config.dayOfWeek,
      hour: config.hour,
      minute: config.minute,
      userId: config.updatedBy,
    );
  }

  Future<void> cancelReminder() async {
    await _notificationService.cancelNotification(notificationId);
  }

  // ---------------------------------------------------------------------------
  // Pending count
  // ---------------------------------------------------------------------------

  /// Returns the number of units across all grounds that have an active meter.
  /// Used to build the notification body text.
  Future<int> getPendingReadingsCount() async {
    try {
      final grounds = await _groundService.getAllGrounds();
      int count = 0;
      for (final ground in grounds) {
        final units = await _rentalUnitService.getAllUnits(ground.id);
        for (final unit in units) {
          if (unit.meterId != null) {
            final meter = await _meterService.getActiveMeter(
              ground.id,
              unit.id,
            );
            if (meter != null) count++;
          }
        }
      }
      return count;
    } catch (_) {
      return 0;
    }
  }

  // ---------------------------------------------------------------------------
  // Default config
  // ---------------------------------------------------------------------------

  ReminderConfig getDefaultConfig() {
    return ReminderConfig(
      id: docId,
      enabled: true,
      dayOfWeek: 7, // Sunday
      hour: 18, // 6 PM
      minute: 0,
      updatedAt: DateTime.now(),
      updatedBy: 'system',
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _normalize(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is DateTime) return MapEntry(key, value.toIso8601String());
      if (value != null && value.runtimeType.toString() == 'Timestamp') {
        return MapEntry(key, (value as dynamic).toDate().toIso8601String());
      }
      return MapEntry(key, value);
    });
  }
}
