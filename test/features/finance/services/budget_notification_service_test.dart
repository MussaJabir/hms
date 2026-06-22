import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/notification_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/features/finance/services/budget_notification_service.dart';
import 'package:hms/features/finance/services/budget_service.dart';
import 'package:hms/features/finance/services/expense_service.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart' show TZDateTime;

class _FakePlugin extends Fake implements FlutterLocalNotificationsPlugin {
  final List<Map<String, dynamic>> shown = [];

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
  }) async {}

  @override
  Future<void> cancel({required int id, String? tag}) async {}

  @override
  T? resolvePlatformSpecificImplementation<
    T extends FlutterLocalNotificationsPlatform
  >() => null;
}

const _userId = 'user-1';

String _iso(DateTime d) => d.toIso8601String();

String _currentPeriod() {
  final now = DateTime.now();
  final mm = now.month.toString().padLeft(2, '0');
  return '${now.year}-$mm';
}

Future<void> _seedBudget(
  FakeFirebaseFirestore fake, {
  required String category,
  required double limit,
  required double spent,
}) async {
  final period = _currentPeriod();
  final id = BudgetService.docId(category, period);
  await fake.collection(BudgetService.collection).doc(id).set({
    'category': category,
    'limitAmount': limit,
    'period': period,
    'spentAmount': spent,
    'createdAt': _iso(DateTime(2026)),
    'updatedAt': _iso(DateTime(2026)),
    'updatedBy': _userId,
    'schemaVersion': 1,
  });
}

void main() {
  late _FakePlugin plugin;
  late FakeFirebaseFirestore fake;
  late BudgetNotificationService service;

  setUp(() {
    tz_data.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('Africa/Dar_es_Salaam'));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }

    plugin = _FakePlugin();
    fake = FakeFirebaseFirestore();
    final firestore = FirestoreService(firestore: fake);
    final activityLog = ActivityLogService(firestore);
    final budgetService = BudgetService(
      firestore,
      ExpenseService(firestore, activityLog),
      RecurringTransactionService(firestore, activityLog),
      activityLog,
    );
    final notificationService = NotificationService(firestore, plugin: plugin);
    service = BudgetNotificationService(notificationService, budgetService);
  });

  test('sends a warning notification at 80%', () async {
    await _seedBudget(fake, category: 'groceries', limit: 100000, spent: 85000);

    await service.checkAndNotify(userId: _userId);

    expect(plugin.shown, hasLength(1));
    expect(plugin.shown.first['title'], 'Budget Warning');
    expect(plugin.shown.first['body'], contains('85%'));
  });

  test('sends an exceeded notification at 100%', () async {
    await _seedBudget(fake, category: 'food', limit: 100000, spent: 120000);

    await service.checkAndNotify(userId: _userId);

    expect(plugin.shown, hasLength(1));
    expect(plugin.shown.first['title'], 'Budget Exceeded');
    expect(plugin.shown.first['body'], contains('120%'));
  });

  test('on-track budgets produce no notification', () async {
    await _seedBudget(fake, category: 'transport', limit: 100000, spent: 40000);

    await service.checkAndNotify(userId: _userId);

    expect(plugin.shown, isEmpty);
  });

  test('an over budget is not double-notified as a warning', () async {
    await _seedBudget(fake, category: 'food', limit: 100000, spent: 130000);

    await service.checkAndNotify(userId: _userId);

    // Only the "exceeded" notification, not also a "warning".
    expect(plugin.shown, hasLength(1));
    expect(plugin.shown.first['title'], 'Budget Exceeded');
  });
}
