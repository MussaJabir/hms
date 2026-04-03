import 'package:flutter/material.dart';
import 'package:hms/core/widgets/alert_severity.dart';
import 'package:hms/features/dashboard/models/dashboard_alert.dart';

class AlertGeneratorService {
  const AlertGeneratorService();

  List<DashboardAlert> generateRentAlerts() => [];

  List<DashboardAlert> generateElectricityAlerts() => [];

  List<DashboardAlert> generateWaterAlerts() => [];

  List<DashboardAlert> generateInventoryAlerts() => [];

  List<DashboardAlert> generateSchoolAlerts() => [];

  List<DashboardAlert> generateBudgetAlerts() => [];

  /// Combines all module alerts, sorted by severity (critical first) then date.
  List<DashboardAlert> getAllAlerts() {
    final all = [
      ...generateRentAlerts(),
      ...generateElectricityAlerts(),
      ...generateWaterAlerts(),
      ...generateInventoryAlerts(),
      ...generateSchoolAlerts(),
      ...generateBudgetAlerts(),
    ];

    all.sort((a, b) {
      final severityOrder = _severityOrder(
        a.severity,
      ).compareTo(_severityOrder(b.severity));
      if (severityOrder != 0) return severityOrder;
      return b.createdAt.compareTo(a.createdAt);
    });

    return all;
  }

  int _severityOrder(AlertSeverity severity) => switch (severity) {
    AlertSeverity.critical => 0,
    AlertSeverity.warning => 1,
    AlertSeverity.info => 2,
    AlertSeverity.success => 3,
  };
}

/// Sample alerts used until real data modules are built.
List<DashboardAlert> sampleAlerts() {
  final now = DateTime.now();
  return [
    DashboardAlert(
      id: 'sample-rent-overdue',
      title: 'Rent Overdue',
      message: 'Room 3 — 15 days overdue. Follow up with tenant.',
      severity: AlertSeverity.critical,
      icon: Icons.payments_outlined,
      module: 'rent',
      createdAt: now.subtract(const Duration(days: 15)),
      actionLabel: 'View Rent',
    ),
    DashboardAlert(
      id: 'sample-water-due',
      title: 'Water Bill Due Soon',
      message: 'Water bill payment is due in 3 days.',
      severity: AlertSeverity.warning,
      icon: Icons.water_drop_outlined,
      module: 'water',
      createdAt: now.subtract(const Duration(hours: 6)),
      actionLabel: 'View Bill',
    ),
    DashboardAlert(
      id: 'sample-meter-reminder',
      title: 'Meter Reading Reminder',
      message: 'Sunday is the usual meter reading day.',
      severity: AlertSeverity.info,
      icon: Icons.electric_meter_outlined,
      module: 'electricity',
      createdAt: now.subtract(const Duration(hours: 1)),
    ),
  ];
}
