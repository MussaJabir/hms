import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/features/electricity/models/monthly_consumption.dart';
import 'package:hms/features/electricity/models/unit_consumption.dart';
import 'package:hms/features/electricity/models/weekly_consumption.dart';
import 'package:hms/features/electricity/services/consumption_analytics_service.dart';
import 'package:hms/features/electricity/services/meter_reading_service.dart';
import 'package:hms/features/electricity/services/meter_service.dart';
import 'package:hms/features/electricity/services/tariff_service.dart';
import 'package:hms/features/grounds/services/rental_unit_service.dart';
import 'package:hms/features/grounds/services/tenant_service.dart';
import 'package:hms/features/rent/services/rent_config_service.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _groundId = 'g-1';
const _unitId = 'u-1';
const _unit2Id = 'u-2';
const _meterId = 'm-1';
const _meter2Id = 'm-2';
const _userId = 'user-1';

const _meterCol = 'grounds/$_groundId/rental_units/$_unitId/meter_registry';
const _meter2Col = 'grounds/$_groundId/rental_units/$_unit2Id/meter_registry';
const _unitCol = 'grounds/$_groundId/rental_units';
const _readingCol = 'grounds/$_groundId/rental_units/$_unitId/meter_readings';
const _reading2Col = 'grounds/$_groundId/rental_units/$_unit2Id/meter_readings';

/// Builds a complete [ConsumptionAnalyticsService] backed by [fb].
ConsumptionAnalyticsService _makeService(FakeFirebaseFirestore fb) {
  final fs = FirestoreService(firestore: fb);
  final al = ActivityLogService(fs);
  final recurring = RecurringTransactionService(fs, al);
  final rentConfig = RentConfigService(recurring);
  final meterSvc = MeterService(fs, al);
  final readingSvc = MeterReadingService(fs, meterSvc, al);
  final tariffSvc = TariffService(fs, al);
  final unitSvc = RentalUnitService(fs, al, rentConfig);
  final tenantSvc = TenantService(fs, al, unitSvc, recurring);
  return ConsumptionAnalyticsService(
    readingSvc,
    tariffSvc,
    meterSvc,
    unitSvc,
    tenantSvc,
  );
}

