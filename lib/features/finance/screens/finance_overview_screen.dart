import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/theme/theme.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/finance/models/budget.dart';
import 'package:hms/features/finance/models/expense.dart';
import 'package:hms/features/finance/models/expense_category.dart';
import 'package:hms/features/finance/models/financial_summary.dart';
import 'package:hms/features/finance/models/income.dart';
import 'package:hms/features/finance/models/income_source.dart';
import 'package:hms/features/finance/providers/budget_providers.dart';
import 'package:hms/features/finance/providers/expense_providers.dart';
import 'package:hms/features/finance/providers/financial_summary_providers.dart';
import 'package:hms/features/finance/providers/income_providers.dart';
import 'package:hms/features/finance/widgets/budget_progress_card.dart';
import 'package:hms/features/finance/widgets/category_breakdown_chart.dart';
import 'package:hms/features/finance/widgets/net_position_card.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'finance_overview_screen.g.dart';

// ---------------------------------------------------------------------------
// Period state + per-period providers
// ---------------------------------------------------------------------------

@riverpod
class FinanceOverviewPeriod extends _$FinanceOverviewPeriod {
  @override
  DateTime build() => DateTime(DateTime.now().year, DateTime.now().month, 1);

  void previous() => state = DateTime(state.year, state.month - 1, 1);

  void next() {
    final now = DateTime.now();
    final next = DateTime(state.year, state.month + 1, 1);
    if (!next.isAfter(DateTime(now.year, now.month, 1))) state = next;
  }

  bool get isCurrentMonth {
    final now = DateTime.now();
    return state.year == now.year && state.month == now.month;
  }

  String get periodString {
    final mm = state.month.toString().padLeft(2, '0');
    return '${state.year}-$mm';
  }
}

@riverpod
Future<FinancialSummary> financeSummaryForPeriod(Ref ref, String period) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(financialSummaryServiceProvider)
      .getSummary(period, groundId: groundId);
}

@riverpod
Stream<List<Income>> financeIncomeForPeriod(Ref ref, String period) {
  return ref.watch(incomeServiceProvider).streamIncomeForMonth(period);
}

@riverpod
Stream<List<Expense>> financeExpensesForPeriod(Ref ref, String period) {
  return ref.watch(expenseServiceProvider).streamExpensesForMonth(period);
}

