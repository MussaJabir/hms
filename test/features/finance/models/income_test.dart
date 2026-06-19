import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/features/finance/models/income.dart';
import 'package:hms/features/finance/models/income_source.dart';

Income _income({String source = 'freelance', String? groundId}) {
  final now = DateTime(2026, 6, 19);
  return Income(
    id: 'i-1',
    source: source,
    description: 'Test income',
    amount: 50000,
    date: now,
    groundId: groundId,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

void main() {
  group('Income', () {
    test('isRentIncome is true when source is rent', () {
      expect(_income(source: 'rent').isRentIncome, isTrue);
      expect(_income(source: 'freelance').isRentIncome, isFalse);
    });

    test('hasGround is true when groundId is set', () {
      expect(_income(groundId: 'g-1').hasGround, isTrue);
      expect(_income(groundId: null).hasGround, isFalse);
      expect(_income(groundId: '').hasGround, isFalse);
    });

    test('round-trips through JSON', () {
      final income = _income(source: 'rent', groundId: 'g-1');
      final restored = Income.fromJson(income.toJson());
      expect(restored, equals(income));
    });
  });

  group('IncomeSource', () {
    test('fromString maps known values correctly', () {
      expect(IncomeSource.fromString('rent'), IncomeSource.rent);
      expect(IncomeSource.fromString('freelance'), IncomeSource.freelance);
      expect(IncomeSource.fromString('business'), IncomeSource.business);
      expect(IncomeSource.fromString('bodaboda'), IncomeSource.bodaboda);
      expect(IncomeSource.fromString('salary'), IncomeSource.salary);
      expect(IncomeSource.fromString('gift'), IncomeSource.gift);
      expect(IncomeSource.fromString('other'), IncomeSource.other);
    });

    test('fromString falls back to other for unknown values', () {
      expect(IncomeSource.fromString('unknown'), IncomeSource.other);
      expect(IncomeSource.fromString(''), IncomeSource.other);
    });

    test('each source carries a label and icon', () {
      for (final source in IncomeSource.values) {
        expect(source.label, isNotEmpty);
        expect(source.icon, isA<IconData>());
      }
    });
  });
}
