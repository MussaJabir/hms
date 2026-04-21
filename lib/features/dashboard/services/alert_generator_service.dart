import 'package:flutter/material.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/core/widgets/alert_severity.dart';
import 'package:hms/features/dashboard/models/dashboard_alert.dart';
import 'package:hms/features/electricity/services/consumption_alert_service.dart';
import 'package:hms/features/electricity/services/electricity_summary_service.dart';
import 'package:hms/features/rent/services/rent_summary_service.dart';
import 'package:hms/features/water/services/water_summary_service.dart';

class AlertGeneratorService {
  AlertGeneratorService(
    this._rentSummaryService,
    this._consumptionAlertService,
    this._electricitySummaryService,
    this._waterSummaryService,
  );

  final RentSummaryService _rentSummaryService;
  final ConsumptionAlertService _consumptionAlertService;
  final ElectricitySummaryService _electricitySummaryService;
  final WaterSummaryService _waterSummaryService;

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

  /// Generates an info alert when units have active meters but no reading
  /// recorded this week.
  Future<List<DashboardAlert>> generateReadingReminderAlerts({
    String? groundId,
  }) async {
    final pending = await _electricitySummaryService.getPendingReadingsCount(
      groundId: groundId,
    );
    if (pending == 0) return [];

    final targetRoute = groundId != null
        ? '/grounds/$groundId/quick-reading'
        : '/grounds';

    return [
      DashboardAlert(
        id: 'meter-readings-pending-${groundId ?? 'all'}',
        title: 'Meter Readings Pending',
        message:
            '$pending room${pending == 1 ? '' : 's'} need readings this week',
        severity: AlertSeverity.info,
        icon: Icons.electric_meter_outlined,
        module: 'electricity',
        createdAt: DateTime.now(),
        targetRoute: targetRoute,
        actionLabel: 'Record Now',
      ),
    ];
  }

  Future<List<DashboardAlert>> generateWaterAlerts({String? groundId}) async {
    final alerts = <DashboardAlert>[];
    final now = DateTime.now();

    // Overdue bills → critical alerts
    final overdueBills = await _waterSummaryService.getOverdueBills(
      groundId: groundId,
    );
    for (final bill in overdueBills) {
      final daysOverdue = now.difference(bill.dueDate).inDays;
      alerts.add(
        DashboardAlert(
          id: 'water-overdue-${bill.id}',
          title: 'Water Bill Overdue',
          message:
              '${bill.groundId} — ${formatTZS(bill.totalAmount)}, '
              '$daysOverdue day${daysOverdue == 1 ? '' : 's'} overdue',
          severity: AlertSeverity.critical,
          icon: Icons.water_drop_outlined,
          module: 'water',
          createdAt: bill.dueDate,
          targetRoute: '/grounds/${bill.groundId}/water/${bill.id}',
          actionLabel: 'Pay Now',
        ),
      );
    }

    // Bills due soon → warning alerts
    final dueSoonBills = await _waterSummaryService.getBillsDueSoon(
      groundId: groundId,
    );
    for (final bill in dueSoonBills) {
      final daysLeft = bill.dueDate.difference(now).inDays;
      alerts.add(
        DashboardAlert(
          id: 'water-due-soon-${bill.id}',
          title: 'Water Bill Due Soon',
          message:
              '${bill.groundId} — ${formatTZS(bill.totalAmount)}, '
              'due in $daysLeft day${daysLeft == 1 ? '' : 's'}',
          severity: AlertSeverity.warning,
          icon: Icons.water_drop_outlined,
          module: 'water',
          createdAt: bill.dueDate,
          targetRoute: '/grounds/${bill.groundId}/water/${bill.id}',
          actionLabel: 'Pay Now',
        ),
      );
    }

    // Deficit → info alert
    final surplusDeficit = await _waterSummaryService
        .getCurrentMonthSurplusDeficit(groundId: groundId);
    if (surplusDeficit < 0) {
      final deficit = surplusDeficit.abs();
      final gLabel = groundId ?? 'All properties';
      alerts.add(
        DashboardAlert(
          id: 'water-deficit-${groundId ?? 'all'}',
          title: 'Water Deficit',
          message:
              '$gLabel — tenant contributions ${formatTZS(deficit)} short of bill',
          severity: AlertSeverity.info,
          icon: Icons.water_drop_outlined,
          module: 'water',
          createdAt: now,
          targetRoute: groundId != null
              ? '/grounds/$groundId/water/contributions'
              : '/grounds',
        ),
      );
    }

    return alerts;
  }

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
      generateReadingReminderAlerts(groundId: groundId),
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
