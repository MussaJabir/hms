import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/theme/app_colors.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/auth/providers/user_providers.dart';
import 'package:hms/features/water/models/water_bill.dart';
import 'package:hms/features/water/providers/water_bill_providers.dart';
import 'package:hms/features/water/models/water_surplus_deficit.dart';
import 'package:hms/features/water/providers/water_contribution_providers.dart';

class WaterBillDetailScreen extends ConsumerWidget {
  const WaterBillDetailScreen({
    super.key,
    required this.groundId,
    required this.billId,
    required this.bill,
  });

  final String groundId;
  final String billId;
  final WaterBill bill;

  String _formatPeriod(String period) {
    try {
      return DateFormat(
        'MMMM yyyy',
      ).format(DateFormat('yyyy-MM').parse(period));
    } catch (_) {
      return period;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSuperAdmin =
        ref.watch(currentUserProfileProvider).asData?.value?.isSuperAdmin ??
        false;
    final AsyncValue<WaterSurplusDeficit> surplusAsync = ref.watch(
      surplusDeficitProvider(groundId, bill.billingPeriod),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_formatPeriod(bill.billingPeriod)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
            onPressed: () => context.push(
              '/grounds/$groundId/water/$billId/edit',
              extra: bill,
            ),
          ),
          if (isSuperAdmin)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Delete',
              color: AppColors.error,
              onPressed: () => _confirmDelete(context, ref),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Amount + status
            _AmountHeader(bill: bill),
            const SizedBox(height: AppSpacing.lg),

            // Details card
            _DetailCard(bill: bill),
            const SizedBox(height: AppSpacing.md),

            // SMS data if available
            if (bill.hasSmsData) ...[
              _SmsDataCard(smsText: bill.rawSmsText!),
              const SizedBox(height: AppSpacing.md),
            ],

            // Notes
            if (bill.notes.isNotEmpty) ...[
              _NotesCard(notes: bill.notes),
              const SizedBox(height: AppSpacing.md),
            ],

            // Tenant contributions summary for this period
            _ContributionsSummaryCard(surplusAsync: surplusAsync),
            const SizedBox(height: AppSpacing.md),

            // Mark paid action
            if (!bill.isPaid) ...[
              const SizedBox(height: AppSpacing.sm),
              ElevatedButton.icon(
                onPressed: () => _showMarkPaidDialog(context, ref),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Mark as Paid'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _showMarkPaidDialog(BuildContext context, WidgetRef ref) async {
    String? selectedMethod;
    const methods = ['Cash', 'Mobile Money', 'Bank Transfer', 'Other'];

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Mark as Paid'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select payment method:'),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                initialValue: selectedMethod,
                hint: const Text('Payment method'),
                items: methods
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (v) => setState(() => selectedMethod = v),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: selectedMethod == null
                  ? null
                  : () async {
                      Navigator.of(ctx).pop();
                      await _markPaid(context, ref, selectedMethod!);
                    },
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _markPaid(
    BuildContext context,
    WidgetRef ref,
    String method,
  ) async {
    try {
      final userId =
          ref.read(authStateProvider).asData?.value?.uid ?? 'unknown';
      await ref
          .read(waterBillServiceProvider)
          .markPaid(
            groundId: groundId,
            billId: billId,
            paymentMethod: method,
            userId: userId,
          );
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Bill marked as paid')));
      context.pop();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Bill'),
        content: Text(
          'Delete the bill for ${_formatPeriod(bill.billingPeriod)}? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    try {
      final userId =
          ref.read(authStateProvider).asData?.value?.uid ?? 'unknown';
      await ref
          .read(waterBillServiceProvider)
          .deleteBill(groundId: groundId, billId: billId, userId: userId);
      messenger.showSnackBar(const SnackBar(content: Text('Bill deleted')));
      router.pop();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}

class _AmountHeader extends StatelessWidget {
  const _AmountHeader({required this.bill});
  final WaterBill bill;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            formatTZS(bill.totalAmount),
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          StatusBadge(status: PaymentStatus.fromString(bill.status)),
          if (bill.isPaid && bill.paidDate != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Paid on ${DateFormat('dd/MM/yyyy').format(bill.paidDate!)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.bill});
  final WaterBill bill;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            _DetailRow(
              label: 'Billing Period',
              value: DateFormat(
                'MMMM yyyy',
              ).format(DateFormat('yyyy-MM').parse(bill.billingPeriod)),
            ),
            const Divider(height: AppSpacing.lg),
            _DetailRow(
              label: 'Previous Reading',
              value: '${bill.previousMeterReading.toStringAsFixed(1)} m³',
            ),
            const Divider(height: AppSpacing.lg),
            _DetailRow(
              label: 'Current Reading',
              value: '${bill.currentMeterReading.toStringAsFixed(1)} m³',
            ),
            const Divider(height: AppSpacing.lg),
            _DetailRow(
              label: 'Units Consumed',
              value: '${bill.unitsConsumed.toStringAsFixed(1)} m³',
            ),
            const Divider(height: AppSpacing.lg),
            _DetailRow(
              label: 'Due Date',
              value: DateFormat('dd/MM/yyyy').format(bill.dueDate),
            ),
            if (bill.paymentMethod != null) ...[
              const Divider(height: AppSpacing.lg),
              _DetailRow(label: 'Payment Method', value: bill.paymentMethod!),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _SmsDataCard extends StatefulWidget {
  const _SmsDataCard({required this.smsText});
  final String smsText;

  @override
  State<_SmsDataCard> createState() => _SmsDataCardState();
}

class _SmsDataCardState extends State<_SmsDataCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Icons.sms_outlined, size: 20),
            title: const Text('Parsed from SMS'),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () => setState(() => _expanded = !_expanded),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: Text(
                widget.smsText,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
              ),
            ),
        ],
      ),
    );
  }
}

class _ContributionsSummaryCard extends StatelessWidget {
  const _ContributionsSummaryCard({required this.surplusAsync});

  final AsyncValue<WaterSurplusDeficit> surplusAsync;

  @override
  Widget build(BuildContext context) {
    final surplus = surplusAsync.asData?.value;
    if (surplus == null || surplus.totalTenants == 0) {
      return const SizedBox.shrink();
    }

    final surplusValue = surplus.surplusDeficit;
    final collected = surplus.totalCollected;
    final billAmount = surplus.actualBillAmount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tenant Contributions This Period',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const Divider(height: AppSpacing.lg),
            _DetailRow(
              label: 'Tenant contributions',
              value: formatTZS(collected),
            ),
            const Divider(height: AppSpacing.lg),
            _DetailRow(label: 'Bill amount', value: formatTZS(billAmount)),
            const Divider(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  surplusValue >= 0 ? 'Surplus' : 'You absorbed',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  formatTZS(surplusValue.abs()),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: surplusValue >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NotesCard extends StatelessWidget {
  const _NotesCard({required this.notes});
  final String notes;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notes', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(notes, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
