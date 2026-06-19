import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/finance/models/income.dart';
import 'package:hms/features/finance/services/income_service.dart';

const _userId = 'user-1';

String _iso(DateTime d) => d.toIso8601String();

/// Seeds an income doc directly with ISO string timestamps (FakeFirebaseFirestore
/// would otherwise return server Timestamps that break fromJson).
Future<String> _seed(
  FakeFirebaseFirestore fake, {
  required String source,
  required DateTime date,
  double amount = 50000,
  String? groundId,
  bool isAutoLinked = false,
  String description = 'Income',
}) async {
  final ref = fake.collection(IncomeService.collection).doc();
  await ref.set({
    'source': source,
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

Income _income({
  String source = 'freelance',
  double amount = 50000,
  String? groundId,
  bool isAutoLinked = false,
}) {
  final now = DateTime.now();
  return Income(
    id: '',
    source: source,
    description: 'Manual income',
    amount: amount,
    date: now,
    groundId: groundId,
    isAutoLinked: isAutoLinked,
    createdAt: now,
    updatedAt: now,
    updatedBy: _userId,
  );
}

void main() {
  late FakeFirebaseFirestore fake;
  late IncomeService service;

  setUp(() {
    fake = FakeFirebaseFirestore();
    final firestore = FirestoreService(firestore: fake);
    service = IncomeService(firestore, ActivityLogService(firestore));
  });

  group('createIncome', () {
    test('writes to the incomes collection', () async {
      final id = await service.createIncome(
        income: _income(amount: 75000),
        userId: _userId,
      );

      final snap = await fake
          .collection(IncomeService.collection)
          .doc(id)
          .get();
      expect(snap.exists, isTrue);
      expect(snap.data()!['source'], 'freelance');
      expect(snap.data()!['amount'], 75000);
      expect(snap.data()!['isAutoLinked'], false);
    });
  });

  group('getCurrentMonthTotal', () {
    test('sums amounts for the current month only', () async {
      final now = DateTime.now();
      final lastMonth = DateTime(now.year, now.month - 1, 15);
      await _seed(fake, source: 'freelance', date: now, amount: 30000);
      await _seed(fake, source: 'business', date: now, amount: 20000);
      await _seed(fake, source: 'gift', date: lastMonth, amount: 99000);

      final total = await service.getCurrentMonthTotal();
      expect(total, 50000);
    });

    test('scopes the total to a ground when provided', () async {
      final now = DateTime.now();
      await _seed(
        fake,
        source: 'freelance',
        date: now,
        amount: 30000,
        groundId: 'g-1',
      );
      await _seed(
        fake,
        source: 'business',
        date: now,
        amount: 20000,
        groundId: 'g-2',
      );

      final total = await service.getCurrentMonthTotal(groundId: 'g-1');
      expect(total, 30000);
    });
  });

  group('getIncomeBySourceForPeriod', () {
    test('groups amounts by source for the period', () async {
      const period = '2026-05';
      final d = DateTime(2026, 5, 10);
      await _seed(fake, source: 'freelance', date: d, amount: 10000);
      await _seed(fake, source: 'freelance', date: d, amount: 5000);
      await _seed(fake, source: 'business', date: d, amount: 40000);
      // Different month — excluded.
      await _seed(
        fake,
        source: 'gift',
        date: DateTime(2026, 4, 10),
        amount: 99000,
      );

      final grouped = await service.getIncomeBySourceForPeriod(period);
      expect(grouped['freelance'], 15000);
      expect(grouped['business'], 40000);
      expect(grouped.containsKey('gift'), isFalse);
    });
  });

  group('getIncomeByGround', () {
    test('returns only income for the requested ground', () async {
      final now = DateTime.now();
      await _seed(fake, source: 'freelance', date: now, groundId: 'g-1');
      await _seed(fake, source: 'business', date: now, groundId: 'g-1');
      await _seed(fake, source: 'gift', date: now, groundId: 'g-2');

      final income = await service.getIncomeByGround('g-1');
      expect(income.length, 2);
      expect(income.every((i) => i.groundId == 'g-1'), isTrue);
    });
  });

  group('auto-linked protection', () {
    test('updateIncome rejects auto-linked entries', () async {
      final id = await _seed(
        fake,
        source: 'rent',
        date: DateTime.now(),
        isAutoLinked: true,
      );

      expect(
        () => service.updateIncome(
          incomeId: id,
          updates: {'amount': 1},
          userId: _userId,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('deleteIncome rejects auto-linked entries', () async {
      final id = await _seed(
        fake,
        source: 'rent',
        date: DateTime.now(),
        isAutoLinked: true,
      );

      expect(
        () => service.deleteIncome(incomeId: id, userId: _userId),
        throwsA(isA<Exception>()),
      );
    });

    test('updateIncome allows manual entries', () async {
      final id = await _seed(fake, source: 'freelance', date: DateTime.now());

      await service.updateIncome(
        incomeId: id,
        updates: {'amount': 12345},
        userId: _userId,
      );

      final snap = await fake
          .collection(IncomeService.collection)
          .doc(id)
          .get();
      expect(snap.data()!['amount'], 12345);
    });

    test('deleteIncome allows manual entries', () async {
      final id = await _seed(fake, source: 'freelance', date: DateTime.now());

      await service.deleteIncome(incomeId: id, userId: _userId);

      final snap = await fake
          .collection(IncomeService.collection)
          .doc(id)
          .get();
      expect(snap.exists, isFalse);
    });
  });
}
