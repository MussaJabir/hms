import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/features/finance/models/expense.dart';
import 'package:hms/features/finance/models/expense_category.dart';

Expense _expense({String category = 'groceries', String? groundId}) {
  final now = DateTime(2026, 6, 19);
  return Expense(
    id: 'e-1',
    category: category,
    description: 'Test expense',
    amount: 50000,
    date: now,
    groundId: groundId,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

void main() {
  group('Expense', () {
    test('isUncategorized is true for "other" and "uncategorized"', () {
      expect(_expense(category: 'other').isUncategorized, isTrue);
      expect(_expense(category: 'uncategorized').isUncategorized, isTrue);
      expect(_expense(category: 'groceries').isUncategorized, isFalse);
    });

    test('hasGround is true when groundId is set', () {
      expect(_expense(groundId: 'g-1').hasGround, isTrue);
      expect(_expense(groundId: null).hasGround, isFalse);
      expect(_expense(groundId: '').hasGround, isFalse);
    });

    test('round-trips through JSON', () {
      final expense = _expense(category: 'maintenance', groundId: 'g-1');
      final restored = Expense.fromJson(expense.toJson());
      expect(restored, equals(expense));
    });
  });

  group('ExpenseCategory', () {
    test('fromString maps known values correctly', () {
      expect(
        ExpenseCategory.fromString('utilities'),
        ExpenseCategory.utilities,
      );
      expect(
        ExpenseCategory.fromString('maintenance'),
        ExpenseCategory.maintenance,
      );
      expect(
        ExpenseCategory.fromString('groceries'),
        ExpenseCategory.groceries,
      );
      expect(ExpenseCategory.fromString('school'), ExpenseCategory.school);
      expect(ExpenseCategory.fromString('savings'), ExpenseCategory.savings);
      expect(
        ExpenseCategory.fromString('uncategorized'),
        ExpenseCategory.uncategorized,
      );
    });

    test('fromString falls back to uncategorized for unknown values', () {
      expect(
        ExpenseCategory.fromString('unknown'),
        ExpenseCategory.uncategorized,
      );
      expect(ExpenseCategory.fromString(''), ExpenseCategory.uncategorized);
    });

    test('covers 14 categories, each with a label and icon', () {
      expect(ExpenseCategory.values.length, 14);
      for (final category in ExpenseCategory.values) {
        expect(category.label, isNotEmpty);
        expect(category.value, isNotEmpty);
        expect(category.icon, isA<IconData>());
      }
    });
  });
}
