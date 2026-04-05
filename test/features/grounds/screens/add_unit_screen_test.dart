import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/features/grounds/screens/add_unit_screen.dart';

Widget _wrap() {
  final router = GoRouter(
    initialLocation: '/grounds/g-1/units/add',
    routes: [
      GoRoute(
        path: '/grounds/:groundId/units/add',
        builder: (ctx, st) =>
            AddUnitScreen(groundId: st.pathParameters['groundId']!),
      ),
    ],
  );
  return ProviderScope(child: MaterialApp.router(routerConfig: router));
}

void main() {
  group('AddUnitScreen — form fields', () {
    testWidgets('renders unit name, rent amount, status, and meter ID fields', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.widgetWithText(TextFormField, 'Unit Name'), findsOneWidget);
      // Currency field uses labelText "Monthly Rent (TZS)"
      expect(
        find.widgetWithText(TextFormField, 'Monthly Rent (TZS)'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextFormField, 'Meter ID (optional)'),
        findsOneWidget,
      );
      // Dropdown is present
      expect(find.text('Status'), findsOneWidget);
    });

    testWidgets('shows Add Unit title in create mode', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.text('Add Unit'), findsWidgets);
    });

    testWidgets('status dropdown defaults to Vacant', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.text('Vacant'), findsOneWidget);
    });
  });

  group('AddUnitScreen — validation', () {
    testWidgets('shows error when name is empty', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      await tester.tap(find.widgetWithText(FilledButton, 'Add Unit'));
      await tester.pump();

      expect(find.text('Name is required'), findsOneWidget);
    });

    testWidgets('shows error when rent amount is empty', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Unit Name'),
        'Room 1',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Add Unit'));
      await tester.pump();

      // HmsCurrencyField default validator fires
      expect(find.text('Amount is required'), findsOneWidget);
    });
  });
}
