import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/widgets/alert_severity.dart';
import 'package:hms/features/electricity/models/consumption_warning.dart';
import 'package:hms/features/electricity/providers/alert_providers.dart';
import 'package:hms/features/electricity/screens/consumption_warnings_screen.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

ConsumptionWarning _warning({
  String unitId = 'u-1',
  String unitName = 'Room 1',
  String meterId = 'm-1',
  double threshold = 100,
  double actualConsumption = 160,
  AlertSeverity severity = AlertSeverity.warning,
}) {
  return ConsumptionWarning(
    groundId: 'g-1',
    unitId: unitId,
    unitName: unitName,
    meterId: meterId,
    meterNumber: 'TZ-001',
    threshold: threshold,
    actualConsumption: actualConsumption,
    readingDate: DateTime(2026, 4, 10),
    severity: severity,
  );
}

Widget _wrap(List<ConsumptionWarning> warnings) {
  final router = GoRouter(
    initialLocation: '/electricity/warnings',
    routes: [
      GoRoute(
        path: '/electricity/warnings',
        builder: (context, state) => const ConsumptionWarningsScreen(),
      ),
      GoRoute(
        path: '/grounds/:groundId/electricity',
        builder: (_, state) => Scaffold(
          body: Text('Overview ${state.pathParameters['groundId']}'),
        ),
      ),
    ],
  );

  return ProviderScope(
    overrides: [activeWarningsProvider.overrideWith((ref) async => warnings)],
    child: MaterialApp.router(routerConfig: router),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('ConsumptionWarningsScreen', () {
    testWidgets('shows empty state when no active warnings', (tester) async {
      await tester.pumpWidget(_wrap([]));
      await tester.pumpAndSettle();

      expect(find.text('All Within Limits'), findsOneWidget);
      expect(
        find.text('No units are consuming above their thresholds right now.'),
        findsOneWidget,
      );
    });

    testWidgets('renders one alert card per warning', (tester) async {
      final warnings = [
        _warning(unitName: 'Room 1', severity: AlertSeverity.warning),
        _warning(
          unitId: 'u-2',
          unitName: 'Room 2',
          meterId: 'm-2',
          actualConsumption: 200,
          severity: AlertSeverity.critical,
        ),
      ];

      await tester.pumpWidget(_wrap(warnings));
      await tester.pumpAndSettle();

      expect(find.text('Room 1'), findsOneWidget);
      expect(find.text('Room 2'), findsOneWidget);
    });

    testWidgets('shows AppBar title "High Consumption Warnings"', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap([]));
      await tester.pumpAndSettle();

      expect(find.text('High Consumption Warnings'), findsOneWidget);
    });

    testWidgets(
      'alert card action navigates to electricity overview for ground',
      (tester) async {
        final warnings = [_warning()];

        await tester.pumpWidget(_wrap(warnings));
        await tester.pumpAndSettle();

        // Tap "View Graph" button on the alert card.
        await tester.tap(find.text('View Graph'));
        await tester.pumpAndSettle();

        // Should navigate to the electricity overview screen.
        expect(find.text('Overview g-1'), findsOneWidget);
      },
    );

    testWidgets('displays percentage over threshold in alert message', (
      tester,
    ) async {
      final warnings = [
        _warning(threshold: 100, actualConsumption: 150, unitName: 'Room A'),
      ];

      await tester.pumpWidget(_wrap(warnings));
      await tester.pumpAndSettle();

      // 50% over threshold should appear in the message.
      expect(find.textContaining('50%'), findsOneWidget);
    });
  });
}
