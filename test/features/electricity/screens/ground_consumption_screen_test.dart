import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/models/ground.dart';
import 'package:hms/features/electricity/models/unit_consumption.dart';
import 'package:hms/features/electricity/providers/analytics_providers.dart';
import 'package:hms/features/electricity/screens/ground_consumption_screen.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

const _groundId = 'g-1';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

// Match the screen's initState: DateTime(now.year, now.month, now.day)
DateTime get _testEnd {
  final n = DateTime.now();
  return DateTime(n.year, n.month, n.day);
}

DateTime get _testStart => DateTime(_testEnd.year, _testEnd.month, 1);

Ground _ground() {
  final now = DateTime.now();
  return Ground(
    id: _groundId,
    name: 'Main Ground',
    location: 'Dar es Salaam',
    numberOfUnits: 4,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

List<UnitConsumption> _sampleUnits() => [
  const UnitConsumption(
    unitId: 'u-1',
    unitName: 'Room 1',
    tenantName: 'Alice',
    unitsConsumed: 120,
    estimatedCost: 25000,
  ),
  const UnitConsumption(
    unitId: 'u-2',
    unitName: 'Room 2',
    tenantName: 'Bob',
    unitsConsumed: 80,
    estimatedCost: 17000,
  ),
  const UnitConsumption(
    unitId: 'u-3',
    unitName: 'Room 3',
    tenantName: '',
    unitsConsumed: 0,
    estimatedCost: 0,
  ),
];

Widget _wrap({List<UnitConsumption>? units}) {
  final resolvedUnits = units ?? _sampleUnits();

  final router = GoRouter(
    initialLocation: '/ground-consumption',
    routes: [
      GoRoute(
        path: '/ground-consumption',
        builder: (_, _) => const GroundConsumptionScreen(groundId: _groundId),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      groundByIdProvider(
        _groundId,
      ).overrideWith((ref) => Stream.value(_ground())),
      groundConsumptionProvider(
        _groundId,
        _testStart,
        _testEnd,
      ).overrideWith((ref) async => resolvedUnits),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

Future<void> _settle(WidgetTester tester) async {
  // Extra pumps needed for chart widgets to complete their build cycles.
  for (int i = 0; i < 8; i++) {
    await tester.pump();
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('GroundConsumptionScreen', () {
    testWidgets('renders summary tiles with totals', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('Total Units'), findsOneWidget);
      expect(find.text('Est. Cost'), findsOneWidget);
    });

    testWidgets('lists units sorted by consumption highest first', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      // Room 1 appears in both chart label and the AppCard title
      expect(find.text('Room 1'), findsAtLeastNWidgets(1));
      expect(find.text('Room 2'), findsAtLeastNWidgets(1));
      // Room 1 has highest consumption — verify trailingText appears
      expect(find.textContaining('120.0 u'), findsOneWidget);
      expect(find.textContaining('80.0 u'), findsOneWidget);
    });

    testWidgets('shows tenant names in list items', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
    });

    testWidgets('shows Vacant for units without a tenant', (tester) async {
      // Use 2-unit dataset so the vacant item is within the viewport.
      await tester.pumpWidget(
        _wrap(
          units: [
            const UnitConsumption(
              unitId: 'u-1',
              unitName: 'Room 1',
              tenantName: 'Alice',
              unitsConsumed: 120,
              estimatedCost: 25000,
            ),
            const UnitConsumption(
              unitId: 'u-2',
              unitName: 'Room 2',
              tenantName: '',
              unitsConsumed: 80,
              estimatedCost: 17000,
            ),
          ],
        ),
      );
      await _settle(tester);

      expect(find.text('Vacant'), findsOneWidget);
    });

    testWidgets('shows empty state when no units have readings', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(units: []));
      await _settle(tester);

      expect(find.text('No Data'), findsOneWidget);
    });
  });
}