Future<void> _seedMeter(
  FakeFirebaseFirestore fb, {
  String unitId = _unitId,
  String meterId = _meterId,
  String col = _meterCol,
}) async {
  await fb.collection(col).doc(meterId).set({
    'groundId': _groundId,
    'unitId': unitId,
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

Future<void> _seedUnit(
  FakeFirebaseFirestore fb, {
  String unitId = _unitId,
  String name = 'Room 1',
}) async {
  await fb.collection(_unitCol).doc(unitId).set({
    'groundId': _groundId,
    'name': name,
    'rentAmount': 50000.0,
    'status': 'occupied',
    'createdAt': DateTime(2026, 1, 1).toIso8601String(),
    'updatedAt': DateTime(2026, 1, 1).toIso8601String(),
    'updatedBy': _userId,
    'schemaVersion': 1,
  });
}

Future<void> _seedReading(
  FakeFirebaseFirestore fb, {
  required String id,
  required DateTime date,
  required double units,
  String unitId = _unitId,
  String meterId = _meterId,
  String? col,
}) async {
  final c = col ?? _readingCol;
  await fb.collection(c).doc(id).set({
    'groundId': _groundId,
    'unitId': unitId,
    'meterId': meterId,
    'reading': units,
    'previousReading': 0.0,
    'unitsConsumed': units,
    'readingDate': date.toIso8601String(),
    'isMeterReset': false,
    'notes': '',
    'createdAt': date.toIso8601String(),
    'updatedAt': date.toIso8601String(),
    'updatedBy': _userId,
    'schemaVersion': 1,
  });
}

// ---------------------------------------------------------------------------
// Model serialization tests
// ---------------------------------------------------------------------------

void main() {
  group('WeeklyConsumption', () {
    test('fromJson / toJson round-trip', () {
      final w = WeeklyConsumption(
        weekStart: DateTime(2026, 3, 10),
        unitsConsumed: 45.5,
        estimatedCost: 10000,
      );
      final json = w.toJson();
      final w2 = WeeklyConsumption.fromJson(json);
      expect(w2.unitsConsumed, w.unitsConsumed);
      expect(w2.estimatedCost, w.estimatedCost);
    });
  });

  group('MonthlyConsumption', () {
    test('fromJson / toJson round-trip', () {
      final m = MonthlyConsumption(
        period: '2026-03',
        unitsConsumed: 200,
        estimatedCost: 45000,
      );
      final json = m.toJson();
      final m2 = MonthlyConsumption.fromJson(json);
      expect(m2.period, '2026-03');
      expect(m2.unitsConsumed, 200);
    });
  });

  group('UnitConsumption', () {
    test('fromJson / toJson round-trip', () {
      final u = UnitConsumption(
        unitId: 'u-1',
        unitName: 'Room 1',
        tenantName: 'Alice',
        unitsConsumed: 150,
        estimatedCost: 29400,
      );
      final json = u.toJson();
      final u2 = UnitConsumption.fromJson(json);
      expect(u2.unitId, 'u-1');
      expect(u2.tenantName, 'Alice');
      expect(u2.estimatedCost, 29400);
    });
  });

  // ---------------------------------------------------------------------------
  // ConsumptionAnalyticsService
  // ---------------------------------------------------------------------------

  group('ConsumptionAnalyticsService.getWeeklyConsumption', () {
    test('groups readings by calendar week', () async {
      final fb = FakeFirebaseFirestore();
      await _seedMeter(fb);

      // Determine the Monday of the current week
      final now = DateTime.now();
      final monday = now.subtract(Duration(days: now.weekday - 1));
      final thisMonday = DateTime(monday.year, monday.month, monday.day);

      // Two readings in this week
      await _seedReading(fb, id: 'r1', date: thisMonday, units: 30);
      await _seedReading(
        fb,
        id: 'r2',
        date: thisMonday.add(const Duration(days: 2)),
        units: 20,
      );

      final svc = _makeService(fb);
      final weekly = await svc.getWeeklyConsumption(
        groundId: _groundId,
        unitId: _unitId,
        meterId: _meterId,
      );

      expect(weekly, hasLength(12));
      // Last bucket = this week: 30 + 20 = 50
      expect(weekly.last.unitsConsumed, 50);
    });

    test('returns 0 for weeks with no readings', () async {
      final fb = FakeFirebaseFirestore();
      await _seedMeter(fb);
      // No readings seeded

      final svc = _makeService(fb);
      final weekly = await svc.getWeeklyConsumption(
        groundId: _groundId,
        unitId: _unitId,
        meterId: _meterId,
      );

      expect(weekly, hasLength(12));
      expect(weekly.every((w) => w.unitsConsumed == 0), isTrue);
    });
  });

  group('ConsumptionAnalyticsService.getMonthlyConsumption', () {
    test('groups readings by YYYY-MM period', () async {
      final fb = FakeFirebaseFirestore();
      await _seedMeter(fb);

      // Reading in the current month
      final now = DateTime.now();
      await _seedReading(
        fb,
        id: 'r1',
        date: DateTime(now.year, now.month, 5),
        units: 100,
      );

      final svc = _makeService(fb);
      final monthly = await svc.getMonthlyConsumption(
        groundId: _groundId,
        unitId: _unitId,
        meterId: _meterId,
      );

      expect(monthly, hasLength(6));
      // Last bucket = current month
      final currentPeriod =
          '${now.year}-${now.month.toString().padLeft(2, '0')}';
      expect(monthly.last.period, currentPeriod);
      expect(monthly.last.unitsConsumed, 100);
      // All other months = 0
      for (final m in monthly.sublist(0, monthly.length - 1)) {
        expect(m.unitsConsumed, 0);
      }
    });
  });

  group('ConsumptionAnalyticsService.getAverageWeeklyConsumption', () {
    test('returns mean of 12 weekly buckets', () async {
      final fb = FakeFirebaseFirestore();
      await _seedMeter(fb);

      // One reading in the current week: 120 units
      final now = DateTime.now();
      final monday = now.subtract(Duration(days: now.weekday - 1));
      final thisMonday = DateTime(monday.year, monday.month, monday.day);
      await _seedReading(fb, id: 'r1', date: thisMonday, units: 120);

      final svc = _makeService(fb);
      final avg = await svc.getAverageWeeklyConsumption(
        groundId: _groundId,
        unitId: _unitId,
        meterId: _meterId,
      );

      // 120 units spread across 12 weeks = 10 average
      expect(avg, closeTo(10.0, 0.01));
    });

    test('returns 0 when no readings exist', () async {
      final fb = FakeFirebaseFirestore();
      await _seedMeter(fb);

      final svc = _makeService(fb);
      final avg = await svc.getAverageWeeklyConsumption(
        groundId: _groundId,
        unitId: _unitId,
        meterId: _meterId,
      );

      expect(avg, 0.0);
    });
  });

  group('ConsumptionAnalyticsService.getGroundConsumption', () {
    test('returns consumption for all units with active meters', () async {
      final fb = FakeFirebaseFirestore();

      // Seed two units with meters
      await _seedUnit(fb, unitId: _unitId, name: 'Room 1');
      await _seedUnit(fb, unitId: _unit2Id, name: 'Room 2');
      await _seedMeter(fb, unitId: _unitId, meterId: _meterId, col: _meterCol);
      await _seedMeter(
        fb,
        unitId: _unit2Id,
        meterId: _meter2Id,
        col: _meter2Col,
      );

      final start = DateTime(2026, 4, 1);
      final end = DateTime(2026, 4, 30);

      await _seedReading(fb, id: 'r1', date: DateTime(2026, 4, 10), units: 80);
      await _seedReading(
        fb,
        id: 'r2',
        date: DateTime(2026, 4, 15),
        units: 50,
        unitId: _unit2Id,
        meterId: _meter2Id,
        col: _reading2Col,
      );

      final svc = _makeService(fb);
      final result = await svc.getGroundConsumption(
        groundId: _groundId,
        start: start,
        end: end,
      );

      expect(result, hasLength(2));
      // Sorted by consumption desc: Room 1 (80) first
      expect(result.first.unitName, 'Room 1');
      expect(result.first.unitsConsumed, 80);
      expect(result.last.unitName, 'Room 2');
      expect(result.last.unitsConsumed, 50);
    });
  });
}
