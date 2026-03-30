import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import 'shimmer_alert_card.dart';
import 'shimmer_card.dart';
import 'shimmer_summary_tile.dart';

enum ShimmerListType { card, alertCard, summaryTile }

class ShimmerList extends StatelessWidget {
  const ShimmerList({
    super.key,
    this.itemCount = 5,
    this.type = ShimmerListType.card,
    this.showLeadingIcon = true,
    this.padding,
  });

  final int itemCount;
  final ShimmerListType type;
  final bool showLeadingIcon;
  final EdgeInsetsGeometry? padding;

  Widget _buildItem() {
    return switch (type) {
      ShimmerListType.card => ShimmerCard(showLeadingIcon: showLeadingIcon),
      ShimmerListType.alertCard => const ShimmerAlertCard(),
      ShimmerListType.summaryTile => const ShimmerSummaryTile(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (context, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, _) => _buildItem(),
    );
  }
}
