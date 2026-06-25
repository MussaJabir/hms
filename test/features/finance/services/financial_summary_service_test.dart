import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/finance/services/budget_service.dart';
import 'package:hms/features/finance/services/expense_service.dart';
import 'package:hms/features/finance/services/financial_summary_service.dart';
import 'package:hms/features/finance/services/income_service.dart';
import 'package:hms/features/grounds/services/ground_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';

const _userId = 'user-1';

String _iso(DateTime d) => d.toIso8601String();

Future<void> _seedIncome(
  FakeFirebaseFirestore fake, {
  required String source,
  required DateTime date,
  required double amount,
  String? groundId,
}) async {
  await fake.collection(IncomeService.collection).add({
    'source': source,
    'description': 'x',
    'amount': amount,
    'date': _iso(date),
    'groundId': ?groundId,
    'isAutoLinked': false,
    'notes': '',
    'createdAt': _iso(date),
    'updatedAt': _iso(date),
    'updatedBy': _userId,
    'schemaVersion': 1,
  });
}

Future<void> _seedExpense(
  FakeFirebaseFirestore fake, {
  required String category,
  required DateTime date,
  required double amount,
  String? groundId,
}) async {
  await fake.collection(ExpenseService.collection).add({
    'category': category,
    'description': 'x',
    'amount': amount,
    'date': _iso(date),
    'groundId': ?groundId,
    'isAutoLinked': false,
    'notes': '',
    'createdAt': _iso(date),
    'updatedAt': _iso(date),
    'updatedBy': _userId,
    'schemaVersion': 1,
  });
}

Future<void> _seedGround(
  FakeFirebaseFirestore fake,
  String id,
  String name,
) async {
  await fake.collection('grounds').doc(id).set({
    'name': name,
    'location': 'Dar',
    'numberOfUnits': 5,
    'createdAt': _iso(DateTime(2026)),
    'updatedAt': _iso(DateTime(2026)),
    'updatedBy': _userId,
    'schemaVersion': 1,
  });
}

String _currentPeriod() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}';
}

void main() {
  late FakeFirebaseFirestore fake;
  late FinancialSummaryService service;

  setUp(() {
    fake = FakeFirebaseFirestore();
    final firestore = FirestoreService(firestore: fake);
    final activityLog = ActivityLogService(firestore);
    final income = IncomeService(firestore, activityLog);
    final expense = ExpenseService(firestore, activityLog);
    final budget = BudgetService(
      firestore,
      expense,
      RecurringTransactionService(firestore, activityLog),
      activityLog,
    );
    final ground = GroundService(firestore, activityLog);
    service = FinancialSummaryService(income, expense, budget, ground);
  });

  group('getNetPosition', () {
    test('combines income and expense totals for the period', () async {
      final now = DateTime.now();
      await _seedIncome(fake, source: 'salary', date: now, amount: 800000);
      await _seedExpense(
        fake,
        category: 'groceries',
        date: now,
        amount: 300000,
      );

      final net = await service.getNetPosition(_currentPeriod());
      expect(net, 500000);
    });
  });

  group('getSummary', () {
    test('aggregates income, expenses, and breakdowns', () async {
      final now = DateTime.now();
      await _seedIncome(fake, source: 'rent', date: now, amount: 500000);
      await _seedIncome(fake, source: 'salary', date: now, amount: 200000);
      await _seedExpense(
        fake,
        category: 'groceries',
        date: now,
        amount: 120000,
      );

      final summary = await service.getSummary(_currentPeriod());
      expect(summary.totalIncome, 700000);
      expect(summary.rentIncome, 500000);
      expect(summary.otherIncome, 200000);
      expect(summary.totalExpenses, 120000);
      expect(summary.incomeBySource['salary'], 200000);
    });
  });

  group('getPerGroundComparison', () {
    test('returns one entry per ground with its income and expenses', () async {
      final now = DateTime.now();
      await _seedGround(fake, 'g-1', 'Main');
      await _seedGround(fake, 'g-2', 'Minor');
      await _seedIncome(
        fake,
        source: 'rent',
        date: now,
        amount: 400000,
        groundId: 'g-1',
      );
      await _seedExpense(
        fake,
        category: 'maintenance',
        date: now,
        amount: 100000,
        groundId: 'g-1',
      );
      await _seedIncome(
        fake,
        source: 'rent',
        date: now,
        amount: 250000,
        groundId: 'g-2',
      );

      final comparison = await service.getPerGroundComparison(_currentPeriod());
      expect(comparison, hasLength(2));
      final main = comparison.firstWhere((c) => c.groundId == 'g-1');
      expect(main.income, 400000);
      expect(main.expenses, 100000);
      expect(main.netPosition, 300000);
      final minor = comparison.firstWhere((c) => c.groundId == 'g-2');
      expect(minor.income, 250000);
      expect(minor.expenses, 0);
    });
  });

  group('getMonthlyTrends', () {
    test('returns the requested number of months', () async {
      final trends = await service.getMonthlyTrends(months: 6);
      expect(trends, hasLength(6));
      // Oldest first, current month last.
      expect(trends.last.period, _currentPeriod());
    });

    test('places income in the correct month bucket', () async {
      final now = DateTime.now();
      await _seedIncome(fake, source: 'salary', date: now, amount: 90000);

      final trends = await service.getMonthlyTrends(months: 3);
      expect(trends, hasLength(3));
      expect(trends.last.income, 90000);
      expect(trends.first.income, 0);
    });
  });
}
