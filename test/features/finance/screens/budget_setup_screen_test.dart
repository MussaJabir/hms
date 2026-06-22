import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/features/finance/models/expense_category.dart';
import 'package:hms/features/finance/providers/budget_providers.dart';
import 'package:hms/features/finance/screens/budget_setup_screen.dart';
import 'package:hms/features/finance/services/budget_service.dart';
import 'package:hms/features/finance/services/expense_service.dart';

String _currentPeriod() {
  final now = DateTime.now();
  final mm = now.month.toString().padLeft(2, '0');
  return '${now.year}-$mm';
}

late FakeFirebaseFirestore _fake;
late BudgetService _service;

Widget _wrap() {
  _fake = FakeFirebaseFirestore();
  final firestore = FirestoreService(firestore: _fake);
  final activityLog = ActivityLogService(firestore);
  _service = BudgetService(
    firestore,
    ExpenseService(firestore, activityLog),
    RecurringTransactionService(firestore, activityLog),
    activityLog,
  );

  final router = GoRouter(
    initialLocation: '/setup',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const Scaffold()),
      GoRoute(
        path: '/setup',
        builder: (context, state) => const BudgetSetupScreen(),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      budgetServiceProvider.overrideWithValue(_service),
      authStateProvider.overrideWith((ref) => const Stream.empty()),
    ],
    child: MaterialApp.router(
      theme: ThemeData(splashFactory: NoSplash.splashFactory),
      routerConfig: router,
    ),
  );
}

void main() {
  group('BudgetSetupScreen', () {
    testWidgets('lists every category with an amount field', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump(); // resolve prefill post-frame
      await tester.pump();

      for (final c in ExpenseCategory.values) {
        expect(find.text(c.label), findsWidgets);
      }
      expect(
        find.byType(TextFormField),
        findsNWidgets(ExpenseCategory.values.length),
      );
      expect(find.text('Save Budgets'), findsOneWidget);
    });

    testWidgets('skips categories with empty or zero amounts on save', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      await tester.pump();

      // Fill only Groceries; leave the rest blank.
      await tester.enterText(
        find.widgetWithText(TextFormField, ExpenseCategory.groceries.label),
        '200000',
      );

      await tester.ensureVisible(find.text('Save Budgets'));
      await tester.tap(find.text('Save Budgets'));
      await tester.pumpAndSettle();

      final budgets = await _service.getBudgetsForPeriod(_currentPeriod());
      expect(budgets, hasLength(1));
      expect(budgets.single.category, 'groceries');
      expect(budgets.single.limitAmount, 200000);
    });
  });
}
