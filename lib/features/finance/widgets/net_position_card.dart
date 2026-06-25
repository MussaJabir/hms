import 'package:flutter/material.dart';
import 'package:hms/core/theme/theme.dart';
import 'package:hms/core/utils/currency_formatter.dart';

/// A prominent card showing income vs expenses and the resulting net position.
/// The background tints green when the net is positive and red when negative.
class NetPositionCard extends StatelessWidget {
  const NetPositionCard({
    super.key,
    required this.totalIncome,
    required this.totalExpenses,
    this.onTap,
  });

  final double totalIncome;
  final double totalExpenses;
  final VoidCallback? onTap;

  double get _net => totalIncome - totalExpenses;
  bool get _isPositive => _net >= 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _isPositive ? AppColors.success : AppColors.error;
    final prefix = _isPositive ? '+' : '-';

    return Card(
      margin: EdgeInsets.zero,
      color: color.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        side: BorderSide(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Net Position This Month',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _Line(
                label: 'Income',
                value: formatTZS(totalIncome),
                color: AppColors.success,
                theme: theme,
              ),
              const SizedBox(height: AppSpacing.xs),
              _Line(
                label: 'Expenses',
                value: formatTZS(totalExpenses),
                color: AppColors.error,
                theme: theme,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Divider(height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Net',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$prefix${formatTZS(_net.abs())}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({
    required this.label,
    required this.value,
    required this.color,
    required this.theme,
  });

  final String label;
  final String value;
  final Color color;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
