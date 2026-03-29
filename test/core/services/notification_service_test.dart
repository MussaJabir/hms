import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/timezone.dart' show TZDateTime;
import 'package:hms/core/models/notification_type.dart';
import 'package:hms/core/models/scheduled_notification.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/notification_service.dart';

// ---------------------------------------------------------------------------
// Fake plugin that satisfies the FlutterLocalNotificationsPlugin factory.
// We inject it via the NotificationService constructor's optional plugin param.
// ---------------------------------------------------------------------------
class _FakePlugin extends Fake implements FlutterLocalNotificationsPlugin {
  bool initialized = false;
  final List<Map<String, dynamic>> shown = [];
  final List<int> cancelled = [];
  bool allCancelled = false;

  @override
  Future<bool?> initialize({
    required InitializationSettings settings,
    DidReceiveNotificationResponseCallback? onDidReceiveNotificationResponse,
    DidReceiveBackgroundNotificationResponseCallback?
    onDidReceiveBackgroundNotificationResponse,
  }) async {
    initialized = true;
    return true;
  }

  @override
  Future<void> show({
    required int id,
    String? title,
    String? body,
    NotificationDetails? notificationDetails,
    String? payload,
  }) async {
    shown.add({'id': id, 'title': title, 'body': body, 'payload': payload});
  }

  @override
  Future<void> zonedSchedule({
    required int id,
    required TZDateTime scheduledDate,
    required NotificationDetails notificationDetails,
    required AndroidScheduleMode androidScheduleMode,
    String? title,
    String? body,
    String? payload,
    DateTimeComponents? matchDateTimeComponents,
  }) async {
    shown.add({
      'id': id,
      'title': title,
      'body': body,
      'payload': payload,
      'scheduled': true,
    });
  }

  @override
  Future<void> cancel({required int id, String? tag}) async {
    cancelled.add(id);
  }

  @override
  Future<void> cancelAll() async {
    allCancelled = true;
  }

  @override
  Future<List<PendingNotificationRequest>> pendingNotificationRequests() async {
    return [];
  }

