import 'package:flutter/material.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/core/widgets/alert_severity.dart';
import 'package:hms/features/dashboard/models/dashboard_alert.dart';
import 'package:hms/features/electricity/services/consumption_alert_service.dart';
import 'package:hms/features/rent/services/rent_summary_service.dart';

class AlertGeneratorService {
  AlertGeneratorService(
    this._rentSummaryService,
    this._consumptionAlertService,
  );

  final RentSummaryService _rentSummaryService;
  final ConsumptionAlertService _consumptionAlertService;

  /// Returns overdue rent alerts, filtered by [groundId] when non-null.
  /// Critical if > 7 days overdue, warning if ≤ 7 days.
  Future<List<DashboardAlert>> generateRentAlerts({String? groundId}) async {
    final overdue = await _rentSummaryService.getOverdueRecords(
      groundId: groundId,
    );
    final now = DateTime.now();

    final alerts = overdue.map((record) {
      final daysOverdue = now.difference(record.dueDate).inDays.abs();
      final severity = daysOverdue > 7
          ? AlertSeverity.critical
          : AlertSeverity.warning;
      return DashboardAlert(
        id: 'rent-overdue-${record.id}',
        title: 'Rent Overdue',
        message:
            '${record.linkedEntityName} — $daysOverdue days overdue, '
            '${formatTZS(record.remainingAmount)} outstanding',
        severity: severity,
        icon: Icons.payments_outlined,
        module: 'rent',
        createdAt: record.dueDate,
        targetRoute: '/rent',
        actionLabel: 'Mark Paid',
      );
    }).toList();

    // Most days overdue first.
    alerts.sort((a, b) {
      final daysA = now.difference(a.createdAt).inDays;
      final daysB = now.difference(b.createdAt).inDays;
      return daysB.compareTo(daysA);
    });

    return alerts;
  }

  Future<List<DashboardAlert>> generateElectricityAlerts({
    String? groundId,
  }) async {
    final warnings = await _consumptionAlertService.getActiveWarnings(
      groundId: groundId,
    );

    final alerts = warnings.map((warning) {
      final percentOver = warning.percentOverThreshold.toStringAsFixed(0);
      return DashboardAlert(
        id: 'electricity-${warning.unitId}-${warning.meterId}',
        title: 'High Consumption',
        message:
            '${warning.unitName}: ${warning.actualConsumption.toStringAsFixed(1)} units '
            '($percentOver% over threshold)',
        severity: warning.severity,
        icon: Icons.bolt_outlined,
        module: 'electricity',
        createdAt: warning.readingDate,
        targetRoute: '/electricity/warnings',
        actionLabel: 'View Details',
      );
    }).toList();

    alerts.sort((a, b) {
      final severityOrder = _severityOrder(
        a.severity,
      ).compareTo(_severityOrder(b.severity));
      if (severityOrder != 0) return severityOrder;
      return b.createdAt.compareTo(a.createdAt);
    });

    return alerts;
  }

  Future<List<DashboardAlert>> generateWaterAlerts({String? groundId}) async =>
      [];

  Future<List<DashboardAlert>> generateInventoryAlerts({
    String? groundId,
  }) async => [];

  Future<List<DashboardAlert>> generateSchoolAlerts({String? groundId}) async =>
      [];

  Future<List<DashboardAlert>> generateBudgetAlerts({String? groundId}) async =>
      [];

  /// Combines all module alerts, sorted by severity (critical first) then date.
  Future<List<DashboardAlert>> getAllAlerts({String? groundId}) async {
    final results = await Future.wait([
      generateRentAlerts(groundId: groundId),
      generateElectricityAlerts(groundId: groundId),
      generateWaterAlerts(groundId: groundId),
      generateInventoryAlerts(groundId: groundId),
      generateSchoolAlerts(groundId: groundId),
      generateBudgetAlerts(groundId: groundId),
    ]);

    final all = results.expand((list) => list).toList();

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
