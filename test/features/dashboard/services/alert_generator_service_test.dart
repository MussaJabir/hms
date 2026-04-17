import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/core/widgets/alert_severity.dart';
import 'package:hms/features/dashboard/services/alert_generator_service.dart';
import 'package:hms/features/electricity/services/consumption_alert_service.dart';
import 'package:hms/features/electricity/services/meter_reading_service.dart';
import 'package:hms/features/electricity/services/meter_service.dart';
import 'package:hms/features/grounds/services/ground_service.dart';
import 'package:hms/features/grounds/services/rental_unit_service.dart';
import 'package:hms/features/rent/services/rent_config_service.dart';
import 'package:hms/features/rent/services/rent_summary_service.dart';

// ---------------------------------------------------------------------------
// Test helpers
//
// A single config "cfg-1" is shared across all tests. Multiple overdue records
// can coexist under one config's collection path without duplication issues.
// ---------------------------------------------------------------------------

const _groundId = 'g-1';
const _unitId = 'u-1';
const _configPath = 'grounds/$_groundId/rental_units/$_unitId/rent_payments';
const _configId = 'cfg-1';

String _currentPeriod() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}';
}

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late ActivityLogService activityLogService;
  late RecurringTransactionService recurringService;
  late RentConfigService rentConfigService;
  late RentSummaryService rentSummaryService;
  late ConsumptionAlertService consumptionAlertService;
  late AlertGeneratorService service;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
    activityLogService = ActivityLogService(firestoreService);
    recurringService = RecurringTransactionService(
      firestoreService,
      activityLogService,
    );
    rentConfigService = RentConfigService(recurringService);
    rentSummaryService = RentSummaryService(
      rentConfigService,
      recurringService,
    );
    final meterService = MeterService(firestoreService, activityLogService);
    final meterReadingService = MeterReadingService(
      firestoreService,
      meterService,
      activityLogService,
    );
    final groundService = GroundService(firestoreService, activityLogService);
    final rentalUnitService = RentalUnitService(
      firestoreService,
      activityLogService,
      RentConfigService(recurringService),
    );
    consumptionAlertService = ConsumptionAlertService(
      meterService,
      meterReadingService,
      rentalUnitService,
      groundService,
    );
    service = AlertGeneratorService(
      rentSummaryService,
      consumptionAlertService,
    );
  });

  /// Seeds the single shared config (idempotent — safe to call multiple times).
  Future<void> ensureConfig() async {
    await fakeFirestore.collection('recurring_configs').doc(_configId).set({
      'id': _configId,
      'type': 'rent',
      'collectionPath': _configPath,
      'linkedEntityId': 'tenant-1',
      'linkedEntityName': 'Tenant 1',
      'amount': 300000.0,
      'frequency': 'monthly',
      'dayOfMonth': 1,
      'isActive': true,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'updatedBy': 'user-1',
      'schemaVersion': 1,
    });
  }

  Future<void> seedOverdueRecord({
    required String id,
    required int daysOverdue,
    String tenantName = 'Test Tenant',
  }) async {
    await ensureConfig();
    final dueDate = DateTime.now().subtract(Duration(days: daysOverdue));
    await fakeFirestore.collection(_configPath).doc(id).set({
      'id': id,
      'configId': _configId,
      'type': 'rent',
      'linkedEntityId': 'tenant-$id',
      'linkedEntityName': tenantName,
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

  // ── generateRentAlerts ───────────────────────────────────────────────────

  group('AlertGeneratorService.generateRentAlerts', () {
    test('returns empty list when no overdue records', () async {
      final alerts = await service.generateRentAlerts();
      expect(alerts, isEmpty);
    });

    test('returns one alert per overdue record', () async {
      await seedOverdueRecord(id: 'r1', daysOverdue: 3);
      await seedOverdueRecord(id: 'r2', daysOverdue: 10);

      final alerts = await service.generateRentAlerts();

      expect(alerts.length, equals(2));
    });

    test('assigns critical severity for > 7 days overdue', () async {
      await seedOverdueRecord(id: 'r1', daysOverdue: 8);

      final alerts = await service.generateRentAlerts();

      expect(alerts.first.severity, equals(AlertSeverity.critical));
    });

    test('assigns warning severity for <= 7 days overdue', () async {
      await seedOverdueRecord(id: 'r1', daysOverdue: 7);

      final alerts = await service.generateRentAlerts();

      expect(alerts.first.severity, equals(AlertSeverity.warning));
    });

    test('alerts sorted by days overdue — most overdue first', () async {
      await seedOverdueRecord(id: 'r1', daysOverdue: 3);
      await seedOverdueRecord(id: 'r2', daysOverdue: 15);
      await seedOverdueRecord(id: 'r3', daysOverdue: 8);

      final alerts = await service.generateRentAlerts();

      // Most overdue (15 days = r2) should be first.
      expect(alerts[0].id, equals('rent-overdue-r2'));
      expect(alerts[1].id, equals('rent-overdue-r3'));
      expect(alerts[2].id, equals('rent-overdue-r1'));
    });

    test('alert uses "rent-overdue-{recordId}" as id', () async {
      await seedOverdueRecord(id: 'r-abc', daysOverdue: 5);

      final alerts = await service.generateRentAlerts();

      expect(alerts.first.id, equals('rent-overdue-r-abc'));
    });

    test('alert icon is payments_outlined', () async {
      await seedOverdueRecord(id: 'r1', daysOverdue: 3);

      final alerts = await service.generateRentAlerts();

      expect(alerts.first.icon, equals(Icons.payments_outlined));
    });

    test('alert module is "rent"', () async {
      await seedOverdueRecord(id: 'r1', daysOverdue: 3);

      final alerts = await service.generateRentAlerts();

      expect(alerts.first.module, equals('rent'));
    });
  });

  // ── generateElectricityAlerts ────────────────────────────────────────────

  group('AlertGeneratorService.generateElectricityAlerts', () {
    Future<void> seedGroundAndUnit() async {
      await fakeFirestore.collection('grounds').doc(_groundId).set({
        'name': 'Ground 1',
        'location': 'Dar es Salaam',
        'numberOfUnits': 1,
        'createdAt': DateTime(2026, 1, 1).toIso8601String(),
        'updatedAt': DateTime(2026, 1, 1).toIso8601String(),
        'updatedBy': 'user-1',
        'schemaVersion': 1,
      });
      await fakeFirestore
          .collection('grounds/$_groundId/rental_units')
          .doc(_unitId)
          .set({
            'groundId': _groundId,
            'name': 'Room 1',
            'rentAmount': 150000.0,
            'status': 'occupied',
            'meterId': 'm-1',
            'createdAt': DateTime(2026, 1, 1).toIso8601String(),
            'updatedAt': DateTime(2026, 1, 1).toIso8601String(),
            'updatedBy': 'user-1',
            'schemaVersion': 1,
          });
    }

    Future<void> seedMeterWithThreshold(double threshold) async {
      await fakeFirestore
          .collection('grounds/$_groundId/rental_units/$_unitId/meter_registry')
          .doc('m-1')
          .set({
            'groundId': _groundId,
            'unitId': _unitId,
            'meterNumber': 'TZ-001',
            'initialReading': 0.0,
            'currentReading': 0.0,
            'weeklyThreshold': threshold,
            'isActive': true,
            'createdAt': DateTime(2026, 1, 1).toIso8601String(),
            'updatedAt': DateTime(2026, 1, 1).toIso8601String(),
            'updatedBy': 'user-1',
            'schemaVersion': 1,
          });
    }

    Future<void> seedConsumptionReading(double units) async {
      await fakeFirestore
          .collection('grounds/$_groundId/rental_units/$_unitId/meter_readings')
          .add({
            'groundId': _groundId,
            'unitId': _unitId,
            'meterId': 'm-1',
            'reading': units,
            'previousReading': 0.0,
            'unitsConsumed': units,
            'readingDate': DateTime(2026, 4, 10).toIso8601String(),
            'isMeterReset': false,
            'notes': '',
            'createdAt': DateTime(2026, 4, 10).toIso8601String(),
            'updatedAt': DateTime(2026, 4, 10).toIso8601String(),
            'updatedBy': 'user-1',
            'schemaVersion': 1,
          });
    }

    test('returns alerts when units are over threshold', () async {
      await seedGroundAndUnit();
      await seedMeterWithThreshold(100);
      await seedConsumptionReading(160); // 60% over threshold → warning

      final alerts = await service.generateElectricityAlerts(
        groundId: _groundId,
      );

      expect(alerts.length, equals(1));
      expect(alerts.first.module, equals('electricity'));
      expect(alerts.first.id, startsWith('electricity-'));
    });

    test('returns empty list when all units are within threshold', () async {
      await seedGroundAndUnit();
      await seedMeterWithThreshold(100);
      await seedConsumptionReading(80); // Under threshold.

      final alerts = await service.generateElectricityAlerts(
        groundId: _groundId,
      );

      expect(alerts, isEmpty);
    });

    test('alert icon is bolt_outlined', () async {
      await seedGroundAndUnit();
      await seedMeterWithThreshold(100);
      await seedConsumptionReading(200);

      final alerts = await service.generateElectricityAlerts(
        groundId: _groundId,
      );

      expect(alerts.first.icon, equals(Icons.bolt_outlined));
    });

    test('alert targetRoute is /electricity/warnings', () async {
      await seedGroundAndUnit();
      await seedMeterWithThreshold(100);
      await seedConsumptionReading(200);

      final alerts = await service.generateElectricityAlerts(
        groundId: _groundId,
      );

      expect(alerts.first.targetRoute, equals('/electricity/warnings'));
    });
  });
}
