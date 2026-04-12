import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/features/electricity/models/electricity_meter.dart';
import 'package:hms/features/electricity/models/meter_reading.dart';
import 'package:hms/features/electricity/models/monthly_consumption.dart';
import 'package:hms/features/electricity/models/weekly_consumption.dart';
import 'package:hms/features/electricity/providers/analytics_providers.dart';
import 'package:hms/features/electricity/providers/meter_providers.dart';
import 'package:hms/features/electricity/providers/meter_reading_providers.dart';
import 'package:hms/features/electricity/screens/consumption_history_screen.dart';
import 'package:hms/features/grounds/models/rental_unit.dart';
import 'package:hms/features/grounds/providers/rental_unit_providers.dart';

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

const _groundId = 'g-1';
const _unitId = 'u-1';
const _meterId = 'm-1';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

final _now = DateTime(2026, 4, 12);

RentalUnit _unit() => RentalUnit(
  id: _unitId,
  groundId: _groundId,
  name: 'Room 1',
  rentAmount: 150000,
  status: 'occupied',
  createdAt: _now,
  updatedAt: _now,
  updatedBy: 'user-1',
);

ElectricityMeter _meter({double threshold = 0}) => ElectricityMeter(
  id: _meterId,
  groundId: _groundId,
  unitId: _unitId,
  meterNumber: 'TZ-001',
  currentReading: 1000,
  weeklyThreshold: threshold,
  lastReadingDate: _now,
  createdAt: _now,
  updatedAt: _now,
  updatedBy: 'user-1',
);

MeterReading _reading({
  required String id,
  required DateTime date,
  required double units,
  bool reset = false,
}) => MeterReading(
  id: id,
  groundId: _groundId,
  unitId: _unitId,
  meterId: _meterId,
  reading: units,
  previousReading: 0,
  unitsConsumed: units,
  readingDate: date,
  isMeterReset: reset,
  createdAt: date,
  updatedAt: date,
  updatedBy: 'user-1',
);

List<WeeklyConsumption> _sampleWeekly() => List.generate(
  12,
  (i) => WeeklyConsumption(
    weekStart: _now.subtract(Duration(days: (11 - i) * 7)),
    unitsConsumed: (i + 1) * 5.0,
    estimatedCost: (i + 1) * 500.0,
  ),
);

List<MonthlyConsumption> _sampleMonthly() => [
  const MonthlyConsumption(
    period: '2025-11',
    unitsConsumed: 100,
    estimatedCost: 15000,
  ),
  const MonthlyConsumption(
    period: '2025-12',
    unitsConsumed: 150,
    estimatedCost: 25000,
  ),
  const MonthlyConsumption(
    period: '2026-01',
    unitsConsumed: 200,
    estimatedCost: 40000,
  ),
  const MonthlyConsumption(
    period: '2026-02',
    unitsConsumed: 175,
    estimatedCost: 35000,
  ),
  const MonthlyConsumption(
    period: '2026-03',
    unitsConsumed: 160,
    estimatedCost: 32000,
  ),
  const MonthlyConsumption(
    period: '2026-04',
    unitsConsumed: 50,
    estimatedCost: 7500,
  ),
];

List<MeterReading> _sampleReadings() => [
  _reading(id: 'r1', date: DateTime(2026, 4, 10), units: 50),
  _reading(id: 'r2', date: DateTime(2026, 4, 3), units: 60),
  _reading(id: 'r3', date: DateTime(2026, 3, 25), units: 55, reset: true),
];

Widget _wrap({
  List<MeterReading>? readings,
  ElectricityMeter? meter,
  List<WeeklyConsumption>? weekly,
  List<MonthlyConsumption>? monthly,
}) {
  final resolvedReadings = readings ?? _sampleReadings();
  final resolvedMeter = meter ?? _meter();
  final resolvedWeekly = weekly ?? _sampleWeekly();
  final resolvedMonthly = monthly ?? _sampleMonthly();

  final router = GoRouter(
    initialLocation: '/history',
    routes: [
      GoRoute(
        path: '/history',
        builder: (_, _) => const ConsumptionHistoryScreen(
          groundId: _groundId,
          unitId: _unitId,
          meterId: _meterId,
        ),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      unitByIdProvider(
        _groundId,
        _unitId,
      ).overrideWith((ref) => Stream.value(_unit())),
      activeMeterProvider(
        _groundId,
        _unitId,
      ).overrideWith((ref) => Stream.value(resolvedMeter)),
      readingsProvider(
        _groundId,
        _unitId,
        _meterId,
      ).overrideWith((ref) => Stream.value(resolvedReadings)),
      averageConsumptionProvider(
        _groundId,
        _unitId,
        _meterId,
      ).overrideWith((ref) async => 32.5),
      weeklyConsumptionProvider(
        _groundId,
        _unitId,
        _meterId,
      ).overrideWith((ref) async => resolvedWeekly),
      monthlyConsumptionProvider(
        _groundId,
        _unitId,
        _meterId,
      ).overrideWith((ref) async => resolvedMonthly),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

Future<void> _settle(WidgetTester tester) async {
  for (int i = 0; i < 4; i++) {
    await tester.pump();
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('ConsumptionHistoryScreen', () {
    testWidgets('renders summary tiles', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      // Summary tiles: Avg Weekly, Last Period, Est. Total
      expect(find.text('Avg Weekly'), findsOneWidget);
      expect(find.text('Last Period'), findsOneWidget);
      expect(find.text('Est. Total'), findsOneWidget);
    });

    testWidgets('toggles between weekly and monthly view', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      // Default is weekly — toggle button should be present
      expect(find.text('Weekly'), findsOneWidget);
      expect(find.text('Monthly'), findsOneWidget);

      // Tap Monthly
      await tester.tap(find.text('Monthly'));
      await tester.pump();

      // Monthly chart title should appear
      expect(find.textContaining('Monthly Consumption'), findsOneWidget);
    });

    testWidgets('shows empty state when no readings', (tester) async {
      await tester.pumpWidget(_wrap(readings: []));
      await _settle(tester);

      expect(find.text('No Readings Yet'), findsOneWidget);
      expect(find.textContaining('Record meter readings'), findsOneWidget);
    });

    testWidgets('shows reading history list', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('Reading History'), findsOneWidget);
      // First two readings (newest) are within the viewport
      expect(find.text('50.0 units'), findsOneWidget);
      expect(find.text('60.0 units'), findsOneWidget);
    });

    testWidgets('shows threshold legend when meter has threshold', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(meter: _meter(threshold: 100)));
      await _settle(tester);

      expect(find.textContaining('Threshold:'), findsOneWidget);
    });
  });
}

