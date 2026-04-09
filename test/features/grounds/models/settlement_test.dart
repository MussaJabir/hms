import 'package:flutter_test/flutter_test.dart';
import 'package:hms/features/grounds/models/settlement.dart';

void main() {
  final now = DateTime(2026, 4, 9);

  Settlement makeSettlement({
    double outstandingRent = 0,
    double outstandingWater = 0,
    double otherCharges = 0,
    String status = 'pending',
  }) => Settlement(
    id: 's-1',
    groundId: 'g-1',
    unitId: 'u-1',
    tenantId: 't-1',
    tenantName: 'Amina Salim',
    moveOutDate: now,
    outstandingRent: outstandingRent,
    outstandingWater: outstandingWater,
    otherCharges: otherCharges,
    status: status,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );

  group('Settlement.totalOutstanding', () {
    test('returns sum of all outstanding amounts', () {
      final s = makeSettlement(
        outstandingRent: 50000,
        outstandingWater: 10000,
        otherCharges: 5000,
      );
      expect(s.totalOutstanding, equals(65000));
    });

    test('returns 0 when all amounts are 0', () {
      expect(makeSettlement().totalOutstanding, equals(0));
    });

    test('handles partial amounts', () {
      final s = makeSettlement(outstandingRent: 30000);
      expect(s.totalOutstanding, equals(30000));
    });
  });

  group('Settlement status getters', () {
    test('isSettled returns true when status is settled', () {
      expect(makeSettlement(status: 'settled').isSettled, isTrue);
      expect(makeSettlement(status: 'pending').isSettled, isFalse);
    });

    test('isPending returns true when status is pending', () {
      expect(makeSettlement(status: 'pending').isPending, isTrue);
      expect(makeSettlement(status: 'settled').isPending, isFalse);
    });

    test('isWaived returns true when status is waived', () {
      expect(makeSettlement(status: 'waived').isWaived, isTrue);
      expect(makeSettlement(status: 'pending').isWaived, isFalse);
    });
  });

  group('Settlement.fromJson', () {
    test('round-trips through JSON', () {
      final s = makeSettlement(
        outstandingRent: 20000,
        outstandingWater: 5000,
        status: 'settled',
      );
      final json = s.toJson();
      final decoded = Settlement.fromJson(json);
      expect(decoded.totalOutstanding, equals(s.totalOutstanding));
      expect(decoded.isSettled, isTrue);
    });
  });
}
