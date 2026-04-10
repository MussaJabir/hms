import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/rent/services/rent_history_service.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late RentHistoryService service;

  const groundId = 'g-1';
  const unitId = 'u-1';
  const tenantId = 'tenant-1';
  const otherTenantId = 'tenant-2';
  const path = 'grounds/$groundId/rental_units/$unitId/rent_payments';

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
    service = RentHistoryService(firestoreService);
  });

  Future<void> seedRecord({
    required String id,
    required String linkedEntityId,
    String period = '2026-03',
    String status = 'pending',
    double amount = 300000,
    double amountPaid = 0,
  }) async {
    final now = DateTime(2026, 3, 1);
    await fakeFirestore.collection(path).doc(id).set({
      'id': id,
      'configId': 'cfg-1',
      'type': 'rent',
      'linkedEntityId': linkedEntityId,
      'linkedEntityName': 'Test Tenant — Room 1',
      'amount': amount,
      'period': period,
      'status': status,
      'amountPaid': amountPaid,
      'dueDate': now.toIso8601String(),
      'createdAt': now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
      'updatedBy': 'user-1',
      'schemaVersion': 1,
    });
  }

  // ── getTenantHistory ───────────────────────────────────────────────────

  group('RentHistoryService.getTenantHistory', () {
    test('returns records for the correct tenant only', () async {
      await seedRecord(id: 'r1', linkedEntityId: tenantId, period: '2026-03');
      await seedRecord(id: 'r2', linkedEntityId: tenantId, period: '2026-02');
      await seedRecord(
        id: 'r3',
        linkedEntityId: otherTenantId,
        period: '2026-03',
      );

      final records = await service.getTenantHistory(
        groundId: groundId,
        unitId: unitId,
        tenantId: tenantId,
      );

      expect(records.length, equals(2));
      expect(records.every((r) => r.linkedEntityId == tenantId), isTrue);
    });

    test('returns empty list when no records exist', () async {
      final records = await service.getTenantHistory(
        groundId: groundId,
        unitId: unitId,
        tenantId: tenantId,
      );
      expect(records, isEmpty);
    });

    test('returns records newest period first', () async {
      await seedRecord(id: 'r1', linkedEntityId: tenantId, period: '2026-01');
      await seedRecord(id: 'r2', linkedEntityId: tenantId, period: '2026-03');
      await seedRecord(id: 'r3', linkedEntityId: tenantId, period: '2026-02');

      final records = await service.getTenantHistory(
        groundId: groundId,
        unitId: unitId,
        tenantId: tenantId,
      );

      expect(records[0].period, equals('2026-03'));
      expect(records[1].period, equals('2026-02'));
      expect(records[2].period, equals('2026-01'));
    });
  });

  // ── getTotalPaidByTenant ───────────────────────────────────────────────

  group('RentHistoryService.getTotalPaidByTenant', () {
    test('sums amountPaid across all records', () async {
      await seedRecord(
        id: 'r1',
        linkedEntityId: tenantId,
        status: 'paid',
        amountPaid: 300000,
      );
      await seedRecord(
        id: 'r2',
        linkedEntityId: tenantId,
        status: 'partial',
        amountPaid: 150000,
      );
      await seedRecord(
        id: 'r3',
        linkedEntityId: tenantId,
        status: 'pending',
        amountPaid: 0,
      );

      final total = await service.getTotalPaidByTenant(
        groundId: groundId,
        unitId: unitId,
        tenantId: tenantId,
      );

      expect(total, equals(450000.0));
    });

    test('returns 0 when no payments made', () async {
      await seedRecord(id: 'r1', linkedEntityId: tenantId, amountPaid: 0);

      final total = await service.getTotalPaidByTenant(
        groundId: groundId,
        unitId: unitId,
        tenantId: tenantId,
      );

      expect(total, equals(0.0));
    });

    test('ignores records from other tenants', () async {
      await seedRecord(
        id: 'r1',
        linkedEntityId: tenantId,
        status: 'paid',
        amountPaid: 300000,
      );
      await seedRecord(
        id: 'r2',
        linkedEntityId: otherTenantId,
        status: 'paid',
        amountPaid: 999999,
      );

      final total = await service.getTotalPaidByTenant(
        groundId: groundId,
        unitId: unitId,
        tenantId: tenantId,
      );

      expect(total, equals(300000.0));
    });
  });

  // ── getPaidMonthsCount ─────────────────────────────────────────────────

  group('RentHistoryService.getPaidMonthsCount', () {
    test('counts only fully paid records', () async {
      await seedRecord(
        id: 'r1',
        linkedEntityId: tenantId,
        status: 'paid',
        period: '2026-03',
      );
      await seedRecord(
        id: 'r2',
        linkedEntityId: tenantId,
        status: 'paid',
        period: '2026-02',
      );
      await seedRecord(
        id: 'r3',
        linkedEntityId: tenantId,
        status: 'partial',
        period: '2026-01',
      );
      await seedRecord(
        id: 'r4',
        linkedEntityId: tenantId,
        status: 'pending',
        period: '2025-12',
      );

      final count = await service.getPaidMonthsCount(
        groundId: groundId,
        unitId: unitId,
        tenantId: tenantId,
      );

      expect(count, equals(2));
    });

    test('returns 0 when no months are paid', () async {
      await seedRecord(id: 'r1', linkedEntityId: tenantId, status: 'pending');

      final count = await service.getPaidMonthsCount(
        groundId: groundId,
        unitId: unitId,
        tenantId: tenantId,
      );

      expect(count, equals(0));
    });
  });

  // ── getOutstandingMonthsCount ──────────────────────────────────────────

  group('RentHistoryService.getOutstandingMonthsCount', () {
    test('counts pending, partial, and overdue records', () async {
      await seedRecord(
        id: 'r1',
        linkedEntityId: tenantId,
        status: 'paid',
        period: '2026-03',
      );
      await seedRecord(
        id: 'r2',
        linkedEntityId: tenantId,
        status: 'partial',
        period: '2026-02',
      );
      await seedRecord(
        id: 'r3',
        linkedEntityId: tenantId,
        status: 'overdue',
        period: '2026-01',
      );
      await seedRecord(
        id: 'r4',
        linkedEntityId: tenantId,
        status: 'pending',
        period: '2025-12',
      );

      final count = await service.getOutstandingMonthsCount(
        groundId: groundId,
        unitId: unitId,
        tenantId: tenantId,
      );

      // partial + overdue + pending = 3
      expect(count, equals(3));
    });

    test('returns 0 when all months are paid', () async {
      await seedRecord(
        id: 'r1',
        linkedEntityId: tenantId,
        status: 'paid',
        period: '2026-03',
      );
      await seedRecord(
        id: 'r2',
        linkedEntityId: tenantId,
        status: 'paid',
        period: '2026-02',
      );

      final count = await service.getOutstandingMonthsCount(
        groundId: groundId,
        unitId: unitId,
        tenantId: tenantId,
      );

      expect(count, equals(0));
    });
  });
}
