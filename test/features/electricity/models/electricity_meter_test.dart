import 'package:flutter_test/flutter_test.dart';
import 'package:hms/features/electricity/models/electricity_meter.dart';

void main() {
  ElectricityMeter makeMeter({double threshold = 0}) {
    final now = DateTime(2026, 4, 12);
    return ElectricityMeter(
      id: 'm-1',
      groundId: 'g-1',
      unitId: 'u-1',
      meterNumber: 'TZ-001',
      weeklyThreshold: threshold,
      createdAt: now,
      updatedAt: now,
      updatedBy: 'user-1',
    );
  }

  group('ElectricityMeter.hasThreshold', () {
    test('returns false when weeklyThreshold is 0', () {
      expect(makeMeter(threshold: 0).hasThreshold, isFalse);
    });

    test('returns true when weeklyThreshold is greater than 0', () {
      expect(makeMeter(threshold: 50).hasThreshold, isTrue);
    });

    test('returns true for fractional threshold values', () {
      expect(makeMeter(threshold: 0.5).hasThreshold, isTrue);
    });
  });
}
