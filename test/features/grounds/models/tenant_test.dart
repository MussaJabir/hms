import 'package:flutter_test/flutter_test.dart';
import 'package:hms/features/grounds/models/tenant.dart';

void main() {
  final now = DateTime.now();

  Tenant makeTenant({DateTime? leaseEndDate}) => Tenant(
    id: 't-1',
    groundId: 'g-1',
    unitId: 'u-1',
    fullName: 'Juma Mkamwa',
    phoneNumber: '0712345678',
    moveInDate: DateTime(2025, 1, 1),
    leaseEndDate: leaseEndDate,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );

  group('Tenant.hasLeaseExpired', () {
    test('returns true when leaseEndDate is in the past', () {
      final tenant = makeTenant(
        leaseEndDate: now.subtract(const Duration(days: 1)),
      );
      expect(tenant.hasLeaseExpired, isTrue);
    });

    test('returns false when leaseEndDate is in the future', () {
      final tenant = makeTenant(
        leaseEndDate: now.add(const Duration(days: 30)),
      );
      expect(tenant.hasLeaseExpired, isFalse);
    });

    test('returns false when leaseEndDate is null', () {
      final tenant = makeTenant();
      expect(tenant.hasLeaseExpired, isFalse);
    });
  });

  group('Tenant.hasNationalId', () {
    test('returns true when nationalId is set', () {
      final tenant = makeTenant().copyWith(nationalId: '12345678901234567890');
      expect(tenant.hasNationalId, isTrue);
    });

    test('returns false when nationalId is null', () {
      expect(makeTenant().hasNationalId, isFalse);
    });

    test('returns false when nationalId is empty string', () {
      final tenant = makeTenant().copyWith(nationalId: '');
      expect(tenant.hasNationalId, isFalse);
    });
  });
}
