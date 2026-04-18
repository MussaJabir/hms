import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/features/electricity/services/consumption_alert_service.dart';
import 'package:hms/features/electricity/services/electricity_summary_service.dart';
import 'package:hms/features/electricity/services/meter_reading_service.dart';
import 'package:hms/features/electricity/services/meter_service.dart';
import 'package:hms/features/electricity/services/tariff_service.dart';
import 'package:hms/features/grounds/services/ground_service.dart';
import 'package:hms/features/grounds/services/rental_unit_service.dart';
import 'package:hms/features/rent/services/rent_config_service.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

// ---------------------------------------------------------------------------
// Seed helpers
// ---------------------------------------------------------------------------

const _groundId = 'g-1';
const _groundId2 = 'g-2';
const _unitId = 'u-1';
const _unitId2 = 'u-2';
const _meterId = 'm-1';
const _meterId2 = 'm-2';
const _userId = 'user-1';

Future<void> _seedGround(
  FakeFirebaseFirestore db, {
  String groundId = _groundId,
}) async {
  await db.collection('grounds').doc(groundId).set({
    'name': 'Ground $groundId',
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
  String groundId = _groundId,
  String unitId = _unitId,
  String? meterId = _meterId,
}) async {
  await db.collection('grounds/$groundId/rental_units').doc(unitId).set({
    'groundId': groundId,
    'name': 'Room $unitId',
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

Future<void> _seedMeter(
  FakeFirebaseFirestore db, {
  String groundId = _groundId,
  String unitId = _unitId,
  String meterId = _meterId,
  bool isActive = true,
  double weeklyThreshold = 0,
}) async {
  await db
      .collection('grounds/$groundId/rental_units/$unitId/meter_registry')
      .doc(meterId)
      .set({
        'groundId': groundId,
        'unitId': unitId,
        'meterNumber': 'TZ-001',
        'initialReading': 0.0,
        'currentReading': 0.0,
        'weeklyThreshold': weeklyThreshold,
        'isActive': isActive,
        'createdAt': DateTime(2026, 1, 1).toIso8601String(),
        'updatedAt': DateTime(2026, 1, 1).toIso8601String(),
        'updatedBy': _userId,
        'schemaVersion': 1,
      });
}

Future<void> _seedReading(
  FakeFirebaseFirestore db, {
  String groundId = _groundId,
  String unitId = _unitId,
  String meterId = _meterId,
  required double unitsConsumed,
  required DateTime readingDate,
}) async {
  await db
      .collection('grounds/$groundId/rental_units/$unitId/meter_readings')
      .add({
        'groundId': groundId,
        'unitId': unitId,
        'meterId': meterId,
        'reading': unitsConsumed,
        'previousReading': 0.0,
        'unitsConsumed': unitsConsumed,
        'readingDate': readingDate.toIso8601String(),
        'isMeterReset': false,
        'notes': '',
        'createdAt': readingDate.toIso8601String(),
        'updatedAt': readingDate.toIso8601String(),
        'updatedBy': _userId,
        'schemaVersion': 1,
      });
}

// ---------------------------------------------------------------------------
// Date helpers
// ---------------------------------------------------------------------------

DateTime get _thisMonday {
  final now = DateTime.now();
  return now.subtract(Duration(days: now.weekday - 1));
}

DateTime get _thisWednesday => _thisMonday.add(const Duration(days: 2));

DateTime get _lastWednesday => _thisMonday.subtract(const Duration(days: 5));

DateTime get _firstOfMonth =>
    DateTime(DateTime.now().year, DateTime.now().month, 1);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late FakeFirebaseFirestore db;
  late FirestoreService firestoreService;
  late ActivityLogService activityLogService;
  late MeterService meterService;
  late MeterReadingService meterReadingService;
  late ConsumptionAlertService alertService;
  late TariffService tariffService;
  late GroundService groundService;
  late RentalUnitService rentalUnitService;
  late ElectricitySummaryService service;

  setUpAll(() {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.UTC);
  });

  setUp(() {
    db = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: db);
    activityLogService = ActivityLogService(firestoreService);
    meterService = MeterService(firestoreService, activityLogService);
    meterReadingService = MeterReadingService(
      firestoreService,
      meterService,
      activityLogService,
    );
    final recurringService = RecurringTransactionService(
      firestoreService,
      activityLogService,
    );
    rentalUnitService = RentalUnitService(
      firestoreService,
      activityLogService,
      RentConfigService(recurringService),
    );
    groundService = GroundService(firestoreService, activityLogService);
    alertService = ConsumptionAlertService(
      meterService,
      meterReadingService,
      rentalUnitService,
      groundService,
    );
    tariffService = TariffService(firestoreService, activityLogService);
    service = ElectricitySummaryService(
      meterService,
      meterReadingService,
      alertService,
      tariffService,
      groundService,
      rentalUnitService,
    );
  });

  // ── getCurrentWeekTotalUnits ───────────────────────────────────────────────

  group('getCurrentWeekTotalUnits', () {
    test('returns 0 when no readings exist', () async {
      await _seedGround(db);
      await _seedUnit(db);
      await _seedMeter(db);

      final total = await service.getCurrentWeekTotalUnits();
      expect(total, 0);
    });

    test('sums all meter readings within the current week', () async {
      await _seedGround(db);
      await _seedUnit(db);
      await _seedMeter(db);

      await _seedReading(db, unitsConsumed: 50, readingDate: _thisWednesday);
      await _seedReading(db, unitsConsumed: 30, readingDate: _thisMonday);

      final total = await service.getCurrentWeekTotalUnits();
      expect(total, closeTo(80, 0.001));
    });

    test('excludes readings from last week', () async {
      await _seedGround(db);
      await _seedUnit(db);
      await _seedMeter(db);

      // Last week reading — should be excluded
      await _seedReading(db, unitsConsumed: 100, readingDate: _lastWednesday);
      // This week reading
      await _seedReading(db, unitsConsumed: 40, readingDate: _thisWednesday);

      final total = await service.getCurrentWeekTotalUnits();
      expect(total, closeTo(40, 0.001));
    });

    test('filters by groundId when provided', () async {
      await _seedGround(db, groundId: _groundId);
      await _seedUnit(db, groundId: _groundId);
      await _seedMeter(db, groundId: _groundId);
      await _seedReading(
        db,
        groundId: _groundId,
        unitsConsumed: 60,
        readingDate: _thisWednesday,
      );

      await _seedGround(db, groundId: _groundId2);
      await _seedUnit(
        db,
        groundId: _groundId2,
        unitId: _unitId2,
        meterId: _meterId2,
      );
      await _seedMeter(
        db,
        groundId: _groundId2,
        unitId: _unitId2,
        meterId: _meterId2,
      );
      await _seedReading(
        db,
        groundId: _groundId2,
        unitId: _unitId2,
        meterId: _meterId2,
        unitsConsumed: 90,
        readingDate: _thisWednesday,
      );

      // Filter to ground 1 only
      final total = await service.getCurrentWeekTotalUnits(groundId: _groundId);
      expect(total, closeTo(60, 0.001));
    });
  });

  // ── getCurrentMonthTotalUnits ──────────────────────────────────────────────

  group('getCurrentMonthTotalUnits', () {
    test('sums readings for current calendar month', () async {
      await _seedGround(db);
      await _seedUnit(db);
      await _seedMeter(db);

      await _seedReading(db, unitsConsumed: 70, readingDate: _firstOfMonth);
      await _seedReading(db, unitsConsumed: 50, readingDate: _thisWednesday);

      final total = await service.getCurrentMonthTotalUnits();
      expect(total, closeTo(120, 0.001));
    });
  });

  // ── getCurrentWeekEstimatedCost ────────────────────────────────────────────

  group('getCurrentWeekEstimatedCost', () {
    test('calls TariffService.calculateCost with week units', () async {
      await _seedGround(db);
      await _seedUnit(db);
      await _seedMeter(db);

      // 75 units → first TANESCO tier only (100 TZS/unit)
      await _seedReading(db, unitsConsumed: 75, readingDate: _thisWednesday);

      final cost = await service.getCurrentWeekEstimatedCost();
      // Default tier: 0-75 @ 100 TZS/unit = 7,500
      expect(cost, closeTo(7500, 1));
    });
  });

  // ── getActiveMetersCount ───────────────────────────────────────────────────

  group('getActiveMetersCount', () {
    test('counts only units with active meters', () async {
      await _seedGround(db);
      // Unit 1: has active meter
      await _seedUnit(db, unitId: _unitId, meterId: _meterId);
      await _seedMeter(db, unitId: _unitId, meterId: _meterId, isActive: true);
      // Unit 2: no meterId on unit
      await _seedUnit(db, unitId: _unitId2, meterId: null);

      final count = await service.getActiveMetersCount();
      expect(count, 1);
    });
  });

  // ── getPendingReadingsCount ────────────────────────────────────────────────

  group('getPendingReadingsCount', () {
    test('returns count of units without a reading this week', () async {
      await _seedGround(db);
      // Unit 1: active meter, no reading this week
      await _seedUnit(db, unitId: _unitId, meterId: _meterId);
      await _seedMeter(db, unitId: _unitId, meterId: _meterId);
      // Unit 2: active meter, has a reading this week
      await _seedUnit(db, unitId: _unitId2, meterId: _meterId2);
      await _seedMeter(db, unitId: _unitId2, meterId: _meterId2);
      await _seedReading(
        db,
        unitId: _unitId2,
        meterId: _meterId2,
        unitsConsumed: 20,
        readingDate: _thisWednesday,
      );

      final count = await service.getPendingReadingsCount();
      expect(count, 1); // Only unit 1 is pending
    });

    test('excludes units with no meterId', () async {
      await _seedGround(db);
      await _seedUnit(db, unitId: _unitId, meterId: null); // no meter

      final count = await service.getPendingReadingsCount();
      expect(count, 0);
    });
  });

  // ── getWarningCount ────────────────────────────────────────────────────────

  group('getWarningCount', () {
    test('returns 0 when no thresholds are set', () async {
      await _seedGround(db);
      await _seedUnit(db);
      await _seedMeter(db, weeklyThreshold: 0);
      await _seedReading(db, unitsConsumed: 200, readingDate: _thisWednesday);

      final count = await service.getWarningCount();
      expect(count, 0);
    });

    test('counts units exceeding their threshold', () async {
      await _seedGround(db);
      await _seedUnit(db, unitId: _unitId, meterId: _meterId);
      await _seedMeter(
        db,
        unitId: _unitId,
        meterId: _meterId,
        weeklyThreshold: 50,
      );
      await _seedReading(
        db,
        unitId: _unitId,
        meterId: _meterId,
        unitsConsumed: 100, // over threshold
        readingDate: _thisWednesday,
      );

      final count = await service.getWarningCount();
      expect(count, 1);
    });
  });

  // ── getWeekOverWeekTrend ───────────────────────────────────────────────────

  group('getWeekOverWeekTrend', () {
    test('returns 0 when last week had no consumption', () async {
      await _seedGround(db);
      await _seedUnit(db);
      await _seedMeter(db);

      await _seedReading(db, unitsConsumed: 50, readingDate: _thisWednesday);

      final trend = await service.getWeekOverWeekTrend();
      expect(trend, 0);
    });

    test('returns positive percentage when this week is higher', () async {
      await _seedGround(db);
      await _seedUnit(db);
      await _seedMeter(db);

      await _seedReading(db, unitsConsumed: 50, readingDate: _lastWednesday);
      await _seedReading(db, unitsConsumed: 75, readingDate: _thisWednesday);

      final trend = await service.getWeekOverWeekTrend();
      // (75 - 50) / 50 * 100 = 50%
      expect(trend, closeTo(50, 0.01));
    });

    test('returns negative percentage when this week is lower', () async {
      await _seedGround(db);
      await _seedUnit(db);
      await _seedMeter(db);

      await _seedReading(db, unitsConsumed: 100, readingDate: _lastWednesday);
      await _seedReading(db, unitsConsumed: 80, readingDate: _thisWednesday);

      final trend = await service.getWeekOverWeekTrend();
      // (80 - 100) / 100 * 100 = -20%
      expect(trend, closeTo(-20, 0.01));
    });
  });
}
