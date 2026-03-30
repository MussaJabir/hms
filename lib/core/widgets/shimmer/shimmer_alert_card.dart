import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import 'shimmer_box.dart';

class ShimmerAlertCard extends StatelessWidget {
  const ShimmerAlertCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;

    return Card(
      margin: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 4,
                decoration: BoxDecoration(color: borderColor),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const ShimmerBox(
                            width: 36,
                            height: 36,
                            borderRadius: 18,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: FractionallySizedBox(
                              widthFactor: 0.5,
                              alignment: Alignment.centerLeft,
                              child: const ShimmerBox(height: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 36 + AppSpacing.sm,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FractionallySizedBox(
                              widthFactor: 0.8,
                              alignment: Alignment.centerLeft,
                              child: const ShimmerBox(height: 12),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            FractionallySizedBox(
                              widthFactor: 0.3,
                              alignment: Alignment.centerLeft,
                              child: const ShimmerBox(height: 10),
                            ),
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
    );
  }
}
