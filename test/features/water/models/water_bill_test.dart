import 'package:flutter_test/flutter_test.dart';
import 'package:hms/features/water/models/water_bill.dart';

WaterBill _bill({
  double prev = 100,
  double curr = 150,
  DateTime? due,
  String status = 'unpaid',
  DateTime? paidDate,
}) {
  final now = DateTime(2026, 4, 18);
  return WaterBill(
    id: 'b-1',
    groundId: 'g-1',
    billingPeriod: '2026-03',
    previousMeterReading: prev,
    currentMeterReading: curr,
    totalAmount: 25000,
    dueDate: due ?? now.add(const Duration(days: 10)),
    status: status,
    paidDate: paidDate,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

void main() {
  group('WaterBill.unitsConsumed', () {
    test('returns difference between current and previous reading', () {
      expect(_bill(prev: 100, curr: 160).unitsConsumed, equals(60.0));
    });

    test('returns zero when readings are equal', () {
      expect(_bill(prev: 200, curr: 200).unitsConsumed, equals(0.0));
    });
  });

  group('WaterBill.isDueSoon', () {
    test('returns true when due within 7 days and not paid', () {
      final soon = DateTime.now().add(const Duration(days: 3));
      expect(_bill(due: soon, status: 'unpaid').isDueSoon, isTrue);
    });

    test('returns false when due in more than 7 days', () {
      final far = DateTime.now().add(const Duration(days: 15));
      expect(_bill(due: far, status: 'unpaid').isDueSoon, isFalse);
    });

    test('returns false when already paid', () {
      final soon = DateTime.now().add(const Duration(days: 3));
      expect(_bill(due: soon, status: 'paid').isDueSoon, isFalse);
    });

    test('returns false when due date has passed', () {
      final past = DateTime.now().subtract(const Duration(days: 1));
      expect(_bill(due: past, status: 'unpaid').isDueSoon, isFalse);
    });
  });

  group('WaterBill.isOverdue', () {
    test('returns true when status is overdue', () {
      expect(_bill(status: 'overdue').isOverdue, isTrue);
    });

    test('returns false when status is unpaid', () {
      expect(_bill(status: 'unpaid').isOverdue, isFalse);
    });

    test('returns false when status is paid', () {
      expect(_bill(status: 'paid').isOverdue, isFalse);
    });
  });

  group('WaterBill.hasSmsData', () {
    test('returns true when rawSmsText is non-empty', () {
      final bill = _bill().copyWith(rawSmsText: 'DAWASCO bill for March');
      expect(bill.hasSmsData, isTrue);
    });

    test('returns false when rawSmsText is null', () {
      expect(_bill().hasSmsData, isFalse);
    });

    test('returns false when rawSmsText is empty string', () {
      final bill = _bill().copyWith(rawSmsText: '');
      expect(bill.hasSmsData, isFalse);
    });
  });

  group('WaterBill status helpers', () {
    test('isPaid is true only for paid status', () {
      expect(_bill(status: 'paid').isPaid, isTrue);
      expect(_bill(status: 'unpaid').isPaid, isFalse);
    });

    test('isUnpaid is true only for unpaid status', () {
      expect(_bill(status: 'unpaid').isUnpaid, isTrue);
      expect(_bill(status: 'paid').isUnpaid, isFalse);
    });
  });
}
