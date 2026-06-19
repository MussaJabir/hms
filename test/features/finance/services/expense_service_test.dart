import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/finance/models/expense.dart';
import 'package:hms/features/finance/services/expense_service.dart';

const _userId = 'user-1';

String _iso(DateTime d) => d.toIso8601String();

/// Seeds an expense doc directly with ISO string timestamps
/// (FakeFirebaseFirestore would otherwise return server Timestamps that break
/// fromJson).
Future<String> _seed(
  FakeFirebaseFirestore fake, {
  required String category,
  required DateTime date,
  double amount = 50000,
  String? groundId,
  bool isAutoLinked = false,
  String description = 'Expense',
}) async {
  final ref = fake.collection(ExpenseService.collection).doc();
  await ref.set({
    'category': category,
    'description': description,
    'amount': amount,
    'date': _iso(date),
    'groundId': ?groundId,
    'isAutoLinked': isAutoLinked,
    'notes': '',
    'createdAt': _iso(date),
    'updatedAt': _iso(date),
    'updatedBy': _userId,
    'schemaVersion': 1,
  });
  return ref.id;
}

Expense _expense({
  String category = 'groceries',
  double amount = 50000,
  String? groundId,
}) {
  final now = DateTime.now();
  return Expense(
    id: '',
    category: category,
    description: 'Manual expense',
    amount: amount,
    date: now,
    groundId: groundId,
    createdAt: now,
    updatedAt: now,
    updatedBy: _userId,
  );
}

void main() {
  late FakeFirebaseFirestore fake;
  late ExpenseService service;

  setUp(() {
    fake = FakeFirebaseFirestore();
    final firestore = FirestoreService(firestore: fake);
    service = ExpenseService(firestore, ActivityLogService(firestore));
  });

  group('createExpense', () {
    test('writes to the expenses collection', () async {
      final id = await service.createExpense(
        expense: _expense(amount: 75000),
        userId: _userId,
      );

      final snap = await fake
          .collection(ExpenseService.collection)
          .doc(id)
          .get();
      expect(snap.exists, isTrue);
      expect(snap.data()!['category'], 'groceries');
      expect(snap.data()!['amount'], 75000);
      expect(snap.data()!['isAutoLinked'], false);
    });
  });

  group('getCurrentMonthTotal', () {
    test('sums amounts for the current month only', () async {
      final now = DateTime.now();
      final lastMonth = DateTime(now.year, now.month - 1, 15);
      await _seed(fake, category: 'groceries', date: now, amount: 30000);
      await _seed(fake, category: 'transport', date: now, amount: 20000);
      await _seed(fake, category: 'food', date: lastMonth, amount: 99000);

      final total = await service.getCurrentMonthTotal();
      expect(total, 50000);
    });

    test('scopes the total to a ground when provided', () async {
      final now = DateTime.now();
      await _seed(
        fake,
        category: 'maintenance',
        date: now,
        amount: 30000,
        groundId: 'g-1',
      );
      await _seed(
        fake,
        category: 'maintenance',
        date: now,
        amount: 20000,
        groundId: 'g-2',
      );

      final total = await service.getCurrentMonthTotal(groundId: 'g-1');
      expect(total, 30000);
    });
  });

  group('getExpensesByCategoryForPeriod', () {
    test('groups amounts by category for the period', () async {
      const period = '2026-05';
      final d = DateTime(2026, 5, 10);
      await _seed(fake, category: 'groceries', date: d, amount: 10000);
      await _seed(fake, category: 'groceries', date: d, amount: 5000);
      await _seed(fake, category: 'transport', date: d, amount: 40000);
      // Different month — excluded.
      await _seed(
        fake,
        category: 'food',
        date: DateTime(2026, 4, 10),
        amount: 99000,
      );

      final grouped = await service.getExpensesByCategoryForPeriod(period);
      expect(grouped['groceries'], 15000);
      expect(grouped['transport'], 40000);
      expect(grouped.containsKey('food'), isFalse);
    });
  });

  group('getTopCategories', () {
    test('returns the top N categories sorted by amount', () async {
      const period = '2026-05';
      final d = DateTime(2026, 5, 10);
      await _seed(fake, category: 'groceries', date: d, amount: 10000);
      await _seed(fake, category: 'transport', date: d, amount: 50000);
      await _seed(fake, category: 'food', date: d, amount: 30000);
      await _seed(fake, category: 'health', date: d, amount: 5000);

      final top = await service.getTopCategories(period, top: 2);
      expect(top.length, 2);
      expect(top[0].key, 'transport');
      expect(top[0].value, 50000);
      expect(top[1].key, 'food');
    });
  });

  group('getExpensesByGround', () {
    test('returns only expenses for the requested ground', () async {
      final now = DateTime.now();
      await _seed(fake, category: 'maintenance', date: now, groundId: 'g-1');
      await _seed(fake, category: 'utilities', date: now, groundId: 'g-1');
      await _seed(fake, category: 'food', date: now, groundId: 'g-2');

      final expenses = await service.getExpensesByGround('g-1');
      expect(expenses.length, 2);
      expect(expenses.every((e) => e.groundId == 'g-1'), isTrue);
    });
  });

  group('auto-linked protection', () {
    test('updateExpense rejects auto-linked entries', () async {
      final id = await _seed(
        fake,
        category: 'utilities',
        date: DateTime.now(),
        isAutoLinked: true,
      );

      expect(
        () => service.updateExpense(
          expenseId: id,
          updates: {'amount': 1},
          userId: _userId,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('deleteExpense rejects auto-linked entries', () async {
      final id = await _seed(
        fake,
        category: 'utilities',
        date: DateTime.now(),
        isAutoLinked: true,
      );

      expect(
        () => service.deleteExpense(expenseId: id, userId: _userId),
        throwsA(isA<Exception>()),
      );
    });

    test('updateExpense allows manual entries', () async {
      final id = await _seed(fake, category: 'groceries', date: DateTime.now());

      await service.updateExpense(
        expenseId: id,
        updates: {'amount': 12345},
        userId: _userId,
      );

      final snap = await fake
          .collection(ExpenseService.collection)
          .doc(id)
          .get();
      expect(snap.data()!['amount'], 12345);
    });
  });

  group('createAutoLinkedExpense', () {
    test('sets isAutoLinked=true and records the module', () async {
      final id = await service.createAutoLinkedExpense(
        category: 'utilities',
        description: 'Water bill — June',
        amount: 18000,
        date: DateTime.now(),
        module: 'water',
        linkedDocumentId: 'bill-1',
        groundId: 'g-1',
        userId: _userId,
      );

      final snap = await fake
          .collection(ExpenseService.collection)
          .doc(id)
          .get();
      expect(snap.data()!['isAutoLinked'], true);
      expect(snap.data()!['module'], 'water');
      expect(snap.data()!['linkedDocumentId'], 'bill-1');
      expect(snap.data()!['groundId'], 'g-1');
    });
  });
}
