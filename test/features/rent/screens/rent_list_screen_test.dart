import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/models/recurring_record.dart';
import 'package:hms/features/rent/providers/rent_generation_providers.dart';
import 'package:hms/features/rent/screens/rent_list_screen.dart';
import 'package:intl/intl.dart';

String _monthYearLabel(DateTime date) => DateFormat('MMMM yyyy').format(date);

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

RecurringRecord _makeRecord({
  required String id,
  required String name,
  String status = 'pending',
  double amount = 300000,
  double amountPaid = 0,
}) {
  final now = DateTime(2026, 4, 1);
  return RecurringRecord(
    id: id,
    configId: 'cfg-$id',
    type: 'rent',
    linkedEntityId: 'tenant-$id',
    linkedEntityName: name,
    amount: amount,
    period: '2026-04',
    status: status,
    amountPaid: amountPaid,
    dueDate: now,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

/// Builds the current and previous period strings relative to [date].
({String current, String previous}) _periods(DateTime date) {
  final prev = DateTime(date.year, date.month - 1, 1);
  String fmt(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}';
  return (current: fmt(date), previous: fmt(prev));
}

Widget _wrap({
  required List<RecurringRecord> records,
  List<RecurringRecord> prevMonthRecords = const [],
  bool isGenerated = true,
}) {
  final now = DateTime.now();
  final p = _periods(now);

  final router = GoRouter(
    initialLocation: '/rent',
    routes: [
      GoRoute(path: '/rent', builder: (ctx, st) => const RentListScreen()),
    ],
  );

  return ProviderScope(
    overrides: [
      rentRecordsForPeriodProvider(
        p.current,
      ).overrideWith((ref) async => records),
      rentRecordsForPeriodProvider(
        p.previous,
      ).overrideWith((ref) async => prevMonthRecords),
      isCurrentMonthGeneratedProvider.overrideWith((ref) async => isGenerated),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('RentListScreen — empty state', () {
    testWidgets('shows empty state when no records', (tester) async {
      await tester.pumpWidget(_wrap(records: []));
      await tester.pumpAndSettle();

      expect(find.text('No Rent Records'), findsOneWidget);
    });
  });

  group('RentListScreen — rent cards', () {
    testWidgets('shows tenant name and status badge', (tester) async {
      final records = [
        _makeRecord(id: '1', name: 'John Doe — Room 1', status: 'paid'),
        _makeRecord(id: '2', name: 'Fatuma Ali — Room 2', status: 'pending'),
      ];

      await tester.pumpWidget(_wrap(records: records));
      await tester.pumpAndSettle();

      expect(find.text('John Doe — Room 1'), findsOneWidget);
      expect(find.text('Fatuma Ali — Room 2'), findsOneWidget);
      expect(find.text('Paid'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
    });
  });

  group('RentListScreen — summary tiles', () {
    testWidgets('shows Expected, Collected, and Outstanding tiles', (
      tester,
    ) async {
      final records = [
        _makeRecord(
          id: '1',
          name: 'John Doe',
          status: 'paid',
          amount: 300000,
          amountPaid: 300000,
        ),
        _makeRecord(
          id: '2',
          name: 'Fatuma Ali',
          status: 'pending',
          amount: 200000,
        ),
      ];

      await tester.pumpWidget(_wrap(records: records));
      await tester.pumpAndSettle();

      expect(find.text('Expected'), findsOneWidget);
      expect(find.text('Collected'), findsOneWidget);
      expect(find.text('Outstanding'), findsOneWidget);
    });
  });

  group('RentListScreen — month navigation', () {
    testWidgets('shows month navigation arrows when records exist', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          records: [_makeRecord(id: '1', name: 'John Doe')],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      // chevron_right appears in both the month navigation and rent cards (AppCard showChevron)
      expect(find.byIcon(Icons.chevron_right), findsAtLeastNWidgets(1));
    });

    testWidgets('tapping previous arrow changes displayed period', (
      tester,
    ) async {
      final now = DateTime.now();
      final prevMonth = DateTime(now.year, now.month - 1, 1);
      final currentMonthName = _monthYearLabel(now);
      final prevMonthName = _monthYearLabel(prevMonth);

      final records = [_makeRecord(id: '1', name: 'John Doe')];
      await tester.pumpWidget(
        _wrap(records: records, prevMonthRecords: records),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining(currentMonthName), findsAtLeastNWidgets(1));

      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();

      expect(find.textContaining(prevMonthName), findsAtLeastNWidgets(1));
    });
  });
}
