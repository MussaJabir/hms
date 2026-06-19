import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/finance/providers/income_providers.dart';
import 'package:hms/features/finance/screens/income_list_screen.dart';
import 'package:hms/features/finance/services/income_service.dart';

Map<String, dynamic> _doc({
  required String source,
  required String description,
  double amount = 50000,
  DateTime? date,
  bool isAutoLinked = false,
}) {
  final d = date ?? DateTime.now();
  final iso = d.toIso8601String();
  return {
    'source': source,
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
    await fake.collection(IncomeService.collection).add(d);
  }
  final firestore = FirestoreService(firestore: fake);
  final service = IncomeService(firestore, ActivityLogService(firestore));

  final router = GoRouter(
    initialLocation: '/finance/income',
    routes: [
      GoRoute(
        path: '/finance/income',
        builder: (context, state) => const IncomeListScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const Scaffold(body: Text('Add')),
          ),
          GoRoute(
            path: ':incomeId/edit',
            builder: (context, state) => const Scaffold(body: Text('Edit')),
          ),
        ],
      ),
    ],
  );

  return ProviderScope(
    overrides: [incomeServiceProvider.overrideWithValue(service)],
    child: MaterialApp.router(
      // NoSplash avoids Material 3's InkSparkle fragment shader, which the
      // test engine cannot load.
      theme: ThemeData(splashFactory: NoSplash.splashFactory),
      routerConfig: router,
    ),
  );
}

/// Pumps until the income stream has delivered data. Avoids pumpAndSettle
/// because the loading shimmer animates indefinitely.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  group('IncomeListScreen', () {
    testWidgets('shows empty state when there is no income', (tester) async {
      await tester.pumpWidget(await _wrap([]));
      await _settle(tester);

      expect(find.text('No Income Recorded'), findsOneWidget);
    });

    testWidgets('shows summary tiles', (tester) async {
      await tester.pumpWidget(
        await _wrap([_doc(source: 'freelance', description: 'Web project')]),
      );
      await _settle(tester);

      expect(find.text('Total This Month'), findsOneWidget);
      expect(find.text('Rent Income'), findsOneWidget);
      expect(find.text('Other Income'), findsOneWidget);
    });

    testWidgets('shows income cards with source icons', (tester) async {
      await tester.pumpWidget(
        await _wrap([
          _doc(source: 'freelance', description: 'Web project'),
          _doc(source: 'business', description: 'Shop sales'),
        ]),
      );
      await _settle(tester);

      expect(find.text('Web project'), findsOneWidget);
      expect(find.text('Shop sales'), findsOneWidget);
      expect(find.byIcon(Icons.computer_outlined), findsOneWidget);
      expect(find.byIcon(Icons.store_outlined), findsOneWidget);
    });

    testWidgets('filter chips narrow the list by source', (tester) async {
      await tester.pumpWidget(
        await _wrap([
          _doc(source: 'freelance', description: 'Web project'),
          _doc(
            source: 'rent',
            description: 'Rent from John',
            isAutoLinked: true,
          ),
        ]),
      );
      await _settle(tester);

      // Both visible under the default "All" filter.
      expect(find.text('Web project'), findsOneWidget);
      expect(find.text('Rent from John'), findsOneWidget);

      // Tap the "Rent" chip → only rent income remains.
      await tester.tap(find.widgetWithText(ChoiceChip, 'Rent'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Web project'), findsNothing);
      expect(find.text('Rent from John'), findsOneWidget);
    });

    testWidgets('auto-linked entries show a read-only indicator', (
      tester,
    ) async {
      await tester.pumpWidget(
        await _wrap([
          _doc(
            source: 'rent',
            description: 'Rent from John',
            isAutoLinked: true,
          ),
        ]),
      );
      await _settle(tester);

      expect(find.text('Auto'), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsWidgets);
    });
  });
}
