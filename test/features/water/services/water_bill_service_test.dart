import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/water/models/water_bill.dart';
import 'package:hms/features/water/services/water_bill_service.dart';

const _groundId = 'g-1';
const _userId = 'user-1';
const _col = 'grounds/$_groundId/water_bills';

/// Seed a bill directly into FakeFirebaseFirestore with ISO string dates
/// (FakeFirebaseFirestore would return server Timestamps for FieldValue.serverTimestamp(),
/// which breaks fromJson — so we seed manually for read-back tests).
Future<String> _seedBill(
  FakeFirebaseFirestore fakeFirestore, {
  String period = '2026-03',
  String status = 'unpaid',
  DateTime? due,
  double totalAmount = 25000,
}) async {
  final now = DateTime(2026, 4, 18);
  final ref = fakeFirestore.collection(_col).doc();
  await ref.set({
    'id': ref.id,
    'groundId': _groundId,
    'billingPeriod': period,
    'previousMeterReading': 100.0,
    'currentMeterReading': 160.0,
    'totalAmount': totalAmount,
    'dueDate': (due ?? now.add(const Duration(days: 10))).toIso8601String(),
    'status': status,
    'notes': '',
    'createdAt': now.toIso8601String(),
    'updatedAt': now.toIso8601String(),
    'updatedBy': _userId,
    'schemaVersion': 1,
  });
  return ref.id;
}

WaterBill _bill({
  String id = '',
  String period = '2026-03',
  String status = 'unpaid',
  DateTime? due,
}) {
  final now = DateTime(2026, 4, 18);
  return WaterBill(
    id: id,
    groundId: _groundId,
    billingPeriod: period,
    previousMeterReading: 100,
    currentMeterReading: 160,
    totalAmount: 25000,
    dueDate: due ?? now.add(const Duration(days: 10)),
    status: status,
    createdAt: now,
    updatedAt: now,
    updatedBy: _userId,
  );
}

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late WaterBillService service;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
    service = WaterBillService(
      firestoreService,
      ActivityLogService(firestoreService),
      firestore: fakeFirestore,
    );
  });

  group('WaterBillService.createBill', () {
    test('writes to correct subcollection', () async {
      final id = await service.createBill(
        groundId: _groundId,
        bill: _bill(),
        userId: _userId,
      );

      final snap = await fakeFirestore.collection(_col).doc(id).get();
      expect(snap.exists, isTrue);
      expect(snap.data()!['billingPeriod'], equals('2026-03'));
    });

    test('returns non-empty document id', () async {
      final id = await service.createBill(
        groundId: _groundId,
        bill: _bill(),
        userId: _userId,
      );
      expect(id.isNotEmpty, isTrue);
    });
  });

  group('WaterBillService.markPaid', () {
    test('updates status to paid and sets paidDate', () async {
      final id = await service.createBill(
        groundId: _groundId,
        bill: _bill(),
        userId: _userId,
      );

      await service.markPaid(
        groundId: _groundId,
        billId: id,
        paymentMethod: 'Cash',
        userId: _userId,
      );

      final snap = await fakeFirestore.collection(_col).doc(id).get();
      expect(snap.data()!['status'], equals('paid'));
      expect(snap.data()!['paymentMethod'], equals('Cash'));
      expect(snap.data()!['paidDate'], isNotNull);
    });
  });

  group('WaterBillService.markOverdueBills', () {
    test('changes unpaid bills past due date to overdue', () async {
      final pastDue = DateTime.now().subtract(const Duration(days: 5));
      final id = await _seedBill(fakeFirestore, due: pastDue);

      final count = await service.markOverdueBills(userId: _userId);

      expect(count, equals(1));
      final snap = await fakeFirestore.collection(_col).doc(id).get();
      expect(snap.data()!['status'], equals('overdue'));
    });

    test('does not change bills with future due dates', () async {
      final futureDue = DateTime.now().add(const Duration(days: 10));
      final id = await _seedBill(fakeFirestore, due: futureDue);

      await service.markOverdueBills(userId: _userId);

      final snap = await fakeFirestore.collection(_col).doc(id).get();
      expect(snap.data()!['status'], equals('unpaid'));
    });
  });

  group('WaterBillService.getAverageMonthlyBill', () {
    test('returns mean of all bill amounts', () async {
      await _seedBill(fakeFirestore, period: '2026-01', totalAmount: 20000);
      await _seedBill(fakeFirestore, period: '2026-02', totalAmount: 30000);

      final avg = await service.getAverageMonthlyBill(_groundId);
      expect(avg, equals(25000.0));
    });

    test('returns 0 when no bills exist', () async {
      final avg = await service.getAverageMonthlyBill(_groundId);
      expect(avg, equals(0.0));
    });
  });
}