  @override
  T? resolvePlatformSpecificImplementation<
    T extends FlutterLocalNotificationsPlatform
  >() => null;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------
void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late _FakePlugin fakePlugin;
  late NotificationService service;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
    fakePlugin = _FakePlugin();
    service = NotificationService(firestoreService, plugin: fakePlugin);
  });

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------
  group('initialize', () {
    test('completes without error', () async {
      await expectLater(service.initialize(), completes);
    });

    test('initializes the flutter_local_notifications plugin', () async {
      await service.initialize();
      expect(fakePlugin.initialized, isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // NotificationType enum
  // ---------------------------------------------------------------------------
  group('NotificationType', () {
    test('rentDue has correct values', () {
      expect(NotificationType.rentDue.id, 'rent_due');
      expect(NotificationType.rentDue.title, 'Rent Due');
      expect(
        NotificationType.rentDue.channelDescription,
        'Rent payment reminder',
      );
    });

    test('meterReading has correct values', () {
      expect(NotificationType.meterReading.id, 'meter_reading');
      expect(NotificationType.meterReading.title, 'Meter Reading');
    });

    test('budgetExceeded has correct values', () {
      expect(NotificationType.budgetExceeded.id, 'budget_exceeded');
      expect(
        NotificationType.budgetExceeded.channelDescription,
        'Budget limit exceeded',
      );
    });

    test('has 10 notification types', () {
      expect(NotificationType.values.length, 10);
    });
  });

  // ---------------------------------------------------------------------------
  // showImmediateNotification
  // ---------------------------------------------------------------------------
  group('showImmediateNotification', () {
    setUp(() async => service.initialize());

    test('saves ScheduledNotification record to Firestore', () async {
      await service.showImmediateNotification(
        notificationId: 1,
        type: NotificationType.lowStock,
        title: 'Low Stock',
        body: 'Rice is running low',
        userId: 'user-1',
      );

      final snap = await fakeFirestore.collection('notifications').get();
      expect(snap.docs.length, 1);
      expect(snap.docs.first.data()['type'], 'low_stock');
      expect(snap.docs.first.data()['title'], 'Low Stock');
    });

    test('calls plugin.show', () async {
      await service.showImmediateNotification(
        notificationId: 42,
        type: NotificationType.rentDue,
        title: 'Rent Due',
        body: 'Room 3 rent is due',
        userId: 'user-1',
      );

      expect(fakePlugin.shown, hasLength(1));
      expect(fakePlugin.shown.first['id'], 42);
    });

    test('stores targetRoute and targetId when provided', () async {
      await service.showImmediateNotification(
        notificationId: 2,
        type: NotificationType.rentDue,
        title: 'Rent Due',
        body: 'Body',
        targetRoute: '/rent',
        targetId: 'tenant-1',
        userId: 'user-1',
      );

      final snap = await fakeFirestore.collection('notifications').get();
      expect(snap.docs.first.data()['targetRoute'], '/rent');
      expect(snap.docs.first.data()['targetId'], 'tenant-1');
    });
  });

  // ---------------------------------------------------------------------------
  // scheduleNotification
  // ---------------------------------------------------------------------------
  group('scheduleNotification', () {
    setUp(() async => service.initialize());

    test('saves ScheduledNotification record to Firestore', () async {
      await service.scheduleNotification(
        notificationId: 10,
        type: NotificationType.rentDue,
        title: 'Rent Due',
        body: 'Room 3 rent is due',
        scheduledDate: DateTime.now().add(const Duration(days: 1)),
        userId: 'user-1',
      );

      final snap = await fakeFirestore.collection('notifications').get();
      expect(snap.docs.length, 1);
      expect(snap.docs.first.data()['type'], 'rent_due');
    });

    test('record starts as unread and not dismissed', () async {
      await service.scheduleNotification(
        notificationId: 11,
        type: NotificationType.waterBillDue,
        title: 'Water Bill',
        body: 'Water bill due',
        scheduledDate: DateTime.now().add(const Duration(days: 3)),
        userId: 'user-1',
      );

      final snap = await fakeFirestore.collection('notifications').get();
      expect(snap.docs.first.data()['isRead'], false);
      expect(snap.docs.first.data()['isDismissed'], false);
    });
  });

  // ---------------------------------------------------------------------------
  // markAsRead
  // ---------------------------------------------------------------------------
  group('markAsRead', () {
    setUp(() async {
      await service.initialize();
      await service.showImmediateNotification(
        notificationId: 1,
        type: NotificationType.lowStock,
        title: 'Low Stock',
        body: 'Body',
        userId: 'user-1',
      );
    });

    test('sets isRead to true', () async {
      final snap = await fakeFirestore.collection('notifications').get();
      final docId = snap.docs.first.id;

      await service.markAsRead(notificationDocId: docId, userId: 'user-1');

      final updated = await fakeFirestore
          .collection('notifications')
          .doc(docId)
          .get();
      expect(updated.data()!['isRead'], isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // markAllAsRead
  // ---------------------------------------------------------------------------
  group('markAllAsRead', () {
    setUp(() async {
      await service.initialize();
      await service.showImmediateNotification(
        notificationId: 1,
        type: NotificationType.rentDue,
        title: 'Rent 1',
        body: 'Body',
        userId: 'user-1',
      );
      await service.showImmediateNotification(
        notificationId: 2,
        type: NotificationType.waterBillDue,
        title: 'Water 1',
        body: 'Body',
        userId: 'user-1',
      );
    });

    test('marks all unread notifications as read', () async {
      await service.markAllAsRead(userId: 'user-1');

      final snap = await fakeFirestore.collection('notifications').get();
      for (final doc in snap.docs) {
        expect(doc.data()['isRead'], isTrue);
      }
    });
  });

  // ---------------------------------------------------------------------------
  // dismiss
  // ---------------------------------------------------------------------------
  group('dismiss', () {
    setUp(() async {
      await service.initialize();
      await service.showImmediateNotification(
        notificationId: 1,
        type: NotificationType.gasRefill,
        title: 'Gas Refill',
        body: 'Body',
        userId: 'user-1',
      );
    });

    test('sets isDismissed to true', () async {
      final snap = await fakeFirestore.collection('notifications').get();
      final docId = snap.docs.first.id;

      await service.dismiss(notificationDocId: docId, userId: 'user-1');

      final updated = await fakeFirestore
          .collection('notifications')
          .doc(docId)
          .get();
      expect(updated.data()!['isDismissed'], isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // getUnreadCount
  // ---------------------------------------------------------------------------
  group('getUnreadCount', () {
    setUp(() async => service.initialize());

    test('returns 0 when no notifications exist', () async {
      expect(await service.getUnreadCount(), 0);
    });

    test('counts only active (unread, non-dismissed) notifications', () async {
      for (var i = 1; i <= 3; i++) {
        await service.showImmediateNotification(
          notificationId: i,
          type: NotificationType.rentDue,
          title: 'Notif $i',
          body: 'Body',
          userId: 'user-1',
        );
      }

      final snap = await fakeFirestore.collection('notifications').get();
      await service.markAsRead(
        notificationDocId: snap.docs.first.id,
        userId: 'user-1',
      );

      expect(await service.getUnreadCount(), 2);
    });

    test('dismissed notifications are not counted as unread', () async {
      await service.showImmediateNotification(
        notificationId: 1,
        type: NotificationType.budgetWarning,
        title: 'Budget',
        body: 'Body',
        userId: 'user-1',
      );

      final snap = await fakeFirestore.collection('notifications').get();
      await service.dismiss(
        notificationDocId: snap.docs.first.id,
        userId: 'user-1',
      );

      expect(await service.getUnreadCount(), 0);
    });
  });

  // ---------------------------------------------------------------------------
  // ScheduledNotification.isActive getter
  // ---------------------------------------------------------------------------
  group('ScheduledNotification.isActive', () {
    final now = DateTime(2026, 3, 1);

    ScheduledNotification makeNotification({
      bool isRead = false,
      bool isDismissed = false,
    }) => ScheduledNotification(
      id: 'n1',
      type: 'rent_due',
      title: 'Test',
      body: 'Body',
      scheduledAt: now,
      createdAt: now,
      updatedAt: now,
      updatedBy: 'user-1',
      isRead: isRead,
      isDismissed: isDismissed,
    );

    test('isActive is true when not read and not dismissed', () {
      expect(makeNotification().isActive, isTrue);
    });

    test('isActive is false when isRead is true', () {
      expect(makeNotification(isRead: true).isActive, isFalse);
    });

    test('isActive is false when isDismissed is true', () {
      expect(makeNotification(isDismissed: true).isActive, isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // cancelAll / cancelNotification
  // ---------------------------------------------------------------------------
  group('cancelAll', () {
    setUp(() async => service.initialize());

    test('calls plugin.cancelAll', () async {
      await service.cancelAll();
      expect(fakePlugin.allCancelled, isTrue);
    });
  });

  group('cancelNotification', () {
    setUp(() async => service.initialize());

    test('calls plugin.cancel with the correct id', () async {
      await service.cancelNotification(99);
      expect(fakePlugin.cancelled, contains(99));
    });
  });
}
