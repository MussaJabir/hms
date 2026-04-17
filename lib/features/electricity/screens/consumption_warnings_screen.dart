import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/electricity/models/consumption_warning.dart';
import 'package:hms/features/electricity/providers/alert_providers.dart';

class ConsumptionWarningsScreen extends ConsumerWidget {
  const ConsumptionWarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final warningsAsync = ref.watch(activeWarningsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('High Consumption Warnings')),
      body: warningsAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: ShimmerList(itemCount: 5),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
        ),
        data: (warnings) {
          if (warnings.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: EmptyState(
                  icon: Icons.bolt,
                  title: 'All Within Limits',
                  message:
                      'No units are consuming above their thresholds right now.',
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: warnings.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) =>
                _WarningCard(warning: warnings[index]),
          );
        },
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.warning});

  final ConsumptionWarning warning;

  @override
  Widget build(BuildContext context) {
    final percentOver = warning.percentOverThreshold.toStringAsFixed(0);
    return AlertCard(
      severity: warning.severity,
      title: warning.unitName,
      message:
          '${warning.actualConsumption.toStringAsFixed(1)} units used vs '
          '${warning.threshold.toStringAsFixed(0)} threshold '
          '($percentOver% over)',
      icon: Icons.bolt_outlined,
      actionLabel: 'View Graph',
      onAction: () => context.push('/grounds/${warning.groundId}/electricity'),
    );
  }
}
