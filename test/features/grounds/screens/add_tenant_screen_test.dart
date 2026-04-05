import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/features/grounds/screens/add_tenant_screen.dart';

Widget _wrap() {
  final router = GoRouter(
    initialLocation: '/grounds/g-1/units/u-1/tenant/add',
    routes: [
      GoRoute(
        path: '/grounds/:groundId/units/:unitId/tenant/add',
        builder: (ctx, st) => AddTenantScreen(
          groundId: st.pathParameters['groundId']!,
          unitId: st.pathParameters['unitId']!,
        ),
      ),
    ],
  );
  return ProviderScope(child: MaterialApp.router(routerConfig: router));
}

void main() {
  group('AddTenantScreen — form fields', () {
    testWidgets('renders all required form fields', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.widgetWithText(TextFormField, 'Full Name'), findsOneWidget);
      expect(
        find.widgetWithText(TextFormField, 'Phone Number'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextFormField, 'National ID (optional)'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextFormField, 'Move-in Date'),
        findsOneWidget,
      );
    });

    testWidgets('shows Add Tenant title in create mode', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.text('Add Tenant'), findsWidgets);
    });
  });

  group('AddTenantScreen — validation', () {
    testWidgets('rejects invalid Tanzanian phone number', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Full Name'),
        'Juma Mkamwa',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Phone Number'),
        '0612345',
      );

      await tester.tap(find.widgetWithText(FilledButton, 'Add Tenant'));
      await tester.pump();

      expect(
        find.text('Invalid phone number — use format 07XXXXXXXX'),
        findsOneWidget,
      );
    });

    testWidgets('accepts valid Tanzanian phone number (07XX)', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Phone Number'),
        '0712345678',
      );

      await tester.tap(find.widgetWithText(FilledButton, 'Add Tenant'));
      await tester.pump();

      // No phone error — only name error remains
      expect(
        find.text('Invalid phone number — use format 07XXXXXXXX'),
        findsNothing,
      );
    });

    testWidgets('requires full name', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      await tester.tap(find.widgetWithText(FilledButton, 'Add Tenant'));
      await tester.pump();

      expect(find.text('Full name is required'), findsOneWidget);
    });
  });
}
