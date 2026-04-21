import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hms/core/theme/theme.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/dashboard/models/monthly_report.dart';
import 'package:hms/features/dashboard/providers/monthly_report_provider.dart';
import 'package:intl/intl.dart';

class MonthlyReportScreen extends ConsumerStatefulWidget {
  const MonthlyReportScreen({super.key});

  @override
  ConsumerState<MonthlyReportScreen> createState() =>
      _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends ConsumerState<MonthlyReportScreen> {
  late DateTime _month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
  }

  String get _period =>
      '${_month.year}-${_month.month.toString().padLeft(2, '0')}';

  String get _headerLabel {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[_month.month - 1]} ${_month.year}';
  }

  void _prevMonth() =>
      setState(() => _month = DateTime(_month.year, _month.month - 1));

  void _nextMonth() =>
      setState(() => _month = DateTime(_month.year, _month.month + 1));

  @override
  Widget build(BuildContext context) {
    final reportAsync = ref.watch(monthlyReportProvider(period: _period));

    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Report')),
      body: OfflineBanner(
        child: reportAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSpacing.screenPadding),
            child: ShimmerList(itemCount: 5),
          ),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (report) => ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              _MonthHeader(
                label: _headerLabel,
                onPrev: _prevMonth,
                onNext: _nextMonth,
              ),
              const SizedBox(height: AppSpacing.md),
              _NetPositionCard(report: report),
              const SizedBox(height: AppSpacing.md),
              _IncomeExpensesRow(report: report),
              const SizedBox(height: AppSpacing.md),
              _RentCollectionCard(report: report),
              const SizedBox(height: AppSpacing.md),
              _TopExpensesSection(expenses: report.topExpenses),
              const SizedBox(height: AppSpacing.md),
              _OverdueSection(items: report.overdueItems),
              const SizedBox(height: AppSpacing.md),
              _PerGroundSection(report: report),
              if (report.electricityUnits > 0) ...[
                const SizedBox(height: AppSpacing.md),
                _ElectricitySummarySection(report: report),
              ],
              if (report.waterBillTotal > 0) ...[
                const SizedBox(height: AppSpacing.md),
                _WaterSummarySection(report: report),
              ],
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Month header with navigation arrows
// ---------------------------------------------------------------------------

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.label,
    required this.onPrev,
    required this.onNext,
  });

  final String label;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          key: const Key('prev_month'),
          icon: const Icon(Icons.chevron_left),
          onPressed: onPrev,
          tooltip: 'Previous month',
        ),
        Text(label, style: theme.textTheme.titleLarge),
        IconButton(
          key: const Key('next_month'),
          icon: const Icon(Icons.chevron_right),
          onPressed: onNext,
          tooltip: 'Next month',
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Net Position card
// ---------------------------------------------------------------------------

class _NetPositionCard extends StatelessWidget {
  const _NetPositionCard({required this.report});

  final MonthlyReport report;

  @override
  Widget build(BuildContext context) {
    final color = report.isPositive ? AppColors.success : AppColors.error;
    final prefix = report.isPositive ? '+' : '';

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        side: BorderSide(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Net Position',
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '$prefix${formatTZS(report.netPosition)}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Income vs Expenses row
// ---------------------------------------------------------------------------

class _IncomeExpensesRow extends StatelessWidget {
  const _IncomeExpensesRow({required this.report});

  final MonthlyReport report;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SummaryTile(
            label: 'Total Income',
            value: formatTZS(report.totalIncome, short: true),
            icon: Icons.arrow_downward,
            iconColor: AppColors.success,
            valueColor: AppColors.success,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: SummaryTile(
            label: 'Total Expenses',
            value: formatTZS(report.totalExpenses, short: true),
            icon: Icons.arrow_upward,
            iconColor: AppColors.error,
            valueColor: AppColors.error,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Rent collection rate
// ---------------------------------------------------------------------------

class _RentCollectionCard extends StatelessWidget {
  const _RentCollectionCard({required this.report});

  final MonthlyReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rate = report.rentCollectionRate;
    final color = rate >= 80
        ? AppColors.success
        : rate >= 50
        ? AppColors.warning
        : AppColors.error;

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        side: BorderSide(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Rent Collection', style: theme.textTheme.bodyLarge),
                Text(
                  '${rate.toStringAsFixed(1)}%',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: (rate / 100).clamp(0.0, 1.0),
                minHeight: 6,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${formatTZS(report.rentCollected)} collected'
              ' of ${formatTZS(report.rentExpected)} expected',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Top 5 Expenses
// ---------------------------------------------------------------------------

class _TopExpensesSection extends StatelessWidget {
  const _TopExpensesSection({required this.expenses});

  final List<ExpenseCategory> expenses;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Top Expenses', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        if (expenses.isEmpty)
          const EmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'No expenses recorded',
            message: 'Expenses will appear here once Finance is set up.',
            compact: true,
          )
        else
          ...expenses.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: AppCard(
                title: e.name,
                trailingText: formatTZS(e.amount),
                leadingIcon: Icons.receipt_long_outlined,
                leadingIconColor: AppColors.secondary,
                leadingIconBackgroundColor: AppColors.secondary.withValues(
                  alpha: 0.12,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Overdue Items
// ---------------------------------------------------------------------------

class _OverdueSection extends StatelessWidget {
  const _OverdueSection({required this.items});

  final List<OverdueItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Overdue Items', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        if (items.isEmpty)
          Row(
            children: [
              const Icon(Icons.check_circle_outline, color: AppColors.success),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'No overdue items',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.success,
                ),
              ),
            ],
          )
        else
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: AlertCard(
                severity: item.daysOverdue >= 7
                    ? AlertSeverity.critical
                    : AlertSeverity.warning,
                title: item.title,
                message:
                    '${item.module} · ${item.daysOverdue} day'
                    '${item.daysOverdue == 1 ? '' : 's'} overdue',
                icon: Icons.warning_amber_outlined,
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Per-Ground Comparison
// ---------------------------------------------------------------------------

class _PerGroundSection extends StatelessWidget {
  const _PerGroundSection({required this.report});

  final MonthlyReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Per-Ground Comparison', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _GroundColumn(
                name: 'Main Ground',
                income: report.mainGroundIncome,
                expenses: report.mainGroundExpenses,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _GroundColumn(
                name: 'Minor Ground',
                income: report.minorGroundIncome,
                expenses: report.minorGroundExpenses,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Electricity Summary (estimated)
// ---------------------------------------------------------------------------

class _ElectricitySummarySection extends StatelessWidget {
  const _ElectricitySummarySection({required this.report});

  final MonthlyReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fmt = NumberFormat('#,##0.0', 'en_US');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Electricity (Estimated)', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: SummaryTile(
                label: 'Total Units',
                value: '${fmt.format(report.electricityUnits)} units',
                icon: Icons.electric_meter_outlined,
                compact: true,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: SummaryTile(
                label: 'Est. Cost',
                value: formatTZS(report.electricityEstimatedCost, short: true),
                icon: Icons.attach_money_outlined,
                compact: true,
                valueColor: AppColors.warning,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Based on current TANESCO tariff rates. Actual bills may vary.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Water Summary
// ---------------------------------------------------------------------------

class _WaterSummarySection extends StatelessWidget {
  const _WaterSummarySection({required this.report});

  final MonthlyReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surplusDeficit = report.waterSurplusDeficit;
    final sdColor = surplusDeficit >= 0 ? AppColors.success : AppColors.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Water', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: SummaryTile(
                label: 'Water Bill',
                value: formatTZS(report.waterBillTotal, short: true),
                icon: Icons.water_drop_outlined,
                compact: true,
                valueColor: AppColors.error,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: SummaryTile(
                label: 'Contributions',
                value: formatTZS(
                  report.waterContributionsCollected,
                  short: true,
                ),
                icon: Icons.people_outlined,
                compact: true,
                valueColor: AppColors.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        SummaryTile(
          label: 'Surplus / Deficit',
          value: formatTZS(surplusDeficit.abs(), short: true),
          icon: surplusDeficit >= 0
              ? Icons.trending_up_outlined
              : Icons.trending_down_outlined,
          compact: true,
          valueColor: sdColor,
          trendText: surplusDeficit >= 0 ? 'Surplus' : 'Deficit',
        ),
      ],
    );
  }
}

class _GroundColumn extends StatelessWidget {
  const _GroundColumn({
    required this.name,
    required this.income,
    required this.expenses,
  });

  final String name;
  final double income;
  final double expenses;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final net = income - expenses;
    final netColor = net >= 0 ? AppColors.success : AppColors.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: theme.textTheme.labelMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        SummaryTile(
          label: 'Income',
          value: formatTZS(income, short: true),
          compact: true,
          valueColor: AppColors.success,
        ),
        const SizedBox(height: AppSpacing.xs),
        SummaryTile(
          label: 'Expenses',
          value: formatTZS(expenses, short: true),
          compact: true,
          valueColor: AppColors.error,
        ),
        const SizedBox(height: AppSpacing.xs),
        SummaryTile(
          label: 'Net',
          value: formatTZS(net, short: true),
          compact: true,
          valueColor: netColor,
        ),
      ],
    );
  }
}
