import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/features/electricity/models/electricity_meter.dart';
import 'package:hms/features/electricity/providers/meter_providers.dart';
import 'package:hms/features/electricity/screens/quick_reading_screen.dart';
import 'package:hms/features/grounds/models/rental_unit.dart';
import 'package:hms/features/grounds/providers/rental_unit_providers.dart';

const _groundId = 'g-1';
const _unit1Id = 'u-1';
const _unit2Id = 'u-2';
const _meter1Id = 'm-1';
const _meter2Id = 'm-2';

ElectricityMeter _meter(
  String meterId,
  String unitId, {
  double currentReading = 1000,
}) {
  final now = DateTime(2026, 4, 1);
  return ElectricityMeter(
    id: meterId,
    groundId: _groundId,
    unitId: unitId,
    meterNumber: 'TZ-00$meterId',
    currentReading: currentReading,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

RentalUnit _unit(String unitId, String name) {
  final now = DateTime(2026, 4, 1);
  return RentalUnit(
    id: unitId,
    groundId: _groundId,
    name: name,
    rentAmount: 150000,
    status: 'occupied',
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

Widget _wrap({
  List<RentalUnit>? units,
  Map<String, ElectricityMeter?>? metersById,
}) {
  final resolvedUnits =
      units ?? [_unit(_unit1Id, 'Room 1'), _unit(_unit2Id, 'Room 2')];
  final resolvedMeters =
      metersById ??
      {
        _unit1Id: _meter(_meter1Id, _unit1Id),
        _unit2Id: _meter(_meter2Id, _unit2Id),
      };

  final router = GoRouter(
    initialLocation: '/grounds/$_groundId/quick-reading',
    routes: [
      GoRoute(
        path: '/grounds/:groundId/quick-reading',
        builder: (ctx, st) =>
            QuickReadingScreen(groundId: st.pathParameters['groundId']!),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      allUnitsProvider(
        _groundId,
      ).overrideWith((ref) => Stream.value(resolvedUnits)),
      for (final unit in resolvedUnits)
        activeMeterProvider(
          _groundId,
          unit.id,
        ).overrideWith((ref) => Stream.value(resolvedMeters[unit.id])),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

// Pump twice: first for the units stream to emit, second for the meter streams.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

void main() {
  group('QuickReadingScreen — unit listing', () {
    testWidgets('lists all units with active meters', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.textContaining('Room 1'), findsOneWidget);
      expect(find.textContaining('Room 2'), findsOneWidget);
    });

    testWidgets('shows unit names and meter numbers', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.textContaining('TZ-00m-1'), findsOneWidget);
      expect(find.textContaining('TZ-00m-2'), findsOneWidget);
    });

    testWidgets('shows empty state when no units have meters', (tester) async {
      final units = [_unit(_unit1Id, 'Room 1')];
      await tester.pumpWidget(
        _wrap(units: units, metersById: {_unit1Id: null}),
      );
      await _settle(tester);

      expect(find.textContaining('No Meters Registered'), findsOneWidget);
    });

    testWidgets('shows live consumed units as user types', (tester) async {
      await tester.pumpWidget(
        _wrap(
          units: [_unit(_unit1Id, 'Room 1')],
          metersById: {
            _unit1Id: _meter(_meter1Id, _unit1Id, currentReading: 1000),
          },
        ),
      );
      await _settle(tester);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Current Reading').first,
        '1075',
      );
      await tester.pump();

      expect(find.textContaining('75.0 units consumed'), findsOneWidget);
    });

    testWidgets(
      'shows meter reset warning when reading is lower than previous',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            units: [_unit(_unit1Id, 'Room 1')],
            metersById: {
              _unit1Id: _meter(_meter1Id, _unit1Id, currentReading: 1000),
            },
          ),
        );
        await _settle(tester);

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Current Reading').first,
          '500',
        );
        await tester.pump();

        expect(find.text('Meter reset or replaced?'), findsOneWidget);
      },
    );

    testWidgets('shows Save All button when meters exist', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('Save All'), findsOneWidget);
    });
  });
}
