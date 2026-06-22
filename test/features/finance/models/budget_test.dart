import 'package:flutter_test/flutter_test.dart';
import 'package:hms/features/finance/models/budget.dart';

Budget _budget({double limit = 100000, double spent = 0}) {
  final now = DateTime(2026, 3, 1);
  return Budget(
    id: '2026-03_groceries',
    category: 'groceries',
    limitAmount: limit,
    period: '2026-03',
    spentAmount: spent,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

void main() {
  group('Budget', () {
    test('remainingAmount = limit - spent', () {
      expect(_budget(limit: 100000, spent: 30000).remainingAmount, 70000);
      // Goes negative when overspent.
      expect(_budget(limit: 100000, spent: 120000).remainingAmount, -20000);
    });

    test('spentPercentage calculates correctly', () {
      expect(_budget(limit: 100000, spent: 50000).spentPercentage, 50);
      expect(_budget(limit: 200000, spent: 50000).spentPercentage, 25);
      // Zero limit guards against divide-by-zero.
      expect(_budget(limit: 0, spent: 50000).spentPercentage, 0);
    });

    test('isOnTrack is true below 80%', () {
      expect(_budget(limit: 100000, spent: 79000).isOnTrack, isTrue);
      expect(_budget(limit: 100000, spent: 80000).isOnTrack, isFalse);
    });

    test('isNearLimit is true for 80–99%', () {
      expect(_budget(limit: 100000, spent: 80000).isNearLimit, isTrue);
      expect(_budget(limit: 100000, spent: 99000).isNearLimit, isTrue);
      expect(_budget(limit: 100000, spent: 79000).isNearLimit, isFalse);
      expect(_budget(limit: 100000, spent: 100000).isNearLimit, isFalse);
    });

    test('isOverLimit is true at 100% and above', () {
      expect(_budget(limit: 100000, spent: 100000).isOverLimit, isTrue);
      expect(_budget(limit: 100000, spent: 150000).isOverLimit, isTrue);
      expect(_budget(limit: 100000, spent: 99000).isOverLimit, isFalse);
    });

    test('statusLabel returns the correct strings', () {
      expect(_budget(limit: 100000, spent: 10000).statusLabel, 'On Track');
      expect(_budget(limit: 100000, spent: 85000).statusLabel, 'Near Limit');
      expect(_budget(limit: 100000, spent: 110000).statusLabel, 'Over Budget');
    });

    test('round-trips through JSON', () {
      final budget = _budget(limit: 100000, spent: 42000);
      expect(Budget.fromJson(budget.toJson()), equals(budget));
    });
  });
}
