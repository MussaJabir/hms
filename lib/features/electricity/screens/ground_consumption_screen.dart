import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:hms/core/theme/app_colors.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/electricity/models/unit_consumption.dart';
import 'package:hms/features/electricity/providers/analytics_providers.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';

class GroundConsumptionScreen extends ConsumerStatefulWidget {
  const GroundConsumptionScreen({super.key, required this.groundId});

  final String groundId;

  @override
  ConsumerState<GroundConsumptionScreen> createState() =>
      _GroundConsumptionScreenState();
}

class _GroundConsumptionScreenState
    extends ConsumerState<GroundConsumptionScreen> {
  late DateTime _start;
  late DateTime _end;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _start = DateTime(now.year, now.month, 1);
    _end = DateTime(now.year, now.month, now.day);
  }

  Future<void> _pickDateRange() async {
    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _start, end: _end),
    );
    if (result != null) {
      setState(() {
        _start = result.start;
        _end = result.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final groundAsync = ref.watch(groundByIdProvider(widget.groundId));
    final groundName = groundAsync.asData?.value?.name ?? 'Ground';

    final consumptionAsync = ref.watch(
      groundConsumptionProvider(widget.groundId, _start, _end),
    );

    final dateLabel =
        '${DateFormat('dd/MM').format(_start)} – ${DateFormat('dd/MM/yy').format(_end)}';

    return Scaffold(
      appBar: AppBar(
        title: Text('$groundName — Consumption'),
        actions: [
          TextButton.icon(
            onPressed: _pickDateRange,
            icon: const Icon(Icons.date_range_outlined, size: 18),
            label: Text(dateLabel),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
          ),
        ],
      ),
      body: consumptionAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: ShimmerList(itemCount: 5),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
        ),
        data: (units) {
          if (units.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: EmptyState(
                  icon: Icons.bar_chart_outlined,
                  title: 'No Data',
                  message: 'No meter readings found for the selected period.',
                ),
              ),
            );
          }

          final totalUnits = units.fold<double>(
            0,
            (s, u) => s + u.unitsConsumed,
          );
          final totalCost = units.fold<double>(
            0,
            (s, u) => s + u.estimatedCost,
          );

          return CustomScrollView(
            slivers: [
              // Summary
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    AppSpacing.md,
                    AppSpacing.screenPadding,
                    0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SummaryTile(
                          label: 'Total Units',
                          value: totalUnits.toStringAsFixed(1),
                          icon: Icons.electric_bolt,
                          compact: true,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: SummaryTile(
                          label: 'Est. Cost',
                          value: formatTZS(totalCost, short: true),
                          icon: Icons.attach_money,
                          compact: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bar chart
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    AppSpacing.md,
                    AppSpacing.screenPadding,
                    0,
                  ),
                  child: _GroundBarChart(units: units),
                ),
              ),
              // Units list header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    AppSpacing.lg,
                    AppSpacing.screenPadding,
                    AppSpacing.xs,
                  ),
                  child: Text(
                    'By Unit (highest first)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Units list
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  0,
                  AppSpacing.screenPadding,
                  AppSpacing.screenPadding,
                ),
                sliver: SliverList.separated(
                  itemCount: units.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final u = units[index];
                    return AppCard(
                      leadingIcon: Icons.electric_meter_outlined,
                      leadingIconColor: AppColors.primary,
                      title: u.unitName,
                      subtitle: u.tenantName.isNotEmpty
                          ? u.tenantName
                          : 'Vacant',
                      trailingText: '${u.unitsConsumed.toStringAsFixed(1)} u',
                      bottom: _ConsumptionBar(
                        units: u.unitsConsumed,
                        maxUnits: totalUnits > 0 ? totalUnits : 1,
                        cost: u.estimatedCost,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Ground bar chart (vertical)
// ---------------------------------------------------------------------------

class _GroundBarChart extends StatefulWidget {
  const _GroundBarChart({required this.units});

  final List<UnitConsumption> units;

  @override
  State<_GroundBarChart> createState() => _GroundBarChartState();
}

class _GroundBarChartState extends State<_GroundBarChart> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    final maxY = widget.units
        .map((u) => u.unitsConsumed)
        .fold<double>(0, (a, b) => a > b ? a : b);
    final yMax = (maxY * 1.2).clamp(10.0, double.infinity);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Consumption by Unit',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  maxY: yMax,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final u = widget.units[groupIndex];
                        return BarTooltipItem(
                          '${u.unitName}\n'
                          '${u.unitsConsumed.toStringAsFixed(1)} u\n'
                          '${formatTZS(u.estimatedCost, short: true)}',
                          const TextStyle(color: Colors.white, fontSize: 11),
                        );
                      },
                    ),
                    touchCallback: (event, response) {
                      setState(() {
                        _touchedIndex = response?.spot?.touchedBarGroupIndex;
                      });
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (value, meta) {
                          if (value == meta.max) return const SizedBox.shrink();
                          return Text(
                            value.toStringAsFixed(0),
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) {
                          final i = value.toInt();
                          if (i < 0 || i >= widget.units.length) {
                            return const SizedBox.shrink();
                          }
                          // Truncate unit name to 6 chars
                          final name = widget.units[i].unitName;
                          final label = name.length > 6
                              ? name.substring(0, 6)
                              : name;
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              label,
                              style: const TextStyle(
                                fontSize: 9,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: yMax / 4,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) =>
                        const FlLine(color: AppColors.border, strokeWidth: 0.5),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(widget.units.length, (i) {
                    final isTouched = _touchedIndex == i;
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: widget.units[i].unitsConsumed,
                          color: isTouched
                              ? AppColors.secondary
                              : AppColors.primaryLight,
                          width: 16,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(3),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Consumption progress bar (inside AppCard bottom)
// ---------------------------------------------------------------------------

class _ConsumptionBar extends StatelessWidget {
  const _ConsumptionBar({
    required this.units,
    required this.maxUnits,
    required this.cost,
  });

  final double units;
  final double maxUnits;
  final double cost;

  @override
  Widget build(BuildContext context) {
    final fraction = (units / maxUnits).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: fraction,
                  minHeight: 4,
                  backgroundColor: AppColors.border,
                  valueColor: const AlwaysStoppedAnimation(
                    AppColors.primaryLight,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              formatTZS(cost, short: true),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}
