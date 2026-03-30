import 'package:flutter/material.dart';

import 'empty_state.dart';

abstract class EmptyStatePresets {
  // Rental
  static EmptyState noTenants({VoidCallback? onAdd}) => EmptyState(
    icon: Icons.person_outline,
    title: 'No Tenants Yet',
    message: 'Add your first tenant to start tracking rent payments.',
    actionLabel: onAdd != null ? 'Add Tenant' : null,
    onAction: onAdd,
  );

  static EmptyState noRentRecords({VoidCallback? onAdd}) => EmptyState(
    icon: Icons.payments_outlined,
    title: 'No Rent Records',
    message: 'Rent records will appear here once tenants are set up.',
    actionLabel: onAdd != null ? 'Record Payment' : null,
    onAction: onAdd,
  );

  // Electricity
  static EmptyState noMeterReadings({VoidCallback? onAdd}) => EmptyState(
    icon: Icons.electric_meter_outlined,
    title: 'No Meter Readings',
    message: 'Start recording meter readings to track electricity consumption.',
    actionLabel: onAdd != null ? 'Add Reading' : null,
    onAction: onAdd,
  );

  // Water
  static EmptyState noWaterBills({VoidCallback? onAdd}) => EmptyState(
    icon: Icons.water_drop_outlined,
    title: 'No Water Bills',
    message: 'Add your first water bill to start tracking utility costs.',
    actionLabel: onAdd != null ? 'Add Bill' : null,
    onAction: onAdd,
  );

  // Finance
  static EmptyState noExpenses({VoidCallback? onAdd}) => EmptyState(
    icon: Icons.receipt_long_outlined,
    title: 'No Expenses Recorded',
    message: 'Start logging expenses to track where your money goes.',
    actionLabel: onAdd != null ? 'Add Expense' : null,
    onAction: onAdd,
  );

  static EmptyState noIncome({VoidCallback? onAdd}) => EmptyState(
    icon: Icons.account_balance_wallet_outlined,
    title: 'No Income Recorded',
    message:
        'Income from rent payments will appear automatically. You can also add other income sources.',
    actionLabel: onAdd != null ? 'Add Income' : null,
    onAction: onAdd,
  );

  // Inventory
  static EmptyState noInventory({VoidCallback? onAdd}) => EmptyState(
    icon: Icons.inventory_2_outlined,
    title: 'No Items Yet',
    message:
        'Add household items to track stock levels and get low-stock alerts.',
    actionLabel: onAdd != null ? 'Add Item' : null,
    onAction: onAdd,
  );

  // Children / School
  static EmptyState noChildren({VoidCallback? onAdd}) => EmptyState(
    icon: Icons.school_outlined,
    title: 'No Children Added',
    message: 'Add your children to track school expenses and fee reminders.',
    actionLabel: onAdd != null ? 'Add Child' : null,
    onAction: onAdd,
  );

  // Notifications
  static EmptyState noNotifications() => const EmptyState(
    icon: Icons.notifications_none_outlined,
    title: 'All Clear',
    message:
        "No notifications right now. We'll alert you when something needs your attention.",
  );

  // Activity Log
  static EmptyState noActivityLogs() => const EmptyState(
    icon: Icons.history_outlined,
    title: 'No Activity Yet',
    message: 'User actions will be logged here as the app is used.',
  );

  // Generic / Dashboard
  static EmptyState noAlerts() => const EmptyState(
    icon: Icons.check_circle_outline,
    title: 'All Good!',
    message: 'No urgent items right now. Everything is on track.',
  );

  // Grounds
  static EmptyState noGrounds({VoidCallback? onAdd}) => EmptyState(
    icon: Icons.home_work_outlined,
    title: 'No Properties Set Up',
    message: 'Add your first property to start managing rental units.',
    actionLabel: onAdd != null ? 'Add Property' : null,
    onAction: onAdd,
  );
}
