import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/widgets/empty_state.dart';
import 'package:hms/core/widgets/empty_state_presets.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('EmptyState (standard mode)', () {
    testWidgets('renders icon, title, and message', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const EmptyState(
            icon: Icons.inbox,
            title: 'No Data',
            message: 'Nothing to show here yet.',
          ),
        ),
      );
      expect(find.byIcon(Icons.inbox), findsOneWidget);
      expect(find.text('No Data'), findsOneWidget);
      expect(find.text('Nothing to show here yet.'), findsOneWidget);
    });

    testWidgets('shows action button when actionLabel and onAction provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          EmptyState(
            icon: Icons.inbox,
            title: 'No Data',
            message: 'Nothing here.',
            actionLabel: 'Add Item',
            onAction: () {},
          ),
        ),
      );
      expect(find.text('Add Item'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('does NOT show action button when actionLabel is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          EmptyState(
            icon: Icons.inbox,
            title: 'No Data',
            message: 'Nothing here.',
            onAction: () {},
          ),
        ),
      );
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('does NOT show action button when onAction is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const EmptyState(
            icon: Icons.inbox,
            title: 'No Data',
            message: 'Nothing here.',
            actionLabel: 'Add Item',
          ),
        ),
      );
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('onAction fires when button is tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          EmptyState(
            icon: Icons.inbox,
            title: 'No Data',
            message: 'Nothing here.',
            actionLabel: 'Add',
            onAction: () => tapped = true,
          ),
        ),
      );
      await tester.tap(find.byType(ElevatedButton));
      expect(tapped, isTrue);
    });
  });

  group('EmptyState (compact mode)', () {
    testWidgets('compact mode renders smaller icon (size 40)', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const EmptyState(
            icon: Icons.inbox,
            title: 'No Data',
            message: 'Nothing here.',
            compact: true,
          ),
        ),
      );
      final icon = tester.widget<Icon>(find.byIcon(Icons.inbox));
      expect(icon.size, 40);
    });

    testWidgets('compact mode uses TextButton instead of ElevatedButton', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          EmptyState(
            icon: Icons.inbox,
            title: 'No Data',
            message: 'Nothing here.',
            actionLabel: 'Add',
            onAction: () {},
            compact: true,
          ),
        ),
      );
      expect(find.byType(TextButton), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
    });
  });

  group('EmptyStatePresets', () {
    testWidgets('noTenants renders "No Tenants Yet"', (tester) async {
      await tester.pumpWidget(_wrap(EmptyStatePresets.noTenants()));
      expect(find.text('No Tenants Yet'), findsOneWidget);
    });

    testWidgets('noTenants with onAdd renders "Add Tenant" button', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(EmptyStatePresets.noTenants(onAdd: () {})));
      expect(find.text('Add Tenant'), findsOneWidget);
    });

    testWidgets('noAlerts renders "All Good!" with no action button', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(EmptyStatePresets.noAlerts()));
      expect(find.text('All Good!'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('noInventory with onAdd renders "Add Item" button', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(EmptyStatePresets.noInventory(onAdd: () => tapped = true)),
      );
      expect(find.text('Add Item'), findsOneWidget);
      await tester.tap(find.byType(ElevatedButton));
      expect(tapped, isTrue);
    });
  });
}
