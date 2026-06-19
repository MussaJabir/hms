import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/features/dashboard/widgets/quick_add_bottom_sheet.dart';
import 'package:hms/features/dashboard/widgets/quick_add_fab.dart';

Widget _wrap(Widget child) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) =>
            Scaffold(body: const SizedBox.expand(), floatingActionButton: child),
      ),
      // The "Log an Expense" action navigates here.
      GoRoute(
        path: '/finance/expenses/add/:category',
        builder: (context, state) =>
            const Scaffold(body: Text('Add Expense')),
      ),
    ],
  );

  return ProviderScope(
    child: MaterialApp.router(
      // NoSplash avoids Material 3's InkSparkle fragment shader on action taps.
      theme: ThemeData(splashFactory: NoSplash.splashFactory),
      routerConfig: router,
    ),
  );
}

void main() {
  group('QuickAddFab', () {
    testWidgets('renders a FAB with add icon', (tester) async {
      await tester.pumpWidget(_wrap(const QuickAddFab()));

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('tapping FAB opens bottom sheet', (tester) async {
      await tester.pumpWidget(_wrap(const QuickAddFab()));

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(QuickAddBottomSheet), findsOneWidget);
    });

    testWidgets('bottom sheet shows all 4 action options', (tester) async {
      await tester.pumpWidget(_wrap(const QuickAddFab()));

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Log an Expense'), findsOneWidget);
      expect(find.text('Record Meter Reading'), findsOneWidget);
      expect(find.text('Record Rent Payment'), findsOneWidget);
      expect(find.text('Add Inventory Item'), findsOneWidget);
    });

    testWidgets('bottom sheet shows Quick Add title', (tester) async {
      await tester.pumpWidget(_wrap(const QuickAddFab()));

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Quick Add'), findsOneWidget);
    });

    testWidgets('tapping an action closes the bottom sheet', (tester) async {
      await tester.pumpWidget(_wrap(const QuickAddFab()));

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.byType(QuickAddBottomSheet), findsOneWidget);

      await tester.tap(find.text('Log an Expense'));
      await tester.pumpAndSettle();

      expect(find.byType(QuickAddBottomSheet), findsNothing);
    });
  });
}
