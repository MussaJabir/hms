import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/finance/providers/expense_providers.dart';
import 'package:hms/features/finance/screens/expense_list_screen.dart';
import 'package:hms/features/finance/services/expense_service.dart';

Map<String, dynamic> _doc({
  required String category,
  required String description,
  double amount = 50000,
  DateTime? date,
  bool isAutoLinked = false,
}) {
  final d = date ?? DateTime.now();
  final iso = d.toIso8601String();
  return {
    'category': category,
    'description': description,
    'amount': amount,
    'date': iso,
    'isAutoLinked': isAutoLinked,
    'notes': '',
    'createdAt': iso,
    'updatedAt': iso,
    'updatedBy': 'user-1',
    'schemaVersion': 1,
  };
}

Future<Widget> _wrap(List<Map<String, dynamic>> docs) async {
  final fake = FakeFirebaseFirestore();
  for (final d in docs) {
    await fake.collection(ExpenseService.collection).add(d);
  }
  final firestore = FirestoreService(firestore: fake);
  final service = ExpenseService(firestore, ActivityLogService(firestore));

  final router = GoRouter(
    initialLocation: '/finance/expenses',
    routes: [
      GoRoute(
        path: '/finance/expenses',
        builder: (context, state) => const ExpenseListScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const Scaffold(body: Text('Add')),
          ),
          GoRoute(
            path: ':expenseId/edit',
            builder: (context, state) => const Scaffold(body: Text('Edit')),
          ),
        ],
      ),
    ],
  );

  return ProviderScope(
    overrides: [expenseServiceProvider.overrideWithValue(service)],
    child: MaterialApp.router(
      // NoSplash avoids Material 3's InkSparkle fragment shader, which the
      // test engine cannot load.
      theme: ThemeData(splashFactory: NoSplash.splashFactory),
      routerConfig: router,
    ),
  );
}

/// Pumps until the expense stream has delivered data. Avoids pumpAndSettle
/// because the loading shimmer animates indefinitely.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  group('ExpenseListScreen', () {
    testWidgets('shows empty state when there are no expenses', (tester) async {
      await tester.pumpWidget(await _wrap([]));
      await _settle(tester);

      expect(find.text('No Expenses Recorded'), findsOneWidget);
    });

    testWidgets('shows summary tiles', (tester) async {
      await tester.pumpWidget(
        await _wrap([_doc(category: 'groceries', description: 'Weekly shop')]),
      );
      await _settle(tester);

      expect(find.text('Total This Month'), findsOneWidget);
      expect(find.text('Daily Average'), findsOneWidget);
      expect(find.text('Categories'), findsOneWidget);
    });

    testWidgets('shows expense cards with category icons', (tester) async {
      await tester.pumpWidget(
        await _wrap([
          _doc(category: 'groceries', description: 'Weekly shop'),
          _doc(category: 'transport', description: 'Bus fare'),
        ]),
      );
      await _settle(tester);

      expect(find.text('Weekly shop'), findsOneWidget);
      expect(find.text('Bus fare'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart_outlined), findsWidgets);
      expect(find.byIcon(Icons.directions_bus_outlined), findsWidgets);
    });

    testWidgets('category filter chips narrow the list', (tester) async {
      await tester.pumpWidget(
        await _wrap([
          _doc(category: 'groceries', description: 'Weekly shop'),
          _doc(category: 'transport', description: 'Bus fare'),
        ]),
      );
      await _settle(tester);

      // Both visible under the default "All" filter.
      expect(find.text('Weekly shop'), findsOneWidget);
      expect(find.text('Bus fare'), findsOneWidget);

      // Tap the "Transport" chip → only transport remains.
      await tester.tap(find.widgetWithText(ChoiceChip, 'Transport'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Weekly shop'), findsNothing);
      expect(find.text('Bus fare'), findsOneWidget);
    });
  });
}
