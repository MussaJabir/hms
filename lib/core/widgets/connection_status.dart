import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class ConnectionStatus extends ConsumerWidget {
  const ConnectionStatus({
    super.key,
    this.showLabel = true,
    this.compact = false,
  });

  final bool showLabel;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivity = ref.watch(connectivityProvider);

    final isOnline = connectivity.when(
      data: (v) => v,
      error: (_, e) => true,
      loading: () => true,
    );
    final color = isOnline ? AppColors.success : AppColors.error;
    final label = isOnline ? 'Online' : 'Offline';

    final dot = Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );

    if (compact) return dot;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        dot,
        if (showLabel) ...[
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
