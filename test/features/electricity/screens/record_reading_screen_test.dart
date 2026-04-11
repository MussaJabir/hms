import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/features/electricity/models/electricity_meter.dart';
import 'package:hms/features/electricity/providers/meter_providers.dart';
import 'package:hms/features/electricity/providers/meter_reading_providers.dart';
import 'package:hms/features/electricity/screens/record_reading_screen.dart';
import 'package:hms/features/grounds/models/rental_unit.dart';
import 'package:hms/features/grounds/providers/rental_unit_providers.dart';

const _groundId = 'g-1';
const _unitId = 'u-1';
const _meterId = 'm-1';

ElectricityMeter _meter({double currentReading = 1000, DateTime? lastDate}) {
  final now = DateTime(2026, 4, 1);
  return ElectricityMeter(
    id: _meterId,
    groundId: _groundId,
    unitId: _unitId,
    meterNumber: 'TZ-001',
    currentReading: currentReading,
    lastReadingDate: lastDate,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

RentalUnit _unit() {
  final now = DateTime(2026, 4, 1);
  return RentalUnit(
    id: _unitId,
    groundId: _groundId,
    name: 'Room 3',
    rentAmount: 150000,
    status: 'occupied',
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

Widget _wrap({ElectricityMeter? meter}) {
  final router = GoRouter(
    initialLocation:
        '/grounds/$_groundId/units/$_unitId/meter/$_meterId/record',
    routes: [
      GoRoute(
        path: '/grounds/:groundId/units/:unitId/meter/:meterId/record',
        builder: (ctx, st) => RecordReadingScreen(
          groundId: st.pathParameters['groundId']!,
          unitId: st.pathParameters['unitId']!,
          meterId: st.pathParameters['meterId']!,
        ),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      activeMeterProvider(
        _groundId,
        _unitId,
      ).overrideWith((ref) => Stream.value(meter ?? _meter())),
      unitByIdProvider(
        _groundId,
        _unitId,
      ).overrideWith((ref) => Stream.value(_unit())),
      latestReadingProvider(
        _groundId,
        _unitId,
        _meterId,
      ).overrideWith((ref) async => null),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  group('RecordReadingScreen — info display', () {
    testWidgets('shows previous reading and unit/meter name', (tester) async {
      await tester.pumpWidget(_wrap(meter: _meter(currentReading: 1245)));
      await tester.pump();

      expect(find.textContaining('1,245'), findsOneWidget);
      expect(find.textContaining('TZ-001'), findsOneWidget);
    });

    testWidgets('shows last reading date when available', (tester) async {
      await tester.pumpWidget(
        _wrap(
          meter: _meter(currentReading: 1000, lastDate: DateTime(2026, 3, 18)),
        ),
      );
      await tester.pump();

      expect(find.textContaining('18/03/2026'), findsOneWidget);
    });

    testWidgets('shows Never when no last reading date', (tester) async {
      await tester.pumpWidget(_wrap(meter: _meter(lastDate: null)));
      await tester.pump();

      expect(find.textContaining('Never'), findsOneWidget);
    });
  });

  group('RecordReadingScreen — live calculation', () {
    testWidgets('shows live consumed units as user types', (tester) async {
      await tester.pumpWidget(_wrap(meter: _meter(currentReading: 1000)));
      await tester.pump();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Current Reading'),
        '1050',
      );
      await tester.pump();

      expect(find.textContaining('50.0 units'), findsOneWidget);
    });

    testWidgets('shows meter reset warning when current < previous', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(meter: _meter(currentReading: 1000)));
      await tester.pump();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Current Reading'),
        '500',
      );
      await tester.pump();

      expect(find.textContaining('Meter reset or replaced?'), findsOneWidget);
    });
  });
}
