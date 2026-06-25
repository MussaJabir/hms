import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/features/finance/models/budget.dart';
import 'package:hms/features/finance/models/expense.dart';
import 'package:hms/features/finance/models/financial_summary.dart';
import 'package:hms/features/finance/models/income.dart';
import 'package:hms/features/finance/screens/finance_overview_screen.dart';

final _now = DateTime(2026, 6, 15);

FinancialSummary _summary() => FinancialSummary(
  period: '2026-06',
  totalIncome: 800000,
  totalExpenses: 500000,
  rentIncome: 500000,
  otherIncome: 300000,
  incomeBySource: const {'rent': 500000, 'salary': 300000},
  expensesByCategory: const {'groceries': 300000, 'transport': 200000},
  budgetComplianceScore: 50,
  budgetsOnTrack: 1,
  budgetsOverLimit: 1,
);

Income _income() => Income(
  id: 'i-1',
  source: 'salary',
  description: 'June salary',
  amount: 300000,
  date: _now,
  createdAt: _now,
  updatedAt: _now,
  updatedBy: 'user-1',
);

Expense _expense() => Expense(
  id: 'e-1',
  category: 'groceries',
  description: 'Weekly shop',
  amount: 120000,
  date: _now,
  createdAt: _now,
  updatedAt: _now,
  updatedBy: 'user-1',
);

/// One on-track budget (75%) and one over-limit (125%) → 50% compliance.
List<Budget> _budgets() => [
  Budget(
    id: '2026-06_groceries',
    category: 'groceries',
    limitAmount: 400000,
    period: '2026-06',
    spentAmount: 300000,
    createdAt: _now,
    updatedAt: _now,
    updatedBy: 'user-1',
  ),
  Budget(
    id: '2026-06_transport',
    category: 'transport',
    limitAmount: 400000,
    period: '2026-06',
    spentAmount: 500000,
    createdAt: _now,
    updatedAt: _now,
    updatedBy: 'user-1',
  ),
];

Widget _wrap() {
  final router = GoRouter(
    initialLocation: '/finance',
    routes: [
      GoRoute(
        path: '/finance',
        builder: (context, state) => const FinanceOverviewScreen(),
      ),
      GoRoute(
        path: '/report',
        builder: (context, state) => const Scaffold(body: Text('Report')),
      ),
      GoRoute(
        path: '/finance/income',
        builder: (context, state) => const Scaffold(body: Text('Income')),
      ),
      GoRoute(
        path: '/finance/expenses',
        builder: (context, state) => const Scaffold(body: Text('Expenses')),
      ),
      GoRoute(
        path: '/finance/budget',
        builder: (context, state) => const Scaffold(body: Text('Budget')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      financeSummaryForPeriodProvider.overrideWith(
        (ref, period) => Future.value(_summary()),
      ),
      financeIncomeForPeriodProvider.overrideWith(
        (ref, period) => Stream.value([_income()]),
      ),
      financeExpensesForPeriodProvider.overrideWith(
        (ref, period) => Stream.value([_expense()]),
      ),
      financeBudgetsForPeriodProvider.overrideWith(
        (ref, period) => Stream.value(_budgets()),
      ),
    ],
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
  group('FinanceOverviewScreen', () {
    testWidgets('renders three tabs', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.widgetWithText(Tab, 'Income'), findsOneWidget);
      expect(find.widgetWithText(Tab, 'Expenses'), findsOneWidget);
      expect(find.widgetWithText(Tab, 'Budget'), findsOneWidget);
    });

    testWidgets('income tab shows source breakdown', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('Total Income'), findsOneWidget);
      expect(find.text('Income by Source'), findsOneWidget);
    });

    testWidgets('expenses tab shows category breakdown', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      await tester.tap(find.widgetWithText(Tab, 'Expenses'));
      await _settle(tester);

      expect(find.text('Total Expenses'), findsOneWidget);
      expect(find.text('Expenses by Category'), findsOneWidget);
    });

    testWidgets('budget tab shows compliance score', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      await tester.tap(find.widgetWithText(Tab, 'Budget'));
      await tester.pump(); // start tab transition
      await tester.pump(const Duration(milliseconds: 400)); // finish animation
      // The budget tab subscribes to its stream only once it has built, so
      // pump again to let the first value arrive and the tab rebuild.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Compliance'), findsOneWidget);
      expect(find.text('50%'), findsOneWidget);
    });

    testWidgets('shows the net position card under the tabs', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('Net Position This Month'), findsOneWidget);
    });
  });
}
