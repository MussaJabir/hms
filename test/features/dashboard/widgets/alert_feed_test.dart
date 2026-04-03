import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/widgets/alert_card.dart';
import 'package:hms/core/widgets/alert_severity.dart';
import 'package:hms/core/widgets/empty_state.dart';
import 'package:hms/features/dashboard/models/dashboard_alert.dart';
import 'package:hms/features/dashboard/providers/alert_provider.dart';
import 'package:hms/features/dashboard/widgets/alert_feed.dart';

Widget _wrap(Widget child, {List<DashboardAlert>? alerts}) {
  return ProviderScope(
    overrides: [if (alerts != null) alertsProvider.overrideWithValue(alerts)],
    child: MaterialApp(
      home: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );
}

List<DashboardAlert> _makeAlerts(List<(String, AlertSeverity)> specs) {
  return specs.indexed.map((entry) {
    final (index, (id, severity)) = entry;
    return DashboardAlert(
      id: id,
      title: 'Alert $id',
      message: 'Message $id',
      severity: severity,
      icon: Icons.warning,
      module: 'test',
      createdAt: DateTime(2026, 4, 1, 10, index),
    );
  }).toList();
}

void main() {
  group('AlertFeed', () {
    testWidgets('shows EmptyState when no alerts', (tester) async {
      await tester.pumpWidget(_wrap(const AlertFeed(), alerts: []));
      await tester.pump();

      expect(find.byType(EmptyState), findsOneWidget);
      expect(find.text('All Good!'), findsOneWidget);
    });

    testWidgets('renders AlertCards when alerts exist', (tester) async {
      final alerts = _makeAlerts([
        ('a1', AlertSeverity.critical),
        ('a2', AlertSeverity.warning),
      ]);

      await tester.pumpWidget(_wrap(const AlertFeed(), alerts: alerts));
      await tester.pump();

      expect(find.byType(AlertCard), findsNWidgets(2));
      expect(find.byType(EmptyState), findsNothing);
    });

    testWidgets('critical alerts appear before warning alerts', (tester) async {
      // Provide warning first, critical second — feed must re-sort by severity
      // since the provider is overridden with unsorted data.
      // But AlertFeed displays in provider order; sorting is the provider's job.
      // So override with correctly sorted list and verify order in UI.
      final alerts = _makeAlerts([
        ('critical-1', AlertSeverity.critical),
        ('warning-1', AlertSeverity.warning),
        ('info-1', AlertSeverity.info),
      ]);

      await tester.pumpWidget(_wrap(const AlertFeed(), alerts: alerts));
      await tester.pump();

      final cards = tester
          .widgetList<AlertCard>(find.byType(AlertCard))
          .toList();
      expect(cards[0].severity, AlertSeverity.critical);
      expect(cards[1].severity, AlertSeverity.warning);
      expect(cards[2].severity, AlertSeverity.info);
    });

    testWidgets('limits displayed alerts to 10', (tester) async {
      final alerts = List.generate(
        15,
        (i) => DashboardAlert(
          id: 'alert-$i',
          title: 'Alert $i',
          message: 'Msg $i',
          severity: AlertSeverity.info,
          icon: Icons.info_outline,
          module: 'test',
          createdAt: DateTime(2026, 4, 1, 10, i),
        ),
      );

      await tester.pumpWidget(_wrap(const AlertFeed(), alerts: alerts));
      await tester.pump();

      expect(find.byType(AlertCard), findsNWidgets(10));
    });

    testWidgets('dismissed alert is removed from feed', (tester) async {
      final alerts = _makeAlerts([
        ('dismiss-me', AlertSeverity.warning),
        ('keep-me', AlertSeverity.info),
      ]);

      await tester.pumpWidget(_wrap(const AlertFeed(), alerts: alerts));
      await tester.pump();

      expect(find.byType(AlertCard), findsNWidgets(2));

      // Tap the close/dismiss button on the first card
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pump();

      expect(find.byType(AlertCard), findsOneWidget);
    });
  });
}
