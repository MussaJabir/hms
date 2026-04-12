import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:hms/core/theme/app_colors.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/electricity/models/monthly_consumption.dart';
import 'package:hms/features/electricity/models/weekly_consumption.dart';
import 'package:hms/features/electricity/providers/analytics_providers.dart';
import 'package:hms/features/electricity/providers/meter_providers.dart';
import 'package:hms/features/electricity/providers/meter_reading_providers.dart';
import 'package:hms/features/grounds/providers/rental_unit_providers.dart';

enum _ViewMode { weekly, monthly }

class ConsumptionHistoryScreen extends ConsumerStatefulWidget {
  const ConsumptionHistoryScreen({
    super.key,
    required this.groundId,
    required this.unitId,
    required this.meterId,
  });

  final String groundId;
  final String unitId;
  final String meterId;

  @override
  ConsumerState<ConsumptionHistoryScreen> createState() =>
      _ConsumptionHistoryScreenState();
}

class _ConsumptionHistoryScreenState
    extends ConsumerState<ConsumptionHistoryScreen> {
  _ViewMode _viewMode = _ViewMode.weekly;

  @override
  Widget build(BuildContext context) {
    final unitAsync = ref.watch(
      unitByIdProvider(widget.groundId, widget.unitId),
    );
    final meterAsync = ref.watch(
      activeMeterProvider(widget.groundId, widget.unitId),
    );
    final readingsAsync = ref.watch(
      readingsProvider(widget.groundId, widget.unitId, widget.meterId),
    );

    final unitName = unitAsync.asData?.value?.name ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Consumption History'),
            if (unitName.isNotEmpty)
              Text(
                unitName,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white70),
              ),
          ],
        ),
        actions: [
          _ViewToggle(
            value: _viewMode,
            onChanged: (v) => setState(() => _viewMode = v),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: readingsAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: ShimmerList(itemCount: 6),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
        ),
        data: (readings) {
          if (readings.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: EmptyState(
                  icon: Icons.bar_chart_outlined,
                  title: 'No Readings Yet',
                  message: 'Record meter readings to see consumption trends.',
                ),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // Summary tiles
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    AppSpacing.md,
                    AppSpacing.screenPadding,
                    0,
                  ),
                  child: _SummaryRow(
                    groundId: widget.groundId,
                    unitId: widget.unitId,
                    meterId: widget.meterId,
                    viewMode: _viewMode,
                    readings: readings,
                  ),
                ),
              ),
              // Chart
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    AppSpacing.md,
                    AppSpacing.screenPadding,
                    0,
                  ),
                  child: _ChartSection(
                    groundId: widget.groundId,
                    unitId: widget.unitId,
                    meterId: widget.meterId,
                    viewMode: _viewMode,
                    meterAsync: meterAsync,
                  ),
                ),
              ),
              // History header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    AppSpacing.lg,
                    AppSpacing.screenPadding,
                    AppSpacing.xs,
                  ),
                  child: Text(
                    'Reading History',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Readings list
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  0,
                  AppSpacing.screenPadding,
                  AppSpacing.screenPadding,
                ),
                sliver: SliverList.separated(
                  itemCount: readings.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final r = readings[index];
                    return AppCard(
                      leadingIcon: r.isMeterReset ? Icons.refresh : Icons.bolt,
                      leadingIconColor: r.isMeterReset
                          ? AppColors.warning
                          : AppColors.primary,
                      title: DateFormat('dd/MM/yyyy').format(r.readingDate),
                      subtitle:
                          '${formatTZS(r.unitsConsumed * 0)} · '
                          'Reading: ${r.reading.toStringAsFixed(1)}',
                      trailingText:
                          '${r.unitsConsumed.toStringAsFixed(1)} units',
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
// View toggle
// ---------------------------------------------------------------------------

class _ViewToggle extends StatelessWidget {
  const _ViewToggle({required this.value, required this.onChanged});

  final _ViewMode value;
  final ValueChanged<_ViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ToggleBtn(
          label: 'Weekly',
          selected: value == _ViewMode.weekly,
          onTap: () => onChanged(_ViewMode.weekly),
        ),
        _ToggleBtn(
          label: 'Monthly',
          selected: value == _ViewMode.monthly,
          onTap: () => onChanged(_ViewMode.monthly),
        ),
      ],
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  const _ToggleBtn({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: selected ? Colors.white24 : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Summary row
// ---------------------------------------------------------------------------

class _SummaryRow extends ConsumerWidget {
  const _SummaryRow({
    required this.groundId,
    required this.unitId,
    required this.meterId,
    required this.viewMode,
    required this.readings,
  });

  final String groundId;
  final String unitId;
  final String meterId;
  final _ViewMode viewMode;
  final List readings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avgAsync = ref.watch(
      averageConsumptionProvider(groundId, unitId, meterId),
    );

    final weeklyAsync = ref.watch(
      weeklyConsumptionProvider(groundId, unitId, meterId),
    );
    final monthlyAsync = ref.watch(
      monthlyConsumptionProvider(groundId, unitId, meterId),
    );

    final avgValue = avgAsync.asData?.value ?? 0;
    final weekly = weeklyAsync.asData?.value ?? [];
    final monthly = monthlyAsync.asData?.value ?? [];

    final lastPeriodUnits = viewMode == _ViewMode.weekly
        ? (weekly.isNotEmpty ? weekly.last.unitsConsumed : 0.0)
        : (monthly.isNotEmpty ? monthly.last.unitsConsumed : 0.0);

    final totalCost = viewMode == _ViewMode.weekly
        ? weekly.fold<double>(0, (s, w) => s + w.estimatedCost)
        : monthly.fold<double>(0, (s, m) => s + m.estimatedCost);

    return Row(
      children: [
        Expanded(
          child: SummaryTile(
            label: 'Avg Weekly',
            value: '${avgValue.toStringAsFixed(1)} u',
            icon: Icons.show_chart,
            compact: true,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: SummaryTile(
            label: 'Last Period',
            value: '${lastPeriodUnits.toStringAsFixed(1)} u',
            icon: Icons.calendar_today_outlined,
            compact: true,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: SummaryTile(
            label: 'Est. Total',
            value: formatTZS(totalCost, short: true),
            icon: Icons.attach_money,
            compact: true,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Chart section
// ---------------------------------------------------------------------------

class _ChartSection extends ConsumerWidget {
  const _ChartSection({
    required this.groundId,
    required this.unitId,
    required this.meterId,
    required this.viewMode,
    required this.meterAsync,
  });

  final String groundId;
  final String unitId;
  final String meterId;
  final _ViewMode viewMode;
  final AsyncValue meterAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final meter = meterAsync.asData?.value;
    final threshold = (meter?.weeklyThreshold ?? 0) > 0
        ? meter!.weeklyThreshold
        : null;

    if (viewMode == _ViewMode.weekly) {
      final weeklyAsync = ref.watch(
        weeklyConsumptionProvider(groundId, unitId, meterId),
      );
      return _buildWeeklyChart(context, theme, weeklyAsync, threshold);
    } else {
      final monthlyAsync = ref.watch(
        monthlyConsumptionProvider(groundId, unitId, meterId),
      );
      return _buildMonthlyChart(context, theme, monthlyAsync);
    }
  }

  Widget _buildWeeklyChart(
    BuildContext context,
    ThemeData theme,
    AsyncValue<List<WeeklyConsumption>> weeklyAsync,
    double? threshold,
  ) {
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
              'Weekly Consumption (last 12 weeks)',
              style: theme.textTheme.titleSmall,
            ),
            if (threshold != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Row(
                  children: [
                    Container(width: 16, height: 2, color: AppColors.error),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Threshold: ${threshold.toStringAsFixed(0)} u/week',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 200,
              child: weeklyAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (weekly) =>
                    _WeeklyBarChart(data: weekly, threshold: threshold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyChart(
    BuildContext context,
    ThemeData theme,
    AsyncValue<List<MonthlyConsumption>> monthlyAsync,
  ) {
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
              'Monthly Consumption (last 6 months)',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 200,
              child: monthlyAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (monthly) => _MonthlyLineChart(data: monthly),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Weekly bar chart
// ---------------------------------------------------------------------------

class _WeeklyBarChart extends StatefulWidget {
  const _WeeklyBarChart({required this.data, this.threshold});

  final List<WeeklyConsumption> data;
  final double? threshold;

  @override
  State<_WeeklyBarChart> createState() => _WeeklyBarChartState();
}

class _WeeklyBarChartState extends State<_WeeklyBarChart> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const Center(child: Text('No data'));
    }

    final maxY = widget.data
        .map((w) => w.unitsConsumed)
        .fold<double>(0, (a, b) => a > b ? a : b);
    final yMax = (maxY * 1.2).clamp(10.0, double.infinity);

    return BarChart(
      BarChartData(
        maxY: yMax,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final w = widget.data[groupIndex];
              return BarTooltipItem(
                '${w.unitsConsumed.toStringAsFixed(1)} u\n'
                '${formatTZS(w.estimatedCost, short: true)}',
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
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= widget.data.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'W${i + 1}',
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
          getDrawingHorizontalLine: (value) =>
              const FlLine(color: AppColors.border, strokeWidth: 0.5),
        ),
        borderData: FlBorderData(show: false),
        extraLinesData: widget.threshold != null
            ? ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: widget.threshold!,
                    color: AppColors.error,
                    strokeWidth: 1.5,
                    dashArray: [6, 4],
                    label: HorizontalLineLabel(show: false),
                  ),
                ],
              )
            : null,
        barGroups: List.generate(widget.data.length, (i) {
          final isTouched = _touchedIndex == i;
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: widget.data[i].unitsConsumed,
                color: isTouched ? AppColors.secondary : AppColors.primaryLight,
                width: 12,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(3),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Monthly line chart
// ---------------------------------------------------------------------------

class _MonthlyLineChart extends StatelessWidget {
  const _MonthlyLineChart({required this.data});

  final List<MonthlyConsumption> data;

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text('No data'));
    }

    final maxY = data
        .map((m) => m.unitsConsumed)
        .fold<double>(0, (a, b) => a > b ? a : b);
    final yMax = (maxY * 1.2).clamp(10.0, double.infinity);

    return LineChart(
      LineChartData(
        maxY: yMax,
        minY: 0,
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) => spots.map((s) {
              final m = data[s.x.toInt()];
              return LineTooltipItem(
                '${m.unitsConsumed.toStringAsFixed(1)} u\n'
                '${formatTZS(m.estimatedCost, short: true)}',
                const TextStyle(color: Colors.white, fontSize: 11),
              );
            }).toList(),
          ),
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
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= data.length) return const SizedBox.shrink();
                // Parse "2026-03" → "Mar"
                final parts = data[i].period.split('-');
                if (parts.length < 2) return const SizedBox.shrink();
                final month = int.tryParse(parts[1]) ?? 1;
                final abbr = DateFormat('MMM').format(DateTime(2000, month));
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    abbr,
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
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              data.length,
              (i) => FlSpot(i.toDouble(), data[i].unitsConsumed),
            ),
            isCurved: true,
            color: AppColors.primaryLight,
            barWidth: 2.5,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.primaryLight.withValues(alpha: 0.15),
            ),
          ),
        ],
      ),
    );
  }
}
