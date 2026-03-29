import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

enum TrendDirection {
  up, // green arrow up — improvement
  down, // red arrow down — decline
  flat, // gray horizontal line — no change
}

class SummaryTile extends StatelessWidget {
  const SummaryTile({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
    this.trend,
    this.trendText,
    this.valueColor,
    this.onTap,
    this.compact = false,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final TrendDirection? trend;
  final String? trendText;
  final Color? valueColor;
  final VoidCallback? onTap;
  final bool compact;

  Color _trendColor() {
    return switch (trend) {
      TrendDirection.up => AppColors.success,
      TrendDirection.down => AppColors.error,
      TrendDirection.flat => AppColors.textSecondary,
      null => AppColors.textSecondary,
    };
  }

  IconData _trendIcon() {
    return switch (trend) {
      TrendDirection.up => Icons.trending_up,
      TrendDirection.down => Icons.trending_down,
      TrendDirection.flat => Icons.trending_flat,
      null => Icons.trending_flat,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final resolvedIconColor = iconColor ?? colorScheme.primary;

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: compact
              ? _CompactLayout(
                  label: label,
                  value: value,
                  icon: icon,
                  iconColor: resolvedIconColor,
                  valueColor: valueColor,
                  textTheme: textTheme,
                )
              : _StandardLayout(
                  label: label,
                  value: value,
                  icon: icon,
                  iconColor: resolvedIconColor,
                  valueColor: valueColor,
                  trend: trend,
                  trendText: trendText,
                  trendColor: _trendColor(),
                  trendIcon: _trendIcon(),
                  textTheme: textTheme,
                ),
        ),
      ),
    );
  }
}

class _StandardLayout extends StatelessWidget {
  const _StandardLayout({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.valueColor,
    required this.trend,
    required this.trendText,
    required this.trendColor,
    required this.trendIcon,
    required this.textTheme,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color iconColor;
  final Color? valueColor;
  final TrendDirection? trend;
  final String? trendText;
  final Color trendColor;
  final IconData trendIcon;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: AppSpacing.sm),
        ],
        Text(
          value,
          style: textTheme.headlineMedium?.copyWith(color: valueColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: textTheme.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (trend != null && trendText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(trendIcon, size: 14, color: trendColor),
              const SizedBox(width: 2),
              Flexible(
                child: Text(
                  trendText!,
                  style: textTheme.bodySmall?.copyWith(color: trendColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _CompactLayout extends StatelessWidget {
  const _CompactLayout({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.valueColor,
    required this.textTheme,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color iconColor;
  final Color? valueColor;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: AppSpacing.xs),
            ],
            Expanded(
              child: Text(
                value,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: textTheme.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
