import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/theme/theme.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/rent/providers/rent_config_providers.dart';
import 'package:hms/features/rent/providers/rent_generation_providers.dart';
import 'package:hms/features/rent/screens/rent_payment_screen.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/recurring_record.dart';

part 'rent_list_screen.g.dart';

// ---------------------------------------------------------------------------
// Period state provider
// ---------------------------------------------------------------------------

@riverpod
class RentListPeriod extends _$RentListPeriod {
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

// ---------------------------------------------------------------------------
// Rent records provider for a period
// ---------------------------------------------------------------------------

@riverpod
Future<List<RecurringRecord>> rentRecordsForPeriod(
  Ref ref,
  String period,
) async {
  final svc = ref.watch(rentGenerationServiceProvider);
  return svc.getRecordsForPeriod(period);
}

// Maps configId → collectionPath so the list screen can build navigation args
@riverpod
Future<Map<String, String>> rentConfigPathMap(Ref ref) async {
  final configs = await ref.watch(activeRentConfigsProvider.future);
  return {for (final c in configs) c.id: c.collectionPath};
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class RentListScreen extends ConsumerWidget {
  const RentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periodDate = ref.watch(rentListPeriodProvider);
    final periodNotifier = ref.read(rentListPeriodProvider.notifier);
    final period = periodNotifier.periodString;
    final isCurrentMonth = periodNotifier.isCurrentMonth;

    final recordsAsync = ref.watch(rentRecordsForPeriodProvider(period));
    final isGeneratedAsync = ref.watch(isCurrentMonthGeneratedProvider);
    final configPathMapAsync = ref.watch(rentConfigPathMapProvider);
    final configPathMap = configPathMapAsync.asData?.value ?? {};
    // selectedGroundId reserved for future ground-scoped filtering
    ref.watch(currentGroundProvider);

    final title = DateFormat('MMMM yyyy').format(periodDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('Rent — $title'),
        actions: [
          // Show Generate button if current month has no records yet
          if (isCurrentMonth)
            isGeneratedAsync.when(
              data: (generated) => generated
                  ? const SizedBox.shrink()
                  : _GenerateButton(period: period),
              loading: () => const SizedBox.shrink(),
              error: (err, st) => const SizedBox.shrink(),
            ),
        ],
      ),
      body: OfflineBanner(
        child: recordsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSpacing.screenPadding),
            child: ShimmerList(itemCount: 5),
          ),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (allRecords) {
            // Filter by selected ground if needed.
            // RecurringRecord doesn't carry groundId directly; we filter by
            // matching the linkedEntityName prefix via collectionPath metadata
            // stored in RecurringConfig. For now, show all — ground filtering
            // at the config level is a Phase 4 refinement.
            final records = allRecords;

            if (records.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: EmptyState(
                  icon: Icons.payments_outlined,
                  title: 'No Rent Records',
                  message: isCurrentMonth
                      ? 'No rent records for this month. Make sure tenants are set up.'
                      : 'No rent records for this period.',
                ),
              );
            }

            // Compute summary totals
            final expected = records.fold<double>(
              0,
              (sum, r) => sum + r.amount,
            );
            final collected = records
                .where((r) => r.status == 'paid' || r.status == 'partial')
                .fold<double>(0, (sum, r) => sum + r.amountPaid);
            final outstanding = expected - collected;

            return CustomScrollView(
              slivers: [
                // ── Summary tiles ──────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      AppSpacing.md,
                      AppSpacing.screenPadding,
                      0,
                    ),
                    child: _SummaryRow(
                      expected: expected,
                      collected: collected,
                      outstanding: outstanding,
                    ),
                  ),
                ),
                // ── Month navigation ───────────────────────────────────
                SliverToBoxAdapter(
                  child: _MonthNavigation(
                    title: title,
                    isCurrentMonth: isCurrentMonth,
                    onPrevious: periodNotifier.previous,
                    onNext: periodNotifier.next,
                  ),
                ),
                // ── Rent cards ─────────────────────────────────────────
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    0,
                    AppSpacing.screenPadding,
                    AppSpacing.screenPadding,
                  ),
                  sliver: SliverList.separated(
                    itemCount: records.length,
                    separatorBuilder: (context2, index2) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, i) => _RentCard(
                      record: records[i],
                      collectionPath: configPathMap[records[i].configId] ?? '',
                    ),
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
    required this.expected,
    required this.collected,
    required this.outstanding,
  });

  final double expected;
  final double collected;
  final double outstanding;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SummaryTile(
            label: 'Expected',
            value: formatTZS(expected, short: true),
            icon: Icons.account_balance_wallet_outlined,
            compact: true,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: SummaryTile(
            label: 'Collected',
            value: formatTZS(collected, short: true),
            icon: Icons.check_circle_outline,
            iconColor: AppColors.success,
            valueColor: AppColors.success,
            compact: true,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: SummaryTile(
            label: 'Outstanding',
            value: formatTZS(outstanding, short: true),
            icon: Icons.schedule_outlined,
            iconColor: outstanding > 0 ? AppColors.error : AppColors.success,
            valueColor: outstanding > 0 ? AppColors.error : AppColors.success,
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

class _RentCard extends StatelessWidget {
  const _RentCard({required this.record, required this.collectionPath});

  final RecurringRecord record;
  final String collectionPath;

  @override
  Widget build(BuildContext context) {
    final status = PaymentStatus.fromString(record.status);
    final isPaid = record.status == 'paid';
    final dueFormatted =
        '${record.dueDate.day.toString().padLeft(2, '0')}/'
        '${record.dueDate.month.toString().padLeft(2, '0')}/'
        '${record.dueDate.year}';

    return AppCard(
      leadingIcon: Icons.payments_outlined,
      leadingIconColor: isPaid ? AppColors.success : null,
      title: record.linkedEntityName,
      subtitle: 'Due: $dueFormatted',
      trailing: StatusBadge(status: status),
      trailingText: formatTZS(record.amount),
      showChevron: !isPaid,
      onTap: () {
        if (isPaid) {
          _showPaidDetails(context);
        } else {
          context.push(
            '/rent/pay',
            extra: RentPaymentArgs(
              record: record,
              collectionPath: collectionPath,
            ),
          );
        }
      },
    );
  }

  void _showPaidDetails(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.borderRadiusLg),
        ),
      ),
      builder: (ctx) {
        final paidDate = record.paidDate;
        final paidDateStr = paidDate != null
            ? '${paidDate.day.toString().padLeft(2, '0')}/'
                  '${paidDate.month.toString().padLeft(2, '0')}/'
                  '${paidDate.year}'
            : '—';
        final methodLabel = switch (record.paymentMethod) {
          'mobile_money' => 'Mobile Money',
          'bank_transfer' => 'Bank Transfer',
          _ => 'Cash',
        };

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
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Payment Recorded',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _DetailRow(label: 'Tenant', value: record.linkedEntityName),
                _DetailRow(
                  label: 'Amount Paid',
                  value: formatTZS(record.amountPaid),
                ),
                _DetailRow(label: 'Paid On', value: paidDateStr),
                _DetailRow(label: 'Method', value: methodLabel),
                if (record.notes != null && record.notes!.isNotEmpty)
                  _DetailRow(label: 'Notes', value: record.notes!),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        );
      },
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(value, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _GenerateButton extends ConsumerWidget {
  const _GenerateButton({required this.period});

  final String period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextButton.icon(
      icon: const Icon(Icons.refresh, size: 18),
      label: const Text('Generate'),
      onPressed: () async {
        final svc = ref.read(rentGenerationServiceProvider);
        // We need a userId — read from auth provider
        final authAsync = ref.read(authStateProvider);
        final uid = authAsync.asData?.value?.uid ?? 'system';
        try {
          final count = await svc.generateCurrentMonth(userId: uid);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Generated $count rent record(s)')),
            );
            ref.invalidate(rentRecordsForPeriodProvider(period));
            ref.invalidate(isCurrentMonthGeneratedProvider);
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Failed to generate: $e')));
          }
        }
      },
    );
  }
}
