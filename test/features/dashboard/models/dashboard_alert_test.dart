import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/widgets/alert_severity.dart';
import 'package:hms/features/dashboard/models/dashboard_alert.dart';

void main() {
  group('DashboardAlert', () {
    final now = DateTime(2026, 4, 1);

    test('creates with required fields', () {
      final alert = DashboardAlert(
        id: 'test-1',
        title: 'Test Alert',
        message: 'This is a test.',
        severity: AlertSeverity.critical,
        icon: Icons.warning,
        module: 'rent',
        createdAt: now,
      );

      expect(alert.id, 'test-1');
      expect(alert.title, 'Test Alert');
      expect(alert.message, 'This is a test.');
      expect(alert.severity, AlertSeverity.critical);
      expect(alert.module, 'rent');
      expect(alert.createdAt, now);
    });

    test('optional fields default to null', () {
      final alert = DashboardAlert(
        id: 'test-2',
        title: 'Info',
        message: 'Just info.',
        severity: AlertSeverity.info,
        icon: Icons.info_outline,
        module: 'electricity',
        createdAt: now,
      );

      expect(alert.targetRoute, isNull);
      expect(alert.targetId, isNull);
      expect(alert.actionLabel, isNull);
    });

    test('supports copyWith', () {
      final alert = DashboardAlert(
        id: 'test-3',
        title: 'Original',
        message: 'Original message.',
        severity: AlertSeverity.warning,
        icon: Icons.warning_amber_outlined,
        module: 'water',
        createdAt: now,
      );

      final updated = alert.copyWith(title: 'Updated');
      expect(updated.title, 'Updated');
      expect(updated.id, alert.id);
      expect(updated.severity, alert.severity);
    });

    test('equality holds for identical alerts', () {
      final a = DashboardAlert(
        id: 'eq-test',
        title: 'Same',
        message: 'Same message.',
        severity: AlertSeverity.success,
        icon: Icons.check_circle_outline,
        module: 'finance',
        createdAt: now,
      );
      final b = DashboardAlert(
        id: 'eq-test',
        title: 'Same',
        message: 'Same message.',
        severity: AlertSeverity.success,
        icon: Icons.check_circle_outline,
        module: 'finance',
        createdAt: now,
      );
      expect(a, equals(b));
    });
  });
}
