import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/features/water/services/water_bill_service.dart';
import 'package:hms/features/water/services/water_contribution_service.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late ActivityLogService activityLogService;
  late RecurringTransactionService recurringService;
  late WaterBillService waterBillService;
  late WaterContributionService service;

  const groundId = 'g-1';
  const unitId = 'u-1';
  const tenantId = 't-1';
  const userId = 'user-1';

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
    activityLogService = ActivityLogService(firestoreService);
    recurringService = RecurringTransactionService(
      firestoreService,
      activityLogService,
    );
    waterBillService = WaterBillService(
      firestoreService,
      activityLogService,
      firestore: fakeFirestore,
    );
    service = WaterContributionService(
      firestoreService,
      recurringService,
      waterBillService,
      activityLogService,
    );
  });

  group('WaterContributionService', () {
    test(
      'setupContribution creates RecurringConfig with type water_contribution',
      () async {
        await service.setupContribution(
          groundId: groundId,
          unitId: unitId,
          tenantId: tenantId,
          tenantName: 'Amina Salim',
          unitName: 'Room 1',
          monthlyAmount: 5000,
          userId: userId,
        );

        final configs = await fakeFirestore
            .collection(RecurringTransactionService.configCollection)
            .get();
        expect(configs.docs, isNotEmpty);
        final config = configs.docs.first.data();
        expect(config['type'], equals('water_contribution'));
        expect(config['linkedEntityId'], equals(tenantId));
        expect(config['amount'], equals(5000.0));
        expect(config['isActive'], isTrue);
      },
    );

    test('deactivateForTenant sets isActive to false', () async {
      await service.setupContribution(
        groundId: groundId,
        unitId: unitId,
        tenantId: tenantId,
        tenantName: 'Amina Salim',
        unitName: 'Room 1',
        monthlyAmount: 5000,
        userId: userId,
      );

      await service.deactivateForTenant(tenantId: tenantId, userId: userId);

      final doc = await fakeFirestore
          .collection(RecurringTransactionService.configCollection)
          .doc('water_$tenantId')
          .get();
      expect(doc.data()?['isActive'], isFalse);
    });

    test('calculateSurplusDeficit computes from records and bill', () async {
      // Set up contribution config
      await service.setupContribution(
        groundId: groundId,
        unitId: unitId,
        tenantId: tenantId,
        tenantName: 'Amina Salim',
        unitName: 'Room 1',
        monthlyAmount: 8000,
        userId: userId,
      );

      // Create a water bill for this period
      await fakeFirestore.collection('grounds/$groundId/water_bills').add({
        'id': 'bill-1',
        'groundId': groundId,
        'billingPeriod': '2026-03',
        'previousMeterReading': 100.0,
        'currentMeterReading': 150.0,
        'totalAmount': 25000.0,
        'dueDate': '2026-04-15T00:00:00.000',
        'status': 'unpaid',
        'notes': '',
        'createdAt': '2026-03-01T00:00:00.000',
        'updatedAt': '2026-03-01T00:00:00.000',
        'updatedBy': userId,
        'schemaVersion': 1,
      });

      final result = await service.calculateSurplusDeficit(
        groundId: groundId,
        period: '2026-03',
      );

      expect(result.actualBillAmount, equals(25000.0));
      expect(result.groundId, equals(groundId));
      expect(result.period, equals('2026-03'));
    });

    test('calculateSurplusDeficit handles no bill for period', () async {
      await service.setupContribution(
        groundId: groundId,
        unitId: unitId,
        tenantId: tenantId,
        tenantName: 'Amina Salim',
        unitName: 'Room 1',
        monthlyAmount: 5000,
        userId: userId,
      );

      final result = await service.calculateSurplusDeficit(
        groundId: groundId,
        period: '2026-03',
      );

      expect(result.actualBillAmount, equals(0.0));
      expect(result.isSurplus, isTrue);
    });

    test('getDefaultAmount returns fallback when not configured', () async {
      final amount = await service.getDefaultAmount();
      expect(amount, equals(5000.0));
    });

    test('setDefaultAmount and getDefaultAmount round-trip', () async {
      await service.setDefaultAmount(amount: 12000, userId: userId);
      final amount = await service.getDefaultAmount();
      expect(amount, equals(12000.0));
    });
  });
}
