import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.title,
    this.subtitle,
    this.trailingText,
    this.trailingTextColor,
    this.leadingIcon,
    this.leadingIconColor,
    this.leadingIconBackgroundColor,
    this.trailing,
    this.bottom,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.showChevron = false,
  });

  final String title;
  final String? subtitle;
  final String? trailingText;
  final Color? trailingTextColor;
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final Color? leadingIconBackgroundColor;
  final Widget? trailing;
  final Widget? bottom;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry? padding;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    final borderColor = isDark
        ? colorScheme.outline.withValues(alpha: 0.3)
        : colorScheme.outline.withValues(alpha: 0.2);

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        side: BorderSide(color: borderColor, width: 0.5),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (leadingIcon != null) ...[
                    _LeadingIcon(
                      icon: leadingIcon!,
                      iconColor: leadingIconColor ?? colorScheme.primary,
                      backgroundColor:
                          leadingIconBackgroundColor ??
                          colorScheme.primary.withValues(alpha: 0.12),
                    ),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: textTheme.bodyLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            subtitle!,
                            style: textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    trailing!,
                  ] else if (trailingText != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      trailingText!,
                      style: textTheme.labelLarge?.copyWith(
                        color: trailingTextColor,
                      ),
                    ),
                  ],
                  if (onTap != null && showChevron) ...[
                    const SizedBox(width: AppSpacing.xs),
                    Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: textTheme.bodySmall?.color,
                    ),
                  ],
                ],
              ),
              if (bottom != null) ...[
                const SizedBox(height: AppSpacing.sm),
                bottom!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  const _LeadingIcon({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
      ),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }
}
