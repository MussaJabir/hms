import 'package:flutter_test/flutter_test.dart';
import 'package:hms/features/water/models/water_surplus_deficit.dart';

void main() {
  WaterSurplusDeficit make({
    double totalCollected = 0,
    double actualBillAmount = 0,
    int totalTenants = 0,
    int paidTenants = 0,
  }) => WaterSurplusDeficit(
    period: '2026-03',
    groundId: 'g-1',
    totalCollected: totalCollected,
    actualBillAmount: actualBillAmount,
    totalTenants: totalTenants,
    paidTenants: paidTenants,
  );

  group('WaterSurplusDeficit', () {
    test('surplusDeficit calculates correctly', () {
      final sd = make(totalCollected: 30000, actualBillAmount: 25000);
      expect(sd.surplusDeficit, equals(5000));
    });

    test('surplusDeficit is negative when deficit', () {
      final sd = make(totalCollected: 20000, actualBillAmount: 30000);
      expect(sd.surplusDeficit, equals(-10000));
    });

    test('isSurplus is true when collected > bill', () {
      final sd = make(totalCollected: 30000, actualBillAmount: 25000);
      expect(sd.isSurplus, isTrue);
      expect(sd.isDeficit, isFalse);
    });

    test('isSurplus is true when collected == bill (break-even)', () {
      final sd = make(totalCollected: 25000, actualBillAmount: 25000);
      expect(sd.isSurplus, isTrue);
    });

    test('isDeficit is true when collected < bill', () {
      final sd = make(totalCollected: 10000, actualBillAmount: 30000);
      expect(sd.isDeficit, isTrue);
      expect(sd.isSurplus, isFalse);
    });

    test('collectionRate percentage correct', () {
      final sd = make(totalTenants: 4, paidTenants: 3);
      expect(sd.collectionRate, equals(75.0));
    });

    test('collectionRate is 0 when no tenants', () {
      final sd = make(totalTenants: 0, paidTenants: 0);
      expect(sd.collectionRate, equals(0));
    });

    test('collectionRate is 100 when all paid', () {
      final sd = make(totalTenants: 5, paidTenants: 5);
      expect(sd.collectionRate, equals(100.0));
    });
  });
}
