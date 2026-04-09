import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/grounds/models/settlement.dart';
import 'package:hms/features/grounds/providers/move_out_providers.dart';
import 'package:intl/intl.dart';

class SettlementHistoryScreen extends ConsumerWidget {
  const SettlementHistoryScreen({
    super.key,
    required this.groundId,
    required this.unitId,
    required this.unitName,
  });

  final String groundId;
  final String unitId;
  final String unitName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settlementsAsync = ref.watch(settlementsProvider(groundId, unitId));

    return Scaffold(
      appBar: AppBar(title: Text('$unitName — Settlement History')),
      body: settlementsAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: ShimmerList(itemCount: 3),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
        ),
        data: (settlements) {
          if (settlements.isEmpty) {
            return const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'No Past Tenants',
              message: 'Settlement records will appear here after a move-out.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: settlements.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final s = settlements[index];
              return _SettlementCard(
                settlement: s,
                groundId: groundId,
                unitId: unitId,
              );
            },
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Settlement card with tap-to-detail
// ---------------------------------------------------------------------------

class _SettlementCard extends ConsumerWidget {
  const _SettlementCard({
    required this.settlement,
    required this.groundId,
    required this.unitId,
  });

  final Settlement settlement;
  final String groundId;
  final String unitId;

  static final _dateFmt = DateFormat('dd/MM/yyyy');

  PaymentStatus _badgeStatus(String status) => switch (status) {
    'settled' => PaymentStatus.paid,
    'waived' => PaymentStatus.waived,
    _ => PaymentStatus.pending,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = settlement;
    return AppCard(
      leadingIcon: Icons.receipt_outlined,
      title: s.tenantName,
      subtitle: 'Moved out: ${_dateFmt.format(s.moveOutDate)}',
      trailing: StatusBadge(status: _badgeStatus(s.status), small: true),
      trailingText: s.isPending ? formatTZS(s.totalOutstanding) : null,
      onTap: () => _showDetail(context, ref),
    );
  }

  Future<void> _showDetail(BuildContext context, WidgetRef ref) async {
    final theme = Theme.of(context);
    final s = settlement;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.md,
          AppSpacing.screenPadding,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Settlement — ${s.tenantName}',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Moved out: ${DateFormat('dd/MM/yyyy').format(s.moveOutDate)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const Divider(height: AppSpacing.lg * 2),
            _DetailRow('Outstanding Rent', formatTZS(s.outstandingRent)),
            const SizedBox(height: AppSpacing.sm),
            _DetailRow('Outstanding Water', formatTZS(s.outstandingWater)),
            const SizedBox(height: AppSpacing.sm),
            _DetailRow('Other Charges', formatTZS(s.otherCharges)),
            const Divider(height: AppSpacing.lg * 2),
            _DetailRow(
              'Total Outstanding',
              formatTZS(s.totalOutstanding),
              bold: true,
            ),
            if (s.notes.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                'Notes:',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(s.notes, style: theme.textTheme.bodyMedium),
            ],
            if (s.isPending) ...[
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        Navigator.of(ctx).pop();
                        await _waive(context, ref);
                      },
                      child: const Text('Waive Balance'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        Navigator.of(ctx).pop();
                        await _markSettled(context, ref);
                      },
                      child: const Text('Mark Settled'),
                    ),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [StatusBadge(status: _badgeStatus(s.status))],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _markSettled(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final userId = ref.read(authStateProvider).asData?.value?.uid ?? 'unknown';
    try {
      await ref
          .read(moveOutServiceProvider)
          .markSettled(
            groundId: groundId,
            unitId: unitId,
            settlementId: settlement.id,
            userId: userId,
          );
      ref.invalidate(settlementsProvider(groundId, unitId));
      if (context.mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Settlement marked as settled.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _waive(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final userId = ref.read(authStateProvider).asData?.value?.uid ?? 'unknown';
    try {
      await ref
          .read(moveOutServiceProvider)
          .waiveBalance(
            groundId: groundId,
            unitId: unitId,
            settlementId: settlement.id,
            userId: userId,
          );
      ref.invalidate(settlementsProvider(groundId, unitId));
      if (context.mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Balance waived.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value, {this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = bold
        ? theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)
        : theme.textTheme.bodyMedium;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}
