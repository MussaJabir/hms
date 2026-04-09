import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/features/grounds/services/move_out_service.dart';
import 'package:hms/features/grounds/services/rental_unit_service.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late ActivityLogService activityLogService;
  late RentalUnitService rentalUnitService;
  late RecurringTransactionService recurringTransactionService;
  late MoveOutService moveOutService;

  const groundId = 'ground-1';
  const unitId = 'unit-1';
  const tenantId = 'tenant-1';
  const userId = 'user-1';
  final moveOutDate = DateTime(2026, 4, 9);

  setUp(() async {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
    activityLogService = ActivityLogService(firestoreService);
    rentalUnitService = RentalUnitService(firestoreService, activityLogService);
    recurringTransactionService = RecurringTransactionService(
      firestoreService,
      activityLogService,
    );
    moveOutService = MoveOutService(
      firestoreService,
      rentalUnitService,
      recurringTransactionService,
      activityLogService,
    );

    // Pre-create the unit document as occupied
    await fakeFirestore
        .collection('grounds/$groundId/rental_units')
        .doc(unitId)
        .set({'status': 'occupied', 'name': 'Room 1'});
  });

  group('MoveOutService.processMoveOut', () {
    test('creates a settlement record in the correct subcollection', () async {
      await moveOutService.processMoveOut(
        groundId: groundId,
        unitId: unitId,
        tenantId: tenantId,
        tenantName: 'Amina Salim',
        moveOutDate: moveOutDate,
        outstandingRent: 50000,
        outstandingWater: 10000,
        userId: userId,
      );

      final snap = await fakeFirestore
          .collection('grounds/$groundId/rental_units/$unitId/settlements')
          .get();

      expect(snap.docs.length, equals(1));
      final data = snap.docs.first.data();
      expect(data['tenantName'], equals('Amina Salim'));
      expect(data['outstandingRent'], equals(50000));
      expect(data['status'], equals('pending'));
    });

    test('returns the settlement document ID', () async {
      final id = await moveOutService.processMoveOut(
        groundId: groundId,
        unitId: unitId,
        tenantId: tenantId,
        tenantName: 'Amina Salim',
        moveOutDate: moveOutDate,
        userId: userId,
      );
      expect(id, isNotEmpty);
    });

    test('updates unit status to vacant', () async {
      await moveOutService.processMoveOut(
        groundId: groundId,
        unitId: unitId,
        tenantId: tenantId,
        tenantName: 'Amina Salim',
        moveOutDate: moveOutDate,
        userId: userId,
      );

      final unit = await fakeFirestore
          .collection('grounds/$groundId/rental_units')
          .doc(unitId)
          .get();

      expect(unit.data()!['status'], equals('vacant'));
    });

    test('sets status to settled when no outstanding balances', () async {
      await moveOutService.processMoveOut(
        groundId: groundId,
        unitId: unitId,
        tenantId: tenantId,
        tenantName: 'John Doe',
        moveOutDate: moveOutDate,
        outstandingRent: 0,
        outstandingWater: 0,
        otherCharges: 0,
        userId: userId,
      );

      final snap = await fakeFirestore
          .collection('grounds/$groundId/rental_units/$unitId/settlements')
          .get();

      expect(snap.docs.first.data()['status'], equals('settled'));
    });

    test('deactivates recurring configs linked to this tenant', () async {
      // Create two recurring configs: one for this tenant, one for another
      await fakeFirestore.collection('recurring_configs').doc('cfg-1').set({
        'id': 'cfg-1',
        'linkedEntityId': tenantId,
        'isActive': true,
        'type': 'rent',
        'linkedEntityName': 'Room 1 - Amina',
        'collectionPath': 'rents',
        'amount': 100000,
        'frequency': 'monthly',
        'dayOfMonth': 1,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'updatedBy': userId,
        'schemaVersion': 1,
      });
      await fakeFirestore.collection('recurring_configs').doc('cfg-2').set({
        'id': 'cfg-2',
        'linkedEntityId': 'other-tenant',
        'isActive': true,
        'type': 'rent',
        'linkedEntityName': 'Room 2 - Other',
        'collectionPath': 'rents',
        'amount': 80000,
        'frequency': 'monthly',
        'dayOfMonth': 1,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'updatedBy': userId,
        'schemaVersion': 1,
      });

      await moveOutService.processMoveOut(
        groundId: groundId,
        unitId: unitId,
        tenantId: tenantId,
        tenantName: 'Amina Salim',
        moveOutDate: moveOutDate,
        userId: userId,
      );

      final cfg1 = await fakeFirestore
          .collection('recurring_configs')
          .doc('cfg-1')
          .get();
      final cfg2 = await fakeFirestore
          .collection('recurring_configs')
          .doc('cfg-2')
          .get();

      // Tenant's config deactivated; other tenant's config untouched
      expect(cfg1.data()!['isActive'], isFalse);
      expect(cfg2.data()!['isActive'], isTrue);
    });
  });

  group('MoveOutService.markSettled', () {
    test('updates settlement status to settled', () async {
      final settlementId = await moveOutService.processMoveOut(
        groundId: groundId,
        unitId: unitId,
        tenantId: tenantId,
        tenantName: 'Amina Salim',
        moveOutDate: moveOutDate,
        outstandingRent: 50000,
        userId: userId,
      );

      await moveOutService.markSettled(
        groundId: groundId,
        unitId: unitId,
        settlementId: settlementId,
        userId: userId,
      );

      final doc = await fakeFirestore
          .collection('grounds/$groundId/rental_units/$unitId/settlements')
          .doc(settlementId)
          .get();

      expect(doc.data()!['status'], equals('settled'));
    });
  });

  group('MoveOutService.waiveBalance', () {
    test('updates settlement status to waived', () async {
      final settlementId = await moveOutService.processMoveOut(
        groundId: groundId,
        unitId: unitId,
        tenantId: tenantId,
        tenantName: 'Amina Salim',
        moveOutDate: moveOutDate,
        outstandingRent: 50000,
        userId: userId,
      );

      await moveOutService.waiveBalance(
        groundId: groundId,
        unitId: unitId,
        settlementId: settlementId,
        userId: userId,
      );

      final doc = await fakeFirestore
          .collection('grounds/$groundId/rental_units/$unitId/settlements')
          .doc(settlementId)
          .get();

      expect(doc.data()!['status'], equals('waived'));
    });
  });
}
