import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:hms/core/models/recurring_record.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/water/providers/water_contribution_providers.dart';

class WaterContributionsScreen extends ConsumerStatefulWidget {
  const WaterContributionsScreen({super.key, required this.groundId});

  final String groundId;

  @override
  ConsumerState<WaterContributionsScreen> createState() =>
      _WaterContributionsScreenState();
}

class _WaterContributionsScreenState
    extends ConsumerState<WaterContributionsScreen> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  }

  String get _period =>
      '${_selectedMonth.year}-${_selectedMonth.month.toString().padLeft(2, '0')}';

  String get _periodLabel => DateFormat('MMMM yyyy').format(_selectedMonth);

  void _prevMonth() => setState(
    () => _selectedMonth = DateTime(
      _selectedMonth.year,
      _selectedMonth.month - 1,
    ),
  );

  void _nextMonth() {
    final now = DateTime.now();
    if (_selectedMonth.year == now.year && _selectedMonth.month == now.month) {
      return;
    }
    setState(
      () => _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contributionsAsync = ref.watch(
      monthContributionsProvider(widget.groundId, _period),
    );
    final surplusAsync = ref.watch(
      surplusDeficitProvider(widget.groundId, _period),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Water Contributions — $_periodLabel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _prevMonth,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _nextMonth,
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.screenPadding,
              AppSpacing.screenPadding,
              AppSpacing.sm,
            ),
            sliver: SliverToBoxAdapter(
              child: _SummaryGrid(
                surplusAsync: surplusAsync,
                contributionsAsync: contributionsAsync,
              ),
            ),
          ),
          contributionsAsync.when(
            loading: () => const SliverPadding(
              padding: EdgeInsets.all(AppSpacing.screenPadding),
              sliver: SliverToBoxAdapter(child: ShimmerList(itemCount: 5)),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(
                child: Text(
                  'Error: $e',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
            data: (records) {
              if (records.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.screenPadding),
                      child: EmptyState(
                        icon: Icons.water_drop_outlined,
                        title: 'No contributions yet',
                        message:
                            'Water contributions are created automatically when tenants move in.',
                      ),
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  0,
                  AppSpacing.screenPadding,
                  AppSpacing.screenPadding,
                ),
                sliver: SliverList.separated(
                  itemCount: records.length,
                  separatorBuilder: (_, i) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, i) => _ContributionCard(
                    record: records[i],
                    onPayTap: () => _showPaymentSheet(context, ref, records[i]),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showPaymentSheet(
    BuildContext context,
    WidgetRef ref,
    RecurringRecord record,
  ) async {
    if (record.isPaid) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _QuickPaymentSheet(
        record: record,
        onConfirm: (method) async {
          final userId =
              ref.read(authStateProvider).asData?.value?.uid ?? 'unknown';
          try {
            await ref
                .read(waterContributionServiceProvider)
                .markPaid(
                  recordId: record.id,
                  configId: record.configId,
                  amount: record.amount,
                  paymentMethod: method,
                  userId: userId,
                );
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contribution marked as paid')),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: $e')));
            }
          }
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Summary grid
// ---------------------------------------------------------------------------

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({
    required this.surplusAsync,
    required this.contributionsAsync,
  });

  final AsyncValue<dynamic> surplusAsync;
  final AsyncValue<List<RecurringRecord>> contributionsAsync;

  @override
  Widget build(BuildContext context) {
    final surplus = surplusAsync.asData?.value;
    final records = contributionsAsync.asData?.value ?? [];
    final paidCount = records.where((r) => r.isPaid).length;
    final totalCount = records.length;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SummaryTile(
                label: 'Collected',
                value: surplus != null
                    ? formatTZS(surplus.totalCollected)
                    : '—',
                icon: Icons.check_circle_outline,
                iconColor: Colors.green,
                compact: true,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: SummaryTile(
                label: 'Bill Amount',
                value: surplus != null
                    ? (surplus.actualBillAmount > 0
                          ? formatTZS(surplus.actualBillAmount)
                          : 'No bill yet')
                    : '—',
                icon: Icons.receipt_outlined,
                iconColor: Colors.blue,
                compact: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: SummaryTile(
                label: surplus?.isSurplus == true ? 'Surplus' : 'Deficit',
                value: surplus != null
                    ? formatTZS(surplus.surplusDeficit.abs())
                    : '—',
                icon: surplus?.isSurplus == true
                    ? Icons.trending_up
                    : Icons.trending_down,
                iconColor: surplus?.isSurplus == true
                    ? Colors.green
                    : Colors.red,
                valueColor: surplus?.isSurplus == true
                    ? Colors.green
                    : Colors.red,
                compact: true,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: SummaryTile(
                label: 'Collection Rate',
                value: totalCount > 0
                    ? '${(paidCount / totalCount * 100).toStringAsFixed(0)}%'
                    : '0%',
                icon: Icons.people_outline,
                iconColor: Colors.teal,
                compact: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Contribution card
// ---------------------------------------------------------------------------

class _ContributionCard extends StatelessWidget {
  const _ContributionCard({required this.record, required this.onPayTap});

  final RecurringRecord record;
  final VoidCallback onPayTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      leadingIcon: Icons.water_drop_outlined,
      leadingIconColor: Colors.blue,
      title: record.linkedEntityName,
      subtitle: '${formatTZS(record.amount)} /month',
      trailing: StatusBadge(status: PaymentStatus.fromString(record.status)),
      onTap: (record.isPending || record.isOverdue) ? onPayTap : null,
    );
  }
}

// ---------------------------------------------------------------------------
// Quick payment bottom sheet
// ---------------------------------------------------------------------------

class _QuickPaymentSheet extends StatefulWidget {
  const _QuickPaymentSheet({required this.record, required this.onConfirm});

  final RecurringRecord record;
  final Future<void> Function(String method) onConfirm;

  @override
  State<_QuickPaymentSheet> createState() => _QuickPaymentSheetState();
}

class _QuickPaymentSheetState extends State<_QuickPaymentSheet> {
  String _method = 'Cash';
  bool _loading = false;
  static const _methods = ['Cash', 'Mobile Money', 'Bank Transfer', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.md,
        AppSpacing.screenPadding,
        MediaQuery.of(context).viewInsets.bottom + AppSpacing.screenPadding,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Record Payment',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.record.linkedEntityName,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            formatTZS(widget.record.amount),
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.md),
          InputDecorator(
            decoration: const InputDecoration(labelText: 'Payment method'),
            child: DropdownButton<String>(
              value: _method,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              items: _methods
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (v) => setState(() => _method = v ?? _method),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: _loading
                ? null
                : () async {
                    final nav = Navigator.of(context);
                    setState(() => _loading = true);
                    try {
                      await widget.onConfirm(_method);
                      if (mounted) nav.pop();
                    } finally {
                      if (mounted) setState(() => _loading = false);
                    }
                  },
            child: _loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Confirm Payment'),
          ),
        ],
      ),
    );
  }
}
