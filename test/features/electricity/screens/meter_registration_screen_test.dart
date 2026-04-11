import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/features/electricity/screens/meter_registration_screen.dart';

Widget _wrap() {
  final router = GoRouter(
    initialLocation: '/grounds/g-1/units/u-1/meter/register',
    routes: [
      GoRoute(
        path: '/grounds/:groundId/units/:unitId/meter/register',
        builder: (ctx, st) => MeterRegistrationScreen(
          groundId: st.pathParameters['groundId']!,
          unitId: st.pathParameters['unitId']!,
        ),
      ),
    ],
  );
  return ProviderScope(child: MaterialApp.router(routerConfig: router));
}

void main() {
  group('MeterRegistrationScreen — fields', () {
    testWidgets('renders meter number, initial reading, and threshold fields', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(
        find.widgetWithText(TextFormField, 'Meter Number'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextFormField, 'Initial Reading (units)'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(
          TextFormField,
          'Weekly Threshold (units, optional)',
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows Register Meter title in create mode', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.text('Register Meter'), findsWidgets);
    });

    testWidgets('shows helper text for threshold field', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(
        find.text('Get alerts when usage exceeds this per week'),
        findsOneWidget,
      );
    });
  });

  group('MeterRegistrationScreen — validation', () {
    testWidgets('shows error when meter number is empty', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      await tester.tap(find.widgetWithText(FilledButton, 'Register Meter'));
      await tester.pump();

      expect(find.text('Meter number is required'), findsOneWidget);
    });

    testWidgets(
      'does not show threshold validation error when field is empty',
      (tester) async {
        await tester.pumpWidget(_wrap());
        await tester.pump();

        // Scroll to and tap the button without entering a meter number to
        // just trigger validation; threshold should produce no error.
        await tester.tap(find.widgetWithText(FilledButton, 'Register Meter'));
        await tester.pump();

        // Meter number error fires but no threshold error
        expect(find.text('Meter number is required'), findsOneWidget);
        expect(find.text('Enter a valid threshold (0 or more)'), findsNothing);
      },
    );
  });
}
