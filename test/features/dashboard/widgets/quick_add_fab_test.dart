import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/features/dashboard/widgets/quick_add_bottom_sheet.dart';
import 'package:hms/features/dashboard/widgets/quick_add_fab.dart';

Widget _wrap(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      home: Scaffold(
        body: const SizedBox.expand(),
        floatingActionButton: child,
      ),
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
