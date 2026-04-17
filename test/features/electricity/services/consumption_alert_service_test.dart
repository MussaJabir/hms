import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/core/widgets/alert_severity.dart';
import 'package:hms/features/electricity/services/consumption_alert_service.dart';
import 'package:hms/features/electricity/services/meter_reading_service.dart';
import 'package:hms/features/electricity/services/meter_service.dart';
import 'package:hms/features/grounds/services/ground_service.dart';
import 'package:hms/features/grounds/services/rental_unit_service.dart';
import 'package:hms/features/rent/services/rent_config_service.dart';

// ---------------------------------------------------------------------------
// Test constants
// ---------------------------------------------------------------------------

const _groundId = 'g-1';
const _groundId2 = 'g-2';
const _unitId = 'u-1';
const _meterId = 'm-1';
const _userId = 'user-1';

// ---------------------------------------------------------------------------
// Seed helpers
// ---------------------------------------------------------------------------

Future<void> _seedGround(
  FakeFirebaseFirestore db, {
  String groundId = _groundId,
  String name = 'Ground 1',
}) async {
  await db.collection('grounds').doc(groundId).set({
    'name': name,
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

Future<void> _seedMeter(
  FakeFirebaseFirestore db, {
  String groundId = _groundId,
  String unitId = _unitId,
  String meterId = _meterId,
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
        'isActive': true,
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
  DateTime? readingDate,
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
        'readingDate': (readingDate ?? DateTime(2026, 4, 10)).toIso8601String(),
        'isMeterReset': false,
        'notes': '',
        'createdAt': DateTime(2026, 4, 10).toIso8601String(),
        'updatedAt': DateTime(2026, 4, 10).toIso8601String(),
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
  late MeterService meterService;
  late MeterReadingService meterReadingService;
  late RentalUnitService rentalUnitService;
  late GroundService groundService;
  late ConsumptionAlertService service;

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
    service = ConsumptionAlertService(
      meterService,
      meterReadingService,
      rentalUnitService,
      groundService,
    );
  });

  // ── getOverThreshold ────────────────────────────────────────────────────────

  group('ConsumptionAlertService.getOverThreshold', () {
    test('returns 0 when meter has no threshold set', () async {
      await _seedMeter(db, weeklyThreshold: 0);
      await _seedReading(db, unitsConsumed: 200);

      final result = await service.getOverThreshold(
        groundId: _groundId,
        unitId: _unitId,
        meterId: _meterId,
      );

      expect(result, equals(0));
    });

    test('returns 0 when latest reading is under threshold', () async {
      await _seedMeter(db, weeklyThreshold: 100);
      await _seedReading(db, unitsConsumed: 80);

      final result = await service.getOverThreshold(
        groundId: _groundId,
        unitId: _unitId,
        meterId: _meterId,
      );

      expect(result, equals(0));
    });

    test(
      'returns positive value when latest reading is over threshold',
      () async {
        await _seedMeter(db, weeklyThreshold: 100);
        await _seedReading(db, unitsConsumed: 150);

        final result = await service.getOverThreshold(
          groundId: _groundId,
          unitId: _unitId,
          meterId: _meterId,
        );

        expect(result, closeTo(50, 0.001));
      },
    );

    test('returns 0 when no reading exists', () async {
      await _seedMeter(db, weeklyThreshold: 100);

      final result = await service.getOverThreshold(
        groundId: _groundId,
        unitId: _unitId,
        meterId: _meterId,
      );

      expect(result, equals(0));
    });
  });

  // ── classifySeverity ────────────────────────────────────────────────────────

  group('ConsumptionAlertService.classifySeverity', () {
    test('returns info for consumption 0-20% over threshold', () {
      // 10% over
      final result = service.classifySeverity(
        threshold: 100,
        actualConsumption: 110,
      );
      expect(result, equals(AlertSeverity.info));
    });

    test('returns info for consumption exactly 20% over threshold', () {
      final result = service.classifySeverity(
        threshold: 100,
        actualConsumption: 120,
      );
      expect(result, equals(AlertSeverity.info));
    });

    test('returns warning for consumption 21-50% over threshold', () {
      // 30% over
      final result = service.classifySeverity(
        threshold: 100,
        actualConsumption: 130,
      );
      expect(result, equals(AlertSeverity.warning));
    });

    test('returns warning for consumption exactly 50% over threshold', () {
      final result = service.classifySeverity(
        threshold: 100,
        actualConsumption: 150,
      );
      expect(result, equals(AlertSeverity.warning));
    });

    test('returns critical for consumption > 50% over threshold', () {
      // 51% over
      final result = service.classifySeverity(
        threshold: 100,
        actualConsumption: 151,
      );
      expect(result, equals(AlertSeverity.critical));
    });

    test('returns critical for consumption 100% over threshold', () {
      final result = service.classifySeverity(
        threshold: 100,
        actualConsumption: 200,
      );
      expect(result, equals(AlertSeverity.critical));
    });

    test('returns info when threshold is 0', () {
      final result = service.classifySeverity(
        threshold: 0,
        actualConsumption: 500,
      );
      expect(result, equals(AlertSeverity.info));
    });
  });

  // ── isConsumptionSpike ──────────────────────────────────────────────────────

  group('ConsumptionAlertService.isConsumptionSpike', () {
    test(
      'returns true when current week is 50%+ above historical average',
      () async {
        await _seedMeter(db);
        final now = DateTime.now();

        // Historical: 4 weeks of ~100 units each.
        for (var i = 1; i <= 4; i++) {
          await _seedReading(
            db,
            unitsConsumed: 100,
            readingDate: now.subtract(Duration(days: i * 7)),
          );
        }

        // Current week: 200 units (100% above average of 100).
        await _seedReading(db, unitsConsumed: 200, readingDate: now);

        final isSpike = await service.isConsumptionSpike(
          groundId: _groundId,
          unitId: _unitId,
          meterId: _meterId,
        );

        expect(isSpike, isTrue);
      },
    );

    test('returns false when current week is below spike threshold', () async {
      await _seedMeter(db);
      final now = DateTime.now();

      // Historical: ~100 units per week.
      for (var i = 1; i <= 4; i++) {
        await _seedReading(
          db,
          unitsConsumed: 100,
          readingDate: now.subtract(Duration(days: i * 7)),
        );
      }

      // Current week: 130 units (30% above — below 50% spike threshold).
      await _seedReading(db, unitsConsumed: 130, readingDate: now);

      final isSpike = await service.isConsumptionSpike(
        groundId: _groundId,
        unitId: _unitId,
        meterId: _meterId,
      );

      expect(isSpike, isFalse);
    });

    test('returns false when no readings exist', () async {
      await _seedMeter(db);

      final isSpike = await service.isConsumptionSpike(
        groundId: _groundId,
        unitId: _unitId,
        meterId: _meterId,
      );

      expect(isSpike, isFalse);
    });
  });

  // ── getActiveWarnings ───────────────────────────────────────────────────────

  group('ConsumptionAlertService.getActiveWarnings', () {
    test('returns warning when reading exceeds threshold', () async {
      await _seedGround(db);
      await _seedUnit(db);
      await _seedMeter(db, weeklyThreshold: 100);
      await _seedReading(db, unitsConsumed: 160);

      final warnings = await service.getActiveWarnings(groundId: _groundId);

      expect(warnings.length, equals(1));
      expect(warnings.first.unitId, equals(_unitId));
      expect(warnings.first.actualConsumption, closeTo(160, 0.001));
    });

    test('returns empty list when readings are under threshold', () async {
      await _seedGround(db);
      await _seedUnit(db);
      await _seedMeter(db, weeklyThreshold: 100);
      await _seedReading(db, unitsConsumed: 80);

      final warnings = await service.getActiveWarnings(groundId: _groundId);

      expect(warnings, isEmpty);
    });

    test(
      'filters by groundId — only returns warnings from the specified ground',
      () async {
        // Seed ground 1 with a high-consumption unit.
        await _seedGround(db, groundId: _groundId);
        await _seedUnit(db, groundId: _groundId);
        await _seedMeter(db, groundId: _groundId, weeklyThreshold: 100);
        await _seedReading(db, groundId: _groundId, unitsConsumed: 200);

        // Seed ground 2 with a different unit — also over threshold.
        await _seedGround(db, groundId: _groundId2, name: 'Ground 2');
        await _seedUnit(
          db,
          groundId: _groundId2,
          unitId: 'u-2',
          meterId: 'm-2',
        );
        await _seedMeter(
          db,
          groundId: _groundId2,
          unitId: 'u-2',
          meterId: 'm-2',
          weeklyThreshold: 50,
        );
        await _seedReading(
          db,
          groundId: _groundId2,
          unitId: 'u-2',
          meterId: 'm-2',
          unitsConsumed: 120,
        );

        // Filter by ground 1 — should return only 1 warning.
        final warnings = await service.getActiveWarnings(groundId: _groundId);

        expect(warnings.length, equals(1));
        expect(warnings.first.groundId, equals(_groundId));
      },
    );

    test('returns warnings from all grounds when groundId is null', () async {
      // Ground 1.
      await _seedGround(db, groundId: _groundId);
      await _seedUnit(db, groundId: _groundId);
      await _seedMeter(db, groundId: _groundId, weeklyThreshold: 100);
      await _seedReading(db, groundId: _groundId, unitsConsumed: 150);

      // Ground 2.
      await _seedGround(db, groundId: _groundId2, name: 'Ground 2');
      await _seedUnit(db, groundId: _groundId2, unitId: 'u-2', meterId: 'm-2');
      await _seedMeter(
        db,
        groundId: _groundId2,
        unitId: 'u-2',
        meterId: 'm-2',
        weeklyThreshold: 50,
      );
      await _seedReading(
        db,
        groundId: _groundId2,
        unitId: 'u-2',
        meterId: 'm-2',
        unitsConsumed: 100,
      );

      final warnings = await service.getActiveWarnings();
      expect(warnings.length, equals(2));
    });

    test('skips units without an active meter', () async {
      await _seedGround(db);
      await _seedUnit(db, meterId: null); // No meter assigned.

      final warnings = await service.getActiveWarnings(groundId: _groundId);
      expect(warnings, isEmpty);
    });

    test('skips meters without a threshold configured', () async {
      await _seedGround(db);
      await _seedUnit(db);
      await _seedMeter(db, weeklyThreshold: 0); // No threshold.
      await _seedReading(db, unitsConsumed: 500);

      final warnings = await service.getActiveWarnings(groundId: _groundId);
      expect(warnings, isEmpty);
    });
  });
}
