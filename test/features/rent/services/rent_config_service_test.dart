import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/features/rent/services/rent_config_service.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late ActivityLogService activityLogService;
  late RecurringTransactionService recurringService;
  late RentConfigService rentConfigService;

  const tenantId = 'tenant-1';
  const userId = 'user-1';

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
    activityLogService = ActivityLogService(firestoreService);
    recurringService = RecurringTransactionService(
      firestoreService,
      activityLogService,
    );
    rentConfigService = RentConfigService(recurringService);
  });

  Future<void> seedConfig({
    required String id,
    required String linkedEntityId,
    bool isActive = true,
    double amount = 200000,
  }) async {
    await fakeFirestore.collection('recurring_configs').doc(id).set({
      'id': id,
      'type': 'rent',
      'linkedEntityId': linkedEntityId,
      'linkedEntityName': 'Test — Room 1',
      'collectionPath': 'grounds/g-1/rental_units/u-1/rent_payments',
      'amount': amount,
      'frequency': 'monthly',
      'dayOfMonth': 1,
      'isActive': isActive,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'updatedBy': userId,
      'schemaVersion': 1,
    });
  }

  group('RentConfigService.getConfigForTenant', () {
    test('returns active config for the given tenant', () async {
      await seedConfig(id: 'rent_$tenantId', linkedEntityId: tenantId);

      final config = await rentConfigService.getConfigForTenant(tenantId);

      expect(config, isNotNull);
      expect(config!.linkedEntityId, equals(tenantId));
    });

    test('returns null when no active config exists', () async {
      final config = await rentConfigService.getConfigForTenant(tenantId);
      expect(config, isNull);
    });

    test('ignores inactive configs', () async {
      await seedConfig(
        id: 'rent_$tenantId',
        linkedEntityId: tenantId,
        isActive: false,
      );

      final config = await rentConfigService.getConfigForTenant(tenantId);
      expect(config, isNull);
    });
  });

  group('RentConfigService.getAllActiveRentConfigs', () {
    test('returns all active rent configs', () async {
      await seedConfig(id: 'rent_t1', linkedEntityId: 't1');
      await seedConfig(id: 'rent_t2', linkedEntityId: 't2');
      await seedConfig(id: 'rent_t3', linkedEntityId: 't3', isActive: false);

      final configs = await rentConfigService.getAllActiveRentConfigs();

      expect(configs.length, equals(2));
      expect(configs.every((c) => c.isActive), isTrue);
    });
  });

  group('RentConfigService.updateRentAmount', () {
    test('updates the amount on the active config', () async {
      await seedConfig(
        id: 'rent_$tenantId',
        linkedEntityId: tenantId,
        amount: 150000,
      );

      await rentConfigService.updateRentAmount(
        tenantId: tenantId,
        newAmount: 200000,
        userId: userId,
      );

      final doc = await fakeFirestore
          .collection('recurring_configs')
          .doc('rent_$tenantId')
          .get();
      expect(doc.data()!['amount'], equals(200000));
    });

    test('is a no-op when no active config exists', () async {
      // Should not throw
      await expectLater(
        rentConfigService.updateRentAmount(
          tenantId: 'nonexistent-tenant',
          newAmount: 200000,
          userId: userId,
        ),
        completes,
      );
    });
  });
}
