import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/models/recurring_config.dart';
import 'package:hms/core/models/recurring_record.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';

/// Stub that silently swallows log calls — keeps tests focused on the engine.
class _StubActivityLogService extends ActivityLogService {
  _StubActivityLogService() : super(_neverFirestore());

  static FirestoreService _neverFirestore() =>
      FirestoreService(firestore: FakeFirebaseFirestore());

  @override
  Future<void> log({
    required String userId,
    required String action,
    required String module,
    required String description,
    String? documentId,
    String? collectionPath,
  }) async {}
}

RecurringConfig _makeConfig({
  String id = 'cfg-1',
  String type = 'rent',
  String collectionPath = 'rent_payments',
  String linkedEntityId = 'tenant-1',
  String linkedEntityName = 'Room 3 - John',
  double amount = 150000,
  bool isActive = true,
  int dayOfMonth = 5,
}) {
  final now = DateTime(2026, 3, 1);
  return RecurringConfig(
    id: id,
    type: type,
    collectionPath: collectionPath,
    linkedEntityId: linkedEntityId,
    linkedEntityName: linkedEntityName,
    amount: amount,
    frequency: 'monthly',
    dayOfMonth: dayOfMonth,
    isActive: isActive,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late _StubActivityLogService activityLogService;
  late RecurringTransactionService service;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
    activityLogService = _StubActivityLogService();
    service = RecurringTransactionService(firestoreService, activityLogService);
  });

  // ---------------------------------------------------------------------------
  // createConfig
  // ---------------------------------------------------------------------------
  group('createConfig', () {
    test('writes config to recurring_configs collection', () async {
      final config = _makeConfig();
      await service.createConfig(config: config, userId: 'user-1');

      final snap = await fakeFirestore
          .collection('recurring_configs')
          .doc('cfg-1')
          .get();
      expect(snap.exists, isTrue);
      expect(snap.data()!['type'], 'rent');
      expect(snap.data()!['linkedEntityId'], 'tenant-1');
    });

    test('returns the config id', () async {
      final config = _makeConfig(id: 'cfg-abc');
      final id = await service.createConfig(config: config, userId: 'user-1');
      expect(id, 'cfg-abc');
    });
  });

  // ---------------------------------------------------------------------------
  // deactivateConfig
  // ---------------------------------------------------------------------------
  group('deactivateConfig', () {
    test('sets isActive to false without deleting the document', () async {
      final config = _makeConfig();
      await service.createConfig(config: config, userId: 'user-1');

      await service.deactivateConfig(configId: 'cfg-1', userId: 'user-1');

      final snap = await fakeFirestore
          .collection('recurring_configs')
          .doc('cfg-1')
          .get();
      expect(snap.exists, isTrue); // not deleted
      expect(snap.data()!['isActive'], isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // generateMonthlyRecords
  // ---------------------------------------------------------------------------
  group('generateMonthlyRecords', () {
    test('creates a record for each active config', () async {
      await service.createConfig(
        config: _makeConfig(id: 'cfg-1'),
        userId: 'user-1',
      );
      await service.createConfig(
        config: _makeConfig(id: 'cfg-2', linkedEntityId: 'tenant-2'),
        userId: 'user-1',
      );

      final created = await service.generateMonthlyRecords(
        userId: 'user-1',
        forDate: DateTime(2026, 3, 15),
      );

      expect(created.length, 2);
    });

    test('skips inactive configs', () async {
      await service.createConfig(
        config: _makeConfig(id: 'cfg-active', isActive: true),
        userId: 'user-1',
      );
      await service.createConfig(
        config: _makeConfig(
          id: 'cfg-inactive',
          linkedEntityId: 'tenant-99',
          isActive: false,
        ),
        userId: 'user-1',
      );
      // Manually set isActive=false since factory defaults to true
      await fakeFirestore
          .collection('recurring_configs')
          .doc('cfg-inactive')
          .update({'isActive': false});

      final created = await service.generateMonthlyRecords(
        userId: 'user-1',
        forDate: DateTime(2026, 3, 15),
      );

      expect(created.length, 1);
    });

    test('is idempotent — calling twice does not create duplicates', () async {
      await service.createConfig(config: _makeConfig(), userId: 'user-1');

      await service.generateMonthlyRecords(
        userId: 'user-1',
        forDate: DateTime(2026, 3, 15),
      );
      final secondCall = await service.generateMonthlyRecords(
        userId: 'user-1',
        forDate: DateTime(2026, 3, 15),
      );

      expect(secondCall, isEmpty);

      final snap = await fakeFirestore.collection('rent_payments').get();
      expect(snap.docs.length, 1);
    });

    test('period format is YYYY-MM', () async {
      await service.createConfig(config: _makeConfig(), userId: 'user-1');

      await service.generateMonthlyRecords(
        userId: 'user-1',
        forDate: DateTime(2026, 3, 15),
      );

      final snap = await fakeFirestore.collection('rent_payments').get();
      expect(snap.docs.first.data()['period'], '2026-03');
    });

    test('due date is calculated from config.dayOfMonth', () async {
      await service.createConfig(
        config: _makeConfig(dayOfMonth: 10),
        userId: 'user-1',
      );

      await service.generateMonthlyRecords(
        userId: 'user-1',
        forDate: DateTime(2026, 3, 15),
      );

      final snap = await fakeFirestore.collection('rent_payments').get();
      final data = snap.docs.first.data();
      // dueDate stored as ISO string
      final dueDate = DateTime.parse(data['dueDate'] as String);
      expect(dueDate.day, 10);
      expect(dueDate.month, 3);
      expect(dueDate.year, 2026);
    });

    test('generated record has pending status', () async {
      await service.createConfig(config: _makeConfig(), userId: 'user-1');

      await service.generateMonthlyRecords(
        userId: 'user-1',
        forDate: DateTime(2026, 3, 15),
      );

      final snap = await fakeFirestore.collection('rent_payments').get();
      expect(snap.docs.first.data()['status'], 'pending');
    });
  });

  // ---------------------------------------------------------------------------
  // updateRecordPayment
  // ---------------------------------------------------------------------------
  group('updateRecordPayment', () {
    setUp(() async {
      await service.createConfig(config: _makeConfig(), userId: 'user-1');
      await service.generateMonthlyRecords(
        userId: 'user-1',
        forDate: DateTime(2026, 3, 15),
      );
    });

    test('updates status and amountPaid', () async {
      final snap = await fakeFirestore.collection('rent_payments').get();
      final recordId = snap.docs.first.id;

      await service.updateRecordPayment(
        collectionPath: 'rent_payments',
        recordId: recordId,
        status: 'paid',
        amountPaid: 150000,
        paymentMethod: 'cash',
        userId: 'user-1',
      );

      final updated = await fakeFirestore
          .collection('rent_payments')
          .doc(recordId)
          .get();
      expect(updated.data()!['status'], 'paid');
      expect(updated.data()!['amountPaid'], 150000);
      expect(updated.data()!['paymentMethod'], 'cash');
      expect(updated.data()!['paidDate'], isNotNull);
    });

    test('updates status to partial without setting paidDate', () async {
      final snap = await fakeFirestore.collection('rent_payments').get();
      final recordId = snap.docs.first.id;

      await service.updateRecordPayment(
        collectionPath: 'rent_payments',
        recordId: recordId,
        status: 'partial',
        amountPaid: 75000,
        userId: 'user-1',
      );

      final updated = await fakeFirestore
          .collection('rent_payments')
          .doc(recordId)
          .get();
      expect(updated.data()!['status'], 'partial');
      expect(updated.data()!['amountPaid'], 75000);
      expect(updated.data()!['paidDate'], isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // markOverdueRecords
  // ---------------------------------------------------------------------------
  group('markOverdueRecords', () {
    test('marks pending records with past dueDate as overdue', () async {
      // Create a config and generate a record with a past due date
      await service.createConfig(
        config: _makeConfig(dayOfMonth: 1),
        userId: 'user-1',
      );
      // Generate for January 2026 — dueDate will be 2026-01-01 (past)
      await service.generateMonthlyRecords(
        userId: 'user-1',
        forDate: DateTime(2026, 1, 15),
      );

      final count = await service.markOverdueRecords(userId: 'user-1');

      expect(count, greaterThanOrEqualTo(1));

      final snap = await fakeFirestore.collection('rent_payments').get();
      final statuses = snap.docs.map((d) => d.data()['status']).toList();
      expect(statuses, contains('overdue'));
    });

    test('does not mark future records as overdue', () async {
      await service.createConfig(
        config: _makeConfig(dayOfMonth: 28),
        userId: 'user-1',
      );
      // Generate for a future month
      final futureDate = DateTime.now().add(const Duration(days: 60));
      await service.generateMonthlyRecords(
        userId: 'user-1',
        forDate: futureDate,
      );

      final count = await service.markOverdueRecords(userId: 'user-1');
      expect(count, 0);
    });
  });

  // ---------------------------------------------------------------------------
  // RecurringRecord helper getters
  // ---------------------------------------------------------------------------
  group('RecurringRecord getters', () {
    final now = DateTime(2026, 3, 1);

    RecurringRecord makeRecord({
      required String status,
      double amount = 100000,
      double amountPaid = 0,
    }) => RecurringRecord(
      id: 'r1',
      configId: 'cfg-1',
      type: 'rent',
      linkedEntityId: 'tenant-1',
      linkedEntityName: 'Room 3',
      amount: amount,
      period: '2026-03',
      status: status,
      amountPaid: amountPaid,
      dueDate: now,
      createdAt: now,
      updatedAt: now,
      updatedBy: 'user-1',
    );

    test('isPaid', () => expect(makeRecord(status: 'paid').isPaid, isTrue));
    test(
      'isPending',
      () => expect(makeRecord(status: 'pending').isPending, isTrue),
    );
    test(
      'isPartial',
      () => expect(makeRecord(status: 'partial').isPartial, isTrue),
    );
    test(
      'isOverdue',
      () => expect(makeRecord(status: 'overdue').isOverdue, isTrue),
    );

    test('remainingAmount equals amount minus amountPaid', () {
      final record = makeRecord(
        status: 'partial',
        amount: 100000,
        amountPaid: 40000,
      );
      expect(record.remainingAmount, 60000);
    });
  });
}
