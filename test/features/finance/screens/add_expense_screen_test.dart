import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/finance/providers/expense_providers.dart';
import 'package:hms/features/finance/screens/add_expense_screen.dart';
import 'package:hms/features/finance/services/expense_service.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';

Widget _wrap() {
  final fake = FakeFirebaseFirestore();
  final firestore = FirestoreService(firestore: fake);
  final service = ExpenseService(firestore, ActivityLogService(firestore));

  return ProviderScope(
    overrides: [
      expenseServiceProvider.overrideWithValue(service),
      authStateProvider.overrideWith((ref) => const Stream.empty()),
      allGroundsProvider.overrideWith((ref) => const Stream.empty()),
    ],
    child: const MaterialApp(home: AddExpenseScreen()),
  );
}

void main() {
  group('AddExpenseScreen', () {
    testWidgets('renders all form fields', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.text('Category'), findsOneWidget);
      expect(find.text('Amount (TZS)'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Date'), findsOneWidget);
      expect(find.text('Ground (optional)'), findsOneWidget);
      expect(find.text('Notes (optional)'), findsOneWidget);
      expect(find.text('Save Expense'), findsOneWidget);
    });

    testWidgets('amount field has autofocus', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      // The autofocused amount field should hold primary focus after build.
      final focused = tester
          .widgetList<EditableText>(find.byType(EditableText))
          .where((w) => w.focusNode.hasPrimaryFocus);
      expect(focused, isNotEmpty);
    });

    testWidgets('"Add Another" keeps the screen open after saving', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      // Fill the minimum required fields: amount + description.
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Amount (TZS)'),
        '15000',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Description'),
        'Weekly groceries',
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      await tester.ensureVisible(find.text('Save Expense'));
      await tester.tap(find.text('Save Expense'));
      await tester.pumpAndSettle();

      // Post-save prompt appears; choose "Add Another".
      expect(find.text('Expense saved'), findsOneWidget);
      await tester.tap(find.text('Add Another'));
      await tester.pumpAndSettle();

      // Still on the add screen, with the entry fields cleared.
      expect(find.text('Save Expense'), findsOneWidget);
      expect(find.text('Weekly groceries'), findsNothing);
    });
  });
}
