import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hms/core/theme/theme.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/features/finance/models/expense_category.dart';

/// A pie chart breaking expenses down by category, with a legend showing each
/// category's amount and percentage share. Reused on the expense list screen,
/// the monthly report, and financial reports.
///
/// Tap a slice (or its legend row) to highlight it and enlarge it.
class CategoryBreakdownChart extends StatefulWidget {
  const CategoryBreakdownChart({
    super.key,
    required this.categoryTotals,
    required this.totalAmount,
    this.labelOf,
    this.iconOf,
  });

  /// Category value → summed amount for the period.
  final Map<String, double> categoryTotals;

  /// Sum of all category amounts (chart denominator).
  final double totalAmount;

  /// Resolves a key to its display label. Defaults to [ExpenseCategory]. Pass
  /// a custom resolver to reuse the chart for income sources, etc.
  final String Function(String key)? labelOf;

  /// Resolves a key to its display icon. Defaults to [ExpenseCategory].
  final IconData Function(String key)? iconOf;

  String _label(String key) =>
      labelOf?.call(key) ?? ExpenseCategory.fromString(key).label;

  IconData _icon(String key) =>
      iconOf?.call(key) ?? ExpenseCategory.fromString(key).icon;

  @override
  State<CategoryBreakdownChart> createState() => _CategoryBreakdownChartState();
}

class _CategoryBreakdownChartState extends State<CategoryBreakdownChart> {
  /// Fixed palette — segments are coloured by their sorted position so colours
  /// stay stable while the same data is on screen.
  static const _palette = <Color>[
    Color(0xFF4E79A7),
    Color(0xFFF28E2B),
    Color(0xFFE15759),
    Color(0xFF76B7B2),
    Color(0xFF59A14F),
    Color(0xFFEDC948),
    Color(0xFFB07AA1),
    Color(0xFFFF9DA7),
    Color(0xFF9C755F),
    Color(0xFFBAB0AC),
    Color(0xFF86BCB6),
    Color(0xFFD37295),
    Color(0xFFA0CBE8),
    Color(0xFFFFBE7D),
  ];

  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.categoryTotals.isEmpty || widget.totalAmount <= 0) {
      return const SizedBox.shrink();
    }

    // Sort categories by amount so colours and legend stay ordered.
    final entries = widget.categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 56,
              startDegreeOffset: -90,
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  if (!event.isInterestedForInteractions ||
                      response == null ||
                      response.touchedSection == null) {
                    setState(() => _touchedIndex = -1);
                    return;
                  }
                  setState(
                    () => _touchedIndex =
                        response.touchedSection!.touchedSectionIndex,
                  );
                },
              ),
              sections: [
                for (var i = 0; i < entries.length; i++)
                  _section(i, entries[i].value),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _Legend(
          entries: entries,
          total: widget.totalAmount,
          colorOf: _colorAt,
          labelOf: widget._label,
          iconOf: widget._icon,
          touchedIndex: _touchedIndex,
          onTap: (i) =>
              setState(() => _touchedIndex = _touchedIndex == i ? -1 : i),
        ),
      ],
    );
  }

  Color _colorAt(int index) => _palette[index % _palette.length];

  PieChartSectionData _section(int index, double value) {
    final isTouched = index == _touchedIndex;
    final share = value / widget.totalAmount * 100;
    return PieChartSectionData(
      color: _colorAt(index),
      value: value,
      title: share >= 6 ? '${share.toStringAsFixed(0)}%' : '',
      radius: isTouched ? 64 : 54,
      titleStyle: TextStyle(
        fontSize: isTouched ? 14 : 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({
    required this.entries,
    required this.total,
    required this.colorOf,
    required this.labelOf,
    required this.iconOf,
    required this.touchedIndex,
    required this.onTap,
  });

  final List<MapEntry<String, double>> entries;
  final double total;
  final Color Function(int) colorOf;
  final String Function(String) labelOf;
  final IconData Function(String) iconOf;
  final int touchedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        for (var i = 0; i < entries.length; i++)
          _LegendRow(
            color: colorOf(i),
            label: labelOf(entries[i].key),
            icon: iconOf(entries[i].key),
            amount: entries[i].value,
            percent: entries[i].value / total * 100,
            highlighted: i == touchedIndex,
            textTheme: theme.textTheme,
            onTap: () => onTap(i),
          ),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.label,
    required this.icon,
    required this.amount,
    required this.percent,
    required this.highlighted,
    required this.textTheme,
    required this.onTap,
  });

  final Color color;
  final String label;
  final IconData icon;
  final double amount;
  final double percent;
  final bool highlighted;
  final TextTheme textTheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: highlighted
              ? color.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                label,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: highlighted ? FontWeight.w600 : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              formatTZS(amount, short: true),
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            SizedBox(
              width: 44,
              child: Text(
                '${percent.toStringAsFixed(0)}%',
                textAlign: TextAlign.end,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
