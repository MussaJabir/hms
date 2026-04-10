import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hms/core/models/recurring_record.dart';
import 'package:hms/core/theme/theme.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/rent/providers/rent_history_providers.dart';
import 'package:intl/intl.dart';

class TenantRentHistoryScreen extends ConsumerWidget {
  const TenantRentHistoryScreen({
    super.key,
    required this.groundId,
    required this.unitId,
    required this.tenantId,
    this.tenantName = '',
  });

  final String groundId;
  final String unitId;
  final String tenantId;
  final String tenantName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(
      tenantHistoryProvider(groundId, unitId, tenantId),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
        bottom: tenantName.isNotEmpty
            ? PreferredSize(
                preferredSize: const Size.fromHeight(24),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Text(
                    tenantName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: OfflineBanner(
        child: historyAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSpacing.screenPadding),
            child: ShimmerList(itemCount: 4),
          ),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (records) {
            if (records.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.screenPadding),
                child: EmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: 'No Payment History',
                  message: 'No payment records found for this tenant yet.',
                ),
              );
            }

            final totalPaid = records.fold<double>(
              0,
              (sum, r) => sum + r.amountPaid,
            );
            final paidMonths = records.where((r) => r.status == 'paid').length;
            final outstanding = records.where((r) => r.status != 'paid').length;
            final grouped = _groupByYear(records);

            return CustomScrollView(
              slivers: [
                // ── Summary tiles ──────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      AppSpacing.md,
                      AppSpacing.screenPadding,
                      AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SummaryTile(
                            label: 'Total Paid',
                            value: formatTZS(totalPaid, short: true),
                            icon: Icons.payments_outlined,
                            iconColor: AppColors.success,
                            valueColor: AppColors.success,
                            compact: true,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: SummaryTile(
                            label: 'Paid Months',
                            value: '$paidMonths',
                            icon: Icons.check_circle_outline,
                            iconColor: AppColors.success,
                            compact: true,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: SummaryTile(
                            label: 'Outstanding',
                            value: '$outstanding',
                            icon: Icons.schedule_outlined,
                            iconColor: outstanding > 0
                                ? AppColors.error
                                : AppColors.success,
                            valueColor: outstanding > 0
                                ? AppColors.error
                                : AppColors.success,
                            compact: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // ── Year-grouped timeline ──────────────────────────────
                ...grouped.entries.expand((entry) {
                  final year = entry.key;
                  final yearRecords = entry.value;
                  return [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screenPadding,
                          AppSpacing.md,
                          AppSpacing.screenPadding,
                          AppSpacing.xs,
                        ),
                        child: Text(
                          '$year',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                              ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding,
                      ),
                      sliver: SliverList.separated(
                        itemCount: yearRecords.length,
                        separatorBuilder: (ctx, i) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (ctx, i) =>
                            _PaymentCard(record: yearRecords[i]),
                      ),
                    ),
                  ];
                }),
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.screenPadding),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Groups records by year (newest year first).
  Map<int, List<RecurringRecord>> _groupByYear(List<RecurringRecord> records) {
    final map = <int, List<RecurringRecord>>{};
    for (final r in records) {
      final year = int.parse(r.period.split('-')[0]);
      (map[year] ??= []).add(r);
    }
    return Map.fromEntries(
      map.entries.toList()..sort((a, b) => b.key.compareTo(a.key)),
    );
  }
}

// ---------------------------------------------------------------------------
// Payment card
// ---------------------------------------------------------------------------

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.record});

  final RecurringRecord record;

  static final _dateFmt = DateFormat('dd/MM/yyyy');

  IconData get _icon => switch (record.status) {
    'paid' => Icons.check_circle_outline,
    'partial' => Icons.timelapse_outlined,
    'overdue' => Icons.error_outline,
    _ => Icons.schedule_outlined,
  };

  Color get _color => switch (record.status) {
    'paid' => AppColors.success,
    'partial' => AppColors.warning,
    'overdue' => AppColors.error,
    _ => AppColors.textSecondary,
  };

  String get _subtitle {
    final dueStr = _dateFmt.format(record.dueDate);
    return switch (record.status) {
      'paid' when record.paidDate != null =>
        'Paid: ${_dateFmt.format(record.paidDate!)}',
      'partial' => 'Due: $dueStr · Partial',
      'overdue' => 'Due: $dueStr · Overdue',
      _ => 'Due: $dueStr',
    };
  }

  String get _trailingText {
    if (record.amountPaid > 0) {
      return '${formatTZS(record.amountPaid)} / ${formatTZS(record.amount)}';
    }
    return formatTZS(record.amount);
  }

  String _periodToMonth(String period) {
    final parts = period.split('-');
    return DateFormat(
      'MMMM yyyy',
    ).format(DateTime(int.parse(parts[0]), int.parse(parts[1])));
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      leadingIcon: _icon,
      leadingIconColor: _color,
      title: _periodToMonth(record.period),
      subtitle: _subtitle,
      trailing: StatusBadge(status: PaymentStatus.fromString(record.status)),
      trailingText: _trailingText,
      onTap: () => _showDetails(context),
    );
  }

  void _showDetails(BuildContext context) {
    final theme = Theme.of(context);
    final methodLabel = switch (record.paymentMethod) {
      'mobile_money' => 'Mobile Money',
      'bank_transfer' => 'Bank Transfer',
      _ when record.paymentMethod != null => record.paymentMethod!,
      _ => '—',
    };

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.borderRadiusLg),
        ),
      ),
      builder: (ctx) => SafeArea(
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
                  Icon(_icon, color: _color, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      _periodToMonth(record.period),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  StatusBadge(status: PaymentStatus.fromString(record.status)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _DetailRow(label: 'Amount Due', value: formatTZS(record.amount)),
              _DetailRow(
                label: 'Amount Paid',
                value: formatTZS(record.amountPaid),
              ),
              if (record.amountPaid < record.amount)
                _DetailRow(
                  label: 'Remaining',
                  value: formatTZS(record.amount - record.amountPaid),
                  valueColor: AppColors.error,
                ),
              _DetailRow(
                label: 'Due Date',
                value: _dateFmt.format(record.dueDate),
              ),
              if (record.paidDate != null)
                _DetailRow(
                  label: 'Paid On',
                  value: _dateFmt.format(record.paidDate!),
                ),
              _DetailRow(label: 'Method', value: methodLabel),
              if (record.notes != null && record.notes!.isNotEmpty)
                _DetailRow(label: 'Notes', value: record.notes!),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(color: valueColor),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
