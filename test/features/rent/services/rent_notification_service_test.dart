import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/models/recurring_record.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/notification_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/features/rent/services/rent_config_service.dart';
import 'package:hms/features/rent/services/rent_notification_service.dart';
import 'package:hms/features/rent/services/rent_summary_service.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart' show TZDateTime;

// ---------------------------------------------------------------------------
// Minimal fake plugin (same pattern as core notification service tests)
// ---------------------------------------------------------------------------

class _FakePlugin extends Fake implements FlutterLocalNotificationsPlugin {
  final List<Map<String, dynamic>> shown = [];
  final List<int> cancelled = [];

  @override
  Future<bool?> initialize({
    required InitializationSettings settings,
    DidReceiveNotificationResponseCallback? onDidReceiveNotificationResponse,
    DidReceiveBackgroundNotificationResponseCallback?
    onDidReceiveBackgroundNotificationResponse,
  }) async => true;

  @override
  Future<void> show({
    required int id,
    String? title,
    String? body,
    NotificationDetails? notificationDetails,
    String? payload,
  }) async {
    shown.add({'id': id, 'title': title, 'body': body});
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
    shown.add({'id': id, 'title': title, 'body': body, 'scheduled': true});
  }

  @override
  Future<void> cancel({required int id, String? tag}) async {
    cancelled.add(id);
  }

  @override
  Future<void> cancelAll() async {}

  @override
  Future<List<PendingNotificationRequest>>
  pendingNotificationRequests() async => [];

  @override
  T? resolvePlatformSpecificImplementation<
    T extends FlutterLocalNotificationsPlatform
  >() => null;
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _groundId = 'g-1';
const _unitId = 'u-1';
const _configPath = 'grounds/$_groundId/rental_units/$_unitId/rent_payments';

String _currentPeriod() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}';
}

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late _FakePlugin fakePlugin;
  late NotificationService notificationService;
  late RecurringTransactionService recurringService;
  late RentConfigService rentConfigService;
  late RentSummaryService rentSummaryService;
  late RentNotificationService service;

  setUpAll(() {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.UTC);
  });

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
    fakePlugin = _FakePlugin();
    notificationService = NotificationService(
      firestoreService,
      plugin: fakePlugin,
    );
    recurringService = RecurringTransactionService(
      firestoreService,
      ActivityLogService(firestoreService),
    );
    rentConfigService = RentConfigService(recurringService);
    rentSummaryService = RentSummaryService(
      rentConfigService,
      recurringService,
    );
    service = RentNotificationService(notificationService, rentSummaryService);
  });

  Future<void> seedOverdueRecord({
    required String id,
    required int daysOverdue,
  }) async {
    const configId = 'cfg-1';
    await fakeFirestore.collection('recurring_configs').doc(configId).set({
      'id': configId,
      'type': 'rent',
      'collectionPath': _configPath,
      'linkedEntityId': 'tenant-1',
      'linkedEntityName': 'John Doe — Room 1',
      'amount': 300000.0,
      'frequency': 'monthly',
      'dayOfMonth': 1,
      'isActive': true,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'updatedBy': 'user-1',
      'schemaVersion': 1,
    });

    final dueDate = DateTime.now().subtract(Duration(days: daysOverdue));
    await fakeFirestore.collection(_configPath).doc(id).set({
      'id': id,
      'configId': configId,
      'type': 'rent',
      'linkedEntityId': 'tenant-1',
      'linkedEntityName': 'John Doe — Room 1',
      'amount': 300000.0,
      'period': _currentPeriod(),
      'status': 'overdue',
      'amountPaid': 0.0,
      'dueDate': dueDate.toIso8601String(),
      'createdAt': dueDate.toIso8601String(),
      'updatedAt': dueDate.toIso8601String(),
      'updatedBy': 'user-1',
      'schemaVersion': 1,
    });
  }

  // ── scheduleOverdueNotifications ─────────────────────────────────────────

  group('RentNotificationService.scheduleOverdueNotifications', () {
    test('shows one notification per overdue record', () async {
      await seedOverdueRecord(id: 'r1', daysOverdue: 5);

      await service.scheduleOverdueNotifications(userId: 'user-1');

      expect(fakePlugin.shown.length, equals(1));
    });

    test('notification title is "Rent Overdue"', () async {
      await seedOverdueRecord(id: 'r1', daysOverdue: 5);

      await service.scheduleOverdueNotifications(userId: 'user-1');

      expect(fakePlugin.shown.first['title'], equals('Rent Overdue'));
    });

    test('body includes tenant name and days overdue', () async {
      await seedOverdueRecord(id: 'r1', daysOverdue: 5);

      await service.scheduleOverdueNotifications(userId: 'user-1');

      final body = fakePlugin.shown.first['body'] as String;
      expect(body, contains('John Doe — Room 1'));
      expect(body, contains('5'));
    });

    test('no notifications shown when no overdue records', () async {
      await service.scheduleOverdueNotifications(userId: 'user-1');

      expect(fakePlugin.shown, isEmpty);
    });
  });

  // ── cancelRentNotifications ──────────────────────────────────────────────

  group('RentNotificationService.cancelRentNotifications', () {
    test('cancels two notification IDs (due + overdue) per record', () async {
      await service.cancelRentNotifications('record-abc');

      expect(fakePlugin.cancelled.length, equals(2));
    });

    test(
      'uses deterministic IDs — same record always produces same IDs',
      () async {
        await service.cancelRentNotifications('record-xyz');
        final first = List<int>.from(fakePlugin.cancelled);

        fakePlugin.cancelled.clear();
        await service.cancelRentNotifications('record-xyz');
        final second = List<int>.from(fakePlugin.cancelled);

        expect(first, equals(second));
      },
    );

    test('different records produce different IDs', () async {
      await service.cancelRentNotifications('record-aaa');
      final idsA = Set<int>.from(fakePlugin.cancelled);

      fakePlugin.cancelled.clear();
      await service.cancelRentNotifications('record-zzz');
      final idsZ = Set<int>.from(fakePlugin.cancelled);

      expect(idsA.intersection(idsZ), isEmpty);
    });
  });

  // ── scheduleRentDueReminder ──────────────────────────────────────────────

  group('RentNotificationService.scheduleRentDueReminder', () {
    test('skips scheduling when due date is in the past', () async {
      // Create a record whose due date was yesterday — reminder should be skipped.
      final pastRecord = _makeRecord(
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
      );

      await service.scheduleRentDueReminder(
        rentRecord: pastRecord,
        userId: 'user-1',
      );

      expect(fakePlugin.shown, isEmpty);
    });

    test('schedules notification for future due date', () async {
      final futureRecord = _makeRecord(
        dueDate: DateTime.now().add(const Duration(days: 10)),
      );

      await service.scheduleRentDueReminder(
        rentRecord: futureRecord,
        userId: 'user-1',
      );

      expect(fakePlugin.shown.length, equals(1));
      expect(fakePlugin.shown.first['scheduled'], isTrue);
    });
  });
}

// ---------------------------------------------------------------------------
// Helper to create a minimal RecurringRecord for testing
// ---------------------------------------------------------------------------

RecurringRecord _makeRecord({required DateTime dueDate}) {
  return RecurringRecord(
    id: 'test-record',
    configId: 'cfg-1',
    type: 'rent',
    linkedEntityId: 'tenant-1',
    linkedEntityName: 'John Doe — Room 1',
    amount: 300000,
    period: '2026-04',
    status: 'pending',
    dueDate: dueDate,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    updatedBy: 'user-1',
  );
}
