import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/features/finance/providers/budget_providers.dart';
import 'package:hms/features/finance/screens/budget_screen.dart';
import 'package:hms/features/finance/services/budget_service.dart';
import 'package:hms/features/finance/services/expense_service.dart';

String _currentPeriod() {
  final now = DateTime.now();
  final mm = now.month.toString().padLeft(2, '0');
  return '${now.year}-$mm';
}

Future<Widget> _wrap(
  List<({String category, double limit, double spent})> budgets,
) async {
  final fake = FakeFirebaseFirestore();
  final period = _currentPeriod();
  for (final b in budgets) {
    final id = BudgetService.docId(b.category, period);
    await fake.collection(BudgetService.collection).doc(id).set({
      'category': b.category,
      'limitAmount': b.limit,
      'period': period,
      'spentAmount': b.spent,
      'createdAt': DateTime(2026).toIso8601String(),
      'updatedAt': DateTime(2026).toIso8601String(),
      'updatedBy': 'user-1',
      'schemaVersion': 1,
    });
  }
  final firestore = FirestoreService(firestore: fake);
  final activityLog = ActivityLogService(firestore);
  final service = BudgetService(
    firestore,
    ExpenseService(firestore, activityLog),
    RecurringTransactionService(firestore, activityLog),
    activityLog,
  );

  final router = GoRouter(
    initialLocation: '/finance/budget',
    routes: [
      GoRoute(
        path: '/finance/budget',
        builder: (context, state) => const BudgetScreen(),
        routes: [
          GoRoute(
            path: 'setup',
            builder: (context, state) => const Scaffold(body: Text('Setup')),
          ),
        ],
      ),
      GoRoute(
        path: '/finance/expenses/add/:category',
        builder: (context, state) => const Scaffold(body: Text('Add')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [budgetServiceProvider.overrideWithValue(service)],
    child: MaterialApp.router(
      theme: ThemeData(splashFactory: NoSplash.splashFactory),
      routerConfig: router,
    ),
  );
}

Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  group('BudgetScreen', () {
    testWidgets('shows empty state when there are no budgets', (tester) async {
      await tester.pumpWidget(await _wrap([]));
      await _settle(tester);

      expect(find.text('No Budgets Set'), findsOneWidget);
      expect(find.text('Set Up'), findsOneWidget);
    });

    testWidgets('shows summary tiles when budgets exist', (tester) async {
      await tester.pumpWidget(
        await _wrap([(category: 'groceries', limit: 100000, spent: 50000)]),
      );
      await _settle(tester);

      expect(find.text('Total Budget'), findsOneWidget);
      expect(find.text('Total Spent'), findsOneWidget);
      expect(find.text('Compliance'), findsOneWidget);
    });

    testWidgets('shows a progress card per budget', (tester) async {
      await tester.pumpWidget(
        await _wrap([
          (category: 'groceries', limit: 100000, spent: 50000),
          (category: 'transport', limit: 50000, spent: 45000),
        ]),
      );
      await _settle(tester);

      expect(find.text('Groceries'), findsOneWidget);
      expect(find.text('Transport'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsWidgets);
    });
  });
}
