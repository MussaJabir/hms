import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/features/grounds/models/tenant.dart';
import 'package:hms/features/grounds/services/rental_unit_service.dart';
import 'package:hms/features/grounds/services/tenant_service.dart';
import 'package:hms/features/rent/services/rent_config_service.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late ActivityLogService activityLogService;
  late TenantService tenantService;

  const groundId = 'ground-1';
  const unitId = 'unit-1';
  final now = DateTime(2026, 4, 5);

  Tenant makeTenant() => Tenant(
    id: '',
    groundId: groundId,
    unitId: unitId,
    fullName: 'Amina Salim',
    phoneNumber: '0712345678',
    moveInDate: DateTime(2026, 1, 1),
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );

  setUp(() async {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
    activityLogService = ActivityLogService(firestoreService);
    final recurringService = RecurringTransactionService(
      firestoreService,
      activityLogService,
    );
    final rentConfigService = RentConfigService(recurringService);
    final rentalUnitService = RentalUnitService(
      firestoreService,
      activityLogService,
      rentConfigService,
    );
    tenantService = TenantService(
      firestoreService,
      activityLogService,
      rentalUnitService,
      recurringService,
    );

    // Pre-create the unit document so updateUnit calls and getUnit don't fail.
    await fakeFirestore
        .collection('grounds/$groundId/rental_units')
        .doc(unitId)
        .set({
          'groundId': groundId,
          'name': 'Room 1',
          'rentAmount': 150000.0,
          'status': 'vacant',
          'createdAt': now.toIso8601String(),
          'updatedAt': now.toIso8601String(),
          'updatedBy': 'user-1',
          'schemaVersion': 1,
        });
  });

  group('TenantService.createTenant', () {
    test('writes to correct subcollection path', () async {
      await tenantService.createTenant(groundId, unitId, makeTenant(), 'u-1');

      final snap = await fakeFirestore
          .collection('grounds/$groundId/rental_units/$unitId/tenants')
          .get();

      expect(snap.docs.length, equals(1));
      expect(snap.docs.first.data()['fullName'], equals('Amina Salim'));
    });

    test('returns a non-empty document ID', () async {
      final id = await tenantService.createTenant(
        groundId,
        unitId,
        makeTenant(),
        'u-1',
      );
      expect(id, isNotEmpty);
    });

    test('updates unit status to occupied', () async {
      await tenantService.createTenant(groundId, unitId, makeTenant(), 'u-1');

      final unit = await fakeFirestore
          .collection('grounds/$groundId/rental_units')
          .doc(unitId)
          .get();

      expect(unit.data()!['status'], equals('occupied'));
    });

    test('logs activity after create', () async {
      await tenantService.createTenant(groundId, unitId, makeTenant(), 'u-1');

      final logs = await fakeFirestore.collection('activity_logs').get();
      final tenantLog = logs.docs.firstWhere(
        (d) => d.data()['module'] == 'tenants',
      );
      expect(tenantLog.data()['action'], equals('create'));
    });

    test('creates a recurring rent config for the new tenant', () async {
      final id = await tenantService.createTenant(
        groundId,
        unitId,
        makeTenant(),
        'u-1',
      );

      final configs = await fakeFirestore.collection('recurring_configs').get();
      expect(configs.docs.length, equals(1));

      final config = configs.docs.first.data();
      expect(config['type'], equals('rent'));
      expect(config['linkedEntityId'], equals(id));
    });

    test('sets linkedEntityId on the rent config to the tenant ID', () async {
      final id = await tenantService.createTenant(
        groundId,
        unitId,
        makeTenant(),
        'u-1',
      );

      final configs = await fakeFirestore.collection('recurring_configs').get();
      expect(configs.docs.first.data()['linkedEntityId'], equals(id));
    });

    test('uses the unit rentAmount for the config amount', () async {
      // Overwrite unit with a specific rentAmount
      await fakeFirestore
          .collection('grounds/$groundId/rental_units')
          .doc(unitId)
          .set({
            'groundId': groundId,
            'name': 'Room 1',
            'rentAmount': 300000.0,
            'status': 'vacant',
            'createdAt': now.toIso8601String(),
            'updatedAt': now.toIso8601String(),
            'updatedBy': 'user-1',
            'schemaVersion': 1,
          });

      await tenantService.createTenant(groundId, unitId, makeTenant(), 'u-1');

      final configs = await fakeFirestore.collection('recurring_configs').get();
      expect(configs.docs.first.data()['amount'], equals(300000.0));
    });
  });
}
