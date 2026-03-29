import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Shimmer skeleton loading placeholder for [AppCard].
/// Uses a pure Flutter animation — no external packages.
class AppCardShimmer extends StatefulWidget {
  const AppCardShimmer({
    super.key,
    this.showLeadingIcon = true,
    this.showSubtitle = true,
    this.showTrailing = true,
  });

  final bool showLeadingIcon;
  final bool showSubtitle;
  final bool showTrailing;

  @override
  State<AppCardShimmer> createState() => _AppCardShimmerState();
}

class _AppCardShimmerState extends State<AppCardShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _animation = Tween<double>(
      begin: -2,
      end: 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark
        ? const Color(0xFF2C2C2C)
        : const Color(0xFFE0E0E0);
    final highlightColor = isDark
        ? const Color(0xFF3A3A3A)
        : const Color(0xFFF5F5F5);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.showLeadingIcon) ...[
                  _ShimmerBox(
                    width: 40,
                    height: 40,
                    borderRadius: AppSpacing.borderRadiusSm,
                    animation: _animation,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                  ),
                  const SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ShimmerBox(
                        width: double.infinity,
                        height: 14,
                        borderRadius: 4,
                        animation: _animation,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                      ),
                      if (widget.showSubtitle) ...[
                        const SizedBox(height: AppSpacing.xs),
                        _ShimmerBox(
                          width: 120,
                          height: 11,
                          borderRadius: 4,
                          animation: _animation,
                          baseColor: baseColor,
                          highlightColor: highlightColor,
                        ),
                      ],
                    ],
                  ),
                ),
                if (widget.showTrailing) ...[
                  const SizedBox(width: AppSpacing.md),
                  _ShimmerBox(
                    width: 60,
                    height: 14,
                    borderRadius: 4,
                    animation: _animation,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.animation,
    required this.baseColor,
    required this.highlightColor,
  });

  final double width;
  final double height;
  final double borderRadius;
  final Animation<double> animation;
  final Color baseColor;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment(animation.value - 1, 0),
          end: Alignment(animation.value + 1, 0),
          colors: [baseColor, highlightColor, baseColor],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}
