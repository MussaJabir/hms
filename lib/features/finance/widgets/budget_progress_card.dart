import 'package:flutter/material.dart';
import 'package:hms/core/theme/theme.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/finance/models/budget.dart';
import 'package:hms/features/finance/models/expense_category.dart';

/// Displays a single category budget with a colour-coded progress bar.
///
/// Bar colour follows spend: green (< 80%), amber (80–99%), red (>= 100%).
class BudgetProgressCard extends StatelessWidget {
  const BudgetProgressCard({super.key, required this.budget, this.onTap});

  final Budget budget;
  final VoidCallback? onTap;

  /// The colour used for the bar, amounts, and remaining text.
  static Color statusColor(Budget budget) {
    if (budget.isOverLimit) return AppColors.error;
    if (budget.isNearLimit) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    final cat = ExpenseCategory.fromString(budget.category);
    final color = statusColor(budget);
    final percent = budget.spentPercentage;

    return AppCard(
      leadingIcon: cat.icon,
      leadingIconColor: color,
      title: cat.label,
      onTap: onTap,
      trailing: Text(
        '${percent.round()}%',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
      bottom: _ProgressSection(budget: budget, color: color),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({required this.budget, required this.color});

  final Budget budget;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Cap the bar at 100% even when overspent so it never overflows.
    final fraction = (budget.spentPercentage / 100).clamp(0.0, 1.0).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 8,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${formatTZS(budget.spentAmount)} / '
              '${formatTZS(budget.limitAmount)}',
              style: theme.textTheme.bodySmall,
            ),
            Text(
              budget.isOverLimit
                  ? '${formatTZS(budget.remainingAmount.abs())} over'
                  : '${formatTZS(budget.remainingAmount)} left',
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
