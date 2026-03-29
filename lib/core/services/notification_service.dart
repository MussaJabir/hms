import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hms/core/models/notification_type.dart';
import 'package:hms/core/models/scheduled_notification.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService(
    this._firestore, {
    FlutterLocalNotificationsPlugin? plugin,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FirestoreService _firestore;
  final FlutterLocalNotificationsPlugin _plugin;

  static const String collection = 'notifications';

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  /// Call once at app startup to configure channels, permissions, and timezone.
  Future<void> initialize() async {
    tz_data.initializeTimeZones();
    // Default to EAT (UTC+3) for Tanzania; falls back to UTC in environments
    // where the full tz database is unavailable (e.g., unit tests).
    try {
      tz.setLocalLocation(tz.getLocation('Africa/Dar_es_Salaam'));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create one Android notification channel per NotificationType.
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    for (final type in NotificationType.values) {
      await androidPlugin?.createNotificationChannel(
        AndroidNotificationChannel(
          type.id,
          type.title,
          description: type.channelDescription,
          importance: Importance.high,
        ),
      );
    }

    // Request POST_NOTIFICATIONS permission (Android 13+).
    await androidPlugin?.requestNotificationsPermission();
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Navigation wiring will be added in a future phase via GoRouter.
    debugPrint(
      'Notification tapped: ${response.id} — payload: ${response.payload}',
    );
  }

  // ---------------------------------------------------------------------------
  // Scheduling helpers
  // ---------------------------------------------------------------------------

  AndroidNotificationDetails _androidDetails(NotificationType type) {
    return AndroidNotificationDetails(
      type.id,
      type.title,
      channelDescription: type.channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );
  }

  // ---------------------------------------------------------------------------
  // Scheduling
  // ---------------------------------------------------------------------------

  /// Schedules a one-time notification at [scheduledDate].
  /// Also saves a ScheduledNotification record to Firestore for the in-app inbox.
  Future<void> scheduleNotification({
    required int notificationId,
    required NotificationType type,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? targetRoute,
    String? targetId,
    required String userId,
  }) async {
    final tzDate = tz.TZDateTime.from(scheduledDate, tz.local);

    await _plugin.zonedSchedule(
      id: notificationId,
      title: title,
      body: body,
      scheduledDate: tzDate,
      notificationDetails: NotificationDetails(android: _androidDetails(type)),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: targetRoute,
    );

    await _saveToFirestore(
      notificationId: notificationId,
      type: type,
      title: title,
      body: body,
      scheduledAt: scheduledDate,
      targetRoute: targetRoute,
      targetId: targetId,
      userId: userId,
    );
  }

  /// Schedules a weekly repeating notification (e.g., meter reading every Sunday at 18:00).
  Future<void> scheduleWeeklyNotification({
    required int notificationId,
    required NotificationType type,
    required String title,
    required String body,
    required int dayOfWeek, // 1=Monday … 7=Sunday
    required int hour,
    required int minute,
    required String userId,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Advance to the correct weekday (Dart weekday: 1=Mon, 7=Sun).
    while (scheduled.weekday != dayOfWeek || scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      id: notificationId,
      title: title,
      body: body,
      scheduledDate: scheduled,
      notificationDetails: NotificationDetails(android: _androidDetails(type)),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );

    await _saveToFirestore(
      notificationId: notificationId,
      type: type,
      title: title,
      body: body,
      scheduledAt: scheduled.toLocal(),
      userId: userId,
    );
  }

  /// Shows a notification immediately.
  /// Also saves to Firestore for the in-app inbox.
  Future<void> showImmediateNotification({
    required int notificationId,
    required NotificationType type,
    required String title,
    required String body,
    String? targetRoute,
    String? targetId,
    required String userId,
  }) async {
    await _plugin.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(android: _androidDetails(type)),
      payload: targetRoute,
    );

    await _saveToFirestore(
      notificationId: notificationId,
      type: type,
      title: title,
      body: body,
      scheduledAt: DateTime.now(),
      targetRoute: targetRoute,
      targetId: targetId,
      userId: userId,
    );
  }

  // ---------------------------------------------------------------------------
  // Cancellation
  // ---------------------------------------------------------------------------

  /// Cancels a single notification by its integer ID.
  Future<void> cancelNotification(int notificationId) async {
    await _plugin.cancel(id: notificationId);
  }

  /// Cancels all notifications belonging to a specific [type] channel.
  Future<void> cancelAllOfType(NotificationType type) async {
    // flutter_local_notifications doesn't support channel-level cancel on Android;
    // cancel all and let the caller re-schedule what's still needed.
    final pending = await _plugin.pendingNotificationRequests();
    for (final n in pending) {
      // Payload carries the type id when set.
      if (n.payload == type.id) {
        await _plugin.cancel(id: n.id);
      }
    }
  }

  /// Cancels ALL pending notifications.
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  // ---------------------------------------------------------------------------
  // Notification history (Firestore-backed in-app inbox)
  // ---------------------------------------------------------------------------

  /// Returns notification history, newest first.
  Future<List<ScheduledNotification>> getHistory({int? limit}) async {
    final docs = await _firestore.getAll(
      collectionPath: collection,
      orderBy: 'scheduledAt',
      descending: true,
      limit: limit,
    );
    return docs.map(_fromMap).toList();
  }

  /// Streams notification history for real-time inbox updates.
  Stream<List<ScheduledNotification>> streamHistory() {
    return _firestore
        .stream(
          collectionPath: collection,
          orderBy: 'scheduledAt',
          descending: true,
        )
        .map((list) => list.map(_fromMap).toList());
  }

  /// Returns the count of active (unread, non-dismissed) notifications.
  Future<int> getUnreadCount() async {
    final all = await getHistory();
    return all.where((n) => n.isActive).length;
  }

  /// Streams the unread count for badge display.
  Stream<int> streamUnreadCount() {
    return streamHistory().map((list) => list.where((n) => n.isActive).length);
  }

  /// Marks a single notification as read.
  Future<void> markAsRead({
    required String notificationDocId,
    required String userId,
  }) async {
    await _firestore.update(
      collectionPath: collection,
      documentId: notificationDocId,
      data: {'isRead': true},
      userId: userId,
    );
  }

  /// Marks all unread notifications as read.
  Future<void> markAllAsRead({required String userId}) async {
    final all = await getHistory();
    final unread = all.where((n) => !n.isRead && !n.isDismissed);
    for (final n in unread) {
      await markAsRead(notificationDocId: n.id, userId: userId);
    }
  }

  /// Dismisses a notification (keeps it in history but removes from active inbox).
  Future<void> dismiss({
    required String notificationDocId,
    required String userId,
  }) async {
    await _firestore.update(
      collectionPath: collection,
      documentId: notificationDocId,
      data: {'isDismissed': true},
      userId: userId,
    );
  }

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  Future<void> _saveToFirestore({
    required int notificationId,
    required NotificationType type,
    required String title,
    required String body,
    required DateTime scheduledAt,
    String? targetRoute,
    String? targetId,
    required String userId,
  }) async {
    final now = DateTime.now();
    final docId = '${type.id}_$notificationId';

    final notification = ScheduledNotification(
      id: docId,
      type: type.id,
      title: title,
      body: body,
      scheduledAt: scheduledAt,
      createdAt: now,
      updatedAt: now,
      updatedBy: userId,
      targetRoute: targetRoute,
      targetId: targetId,
    );

    await _firestore.set(
      collectionPath: collection,
      documentId: docId,
      data: notification.toJson()..remove('id'),
      userId: userId,
    );
  }

  ScheduledNotification _fromMap(Map<String, dynamic> map) {
    return ScheduledNotification.fromJson(_normalizeTimestamps(map));
  }

  Map<String, dynamic> _normalizeTimestamps(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is DateTime) return MapEntry(key, value.toIso8601String());
      if (value != null && value.runtimeType.toString() == 'Timestamp') {
        return MapEntry(key, (value as dynamic).toDate().toIso8601String());
      }
      return MapEntry(key, value);
    });
  }
}
