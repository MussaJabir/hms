import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/models/ground.dart';
import 'package:hms/features/electricity/models/electricity_meter.dart';
import 'package:hms/features/electricity/providers/meter_providers.dart';
import 'package:hms/features/electricity/screens/electricity_overview_screen.dart';
import 'package:hms/features/grounds/models/rental_unit.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';
import 'package:hms/features/grounds/providers/rental_unit_providers.dart';

const _groundId = 'g-1';

Ground _ground() {
  final now = DateTime(2026, 4, 12);
  return Ground(
    id: _groundId,
    name: 'Main Ground',
    location: 'Dar es Salaam',
    numberOfUnits: 2,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

RentalUnit _unit({required String id, required String name}) {
  final now = DateTime(2026, 4, 12);
  return RentalUnit(
    id: id,
    groundId: _groundId,
    name: name,
    rentAmount: 150000,
    status: 'occupied',
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

ElectricityMeter _meter(String unitId) {
  final now = DateTime(2026, 4, 12);
  return ElectricityMeter(
    id: 'm-$unitId',
    groundId: _groundId,
    unitId: unitId,
    meterNumber: 'TZ-${unitId.toUpperCase()}',
    currentReading: 300,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

Widget _wrap({
  required List<RentalUnit> units,
  Map<String, ElectricityMeter?> meters = const {},
}) {
  final router = GoRouter(
    initialLocation: '/grounds/$_groundId/electricity',
    routes: [
      GoRoute(
        path: '/grounds/:groundId/electricity',
        builder: (ctx, st) =>
            ElectricityOverviewScreen(groundId: st.pathParameters['groundId']!),
      ),
      GoRoute(
        path: '/grounds/:groundId/units/:unitId/meter/register',
        builder: (ctx, st) => const Scaffold(body: Text('Register')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      groundByIdProvider(
        _groundId,
      ).overrideWith((ref) => Stream.value(_ground())),
      allUnitsProvider(_groundId).overrideWith((ref) => Stream.value(units)),
      for (final entry in meters.entries)
        activeMeterProvider(
          _groundId,
          entry.key,
        ).overrideWith((ref) => Stream.value(entry.value)),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  group('ElectricityOverviewScreen — empty state', () {
    testWidgets('shows empty state when no units', (tester) async {
      await tester.pumpWidget(_wrap(units: []));
      await tester.pump();

      expect(find.text('No Units'), findsOneWidget);
    });
  });

  group('ElectricityOverviewScreen — with units', () {
    testWidgets('lists all units', (tester) async {
      final units = [
        _unit(id: 'u1', name: 'Room 1'),
        _unit(id: 'u2', name: 'Room 2'),
      ];

      await tester.pumpWidget(
        _wrap(units: units, meters: {'u1': _meter('u1'), 'u2': null}),
      );
      await tester.pump();
      await tester.pump(); // Allow streams to emit

      expect(find.text('Room 1'), findsOneWidget);
      expect(find.text('Room 2'), findsOneWidget);
    });

    testWidgets('shows meter number for units that have a meter', (
      tester,
    ) async {
      final units = [_unit(id: 'u1', name: 'Room 1')];

      await tester.pumpWidget(
        _wrap(units: units, meters: {'u1': _meter('u1')}),
      );
      await tester.pump();
      await tester.pump();

      expect(find.textContaining('TZ-U1'), findsOneWidget);
    });

    testWidgets('shows Register button for units without a meter', (
      tester,
    ) async {
      final units = [_unit(id: 'u1', name: 'Room 1')];

      await tester.pumpWidget(_wrap(units: units, meters: {'u1': null}));
      await tester.pump();
      await tester.pump();

      expect(find.text('Register'), findsOneWidget);
    });
  });
}
