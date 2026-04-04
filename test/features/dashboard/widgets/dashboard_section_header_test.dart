import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/features/dashboard/widgets/dashboard_section_header.dart';

Widget _wrap(Widget child) => MaterialApp(
  home: Scaffold(
    body: Padding(padding: const EdgeInsets.all(16), child: child),
  ),
);

void main() {
  group('DashboardSectionHeader', () {
    testWidgets('renders title text', (tester) async {
      await tester.pumpWidget(
        _wrap(const DashboardSectionHeader(title: 'Needs Attention')),
      );

      expect(find.text('Needs Attention'), findsOneWidget);
    });

    testWidgets('renders badge when badgeCount > 0', (tester) async {
      await tester.pumpWidget(
        _wrap(const DashboardSectionHeader(title: 'Alerts', badgeCount: 3)),
      );

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('does not render badge when badgeCount is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const DashboardSectionHeader(title: 'Alerts')),
      );

      // No numeric badge text — only the title
      expect(find.text('Alerts'), findsOneWidget);
      expect(find.text('0'), findsNothing);
    });

    testWidgets('does not render badge when badgeCount is 0', (tester) async {
      await tester.pumpWidget(
        _wrap(const DashboardSectionHeader(title: 'Alerts', badgeCount: 0)),
      );

      expect(find.text('0'), findsNothing);
    });

    testWidgets('renders action text button when provided', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          DashboardSectionHeader(
            title: 'Alerts',
            actionText: 'See all →',
            onAction: () => tapped = true,
          ),
        ),
      );

      expect(find.text('See all →'), findsOneWidget);
      await tester.tap(find.text('See all →'));
      expect(tapped, isTrue);
    });

    testWidgets('does not render action text when actionText is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const DashboardSectionHeader(title: 'Alerts')),
      );

      expect(find.byType(TextButton), findsNothing);
    });
  });
}
