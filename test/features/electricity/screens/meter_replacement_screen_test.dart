import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/features/electricity/models/electricity_meter.dart';
import 'package:hms/features/electricity/providers/meter_providers.dart';
import 'package:hms/features/electricity/screens/meter_replacement_screen.dart';

const _groundId = 'g-1';
const _unitId = 'u-1';

ElectricityMeter _activeMeter({double threshold = 50}) {
  final now = DateTime(2026, 4, 12);
  return ElectricityMeter(
    id: 'm-1',
    groundId: _groundId,
    unitId: _unitId,
    meterNumber: 'TZ-001',
    initialReading: 100,
    currentReading: 250,
    weeklyThreshold: threshold,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

Widget _wrap(ElectricityMeter? meter) {
  final router = GoRouter(
    initialLocation: '/grounds/$_groundId/units/$_unitId/meter/replace',
    routes: [
      GoRoute(
        path: '/grounds/:groundId/units/:unitId/meter/replace',
        builder: (ctx, st) => MeterReplacementScreen(
          groundId: st.pathParameters['groundId']!,
          unitId: st.pathParameters['unitId']!,
          currentMeterId: 'm-1',
        ),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      activeMeterProvider(
        _groundId,
        _unitId,
      ).overrideWith((ref) => Stream.value(meter)),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  group('MeterReplacementScreen — current meter info', () {
    testWidgets('shows current meter number', (tester) async {
      await tester.pumpWidget(_wrap(_activeMeter()));
      await tester.pump();

      expect(find.textContaining('TZ-001'), findsWidgets);
    });

    testWidgets('shows warning about fresh reading history', (tester) async {
      await tester.pumpWidget(_wrap(_activeMeter()));
      await tester.pump();

      expect(
        find.textContaining('starts a fresh reading history'),
        findsOneWidget,
      );
    });

    testWidgets('shows default threshold hint from old meter', (tester) async {
      await tester.pumpWidget(_wrap(_activeMeter(threshold: 50)));
      await tester.pump();

      expect(
        find.textContaining('Defaults to old meter threshold'),
        findsOneWidget,
      );
    });
  });

  group('MeterReplacementScreen — new meter form', () {
    testWidgets('renders new meter number and initial reading fields', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(_activeMeter()));
      await tester.pump();

      expect(
        find.widgetWithText(TextFormField, 'New Meter Number'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextFormField, 'New Meter Initial Reading (units)'),
        findsOneWidget,
      );
    });

    testWidgets('shows error when new meter number is empty', (tester) async {
      await tester.pumpWidget(_wrap(_activeMeter()));
      await tester.pump();

      final btn = find.widgetWithText(FilledButton, 'Replace Meter');
      await tester.ensureVisible(btn);
      await tester.tap(btn);
      await tester.pump();

      expect(find.text('Meter number is required'), findsOneWidget);
    });
  });
}
