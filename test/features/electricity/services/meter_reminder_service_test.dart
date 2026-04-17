import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/notification_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/features/electricity/services/meter_reminder_service.dart';
import 'package:hms/features/electricity/services/meter_service.dart';
import 'package:hms/features/grounds/services/ground_service.dart';
import 'package:hms/features/grounds/services/rental_unit_service.dart';
import 'package:hms/features/rent/services/rent_config_service.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart' show TZDateTime;

// ---------------------------------------------------------------------------
// Fake notification plugin
// ---------------------------------------------------------------------------

class _FakePlugin extends Fake implements FlutterLocalNotificationsPlugin {
  final List<int> cancelled = [];
  final List<Map<String, dynamic>> scheduled = [];

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
    scheduled.add({'id': id, 'title': title, 'body': body});
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
    scheduled.add({'id': id, 'title': title, 'body': body, 'weekly': true});
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
// Seed helpers
// ---------------------------------------------------------------------------

const _groundId = 'g-1';
const _unitId = 'u-1';
const _meterId = 'm-1';
const _userId = 'user-1';

Future<void> _seedGround(FakeFirebaseFirestore db) async {
  await db.collection('grounds').doc(_groundId).set({
    'name': 'Ground 1',
    'location': 'Dar es Salaam',
    'numberOfUnits': 1,
    'createdAt': DateTime(2026, 1, 1).toIso8601String(),
    'updatedAt': DateTime(2026, 1, 1).toIso8601String(),
    'updatedBy': _userId,
    'schemaVersion': 1,
  });
}

Future<void> _seedUnit(
  FakeFirebaseFirestore db, {
  String? meterId = _meterId,
}) async {
  await db.collection('grounds/$_groundId/rental_units').doc(_unitId).set({
    'groundId': _groundId,
    'name': 'Room 1',
    'rentAmount': 150000.0,
    'status': 'occupied',
    // ignore: use_null_aware_elements
    if (meterId != null) 'meterId': meterId,
    'createdAt': DateTime(2026, 1, 1).toIso8601String(),
    'updatedAt': DateTime(2026, 1, 1).toIso8601String(),
    'updatedBy': _userId,
    'schemaVersion': 1,
  });
}

Future<void> _seedMeter(FakeFirebaseFirestore db) async {
  await db
      .collection('grounds/$_groundId/rental_units/$_unitId/meter_registry')
      .doc(_meterId)
      .set({
        'groundId': _groundId,
        'unitId': _unitId,
        'meterNumber': 'TZ-001',
        'initialReading': 0.0,
        'currentReading': 0.0,
        'weeklyThreshold': 0.0,
        'isActive': true,
        'createdAt': DateTime(2026, 1, 1).toIso8601String(),
        'updatedAt': DateTime(2026, 1, 1).toIso8601String(),
        'updatedBy': _userId,
        'schemaVersion': 1,
      });
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late FakeFirebaseFirestore db;
  late FirestoreService firestoreService;
  late ActivityLogService activityLogService;
  late NotificationService notificationService;
  late _FakePlugin fakePlugin;
  late GroundService groundService;
  late RentalUnitService rentalUnitService;
  late MeterService meterService;
  late MeterReminderService service;

  setUpAll(() {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.UTC);
  });

  setUp(() {
    db = FakeFirebaseFirestore();
    fakePlugin = _FakePlugin();
    firestoreService = FirestoreService(firestore: db);
    activityLogService = ActivityLogService(firestoreService);
    notificationService = NotificationService(
      firestoreService,
      plugin: fakePlugin,
    );
    groundService = GroundService(firestoreService, activityLogService);
    final recurringService = RecurringTransactionService(
      firestoreService,
      activityLogService,
    );
    rentalUnitService = RentalUnitService(
      firestoreService,
      activityLogService,
      RentConfigService(recurringService),
    );
    meterService = MeterService(firestoreService, activityLogService);
    service = MeterReminderService(
      firestoreService,
      notificationService,
      groundService,
      rentalUnitService,
      meterService,
      activityLogService,
    );
  });

  // ── getDefaultConfig ───────────────────────────────────────────────────────

  group('getDefaultConfig', () {
    test('returns Sunday 6 PM enabled', () {
      final config = service.getDefaultConfig();
      expect(config.enabled, isTrue);
      expect(config.dayOfWeek, 7); // Sunday
      expect(config.hour, 18);
      expect(config.minute, 0);
    });
  });

  // ── getConfig ──────────────────────────────────────────────────────────────

  group('getConfig', () {
    test('returns default when document does not exist', () async {
      final config = await service.getConfig();
      expect(config.enabled, isTrue);
      expect(config.dayOfWeek, 7);
      expect(config.hour, 18);
    });

    test('returns saved config when document exists', () async {
      final custom = service.getDefaultConfig().copyWith(
        dayOfWeek: 5, // Friday
        hour: 9,
        minute: 30,
        updatedAt: DateTime(2026, 4, 17),
        updatedBy: _userId,
      );
      await service.updateConfig(config: custom, userId: _userId);

      final fetched = await service.getConfig();
      expect(fetched.dayOfWeek, 5);
      expect(fetched.hour, 9);
      expect(fetched.minute, 30);
    });
  });

  // ── scheduleReminder ───────────────────────────────────────────────────────

  group('scheduleReminder', () {
    test('cancels existing notification before scheduling', () async {
      await service.scheduleReminder();

      // The cancel call should have been issued for the fixed ID.
      expect(
        fakePlugin.cancelled.contains(MeterReminderService.notificationId),
        isTrue,
      );
    });

    test('schedules weekly notification when config is enabled', () async {
      await service.scheduleReminder();

      expect(fakePlugin.scheduled, isNotEmpty);
      final n = fakePlugin.scheduled.last;
      expect(n['id'], MeterReminderService.notificationId);
      expect(n['weekly'], isTrue);
    });

    test('does not schedule when config.enabled is false', () async {
      // Save a disabled config first.
      final disabled = service.getDefaultConfig().copyWith(
        enabled: false,
        updatedAt: DateTime.now(),
        updatedBy: _userId,
      );
      await service.updateConfig(config: disabled, userId: _userId);
      fakePlugin.scheduled.clear();

      await service.scheduleReminder();

      // Should cancel but not schedule.
      expect(fakePlugin.scheduled, isEmpty);
      expect(
        fakePlugin.cancelled.contains(MeterReminderService.notificationId),
        isTrue,
      );
    });
  });

  // ── getPendingReadingsCount ────────────────────────────────────────────────

  group('getPendingReadingsCount', () {
    test('returns 0 when no grounds exist', () async {
      final count = await service.getPendingReadingsCount();
      expect(count, 0);
    });

    test('counts only units with active meters', () async {
      await _seedGround(db);
      await _seedUnit(db); // unit with meterId set
      await _seedMeter(db); // active meter

      final count = await service.getPendingReadingsCount();
      expect(count, 1);
    });

    test('excludes units that have no meterId', () async {
      await _seedGround(db);
      await _seedUnit(db, meterId: null); // no meter

      final count = await service.getPendingReadingsCount();
      expect(count, 0);
    });
  });
}
