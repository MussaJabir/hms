import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import 'shimmer_box.dart';

class ShimmerSummaryTile extends StatelessWidget {
  const ShimmerSummaryTile({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: compact ? _buildCompact() : _buildStandard(),
      ),
    );
  }

  Widget _buildStandard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const ShimmerBox(width: 24, height: 24, borderRadius: 12),
        const SizedBox(height: AppSpacing.sm),
        FractionallySizedBox(
          widthFactor: 0.7,
          child: const ShimmerBox(height: 22),
        ),
        const SizedBox(height: AppSpacing.xs),
        FractionallySizedBox(
          widthFactor: 0.5,
          child: const ShimmerBox(height: 12),
        ),
        const SizedBox(height: AppSpacing.xs),
        FractionallySizedBox(
          widthFactor: 0.4,
          child: const ShimmerBox(height: 11),
        ),
      ],
    );
  }

  Widget _buildCompact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const ShimmerBox(width: 18, height: 18, borderRadius: 9),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: FractionallySizedBox(
                widthFactor: 0.7,
                alignment: Alignment.centerLeft,
                child: const ShimmerBox(height: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        FractionallySizedBox(
          widthFactor: 0.5,
          child: const ShimmerBox(height: 11),
        ),
      ],
    );
  }
}
