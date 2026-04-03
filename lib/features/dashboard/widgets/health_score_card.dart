import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hms/core/theme/theme.dart';
import 'package:hms/features/dashboard/models/health_score.dart';
import 'package:hms/features/dashboard/providers/health_score_provider.dart';

class HealthScoreCard extends ConsumerWidget {
  const HealthScoreCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.watch(healthScoreProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        side: BorderSide(
          color: isDark
              ? theme.colorScheme.outline.withValues(alpha: 0.3)
              : theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: InkWell(
        onTap: () => _showBreakdown(context, score),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.cardPadding),
          child: Row(
            children: [
              _CircularScore(score: score),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Health Score',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      score.label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: score.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Tap for breakdown',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBreakdown(BuildContext context, HealthScore score) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.borderRadiusLg),
        ),
      ),
      builder: (_) => _BreakdownSheet(score: score),
    );
  }
}

// ---------------------------------------------------------------------------
// Circular progress painter
// ---------------------------------------------------------------------------

class _CircularScore extends StatelessWidget {
  const _CircularScore({required this.score});

  final HealthScore score;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = score.totalScore / 100;
    final displayValue = score.totalScore.round();

    return SizedBox(
      width: 72,
      height: 72,
      child: CustomPaint(
        painter: _ArcPainter(
          progress: percentage,
          color: score.color,
          trackColor: theme.brightness == Brightness.dark
              ? AppColors.darkBorder
              : AppColors.border,
        ),
        child: Center(
          child: Text(
            '$displayValue',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: score.color,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  const _ArcPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  final double progress;
  final Color color;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 6.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    const startAngle = -math.pi / 2;
    const fullSweep = 2 * math.pi;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      fullSweep,
      false,
      trackPaint,
    );

    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        fullSweep * progress,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.progress != progress ||
      old.color != color ||
      old.trackColor != trackColor;
}

// ---------------------------------------------------------------------------
// Breakdown bottom sheet
// ---------------------------------------------------------------------------

class _BreakdownSheet extends StatelessWidget {
  const _BreakdownSheet({required this.score});

  final HealthScore score;

  List<HealthScoreFactor> _factors() => [
    HealthScoreFactor(
      name: 'Rent Collection',
      weight: 0.35,
      score: score.rentScore,
      isActive: score.rentActive,
    ),
    HealthScoreFactor(
      name: 'Bills & Utilities',
      weight: 0.20,
      score: score.billsScore,
      isActive: score.billsActive,
    ),
    HealthScoreFactor(
      name: 'Inventory Stock',
      weight: 0.15,
      score: score.stockScore,
      isActive: score.stockActive,
    ),
    HealthScoreFactor(
      name: 'Overdue Items',
      weight: 0.15,
      score: score.overdueScore,
      isActive: score.overdueActive,
    ),
    HealthScoreFactor(
      name: 'Budget Compliance',
      weight: 0.15,
      score: score.budgetScore,
      isActive: score.budgetActive,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final factors = _factors();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.md,
          AppSpacing.screenPadding,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Health Score Breakdown',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${score.totalScore.round()}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: score.color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      score.label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: score.color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            const Divider(),
            const SizedBox(height: AppSpacing.sm),
            ...factors.map((f) => _FactorRow(factor: f, isDark: isDark)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Inactive modules are excluded from the score calculation.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FactorRow extends StatelessWidget {
  const _FactorRow({required this.factor, required this.isDark});

  final HealthScoreFactor factor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inactiveColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  factor.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: factor.isActive ? null : inactiveColor,
                  ),
                ),
                Text(
                  'Weight: ${(factor.weight * 100).round()}%',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: inactiveColor,
                  ),
                ),
              ],
            ),
          ),
          if (!factor.isActive)
            Text(
              'Not set up',
              style: theme.textTheme.bodySmall?.copyWith(color: inactiveColor),
            )
          else
            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: factor.score / 100,
                      minHeight: 6,
                      backgroundColor: isDark
                          ? AppColors.darkBorder
                          : AppColors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _scoreColor(factor.score),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                SizedBox(
                  width: 36,
                  child: Text(
                    '${factor.score.round()}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: _scoreColor(factor.score),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Color _scoreColor(double score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.primary;
    if (score >= 40) return AppColors.warning;
    return AppColors.error;
  }
}
