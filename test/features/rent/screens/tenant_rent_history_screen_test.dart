import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/models/recurring_record.dart';
import 'package:hms/features/rent/providers/rent_history_providers.dart';
import 'package:hms/features/rent/screens/tenant_rent_history_screen.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

RecurringRecord _makeRecord({
  required String id,
  String period = '2026-03',
  String status = 'pending',
  double amount = 300000,
  double amountPaid = 0,
  DateTime? paidDate,
}) {
  final now = DateTime(2026, 3, 1);
  return RecurringRecord(
    id: id,
    configId: 'cfg-1',
    type: 'rent',
    linkedEntityId: 'tenant-1',
    linkedEntityName: 'John Doe — Room 3',
    amount: amount,
    period: period,
    status: status,
    amountPaid: amountPaid,
    paidDate: paidDate,
    dueDate: now,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

Widget _wrap({
  required List<RecurringRecord> records,
  String tenantName = 'John Doe',
}) {
  return ProviderScope(
    overrides: [
      tenantHistoryProvider(
        'g1',
        'u1',
        'tenant-1',
      ).overrideWith((ref) => Stream.value(records)),
    ],
    child: MaterialApp(
      home: TenantRentHistoryScreen(
        groundId: 'g1',
        unitId: 'u1',
        tenantId: 'tenant-1',
        tenantName: tenantName,
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('TenantRentHistoryScreen — empty state', () {
    testWidgets('shows empty state when no history', (tester) async {
      await tester.pumpWidget(_wrap(records: []));
      await tester.pumpAndSettle();

      expect(find.text('No Payment History'), findsOneWidget);
    });
  });

  group('TenantRentHistoryScreen — summary tiles', () {
    testWidgets('shows Total Paid, Paid Months, Outstanding tiles', (
      tester,
    ) async {
      final records = [
        _makeRecord(
          id: 'r1',
          status: 'paid',
          amount: 300000,
          amountPaid: 300000,
          period: '2026-03',
        ),
        _makeRecord(
          id: 'r2',
          status: 'pending',
          amount: 300000,
          amountPaid: 0,
          period: '2026-02',
        ),
      ];

      await tester.pumpWidget(_wrap(records: records));
      await tester.pumpAndSettle();

      expect(find.text('Total Paid'), findsOneWidget);
      expect(find.text('Paid Months'), findsOneWidget);
      expect(find.text('Outstanding'), findsOneWidget);
    });
  });

  group('TenantRentHistoryScreen — payment cards', () {
    testWidgets('renders a card per payment record', (tester) async {
      final records = [
        _makeRecord(id: 'r1', period: '2026-03', status: 'paid'),
        _makeRecord(id: 'r2', period: '2026-02', status: 'pending'),
        _makeRecord(id: 'r3', period: '2026-01', status: 'overdue'),
      ];

      await tester.pumpWidget(_wrap(records: records));
      await tester.pumpAndSettle();

      expect(find.text('March 2026'), findsOneWidget);
      expect(find.text('February 2026'), findsOneWidget);
      expect(find.text('January 2026'), findsOneWidget);
    });

    testWidgets('groups records under a year header', (tester) async {
      final records = [
        _makeRecord(id: 'r1', period: '2026-03', status: 'paid'),
        _makeRecord(id: 'r2', period: '2025-12', status: 'paid'),
      ];

      await tester.pumpWidget(_wrap(records: records));
      await tester.pumpAndSettle();

      expect(find.text('2026'), findsOneWidget);
      expect(find.text('2025'), findsOneWidget);
    });
  });

  group('TenantRentHistoryScreen — status badges', () {
    testWidgets('shows Paid badge for a paid record', (tester) async {
      final records = [
        _makeRecord(id: 'r1', status: 'paid', amountPaid: 300000),
      ];

      await tester.pumpWidget(_wrap(records: records));
      await tester.pumpAndSettle();

      expect(find.text('Paid'), findsOneWidget);
    });

    testWidgets('shows Pending badge for a pending record', (tester) async {
      final records = [_makeRecord(id: 'r1', status: 'pending')];

      await tester.pumpWidget(_wrap(records: records));
      await tester.pumpAndSettle();

      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('shows Overdue badge for an overdue record', (tester) async {
      final records = [_makeRecord(id: 'r1', status: 'overdue')];

      await tester.pumpWidget(_wrap(records: records));
      await tester.pumpAndSettle();

      expect(find.text('Overdue'), findsOneWidget);
    });
  });

  group('TenantRentHistoryScreen — tenant name subtitle', () {
    testWidgets('shows tenant name when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          records: [_makeRecord(id: 'r1', status: 'paid')],
          tenantName: 'Jane Smith',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Jane Smith'), findsOneWidget);
    });
  });
}
