import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'payment_status.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status, this.small = false});

  final PaymentStatus status;
  final bool small;

  ({Color background, Color text}) _colors() {
    return switch (status) {
      PaymentStatus.paid || PaymentStatus.active || PaymentStatus.adequate => (
        background: AppColors.success.withValues(alpha: 0.15),
        text: AppColors.success,
      ),
      PaymentStatus.partial => (
        background: AppColors.warning.withValues(alpha: 0.15),
        text: AppColors.warning,
      ),
      PaymentStatus.pending => (
        background: AppColors.primaryLight.withValues(alpha: 0.15),
        text: AppColors.primaryLight,
      ),
      PaymentStatus.overdue ||
      PaymentStatus.unpaid ||
      PaymentStatus.low ||
      PaymentStatus.high => (
        background: AppColors.error.withValues(alpha: 0.15),
        text: AppColors.error,
      ),
      PaymentStatus.vacant || PaymentStatus.inactive => (
        background: AppColors.border.withValues(alpha: 0.30),
        text: AppColors.textSecondary,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _colors();

    final textStyle = small
        ? theme.textTheme.bodySmall?.copyWith(
            color: colors.text,
            fontWeight: FontWeight.w600,
          )
        : theme.textTheme.labelLarge?.copyWith(
            color: colors.text,
            fontWeight: FontWeight.w600,
          );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? AppSpacing.xs : AppSpacing.sm,
        vertical: small ? 2.0 : AppSpacing.xs / 2,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status.label, style: textStyle),
    );
  }
}
