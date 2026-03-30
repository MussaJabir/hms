import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import 'shimmer_box.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({
    super.key,
    this.showLeadingIcon = true,
    this.showTrailing = true,
    this.showBottom = false,
  });

  final bool showLeadingIcon;
  final bool showTrailing;
  final bool showBottom;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (showLeadingIcon) ...[
                  const ShimmerBox(width: 40, height: 40, borderRadius: 20),
                  const SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FractionallySizedBox(
                        widthFactor: 0.6,
                        child: const ShimmerBox(height: 14),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      FractionallySizedBox(
                        widthFactor: 0.4,
                        child: const ShimmerBox(height: 12),
                      ),
                    ],
                  ),
                ),
                if (showTrailing) ...[
                  const SizedBox(width: AppSpacing.md),
                  const ShimmerBox(width: 80, height: 14),
                ],
              ],
            ),
            if (showBottom) ...[
              const SizedBox(height: AppSpacing.sm),
              const ShimmerBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}
