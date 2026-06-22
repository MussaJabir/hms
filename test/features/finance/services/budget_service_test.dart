import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/features/finance/services/budget_service.dart';
import 'package:hms/features/finance/services/expense_service.dart';

const _userId = 'user-1';

String _iso(DateTime d) => d.toIso8601String();

Future<void> _seedExpense(
  FakeFirebaseFirestore fake, {
  required String category,
  required DateTime date,
  required double amount,
}) async {
  await fake.collection(ExpenseService.collection).add({
    'category': category,
    'description': 'x',
    'amount': amount,
    'date': _iso(date),
    'isAutoLinked': false,
    'notes': '',
    'createdAt': _iso(date),
    'updatedAt': _iso(date),
    'updatedBy': _userId,
    'schemaVersion': 1,
  });
}

Future<void> _seedBudget(
  FakeFirebaseFirestore fake, {
  required String category,
  required String period,
  required double limit,
  double spent = 0,
}) async {
  final id = BudgetService.docId(category, period);
  await fake.collection(BudgetService.collection).doc(id).set({
    'category': category,
    'limitAmount': limit,
    'period': period,
    'spentAmount': spent,
    'createdAt': _iso(DateTime(2026)),
    'updatedAt': _iso(DateTime(2026)),
    'updatedBy': _userId,
    'schemaVersion': 1,
  });
}

void main() {
  late FakeFirebaseFirestore fake;
  late BudgetService service;

  setUp(() {
    fake = FakeFirebaseFirestore();
    final firestore = FirestoreService(firestore: fake);
    final activityLog = ActivityLogService(firestore);
    service = BudgetService(
      firestore,
      ExpenseService(firestore, activityLog),
      RecurringTransactionService(firestore, activityLog),
      activityLog,
    );
  });

  group('setBudget', () {
    test('writes to the budgets collection with deterministic id', () async {
      final id = await service.setBudget(
        category: 'groceries',
        limitAmount: 200000,
        period: '2026-03',
        userId: _userId,
      );

      expect(id, '2026-03_groceries');
      final snap = await fake
          .collection(BudgetService.collection)
          .doc(id)
          .get();
      expect(snap.exists, isTrue);
      expect(snap.data()!['limitAmount'], 200000);
      expect(snap.data()!['category'], 'groceries');
    });

    test('updating preserves the existing spentAmount', () async {
      await _seedBudget(
        fake,
        category: 'groceries',
        period: '2026-03',
        limit: 100000,
        spent: 45000,
      );

      await service.setBudget(
        category: 'groceries',
        limitAmount: 250000,
        period: '2026-03',
        userId: _userId,
      );

      final budget = await service.getBudget('groceries', '2026-03');
      expect(budget!.limitAmount, 250000);
      expect(budget.spentAmount, 45000);
    });
  });

  group('recalculateSpent', () {
    test('sums matching expenses into each budget', () async {
      const period = '2026-03';
      final d = DateTime(2026, 3, 10);
      await _seedBudget(
        fake,
        category: 'groceries',
        period: period,
        limit: 100000,
      );
      await _seedBudget(
        fake,
        category: 'transport',
        period: period,
        limit: 50000,
      );
      await _seedExpense(fake, category: 'groceries', date: d, amount: 30000);
      await _seedExpense(fake, category: 'groceries', date: d, amount: 20000);
      await _seedExpense(fake, category: 'transport', date: d, amount: 15000);
      // Different month — ignored.
      await _seedExpense(
        fake,
        category: 'groceries',
        date: DateTime(2026, 2, 10),
        amount: 99000,
      );

      await service.recalculateSpent(period, _userId);

      expect(
        (await service.getBudget('groceries', period))!.spentAmount,
        50000,
      );
      expect(
        (await service.getBudget('transport', period))!.spentAmount,
        15000,
      );
    });
  });

  group('copyFromPreviousMonth', () {
    test('creates new budgets with the previous month limits', () async {
      await _seedBudget(
        fake,
        category: 'groceries',
        period: '2026-02',
        limit: 100000,
      );
      await _seedBudget(
        fake,
        category: 'transport',
        period: '2026-02',
        limit: 40000,
      );

      final created = await service.copyFromPreviousMonth(
        currentPeriod: '2026-03',
        userId: _userId,
      );

      expect(created, 2);
      final budgets = await service.getBudgetsForPeriod('2026-03');
      expect(
        budgets.map((b) => b.category),
        containsAll(['groceries', 'transport']),
      );
      expect(
        budgets.firstWhere((b) => b.category == 'groceries').limitAmount,
        100000,
      );
    });

    test('does not overwrite existing budgets in the current month', () async {
      await _seedBudget(
        fake,
        category: 'groceries',
        period: '2026-02',
        limit: 100000,
      );
      await _seedBudget(
        fake,
        category: 'groceries',
        period: '2026-03',
        limit: 999999,
      );

      final created = await service.copyFromPreviousMonth(
        currentPeriod: '2026-03',
        userId: _userId,
      );

      expect(created, 0);
      final budget = await service.getBudget('groceries', '2026-03');
      expect(budget!.limitAmount, 999999);
    });
  });

  group('warning / over queries', () {
    setUp(() async {
      const period = '2026-03';
      await _seedBudget(
        fake,
        category: 'groceries',
        period: period,
        limit: 100000,
        spent: 50000, // 50% — on track
      );
      await _seedBudget(
        fake,
        category: 'transport',
        period: period,
        limit: 100000,
        spent: 85000, // 85% — near limit
      );
      await _seedBudget(
        fake,
        category: 'food',
        period: period,
        limit: 100000,
        spent: 120000, // 120% — over
      );
    });

    test('getWarningBudgets returns only 80%+ budgets', () async {
      final warning = await service.getWarningBudgets('2026-03');
      final cats = warning.map((b) => b.category).toSet();
      expect(cats, {'transport', 'food'});
    });

    test('getOverBudgets returns only 100%+ budgets', () async {
      final over = await service.getOverBudgets('2026-03');
      expect(over.map((b) => b.category), ['food']);
    });
  });

  group('getBudgetComplianceScore', () {
    test('is the share of on-track categories', () async {
      const period = '2026-03';
      // 2 of 4 on track → 50.
      await _seedBudget(
        fake,
        category: 'groceries',
        period: period,
        limit: 100000,
        spent: 10000,
      );
      await _seedBudget(
        fake,
        category: 'transport',
        period: period,
        limit: 100000,
        spent: 20000,
      );
      await _seedBudget(
        fake,
        category: 'food',
        period: period,
        limit: 100000,
        spent: 90000,
      );
      await _seedBudget(
        fake,
        category: 'health',
        period: period,
        limit: 100000,
        spent: 130000,
      );

      expect(await service.getBudgetComplianceScore(period), 50);
    });

    test('is 100 when no budgets are set', () async {
      expect(await service.getBudgetComplianceScore('2026-03'), 100);
    });
  });

  group('totals', () {
    test('getTotalLimit and getTotalSpent sum across categories', () async {
      const period = '2026-03';
      await _seedBudget(
        fake,
        category: 'groceries',
        period: period,
        limit: 100000,
        spent: 30000,
      );
      await _seedBudget(
        fake,
        category: 'transport',
        period: period,
        limit: 50000,
        spent: 20000,
      );

      expect(await service.getTotalLimit(period), 150000);
      expect(await service.getTotalSpent(period), 50000);
    });
  });
}
