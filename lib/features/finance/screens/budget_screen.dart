import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/theme/theme.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/finance/models/budget.dart';
import 'package:hms/features/finance/providers/budget_providers.dart';
import 'package:hms/features/finance/widgets/budget_progress_card.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budget_screen.g.dart';

// ---------------------------------------------------------------------------
// Period state + per-period stream
// ---------------------------------------------------------------------------

@riverpod
class BudgetPeriod extends _$BudgetPeriod {
  @override
  DateTime build() => DateTime(DateTime.now().year, DateTime.now().month, 1);

  void previous() {
    state = DateTime(state.year, state.month - 1, 1);
  }

  void next() {
    final now = DateTime.now();
    final next = DateTime(state.year, state.month + 1, 1);
    if (!next.isAfter(DateTime(now.year, now.month, 1))) {
      state = next;
    }
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
Stream<List<Budget>> budgetsForPeriod(Ref ref, String period) {
  return ref.watch(budgetServiceProvider).streamBudgetsForPeriod(period);
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh recorded spending against actual expenses when the screen opens
    // so the bars reflect any expenses added since the budgets were set.
    WidgetsBinding.instance.addPostFrameCallback((_) => _recalculate());
  }

  Future<void> _recalculate() async {
    final period = ref.read(budgetPeriodProvider.notifier).periodString;
    try {
      await ref.read(budgetServiceProvider).recalculateSpent(period, 'system');
    } catch (_) {
      // Best-effort refresh; the stream still shows last-known spend.
    }
  }

  @override
  Widget build(BuildContext context) {
    final periodDate = ref.watch(budgetPeriodProvider);
    final periodNotifier = ref.read(budgetPeriodProvider.notifier);
    final period = periodNotifier.periodString;
    final isCurrentMonth = periodNotifier.isCurrentMonth;
    final monthLabel = DateFormat('MMMM yyyy').format(periodDate);

    final budgetsAsync = ref.watch(budgetsForPeriodProvider(period));

    return Scaffold(
      appBar: AppBar(
        title: Text('Budget — $monthLabel'),
        actions: [
          budgetsAsync.maybeWhen(
            data: (budgets) => TextButton(
              onPressed: () => context.push('/finance/budget/setup'),
              child: Text(budgets.isEmpty ? 'Set Up' : 'Edit'),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: OfflineBanner(
        child: budgetsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSpacing.screenPadding),
            child: ShimmerList(itemCount: 5),
          ),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (budgets) {
            final totalLimit = budgets.fold<double>(
              0,
              (s, b) => s + b.limitAmount,
            );
            final totalSpent = budgets.fold<double>(
              0,
              (s, b) => s + b.spentAmount,
            );
            final onTrack = budgets.where((b) => b.isOnTrack).length;
            final compliance = budgets.isEmpty
                ? 100.0
                : onTrack / budgets.length * 100;
            final spentRatio = totalLimit > 0 ? totalSpent / totalLimit : 0.0;
            final spentColor = spentRatio >= 1
                ? AppColors.error
                : spentRatio >= 0.8
                ? AppColors.warning
                : AppColors.success;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _MonthNavigation(
                    title: monthLabel,
                    isCurrentMonth: isCurrentMonth,
                    onPrevious: periodNotifier.previous,
                    onNext: periodNotifier.next,
                  ),
                ),
                if (budgets.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screenPadding,
                        0,
                        AppSpacing.screenPadding,
                        AppSpacing.md,
                      ),
                      child: _SummaryRow(
                        totalLimit: totalLimit,
                        totalSpent: totalSpent,
                        spentColor: spentColor,
                        compliance: compliance,
                      ),
                    ),
                  ),
                if (budgets.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.screenPadding),
                      child: EmptyState(
                        icon: Icons.pie_chart_outline,
                        title: 'No Budgets Set',
                        message:
                            'Set up your first monthly budget to track '
                            'spending against limits.',
                        actionLabel: 'Set Up Budgets',
                        onAction: () => context.push('/finance/budget/setup'),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      AppSpacing.sm,
                      AppSpacing.screenPadding,
                      AppSpacing.screenPadding,
                    ),
                    sliver: SliverList.separated(
                      itemCount: budgets.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, i) {
                        final budget = budgets[i];
                        return BudgetProgressCard(
                          budget: budget,
                          onTap: () => context.push(
                            '/finance/expenses/add/${budget.category}',
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets
// ---------------------------------------------------------------------------

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.totalLimit,
    required this.totalSpent,
    required this.spentColor,
    required this.compliance,
  });

  final double totalLimit;
  final double totalSpent;
  final Color spentColor;
  final double compliance;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SummaryTile(
            label: 'Total Budget',
            value: formatTZS(totalLimit, short: true),
            icon: Icons.account_balance_wallet_outlined,
            compact: true,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: SummaryTile(
            label: 'Total Spent',
            value: formatTZS(totalSpent, short: true),
            icon: Icons.receipt_long_outlined,
            iconColor: spentColor,
            valueColor: spentColor,
            compact: true,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: SummaryTile(
            label: 'Compliance',
            value: '${compliance.round()}%',
            icon: Icons.verified_outlined,
            compact: true,
          ),
        ),
      ],
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
        vertical: AppSpacing.sm,
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
