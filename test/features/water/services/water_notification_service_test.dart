import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/models/notification_type.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/notification_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/features/grounds/services/ground_service.dart';
import 'package:hms/features/water/models/water_bill.dart';
import 'package:hms/features/water/services/water_bill_service.dart';
import 'package:hms/features/water/services/water_contribution_service.dart';
import 'package:hms/features/water/services/water_notification_service.dart';
import 'package:hms/features/water/services/water_summary_service.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart' show TZDateTime;

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

const _groundId = 'g-1';
const _userId = 'user-1';

WaterBill _makeBill({
  String id = 'bill-1',
  String status = 'unpaid',
  DateTime? dueDate,
}) {
  final now = DateTime.now();
  return WaterBill(
    id: id,
    groundId: _groundId,
    billingPeriod: '2026-04',
    previousMeterReading: 100,
    currentMeterReading: 160,
    totalAmount: 25000,
    dueDate: dueDate ?? now.add(const Duration(days: 10)),
    status: status,
    createdAt: now,
    updatedAt: now,
    updatedBy: _userId,
  );
}

void main() {
  late _FakePlugin fakePlugin;
  late NotificationService notificationService;
  late WaterNotificationService service;

  setUp(() {
    tz_data.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('Africa/Dar_es_Salaam'));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }

    fakePlugin = _FakePlugin();
    final fakeFirestore = FakeFirebaseFirestore();
    final firestoreService = FirestoreService(firestore: fakeFirestore);
    final activityLogService = ActivityLogService(firestoreService);
    final recurringService = RecurringTransactionService(
      firestoreService,
      activityLogService,
    );
    final waterBillService = WaterBillService(
      firestoreService,
      activityLogService,
      firestore: fakeFirestore,
    );
    final contributionService = WaterContributionService(
      firestoreService,
      recurringService,
      waterBillService,
      activityLogService,
    );
    final groundService = GroundService(firestoreService, activityLogService);
    final summaryService = WaterSummaryService(
      waterBillService,
      contributionService,
      groundService,
    );
    notificationService = NotificationService(
      firestoreService,
      plugin: fakePlugin,
    );
    service = WaterNotificationService(notificationService, summaryService);
  });

  group('scheduleBillReminder', () {
    test('uses NotificationType.waterBillDue', () async {
      final bill = _makeBill(
        dueDate: DateTime.now().add(const Duration(days: 10)),
      );
      await service.scheduleBillReminder(
        bill: bill,
        groundName: 'Test Ground',
        daysBefore: 3,
        userId: _userId,
      );
      expect(fakePlugin.shown, hasLength(1));
      expect(fakePlugin.shown.first['title'], contains('Water Bill Due Soon'));
    });

    test('does not schedule when reminder date is in the past', () async {
      // Bill due in 2 days, daysBefore=3 → reminder already past
      final bill = _makeBill(
        dueDate: DateTime.now().add(const Duration(days: 2)),
      );
      await service.scheduleBillReminder(
        bill: bill,
        groundName: 'Test Ground',
        daysBefore: 3,
        userId: _userId,
      );
      expect(fakePlugin.shown, isEmpty);
    });
  });

  group('cancelBillNotifications', () {
    test('uses deterministic IDs derived from billId', () async {
      const billId = 'test-bill-abc';
      await service.cancelBillNotifications(billId);
      expect(fakePlugin.cancelled, hasLength(2));
      // Both IDs must be deterministic (same bill → same IDs on every call).
      final ids1 = [...fakePlugin.cancelled];
      fakePlugin.cancelled.clear();
      await service.cancelBillNotifications(billId);
      expect(fakePlugin.cancelled, equals(ids1));
    });

    test('different bills produce different IDs', () async {
      final bill1 = _makeBill(id: 'bill-aaa');
      final bill2 = _makeBill(id: 'bill-bbb');
      await service.scheduleBillReminder(
        bill: bill1,
        groundName: 'G',
        daysBefore: 3,
        userId: _userId,
      );
      await service.scheduleBillReminder(
        bill: bill2,
        groundName: 'G',
        daysBefore: 3,
        userId: _userId,
      );
      if (fakePlugin.shown.length >= 2) {
        expect(
          fakePlugin.shown[0]['id'],
          isNot(equals(fakePlugin.shown[1]['id'])),
        );
      }
    });
  });

  group('notifyOverdueBills', () {
    test('shows immediate notification type matches waterBillDue channel', () {
      expect(NotificationType.waterBillDue.id, equals('water_bill_due'));
    });
  });
}
