import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/features/rent/services/rent_config_service.dart';
import 'package:hms/features/rent/services/rent_summary_service.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _ground1 = 'g-1';
const _ground2 = 'g-2';
const _unit1 = 'u-1';
const _unit2 = 'u-2';
const _configPath1 = 'grounds/$_ground1/rental_units/$_unit1/rent_payments';
const _configPath2 = 'grounds/$_ground2/rental_units/$_unit2/rent_payments';

String _currentPeriod() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}';
}

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late RecurringTransactionService recurringService;
  late RentConfigService rentConfigService;
  late RentSummaryService service;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
    recurringService = RecurringTransactionService(
      firestoreService,
      ActivityLogService(firestoreService),
    );
    rentConfigService = RentConfigService(recurringService);
    service = RentSummaryService(rentConfigService, recurringService);
  });

  /// Seeds a rent RecurringConfig with [collectionPath] determining the ground.
  Future<String> seedConfig({
    required String id,
    required String collectionPath,
    double amount = 300000,
    bool isActive = true,
  }) async {
    await fakeFirestore.collection('recurring_configs').doc(id).set({
      'id': id,
      'type': 'rent',
      'collectionPath': collectionPath,
      'linkedEntityId': 'tenant-$id',
      'linkedEntityName': 'Tenant $id',
      'amount': amount,
      'frequency': 'monthly',
      'dayOfMonth': 1,
      'isActive': isActive,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'updatedBy': 'user-1',
      'schemaVersion': 1,
    });
    return id;
  }

  /// Seeds a rent payment record under [collectionPath].
  Future<void> seedRecord({
    required String id,
    required String configId,
    required String collectionPath,
    String? period,
    double amountPaid = 0,
    String status = 'pending',
  }) async {
    final now = DateTime.now();
    await fakeFirestore.collection(collectionPath).doc(id).set({
      'id': id,
      'configId': configId,
      'type': 'rent',
      'linkedEntityId': 'tenant-$configId',
      'linkedEntityName': 'Tenant $configId',
      'amount': 300000,
      'period': period ?? _currentPeriod(),
      'status': status,
      'amountPaid': amountPaid,
      'dueDate': now.toIso8601String(),
      'createdAt': now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
      'updatedBy': 'user-1',
      'schemaVersion': 1,
    });
  }

  // ── getCurrentMonthExpected ──────────────────────────────────────────────

  group('RentSummaryService.getCurrentMonthExpected', () {
    test('sums active config amounts', () async {
      await seedConfig(
        id: 'cfg-1',
        collectionPath: _configPath1,
        amount: 300000,
      );
      await seedConfig(
        id: 'cfg-2',
        collectionPath: _configPath2,
        amount: 200000,
      );

      final total = await service.getCurrentMonthExpected();

      expect(total, equals(500000.0));
    });

    test('returns 0 when no active configs', () async {
      final total = await service.getCurrentMonthExpected();
      expect(total, equals(0.0));
    });

    test('excludes inactive configs', () async {
      await seedConfig(
        id: 'cfg-1',
        collectionPath: _configPath1,
        amount: 300000,
      );
      await seedConfig(
        id: 'cfg-2',
        collectionPath: _configPath2,
        amount: 200000,
        isActive: false,
      );

      final total = await service.getCurrentMonthExpected();

      expect(total, equals(300000.0));
    });

    test('ground filter includes only matching ground', () async {
      await seedConfig(
        id: 'cfg-1',
        collectionPath: _configPath1,
        amount: 300000,
      );
      await seedConfig(
        id: 'cfg-2',
        collectionPath: _configPath2,
        amount: 200000,
      );

      final total = await service.getCurrentMonthExpected(groundId: _ground1);

      expect(total, equals(300000.0));
    });
  });

  // ── getCurrentMonthCollected ─────────────────────────────────────────────

  group('RentSummaryService.getCurrentMonthCollected', () {
    test('sums amountPaid across current-month records', () async {
      await seedConfig(id: 'cfg-1', collectionPath: _configPath1);
      await seedConfig(id: 'cfg-2', collectionPath: _configPath2);
      await seedRecord(
        id: 'r1',
        configId: 'cfg-1',
        collectionPath: _configPath1,
        amountPaid: 300000,
        status: 'paid',
      );
      await seedRecord(
        id: 'r2',
        configId: 'cfg-2',
        collectionPath: _configPath2,
        amountPaid: 150000,
        status: 'partial',
      );

      final collected = await service.getCurrentMonthCollected();

      expect(collected, equals(450000.0));
    });

    test('returns 0 when no payments made', () async {
      await seedConfig(id: 'cfg-1', collectionPath: _configPath1);
      await seedRecord(
        id: 'r1',
        configId: 'cfg-1',
        collectionPath: _configPath1,
        amountPaid: 0,
      );

      final collected = await service.getCurrentMonthCollected();

      expect(collected, equals(0.0));
    });
  });

  // ── getCurrentMonthOutstanding ───────────────────────────────────────────

  group('RentSummaryService.getCurrentMonthOutstanding', () {
    test('returns expected minus collected', () async {
      await seedConfig(
        id: 'cfg-1',
        collectionPath: _configPath1,
        amount: 300000,
      );
      await seedRecord(
        id: 'r1',
        configId: 'cfg-1',
        collectionPath: _configPath1,
        amountPaid: 100000,
        status: 'partial',
      );

      final outstanding = await service.getCurrentMonthOutstanding();

      // expected=300000, collected=100000, outstanding=200000
      expect(outstanding, equals(200000.0));
    });

    test('clamps to 0 when fully collected', () async {
      await seedConfig(
        id: 'cfg-1',
        collectionPath: _configPath1,
        amount: 300000,
      );
      await seedRecord(
        id: 'r1',
        configId: 'cfg-1',
        collectionPath: _configPath1,
        amountPaid: 300000,
        status: 'paid',
      );

      final outstanding = await service.getCurrentMonthOutstanding();

      expect(outstanding, equals(0.0));
    });
  });

  // ── getCurrentMonthCollectionRate ────────────────────────────────────────

  group('RentSummaryService.getCurrentMonthCollectionRate', () {
    test('calculates percentage correctly', () async {
      await seedConfig(
        id: 'cfg-1',
        collectionPath: _configPath1,
        amount: 400000,
      );
      await seedRecord(
        id: 'r1',
        configId: 'cfg-1',
        collectionPath: _configPath1,
        amountPaid: 200000,
        status: 'partial',
      );

      final rate = await service.getCurrentMonthCollectionRate();

      expect(rate, closeTo(50.0, 0.01));
    });

    test('returns 0 when expected is 0', () async {
      final rate = await service.getCurrentMonthCollectionRate();
      expect(rate, equals(0.0));
    });

    test('clamps to 100 when collected exceeds expected', () async {
      await seedConfig(
        id: 'cfg-1',
        collectionPath: _configPath1,
        amount: 100000,
      );
      await seedRecord(
        id: 'r1',
        configId: 'cfg-1',
        collectionPath: _configPath1,
        amountPaid: 200000, // overpayment scenario
        status: 'paid',
      );

      final rate = await service.getCurrentMonthCollectionRate();

      expect(rate, equals(100.0));
    });

    test('ground filter applies correctly', () async {
      await seedConfig(
        id: 'cfg-1',
        collectionPath: _configPath1,
        amount: 300000,
      );
      await seedConfig(
        id: 'cfg-2',
        collectionPath: _configPath2,
        amount: 300000,
      );
      await seedRecord(
        id: 'r1',
        configId: 'cfg-1',
        collectionPath: _configPath1,
        amountPaid: 300000,
        status: 'paid',
      );
      await seedRecord(
        id: 'r2',
        configId: 'cfg-2',
        collectionPath: _configPath2,
        amountPaid: 0,
        status: 'pending',
      );

      // Ground 1: 300k collected / 300k expected = 100%
      final rate1 = await service.getCurrentMonthCollectionRate(
        groundId: _ground1,
      );
      expect(rate1, closeTo(100.0, 0.01));

      // Ground 2: 0 collected / 300k expected = 0%
      final rate2 = await service.getCurrentMonthCollectionRate(
        groundId: _ground2,
      );
      expect(rate2, closeTo(0.0, 0.01));
    });
  });
}
