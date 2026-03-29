import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../utils/time_ago.dart';
import 'alert_severity.dart';

class AlertCard extends StatelessWidget {
  const AlertCard({
    super.key,
    required this.severity,
    required this.title,
    required this.message,
    required this.icon,
    this.onTap,
    this.onDismiss,
    this.actionLabel,
    this.onAction,
    this.timestamp,
  });

  final AlertSeverity severity;
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  final String? actionLabel;
  final VoidCallback? onAction;
  final DateTime? timestamp;

  Color _borderColor() {
    return switch (severity) {
      AlertSeverity.critical => AppColors.error,
      AlertSeverity.warning => AppColors.warning,
      AlertSeverity.info => AppColors.primaryLight,
      AlertSeverity.success => AppColors.success,
    };
  }

  Color _iconColor() => _borderColor();

  Color _iconBackground() {
    return _borderColor().withValues(alpha: 0.12);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final severityColor = _borderColor();

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Thick left border
                Container(
                  width: 4,
                  decoration: BoxDecoration(color: severityColor),
                ),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: _iconBackground(),
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.borderRadiusSm,
                                ),
                              ),
                              child: Icon(icon, color: _iconColor(), size: 18),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                title,
                                style: textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (onDismiss != null)
                              SizedBox(
                                width: 28,
                                height: 28,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  iconSize: 16,
                                  icon: Icon(
                                    Icons.close,
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                  onPressed: onDismiss,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        // Message
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 36 + AppSpacing.sm,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                              ),
                              if (timestamp != null ||
                                  (actionLabel != null &&
                                      onAction != null)) ...[
                                const SizedBox(height: AppSpacing.xs),
                                Row(
                                  children: [
                                    if (timestamp != null)
                                      Expanded(
                                        child: Text(
                                          timeAgo(timestamp!),
                                          style: textTheme.bodySmall,
                                        ),
                                      )
                                    else
                                      const Spacer(),
                                    if (actionLabel != null && onAction != null)
                                      TextButton(
                                        onPressed: onAction,
                                        style: TextButton.styleFrom(
                                          foregroundColor: severityColor,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: AppSpacing.sm,
                                          ),
                                          minimumSize: Size.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          textStyle: textTheme.labelLarge
                                              ?.copyWith(color: severityColor),
                                        ),
                                        child: Text(actionLabel!),
                                      ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
