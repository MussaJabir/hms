import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/features/grounds/screens/add_ground_screen.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _wrap() {
  final router = GoRouter(
    initialLocation: '/grounds/add',
    routes: [
      GoRoute(
        path: '/grounds/add',
        builder: (ctx, st) => const AddGroundScreen(),
      ),
    ],
  );
  return ProviderScope(child: MaterialApp.router(routerConfig: router));
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('AddGroundScreen — form fields', () {
    testWidgets('renders name, location, and number of units fields', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(
        find.widgetWithText(TextFormField, 'Property Name'),
        findsOneWidget,
      );
      expect(find.widgetWithText(TextFormField, 'Location'), findsOneWidget);
      expect(
        find.widgetWithText(TextFormField, 'Number of Units'),
        findsOneWidget,
      );
    });

    testWidgets('shows Add Property title in create mode', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.text('Add Property'), findsWidgets);
    });
  });

  group('AddGroundScreen — validation', () {
    testWidgets('shows validation errors when form submitted empty', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      // Tap submit without filling in any fields.
      final submitButton = find.widgetWithText(FilledButton, 'Add Property');
      await tester.tap(submitButton);
      await tester.pump();

      expect(find.text('Name is required'), findsOneWidget);
      expect(find.text('Location is required'), findsOneWidget);
      expect(find.text('Number of units is required'), findsOneWidget);
    });

    testWidgets('shows error when units is zero', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Property Name'),
        'Test',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Location'),
        'Dar es Salaam',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Number of Units'),
        '0',
      );

      await tester.tap(find.widgetWithText(FilledButton, 'Add Property'));
      await tester.pump();

      expect(find.text('Must be a positive whole number'), findsOneWidget);
    });
  });
}
