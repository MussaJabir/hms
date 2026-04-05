import 'package:flutter_test/flutter_test.dart';
import 'package:hms/features/grounds/models/rental_unit.dart';

void main() {
  final now = DateTime(2026, 4, 5, 10, 0);

  RentalUnit makeUnit({String status = 'occupied'}) => RentalUnit(
    id: 'unit-1',
    groundId: 'ground-1',
    name: 'Room 1',
    rentAmount: 150000,
    status: status,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );

  group('RentalUnit getters', () {
    test('isOccupied returns true when status is occupied', () {
      expect(makeUnit(status: 'occupied').isOccupied, isTrue);
    });

    test('isOccupied returns false when status is vacant', () {
      expect(makeUnit(status: 'vacant').isOccupied, isFalse);
    });

    test('isVacant returns true when status is vacant', () {
      expect(makeUnit(status: 'vacant').isVacant, isTrue);
    });

    test('isVacant returns false when status is occupied', () {
      expect(makeUnit(status: 'occupied').isVacant, isFalse);
    });
  });

  group('RentalUnit fromJson/toJson', () {
    test('round-trips correctly', () {
      final unit = makeUnit();
      final json = unit.toJson();
      final restored = RentalUnit.fromJson(json);

      expect(restored.id, equals(unit.id));
      expect(restored.groundId, equals(unit.groundId));
      expect(restored.name, equals(unit.name));
      expect(restored.rentAmount, equals(unit.rentAmount));
      expect(restored.status, equals(unit.status));
      expect(restored.schemaVersion, equals(1));
    });

    test('meterId defaults to null when absent', () {
      final unit = makeUnit();
      expect(unit.meterId, isNull);
    });

    test('meterId is preserved when set', () {
      final unit = makeUnit().copyWith(meterId: 'M-001');
      final json = unit.toJson();
      final restored = RentalUnit.fromJson(json);
      expect(restored.meterId, equals('M-001'));
    });
  });
}
