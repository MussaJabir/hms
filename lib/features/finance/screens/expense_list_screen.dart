import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/theme/theme.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/finance/models/models.dart';
import 'package:hms/features/finance/providers/expense_providers.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'expense_list_screen.g.dart';

// ---------------------------------------------------------------------------
// Period state + per-period stream
// ---------------------------------------------------------------------------

@riverpod
class ExpenseListPeriod extends _$ExpenseListPeriod {
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

  /// Days elapsed in the selected month — used for daily averages. The current
  /// month counts up to today; past months count their full length.
  int get daysElapsed {
    final now = DateTime.now();
    if (isCurrentMonth) return now.day;
    return DateTime(state.year, state.month + 1, 0).day; // last day of month
  }
}

@riverpod
Stream<List<Expense>> expensesForPeriod(Ref ref, String period) {
  return ref.watch(expenseServiceProvider).streamExpensesForMonth(period);
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class ExpenseListScreen extends ConsumerStatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  ConsumerState<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends ConsumerState<ExpenseListScreen> {
  /// Selected category filter; null = All.
  String? _categoryFilter;

  @override
  Widget build(BuildContext context) {
    final periodDate = ref.watch(expenseListPeriodProvider);
    final periodNotifier = ref.read(expenseListPeriodProvider.notifier);
    final period = periodNotifier.periodString;
    final isCurrentMonth = periodNotifier.isCurrentMonth;
    final daysElapsed = periodNotifier.daysElapsed;
    final title = DateFormat('MMMM yyyy').format(periodDate);

    final expensesAsync = ref.watch(expensesForPeriodProvider(period));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add expense',
            onPressed: () => context.push('/finance/expenses/add'),
          ),
        ],
      ),
      body: OfflineBanner(
        child: expensesAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSpacing.screenPadding),
            child: ShimmerList(itemCount: 5),
          ),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (allExpenses) {
            final total = allExpenses.fold<double>(0, (s, e) => s + e.amount);
            final dailyAverage = daysElapsed > 0 ? total / daysElapsed : 0.0;
            final usedCategories = allExpenses.map((e) => e.category).toSet();

            // Keep the active filter only while that category still has data.
            final activeFilter =
                _categoryFilter != null &&
                    usedCategories.contains(_categoryFilter)
                ? _categoryFilter
                : null;
            final filtered = activeFilter == null
                ? allExpenses
                : allExpenses.where((e) => e.category == activeFilter).toList();

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _MonthNavigation(
                    title: title,
                    isCurrentMonth: isCurrentMonth,
                    onPrevious: periodNotifier.previous,
                    onNext: periodNotifier.next,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      0,
                      AppSpacing.screenPadding,
                      AppSpacing.md,
                    ),
                    child: _SummaryRow(
                      total: total,
                      dailyAverage: dailyAverage,
                      categoryCount: usedCategories.length,
                    ),
                  ),
                ),
                if (usedCategories.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _CategoryFilterChips(
                      usedCategories: usedCategories,
                      selected: activeFilter,
                      onSelected: (c) => setState(() => _categoryFilter = c),
                    ),
                  ),
                if (allExpenses.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.screenPadding),
                      child: EmptyStatePresets.noExpenses(
                        onAdd: () => context.push('/finance/expenses/add'),
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
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, i) =>
                          _ExpenseCard(expense: filtered[i]),
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
    required this.total,
    required this.dailyAverage,
    required this.categoryCount,
  });

  final double total;
  final double dailyAverage;
  final int categoryCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SummaryTile(
            label: 'Total This Month',
            value: formatTZS(total, short: true),
            icon: Icons.receipt_long_outlined,
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
            valueColor: AppColors.error,
            compact: true,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: SummaryTile(
            label: 'Categories',
            value: '$categoryCount',
            icon: Icons.category_outlined,
            compact: true,
          ),
        ),
      ],
    );
  }
}

class _CategoryFilterChips extends StatelessWidget {
  const _CategoryFilterChips({
    required this.usedCategories,
    required this.selected,
    required this.onSelected,
  });

  final Set<String> usedCategories;
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    // "All" first, then one chip per ExpenseCategory that has entries, kept in
    // the enum's declaration order.
    final categories = ExpenseCategory.values
        .where((c) => usedCategories.contains(c.value))
        .toList();

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        itemCount: categories.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) {
          if (i == 0) {
            return Center(
              child: ChoiceChip(
                label: const Text('All'),
                selected: selected == null,
                onSelected: (_) => onSelected(null),
              ),
            );
          }
          final category = categories[i - 1];
          return Center(
            child: ChoiceChip(
              avatar: Icon(category.icon, size: 16),
              label: Text(category.label),
              selected: selected == category.value,
              onSelected: (_) => onSelected(category.value),
            ),
          );
        },
      ),
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

class _ExpenseCard extends StatelessWidget {
  const _ExpenseCard({required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final cat = ExpenseCategory.fromString(expense.category);
    final dateStr = DateFormat('dd/MM/yyyy').format(expense.date);

    return AppCard(
      leadingIcon: cat.icon,
      leadingIconColor: AppColors.error,
      title: expense.description,
      subtitle: '${cat.label} · $dateStr',
      showChevron: !expense.isAutoLinked,
      trailing: _TrailingAmount(
        amount: expense.amount,
        isAutoLinked: expense.isAutoLinked,
      ),
      onTap: () {
        if (expense.isAutoLinked) {
          _showAutoLinkedDetails(context);
        } else {
          context.push('/finance/expenses/${expense.id}/edit', extra: expense);
        }
      },
    );
  }

  void _showAutoLinkedDetails(BuildContext context) {
    final theme = Theme.of(context);
    final cat = ExpenseCategory.fromString(expense.category);
    final dateStr = DateFormat('dd/MM/yyyy').format(expense.date);

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.borderRadiusLg),
        ),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Auto-linked Expense',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'This entry was created automatically from the '
                  '${expense.module ?? 'source'} module and is managed there.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _DetailRow(label: 'Description', value: expense.description),
                _DetailRow(label: 'Category', value: cat.label),
                _DetailRow(label: 'Amount', value: formatTZS(expense.amount)),
                _DetailRow(label: 'Date', value: dateStr),
                if (expense.notes.isNotEmpty)
                  _DetailRow(label: 'Notes', value: expense.notes),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TrailingAmount extends StatelessWidget {
  const _TrailingAmount({required this.amount, required this.isAutoLinked});

  final double amount;
  final bool isAutoLinked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          formatTZS(amount),
          style: theme.textTheme.labelLarge?.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (isAutoLinked) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.lock_outline,
                size: 12,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 2),
              Text(
                'Auto',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
