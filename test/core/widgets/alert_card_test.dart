import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/theme/app_colors.dart';
import 'package:hms/core/widgets/alert_card.dart';
import 'package:hms/core/widgets/alert_severity.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('AlertCard', () {
    testWidgets('renders title and message', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AlertCard(
            severity: AlertSeverity.critical,
            title: 'Rent Overdue',
            message: 'Room 3 — John, 15 days overdue',
            icon: Icons.warning_amber_rounded,
          ),
        ),
      );
      expect(find.text('Rent Overdue'), findsOneWidget);
      expect(find.text('Room 3 — John, 15 days overdue'), findsOneWidget);
    });

    testWidgets('critical severity uses red border color', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AlertCard(
            severity: AlertSeverity.critical,
            title: 'Title',
            message: 'Msg',
            icon: Icons.error,
          ),
        ),
      );
      final containers = tester
          .widgetList<Container>(find.byType(Container))
          .toList();
      final borderContainer = containers.firstWhere(
        (c) =>
            c.decoration is BoxDecoration &&
            (c.decoration as BoxDecoration).color == AppColors.error,
        orElse: () => throw TestFailure('No red container found'),
      );
      expect(
        (borderContainer.decoration as BoxDecoration).color,
        AppColors.error,
      );
    });

    testWidgets('warning severity uses amber border color', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AlertCard(
            severity: AlertSeverity.warning,
            title: 'Title',
            message: 'Msg',
            icon: Icons.warning,
          ),
        ),
      );
      final containers = tester
          .widgetList<Container>(find.byType(Container))
          .toList();
      final borderContainer = containers.firstWhere(
        (c) =>
            c.decoration is BoxDecoration &&
            (c.decoration as BoxDecoration).color == AppColors.warning,
        orElse: () => throw TestFailure('No amber container found'),
      );
      expect(
        (borderContainer.decoration as BoxDecoration).color,
        AppColors.warning,
      );
    });

    testWidgets('info severity uses blue border color', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AlertCard(
            severity: AlertSeverity.info,
            title: 'Title',
            message: 'Msg',
            icon: Icons.info,
          ),
        ),
      );
      final containers = tester
          .widgetList<Container>(find.byType(Container))
          .toList();
      final borderContainer = containers.firstWhere(
        (c) =>
            c.decoration is BoxDecoration &&
            (c.decoration as BoxDecoration).color == AppColors.primaryLight,
        orElse: () => throw TestFailure('No blue container found'),
      );
      expect(
        (borderContainer.decoration as BoxDecoration).color,
        AppColors.primaryLight,
      );
    });

    testWidgets('success severity uses green border color', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AlertCard(
            severity: AlertSeverity.success,
            title: 'Title',
            message: 'Msg',
            icon: Icons.check_circle,
          ),
        ),
      );
      final containers = tester
          .widgetList<Container>(find.byType(Container))
          .toList();
      final borderContainer = containers.firstWhere(
        (c) =>
            c.decoration is BoxDecoration &&
            (c.decoration as BoxDecoration).color == AppColors.success,
        orElse: () => throw TestFailure('No green container found'),
      );
      expect(
        (borderContainer.decoration as BoxDecoration).color,
        AppColors.success,
      );
    });

    testWidgets('icon is displayed', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AlertCard(
            severity: AlertSeverity.warning,
            title: 'Title',
            message: 'Msg',
            icon: Icons.bolt,
          ),
        ),
      );
      expect(find.byIcon(Icons.bolt), findsOneWidget);
    });

    testWidgets('onTap fires when card is tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          AlertCard(
            severity: AlertSeverity.info,
            title: 'Title',
            message: 'Msg',
            icon: Icons.info,
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.tap(find.byType(AlertCard));
      expect(tapped, isTrue);
    });

    testWidgets('dismiss button shows when onDismiss is provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          AlertCard(
            severity: AlertSeverity.critical,
            title: 'Title',
            message: 'Msg',
            icon: Icons.error,
            onDismiss: () {},
          ),
        ),
      );
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('dismiss button does NOT show when onDismiss is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const AlertCard(
            severity: AlertSeverity.critical,
            title: 'Title',
            message: 'Msg',
            icon: Icons.error,
          ),
        ),
      );
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('action button shows when actionLabel and onAction provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          AlertCard(
            severity: AlertSeverity.critical,
            title: 'Title',
            message: 'Msg',
            icon: Icons.error,
            actionLabel: 'Mark Paid',
            onAction: () {},
          ),
        ),
      );
      expect(find.text('Mark Paid'), findsOneWidget);
    });

    testWidgets('action button does NOT show when onAction is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const AlertCard(
            severity: AlertSeverity.critical,
            title: 'Title',
            message: 'Msg',
            icon: Icons.error,
            actionLabel: 'Mark Paid',
            // onAction intentionally omitted
          ),
        ),
      );
      expect(find.text('Mark Paid'), findsNothing);
    });

    testWidgets('action button does NOT show when actionLabel is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          AlertCard(
            severity: AlertSeverity.critical,
            title: 'Title',
            message: 'Msg',
            icon: Icons.error,
            onAction: () {},
            // actionLabel intentionally omitted
          ),
        ),
      );
      // No TextButton label rendered
      expect(find.byType(TextButton), findsNothing);
    });

    testWidgets('timestamp renders relative time when provided', (
      tester,
    ) async {
      final fiveMinAgo = DateTime.now().subtract(const Duration(minutes: 5));
      await tester.pumpWidget(
        _wrap(
          AlertCard(
            severity: AlertSeverity.info,
            title: 'Title',
            message: 'Msg',
            icon: Icons.info,
            timestamp: fiveMinAgo,
          ),
        ),
      );
      expect(find.text('5 min ago'), findsOneWidget);
    });
  });
}
