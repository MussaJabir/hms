import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/widgets/alert_card.dart';
import 'package:hms/core/widgets/empty_state_presets.dart';
import 'package:hms/features/dashboard/models/dashboard_alert.dart';
import 'package:hms/features/dashboard/providers/alert_provider.dart';

class AlertFeed extends ConsumerStatefulWidget {
  const AlertFeed({super.key});

  @override
  ConsumerState<AlertFeed> createState() => _AlertFeedState();
}

class _AlertFeedState extends ConsumerState<AlertFeed> {
  final Set<String> _dismissed = {};

  @override
  Widget build(BuildContext context) {
    final allAlerts = ref.watch(alertsProvider);
    final visible = allAlerts
        .where((a) => !_dismissed.contains(a.id))
        .take(10)
        .toList();

    if (visible.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.lg,
        ),
        child: EmptyStatePresets.noAlerts(),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.md,
      ),
      itemCount: visible.length,
      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final alert = visible[index];
        return _AlertFeedItem(
          alert: alert,
          onDismiss: () => setState(() => _dismissed.add(alert.id)),
          onTap: alert.targetRoute != null
              ? () => context.push(alert.targetRoute!)
              : null,
          onAction: alert.targetRoute != null && alert.actionLabel != null
              ? () => context.push(alert.targetRoute!)
              : null,
        );
      },
    );
  }
}

class _AlertFeedItem extends StatelessWidget {
  const _AlertFeedItem({
    required this.alert,
    required this.onDismiss,
    this.onTap,
    this.onAction,
  });

  final DashboardAlert alert;
  final VoidCallback onDismiss;
  final VoidCallback? onTap;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return AlertCard(
      severity: alert.severity,
      title: alert.title,
      message: alert.message,
      icon: alert.icon,
      timestamp: alert.createdAt,
      actionLabel: alert.actionLabel,
      onTap: onTap,
      onDismiss: onDismiss,
      onAction: onAction,
    );
  }
}
