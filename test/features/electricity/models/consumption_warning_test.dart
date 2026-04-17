import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/widgets/alert_severity.dart';
import 'package:hms/features/electricity/models/consumption_warning.dart';

void main() {
  ConsumptionWarning makeWarning({
    double threshold = 100,
    double actualConsumption = 150,
    AlertSeverity severity = AlertSeverity.warning,
  }) {
    return ConsumptionWarning(
      groundId: 'g-1',
      unitId: 'u-1',
      unitName: 'Room 1',
      meterId: 'm-1',
      meterNumber: 'TZ-001',
      threshold: threshold,
      actualConsumption: actualConsumption,
      readingDate: DateTime(2026, 4, 10),
      severity: severity,
    );
  }

  group('ConsumptionWarning.percentOverThreshold', () {
    test('calculates percentage correctly when over threshold', () {
      final w = makeWarning(threshold: 100, actualConsumption: 150);
      expect(w.percentOverThreshold, closeTo(50.0, 0.001));
    });

    test('returns 0 when threshold is 0', () {
      final w = makeWarning(threshold: 0, actualConsumption: 100);
      expect(w.percentOverThreshold, equals(0));
    });

    test('returns 0 when consumption equals threshold', () {
      final w = makeWarning(threshold: 100, actualConsumption: 100);
      expect(w.percentOverThreshold, closeTo(0.0, 0.001));
    });

    test('calculates correctly for 120% over threshold', () {
      final w = makeWarning(threshold: 100, actualConsumption: 220);
      expect(w.percentOverThreshold, closeTo(120.0, 0.001));
    });
  });

  group('ConsumptionWarning.unitsOverThreshold', () {
    test('returns correct units over threshold', () {
      final w = makeWarning(threshold: 100, actualConsumption: 145);
      expect(w.unitsOverThreshold, closeTo(45.0, 0.001));
    });

    test('returns negative when under threshold', () {
      // Model doesn't guard against this; caller is responsible for filtering.
      final w = makeWarning(threshold: 100, actualConsumption: 80);
      expect(w.unitsOverThreshold, closeTo(-20.0, 0.001));
    });
  });
}