@riverpod
Stream<List<Budget>> financeBudgetsForPeriod(Ref ref, String period) {
  return ref.watch(budgetServiceProvider).streamBudgetsForPeriod(period);
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

/// The finance hub: income, expenses, and budget summaries across three tabs,
/// with a net-position card pinned below and a shared month selector.
class FinanceOverviewScreen extends ConsumerStatefulWidget {
  const FinanceOverviewScreen({super.key});

  @override
  ConsumerState<FinanceOverviewScreen> createState() =>
      _FinanceOverviewScreenState();
}

class _FinanceOverviewScreenState extends ConsumerState<FinanceOverviewScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final periodDate = ref.watch(financeOverviewPeriodProvider);
    final notifier = ref.read(financeOverviewPeriodProvider.notifier);
    final period = notifier.periodString;
    final monthLabel = DateFormat('MMMM yyyy').format(periodDate);
    final summaryAsync = ref.watch(financeSummaryForPeriodProvider(period));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Income'),
            Tab(text: 'Expenses'),
            Tab(text: 'Budget'),
          ],
        ),
      ),
      body: OfflineBanner(
        child: Column(
          children: [
            _MonthNavigation(
              title: monthLabel,
              isCurrentMonth: notifier.isCurrentMonth,
              onPrevious: notifier.previous,
              onNext: notifier.next,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _IncomeTab(period: period),
                  _ExpensesTab(period: period),
                  _BudgetTab(period: period),
                ],
              ),
            ),
            // ── Net position (visible under every tab) ───────────────────
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: NetPositionCard(
                totalIncome: summaryAsync.asData?.value.totalIncome ?? 0,
                totalExpenses: summaryAsync.asData?.value.totalExpenses ?? 0,
                onTap: () => context.push('/report'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Income tab
// ---------------------------------------------------------------------------

class _IncomeTab extends ConsumerWidget {
  const _IncomeTab({required this.period});

  final String period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(financeSummaryForPeriodProvider(period));
    final incomeAsync = ref.watch(financeIncomeForPeriodProvider(period));

    return summaryAsync.when(
      loading: () => const _TabShimmer(),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (summary) {
        final recent = incomeAsync.asData?.value ?? const <Income>[];
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            Row(
              children: [
                Expanded(
                  child: SummaryTile(
                    label: 'Total Income',
                    value: formatTZS(summary.totalIncome, short: true),
                    icon: Icons.arrow_downward,
                    iconColor: AppColors.success,
                    valueColor: AppColors.success,
                    compact: true,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: SummaryTile(
                    label: 'Rent Income',
                    value: formatTZS(summary.rentIncome, short: true),
                    icon: Icons.home_work_outlined,
                    compact: true,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: SummaryTile(
                    label: 'Other Income',
                    value: formatTZS(summary.otherIncome, short: true),
                    icon: Icons.attach_money_outlined,
                    compact: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            if (summary.incomeBySource.isNotEmpty) ...[
              Text(
                'Income by Source',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              CategoryBreakdownChart(
                categoryTotals: summary.incomeBySource,
                totalAmount: summary.totalIncome,
                labelOf: (k) => IncomeSource.fromString(k).label,
                iconOf: (k) => IncomeSource.fromString(k).icon,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            _RecentHeader(
              title: 'Recent Income',
              onViewAll: () => context.push('/finance/income'),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (recent.isEmpty)
              const EmptyState(
                icon: Icons.payments_outlined,
                title: 'No income yet',
                message: 'Income for this month will appear here.',
                compact: true,
              )
            else
              ...recent.take(5).map((i) => _IncomeRow(income: i)),
          ],
        );
      },
    );
  }
}

class _IncomeRow extends StatelessWidget {
  const _IncomeRow({required this.income});

  final Income income;

  @override
  Widget build(BuildContext context) {
    final source = IncomeSource.fromString(income.source);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        leadingIcon: source.icon,
        leadingIconColor: AppColors.success,
        title: income.description,
        subtitle:
            '${source.label} · ${DateFormat('dd/MM/yyyy').format(income.date)}',
        trailingText: formatTZS(income.amount),
        trailingTextColor: AppColors.success,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Expenses tab
// ---------------------------------------------------------------------------

class _ExpensesTab extends ConsumerWidget {
  const _ExpensesTab({required this.period});

  final String period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(financeSummaryForPeriodProvider(period));
    final expensesAsync = ref.watch(financeExpensesForPeriodProvider(period));

    return summaryAsync.when(
      loading: () => const _TabShimmer(),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (summary) {
        final recent = expensesAsync.asData?.value ?? const <Expense>[];
        final dailyAverage = summary.totalExpenses / _daysInPeriod(period);
        final topCategory = _topCategory(summary.expensesByCategory);

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            Row(
              children: [
                Expanded(
                  child: SummaryTile(
                    label: 'Total Expenses',
                    value: formatTZS(summary.totalExpenses, short: true),
                    icon: Icons.arrow_upward,
                    iconColor: AppColors.error,
                    valueColor: AppColors.error,
                    compact: true,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: SummaryTile(
                    label: 'Daily Average',
                    value: formatTZS(dailyAverage, short: true),
                    icon: Icons.show_chart_outlined,
                    compact: true,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: SummaryTile(
                    label: 'Top Category',
                    value: topCategory == null
                        ? '—'
                        : ExpenseCategory.fromString(topCategory).label,
                    icon: Icons.category_outlined,
                    compact: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            if (summary.expensesByCategory.isNotEmpty) ...[
              Text(
                'Expenses by Category',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              CategoryBreakdownChart(
                categoryTotals: summary.expensesByCategory,
                totalAmount: summary.totalExpenses,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
            _RecentHeader(
              title: 'Recent Expenses',
              onViewAll: () => context.push('/finance/expenses'),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (recent.isEmpty)
              const EmptyState(
                icon: Icons.receipt_long_outlined,
                title: 'No expenses yet',
                message: 'Expenses for this month will appear here.',
                compact: true,
              )
            else
              ...recent.take(5).map((e) => _ExpenseRow(expense: e)),
          ],
        );
      },
    );
  }
}

class _ExpenseRow extends StatelessWidget {
  const _ExpenseRow({required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final cat = ExpenseCategory.fromString(expense.category);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        leadingIcon: cat.icon,
        leadingIconColor: AppColors.error,
        title: expense.description,
        subtitle:
            '${cat.label} · ${DateFormat('dd/MM/yyyy').format(expense.date)}',
        trailingText: formatTZS(expense.amount),
        trailingTextColor: AppColors.error,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Budget tab
// ---------------------------------------------------------------------------

class _BudgetTab extends ConsumerWidget {
  const _BudgetTab({required this.period});

  final String period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(financeBudgetsForPeriodProvider(period));

    return budgetsAsync.when(
      loading: () => const _TabShimmer(),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (budgets) {
        final onTrack = budgets.where((b) => b.isOnTrack).length;
        final overLimit = budgets.where((b) => b.isOverLimit).length;
        final compliance = budgets.isEmpty
            ? 100.0
            : onTrack / budgets.length * 100;
        // Highest spend percentage first — the budgets needing attention.
        final sorted = [...budgets]
          ..sort((a, b) => b.spentPercentage.compareTo(a.spentPercentage));

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            Row(
              children: [
                Expanded(
                  child: SummaryTile(
                    label: 'Compliance',
                    value: '${compliance.round()}%',
                    icon: Icons.verified_outlined,
                    compact: true,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: SummaryTile(
                    label: 'On Track',
                    value: '$onTrack',
                    icon: Icons.check_circle_outline,
                    valueColor: AppColors.success,
                    compact: true,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: SummaryTile(
                    label: 'Over Budget',
                    value: '$overLimit',
                    icon: Icons.error_outline,
                    valueColor: overLimit > 0
                        ? AppColors.error
                        : AppColors.textSecondary,
                    compact: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _RecentHeader(
              title: 'Budgets',
              viewAllLabel: 'Manage Budgets',
              onViewAll: () => context.push('/finance/budget'),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (sorted.isEmpty)
              EmptyState(
                icon: Icons.pie_chart_outline,
                title: 'No budgets set',
                message: 'Set monthly limits to track spending.',
                actionLabel: 'Set Up Budgets',
                onAction: () => context.push('/finance/budget/setup'),
                compact: true,
              )
            else
              ...sorted.map(
                (b) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: BudgetProgressCard(
                    budget: b,
                    onTap: () =>
                        context.push('/finance/expenses/add/${b.category}'),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Shared widgets / helpers
// ---------------------------------------------------------------------------

class _RecentHeader extends StatelessWidget {
  const _RecentHeader({
    required this.title,
    required this.onViewAll,
    this.viewAllLabel = 'View All',
  });

  final String title;
  final String viewAllLabel;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        TextButton(onPressed: onViewAll, child: Text('$viewAllLabel →')),
      ],
    );
  }
}

class _TabShimmer extends StatelessWidget {
  const _TabShimmer();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.screenPadding),
      child: ShimmerList(itemCount: 4),
    );
  }
}

class _MonthNavigation extends StatelessWidget {
  const _MonthNavigation({
    required this.title,
    required this.isCurrentMonth,
    required this.onPrevious,
    required this.onNext,
  });

  final String title;
  final bool isCurrentMonth;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            tooltip: 'Previous month',
            onPressed: onPrevious,
          ),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: isCurrentMonth ? Theme.of(context).disabledColor : null,
            ),
            tooltip: 'Next month',
            onPressed: isCurrentMonth ? null : onNext,
          ),
        ],
      ),
    );
  }
}

/// Number of days to divide by for the daily average: full month length for a
/// past month, days elapsed for the current month.
int _daysInPeriod(String period) {
  final parts = period.split('-');
  final year = int.tryParse(parts[0]) ?? DateTime.now().year;
  final month = int.tryParse(parts[1]) ?? DateTime.now().month;
  final now = DateTime.now();
  if (year == now.year && month == now.month) return now.day;
  return DateTime(year, month + 1, 0).day;
}

String? _topCategory(Map<String, double> byCategory) {
  if (byCategory.isEmpty) return null;
  final entries = byCategory.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  return entries.first.key;
}
