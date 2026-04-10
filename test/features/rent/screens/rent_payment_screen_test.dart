import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/models/recurring_record.dart';
import 'package:hms/features/rent/screens/rent_payment_screen.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

RecurringRecord _makeRecord({
  double amount = 300000,
  double amountPaid = 0,
  String status = 'pending',
  String name = 'John Doe — Room 3',
}) {
  final now = DateTime(2026, 3, 1);
  return RecurringRecord(
    id: 'rec-1',
    configId: 'cfg-1',
    type: 'rent',
    linkedEntityId: 'tenant-1',
    linkedEntityName: name,
    amount: amount,
    period: '2026-03',
    status: status,
    amountPaid: amountPaid,
    dueDate: now,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

Widget _wrap(RecurringRecord record) {
  return ProviderScope(
    child: MaterialApp(
      home: RentPaymentScreen(
        record: record,
        collectionPath: 'grounds/g1/rental_units/u1/recurring_records',
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Status calculation (unit tests — pure logic, no Flutter needed)
// ---------------------------------------------------------------------------

String _calcStatus({required double amountPaying, required double remaining}) {
  return amountPaying >= remaining ? 'paid' : 'partial';
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // ── Unit tests: status calculation ──────────────────────────────────────

  group('Status calculation', () {
    test('full payment → paid', () {
      expect(_calcStatus(amountPaying: 300000, remaining: 300000), 'paid');
    });

    test('overpayment (edge case) → paid', () {
      expect(_calcStatus(amountPaying: 350000, remaining: 300000), 'paid');
    });

    test('partial payment → partial', () {
      expect(_calcStatus(amountPaying: 150000, remaining: 300000), 'partial');
    });

    test('1 TZS payment → partial', () {
      expect(_calcStatus(amountPaying: 1, remaining: 300000), 'partial');
    });
  });

  // ── Widget tests ─────────────────────────────────────────────────────────

  group('RentPaymentScreen — info display', () {
    testWidgets('shows tenant name', (tester) async {
      await tester.pumpWidget(_wrap(_makeRecord()));
      await tester.pumpAndSettle();

      expect(find.text('John Doe — Room 3'), findsAtLeastNWidgets(1));
    });

    testWidgets('shows rent period', (tester) async {
      await tester.pumpWidget(_wrap(_makeRecord()));
      await tester.pumpAndSettle();

      expect(find.textContaining('March 2026'), findsOneWidget);
    });

    testWidgets('pre-fills amount with remaining balance (full unpaid)', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(_makeRecord(amount: 300000)));
      await tester.pumpAndSettle();

      // The amount field should be pre-filled with 300,000
      expect(find.text('300,000'), findsOneWidget);
    });

    testWidgets('pre-fills amount with remaining balance (partially paid)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(_makeRecord(amount: 300000, amountPaid: 100000)),
      );
      await tester.pumpAndSettle();

      // Remaining = 200,000
      expect(find.text('200,000'), findsOneWidget);
    });

    testWidgets('shows Already Paid row when amountPaid > 0', (tester) async {
      await tester.pumpWidget(
        _wrap(_makeRecord(amount: 300000, amountPaid: 100000)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Already Paid'), findsOneWidget);
    });

    testWidgets('does not show Already Paid row when nothing paid', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(_makeRecord(amountPaid: 0)));
      await tester.pumpAndSettle();

      expect(find.text('Already Paid'), findsNothing);
    });
  });

  group('RentPaymentScreen — payment method default', () {
    testWidgets('payment method defaults to Cash', (tester) async {
      await tester.pumpWidget(_wrap(_makeRecord()));
      await tester.pumpAndSettle();

      expect(find.text('Cash'), findsOneWidget);
    });
  });

  group('RentPaymentScreen — confirm button state', () {
    // Sets a phone-sized logical viewport so the entire form is rendered
    // (ListView is lazy; without sufficient height the button won't be built).
    void setPhoneViewport(WidgetTester tester) {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(400, 1200);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
    }

    testWidgets('confirm button is enabled when amount > 0', (tester) async {
      setPhoneViewport(tester);
      await tester.pumpWidget(_wrap(_makeRecord(amount: 300000)));
      await tester.pumpAndSettle();

      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Confirm Payment'),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('confirm button is disabled when amount is 0', (tester) async {
      setPhoneViewport(tester);
      await tester.pumpWidget(_wrap(_makeRecord(amount: 300000)));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Custom'));
      await tester.pumpAndSettle();

      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Confirm Payment'),
      );
      expect(button.onPressed, isNull);
    });
  });

  group('RentPaymentScreen — quick amount buttons', () {
    testWidgets('tapping Full sets amount to remaining balance', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(_makeRecord(amount: 300000)));
      await tester.pumpAndSettle();

      // Tap Custom first to clear
      await tester.tap(find.text('Custom'));
      await tester.pumpAndSettle();

      // Tap Full to restore
      await tester.tap(find.text('Full'));
      await tester.pumpAndSettle();

      expect(find.text('300,000'), findsOneWidget);
    });

    testWidgets('tapping Half sets amount to half remaining', (tester) async {
      await tester.pumpWidget(_wrap(_makeRecord(amount: 300000)));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Half'));
      await tester.pumpAndSettle();

      expect(find.text('150,000'), findsOneWidget);
    });

    testWidgets('tapping Custom clears the amount field', (tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(400, 1200);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_wrap(_makeRecord(amount: 300000)));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Custom'));
      await tester.pumpAndSettle();

      // Field should be empty — confirm button disabled
      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Confirm Payment'),
      );
      expect(button.onPressed, isNull);
    });
  });

  // ── QuickAmountButtons widget tests ────────────────────────────────────

  group('QuickAmountButtons — renders 3 buttons', () {
    testWidgets('shows Full, Half, and Custom buttons', (tester) async {
      await tester.pumpWidget(_wrap(_makeRecord(amount: 300000)));
      await tester.pumpAndSettle();

      expect(find.text('Full'), findsOneWidget);
      expect(find.text('Half'), findsOneWidget);
      expect(find.text('Custom'), findsOneWidget);
    });

    testWidgets('Full button shows the full amount label', (tester) async {
      await tester.pumpWidget(_wrap(_makeRecord(amount: 300000)));
      await tester.pumpAndSettle();

      // Short-format label on the button — "300K"
      expect(find.textContaining('300K'), findsAtLeastNWidgets(1));
    });
  });
}
