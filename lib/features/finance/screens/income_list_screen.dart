import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/theme/theme.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/finance/models/models.dart';
import 'package:hms/features/finance/providers/income_providers.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'income_list_screen.g.dart';

// ---------------------------------------------------------------------------
// Period state + per-period stream
// ---------------------------------------------------------------------------

@riverpod
class IncomeListPeriod extends _$IncomeListPeriod {
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
Stream<List<Income>> incomeForPeriod(Ref ref, String period) {
  return ref.watch(incomeServiceProvider).streamIncomeForMonth(period);
}

// ---------------------------------------------------------------------------
// Source filter
// ---------------------------------------------------------------------------

enum _SourceFilter {
  all('All'),
  rent('Rent'),
  freelance('Freelance'),
  business('Business'),
  other('Other');

  const _SourceFilter(this.label);

  final String label;

  bool matches(Income income) {
    switch (this) {
      case _SourceFilter.all:
        return true;
      case _SourceFilter.rent:
        return income.source == 'rent';
      case _SourceFilter.freelance:
        return income.source == 'freelance';
      case _SourceFilter.business:
        return income.source == 'business';
      case _SourceFilter.other:
        return !const {'rent', 'freelance', 'business'}.contains(income.source);
    }
  }
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class IncomeListScreen extends ConsumerStatefulWidget {
  const IncomeListScreen({super.key});

  @override
  ConsumerState<IncomeListScreen> createState() => _IncomeListScreenState();
}

class _IncomeListScreenState extends ConsumerState<IncomeListScreen> {
  _SourceFilter _filter = _SourceFilter.all;

  @override
  Widget build(BuildContext context) {
    final periodDate = ref.watch(incomeListPeriodProvider);
    final periodNotifier = ref.read(incomeListPeriodProvider.notifier);
    final period = periodNotifier.periodString;
    final isCurrentMonth = periodNotifier.isCurrentMonth;
    final title = DateFormat('MMMM yyyy').format(periodDate);

    final incomeAsync = ref.watch(incomeForPeriodProvider(period));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Income'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add income',
            onPressed: () => context.push('/finance/income/add'),
          ),
        ],
      ),
      body: OfflineBanner(
        child: incomeAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSpacing.screenPadding),
            child: ShimmerList(itemCount: 5),
          ),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (allIncome) {
            final total = allIncome.fold<double>(0, (s, i) => s + i.amount);
            final rentTotal = allIncome
                .where((i) => i.isRentIncome)
                .fold<double>(0, (s, i) => s + i.amount);
            final otherTotal = total - rentTotal;
            final filtered = allIncome
                .where((i) => _filter.matches(i))
                .toList();

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
                      rentTotal: rentTotal,
                      otherTotal: otherTotal,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _FilterChips(
                    selected: _filter,
                    onSelected: (f) => setState(() => _filter = f),
                  ),
                ),
                if (allIncome.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.screenPadding),
                      child: EmptyStatePresets.noIncome(
                        onAdd: () => context.push('/finance/income/add'),
                      ),
                    ),
                  )
                else if (filtered.isEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.screenPadding),
                      child: EmptyState(
                        icon: Icons.filter_alt_off_outlined,
                        title: 'No Matching Income',
                        message:
                            'No income for the selected filter this month.',
                        compact: true,
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      0,
                      AppSpacing.screenPadding,
                      AppSpacing.screenPadding,
                    ),
                    sliver: SliverList.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, i) =>
                          _IncomeCard(income: filtered[i]),
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
    required this.rentTotal,
    required this.otherTotal,
  });

  final double total;
  final double rentTotal;
  final double otherTotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SummaryTile(
            label: 'Total This Month',
            value: formatTZS(total, short: true),
            icon: Icons.account_balance_wallet_outlined,
            iconColor: AppColors.success,
            valueColor: AppColors.success,
            compact: true,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: SummaryTile(
            label: 'Rent Income',
            value: formatTZS(rentTotal, short: true),
            icon: Icons.payments_outlined,
            valueColor: AppColors.success,
            compact: true,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: SummaryTile(
            label: 'Other Income',
            value: formatTZS(otherTotal, short: true),
            icon: Icons.attach_money_outlined,
            valueColor: AppColors.success,
            compact: true,
          ),
        ),
      ],
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.selected, required this.onSelected});

  final _SourceFilter selected;
  final ValueChanged<_SourceFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        itemCount: _SourceFilter.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) {
          final filter = _SourceFilter.values[i];
          return Center(
            child: ChoiceChip(
              label: Text(filter.label),
              selected: filter == selected,
              onSelected: (_) => onSelected(filter),
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

class _IncomeCard extends StatelessWidget {
  const _IncomeCard({required this.income});

  final Income income;

  @override
  Widget build(BuildContext context) {
    final src = IncomeSource.fromString(income.source);
    final dateStr = DateFormat('dd/MM/yyyy').format(income.date);

    return AppCard(
      leadingIcon: src.icon,
      leadingIconColor: AppColors.success,
      title: income.description,
      subtitle: '${src.label} · $dateStr',
      showChevron: !income.isAutoLinked,
      trailing: _TrailingAmount(
        amount: income.amount,
        isAutoLinked: income.isAutoLinked,
      ),
      onTap: () {
        if (income.isAutoLinked) {
          _showAutoLinkedDetails(context);
        } else {
          context.push('/finance/income/${income.id}/edit', extra: income);
        }
      },
    );
  }

  void _showAutoLinkedDetails(BuildContext context) {
    final theme = Theme.of(context);
    final src = IncomeSource.fromString(income.source);
    final dateStr = DateFormat('dd/MM/yyyy').format(income.date);

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
                        'Auto-linked Income',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'This entry was created automatically from a rent payment '
                  'and is managed from the rent module.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                _DetailRow(label: 'Description', value: income.description),
                _DetailRow(label: 'Source', value: src.label),
                _DetailRow(label: 'Amount', value: formatTZS(income.amount)),
                _DetailRow(label: 'Date', value: dateStr),
                if (income.notes.isNotEmpty)
                  _DetailRow(label: 'Notes', value: income.notes),
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
            color: AppColors.success,
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
