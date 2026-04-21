import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/features/grounds/services/ground_service.dart';
import 'package:hms/features/water/services/water_bill_service.dart';
import 'package:hms/features/water/services/water_contribution_service.dart';
import 'package:hms/features/water/services/water_summary_service.dart';

const _groundId = 'g-1';
const _userId = 'user-1';

String _currentPeriod() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}';
}

Future<String> _seedBill(
  FakeFirebaseFirestore fakeFirestore, {
  String groundId = _groundId,
  String? period,
  String status = 'unpaid',
  DateTime? dueDate,
  double totalAmount = 30000.0,
}) async {
  final now = DateTime.now();
  final col = 'grounds/$groundId/water_bills';
  final ref = fakeFirestore.collection(col).doc();
  await ref.set({
    'id': ref.id,
    'groundId': groundId,
    'billingPeriod': period ?? _currentPeriod(),
    'previousMeterReading': 100.0,
    'currentMeterReading': 160.0,
    'totalAmount': totalAmount,
    'dueDate': (dueDate ?? now.add(const Duration(days: 10))).toIso8601String(),
    'status': status,
    'notes': '',
    'createdAt': now.toIso8601String(),
    'updatedAt': now.toIso8601String(),
    'updatedBy': _userId,
    'schemaVersion': 1,
  });
  return ref.id;
}

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late ActivityLogService activityLogService;
  late RecurringTransactionService recurringService;
  late WaterBillService waterBillService;
  late WaterContributionService contributionService;
  late GroundService groundService;
  late WaterSummaryService service;

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
    contributionService = WaterContributionService(
      firestoreService,
      recurringService,
      waterBillService,
      activityLogService,
    );
    groundService = GroundService(firestoreService, activityLogService);
    service = WaterSummaryService(
      waterBillService,
      contributionService,
      groundService,
    );
  });

  group('getCurrentMonthCost', () {
    test('returns 0 when no bills exist', () async {
      final cost = await service.getCurrentMonthCost(groundId: _groundId);
      expect(cost, 0.0);
    });

    test('sums bill amount for current period', () async {
      await _seedBill(fakeFirestore, totalAmount: 25000);
      final cost = await service.getCurrentMonthCost(groundId: _groundId);
      expect(cost, 25000.0);
    });

    test('ignores bills from other periods', () async {
      await _seedBill(fakeFirestore, period: '2024-01', totalAmount: 15000);
      final cost = await service.getCurrentMonthCost(groundId: _groundId);
      expect(cost, 0.0);
    });
  });

  group('getUnpaidBillsCount', () {
    test('returns 0 when no bills', () async {
      final count = await service.getUnpaidBillsCount(groundId: _groundId);
      expect(count, 0);
    });

    test('counts unpaid and overdue bills', () async {
      await _seedBill(fakeFirestore, status: 'unpaid');
      await _seedBill(fakeFirestore, status: 'overdue');
      await _seedBill(fakeFirestore, status: 'paid');
      final count = await service.getUnpaidBillsCount(groundId: _groundId);
      expect(count, 2);
    });

    test('paid bills are not counted', () async {
      await _seedBill(fakeFirestore, status: 'paid');
      final count = await service.getUnpaidBillsCount(groundId: _groundId);
      expect(count, 0);
    });
  });

  group('getBillsDueSoon', () {
    test('returns bills due within 7 days', () async {
      final soon = DateTime.now().add(const Duration(days: 3));
      await _seedBill(fakeFirestore, dueDate: soon, status: 'unpaid');
      final bills = await service.getBillsDueSoon(groundId: _groundId);
      expect(bills, hasLength(1));
    });

    test('excludes bills due after 7 days', () async {
      final far = DateTime.now().add(const Duration(days: 10));
      await _seedBill(fakeFirestore, dueDate: far, status: 'unpaid');
      final bills = await service.getBillsDueSoon(groundId: _groundId);
      expect(bills, isEmpty);
    });

    test('excludes paid bills even if due soon', () async {
      final soon = DateTime.now().add(const Duration(days: 2));
      await _seedBill(fakeFirestore, dueDate: soon, status: 'paid');
      final bills = await service.getBillsDueSoon(groundId: _groundId);
      expect(bills, isEmpty);
    });
  });

  group('getOverdueBills', () {
    test('returns only overdue bills', () async {
      await _seedBill(fakeFirestore, status: 'overdue');
      await _seedBill(fakeFirestore, status: 'unpaid');
      await _seedBill(fakeFirestore, status: 'paid');
      final bills = await service.getOverdueBills(groundId: _groundId);
      expect(bills, hasLength(1));
      expect(bills.first.isOverdue, isTrue);
    });

    test('returns empty when no overdue bills', () async {
      await _seedBill(fakeFirestore, status: 'unpaid');
      final bills = await service.getOverdueBills(groundId: _groundId);
      expect(bills, isEmpty);
    });
  });

  group('getCurrentMonthSurplusDeficit', () {
    test('returns 0 when no bills and no contributions', () async {
      final sd = await service.getCurrentMonthSurplusDeficit(
        groundId: _groundId,
      );
      expect(sd, 0.0);
    });

    test(
      'returns negative when bill exists but no contributions paid',
      () async {
        await _seedBill(fakeFirestore, totalAmount: 20000);
        final sd = await service.getCurrentMonthSurplusDeficit(
          groundId: _groundId,
        );
        // bill exists (20000), no contributions paid → deficit of -20000
        expect(sd, -20000.0);
      },
    );
  });

  group('ground filtering', () {
    test('filters by groundId and ignores other grounds', () async {
      // Seed bill for g-1 and g-2
      await _seedBill(fakeFirestore, groundId: 'g-1', totalAmount: 25000);
      await _seedBill(fakeFirestore, groundId: 'g-2', totalAmount: 40000);

      // Ground g-1 filtering
      final cost = await service.getCurrentMonthCost(groundId: 'g-1');
      expect(cost, 25000.0);

      final count = await service.getUnpaidBillsCount(groundId: 'g-1');
      expect(count, 1);
    });
  });
}
