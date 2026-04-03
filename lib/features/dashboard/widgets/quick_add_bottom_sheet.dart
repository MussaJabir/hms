import 'package:flutter/material.dart';
import 'package:hms/core/theme/theme.dart';

class _QuickAction {
  const _QuickAction({
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
    required this.module,
  });

  final String label;
  final String description;
  final IconData icon;
  final Color color;
  final String module;
}

const _actions = [
  _QuickAction(
    label: 'Log an Expense',
    description: 'Record a household or rental expense',
    icon: Icons.receipt_long_outlined,
    color: AppColors.secondary,
    module: 'Finance',
  ),
  _QuickAction(
    label: 'Record Meter Reading',
    description: 'Enter a new electricity meter reading',
    icon: Icons.electric_meter_outlined,
    color: AppColors.warning,
    module: 'Electricity',
  ),
  _QuickAction(
    label: 'Record Rent Payment',
    description: 'Mark rent as paid for a tenant',
    icon: Icons.payments_outlined,
    color: AppColors.success,
    module: 'Rent',
  ),
  _QuickAction(
    label: 'Add Inventory Item',
    description: 'Add or restock a household item',
    icon: Icons.inventory_2_outlined,
    color: AppColors.primaryLight,
    module: 'Inventory',
  ),
];

class QuickAddBottomSheet extends StatelessWidget {
  const QuickAddBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(top: AppSpacing.md),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.md,
                AppSpacing.screenPadding,
                AppSpacing.sm,
              ),
              child: Text('Quick Add', style: theme.textTheme.headlineSmall),
            ),
            ..._actions.map((action) => _ActionTile(action: action)),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.action});

  final _QuickAction action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Coming soon — ${action.label} will be available after '
              '${action.module} is built',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: action.color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(action.icon, color: action.color, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(action.label, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 2),
                  Text(
                    action.description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
