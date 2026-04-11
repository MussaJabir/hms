import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hms/core/models/recurring_record.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/services/services.dart';
import 'package:hms/core/theme/theme.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/rent/providers/rent_generation_providers.dart';
import 'package:hms/features/rent/providers/rent_summary_providers.dart';
import 'package:hms/features/rent/widgets/widgets.dart';
import 'package:intl/intl.dart';

// ---------------------------------------------------------------------------
// Data class passed via GoRouter extra
// ---------------------------------------------------------------------------

class RentPaymentArgs {
  const RentPaymentArgs({required this.record, required this.collectionPath});

  final RecurringRecord record;
  final String collectionPath;
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class RentPaymentScreen extends ConsumerStatefulWidget {
  const RentPaymentScreen({
    super.key,
    required this.record,
    required this.collectionPath,
  });

  final RecurringRecord record;
  final String collectionPath;

  @override
  ConsumerState<RentPaymentScreen> createState() => _RentPaymentScreenState();
}

class _RentPaymentScreenState extends ConsumerState<RentPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountCtrl;
  late double _amount;
  String _paymentMethod = 'cash';
  final _notesCtrl = TextEditingController();
  bool _submitting = false;

  double get _remaining => widget.record.amount - widget.record.amountPaid;

  @override
  void initState() {
    super.initState();
    _amount = _remaining;
    final formatted = NumberFormat('#,##0', 'en_US').format(_remaining.round());
    _amountCtrl = TextEditingController(text: formatted);
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _setAmount(double value) {
    setState(() {
      _amount = value;
      if (value == 0) {
        _amountCtrl.clear();
      } else {
        final formatted = NumberFormat('#,##0', 'en_US').format(value.round());
        _amountCtrl.text = formatted;
      }
    });
  }

  String _calcStatus() {
    return _amount >= _remaining ? 'paid' : 'partial';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    final uid = ref.read(authStateProvider).asData?.value?.uid ?? 'system';
    final recurringService = ref.read(recurringTransactionServiceProvider);
    final activityLog = ref.read(activityLogServiceProvider);
    final newStatus = _calcStatus();
    final newAmountPaid = widget.record.amountPaid + _amount;

    try {
      await recurringService.updateRecordPayment(
        collectionPath: widget.collectionPath,
        recordId: widget.record.id,
        status: newStatus,
        amountPaid: newAmountPaid,
        paymentMethod: _paymentMethod,
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        userId: uid,
      );

      await activityLog.log(
        userId: uid,
        action: 'updated',
        module: 'rent',
        description:
            'Recorded rent payment of ${formatTZS(_amount)} for '
            '${widget.record.linkedEntityName}',
        documentId: widget.record.id,
        collectionPath: widget.collectionPath,
      );

      // Auto-link payment as income so Phase 7 (Finance) picks it up.
      final pathParts = widget.collectionPath.split('/');
      // collectionPath: grounds/{groundId}/rental_units/{unitId}/rent_payments
      if (pathParts.length >= 4) {
        final groundId = pathParts[1];
        final unitId = pathParts[3];
        await ref
            .read(rentIncomeLinkServiceProvider)
            .createIncomeFromRentPayment(
              groundId: groundId,
              tenantId: widget.record.linkedEntityId,
              tenantName: widget.record.linkedEntityName,
              unitName: unitId,
              rentRecordId: widget.record.id,
              amount: _amount,
              userId: uid,
            );
      }

      // Cancel any overdue / due-reminder notifications for this record.
      ref
          .read(rentNotificationServiceProvider)
          .asData
          ?.value
          .cancelRentNotifications(widget.record.id)
          .catchError((e) => null);

      if (!mounted) return;

      // Invalidate generation service so RentListScreen refreshes
      // (rentRecordsForPeriodProvider watches rentGenerationServiceProvider)
      ref.invalidate(rentGenerationServiceProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 18),
              const SizedBox(width: AppSpacing.sm),
              Text('Payment recorded — ${formatTZS(_amount)}'),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to record payment: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final record = widget.record;
    final period = DateFormat('MMMM yyyy').format(
      DateTime(
        int.parse(record.period.split('-')[0]),
        int.parse(record.period.split('-')[1]),
      ),
    );
    final dueFormatted =
        '${record.dueDate.day.toString().padLeft(2, '0')}/'
        '${record.dueDate.month.toString().padLeft(2, '0')}/'
        '${record.dueDate.year}';

    return Scaffold(
      appBar: AppBar(title: const Text('Record Payment')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              // ── Tenant / record info ─────────────────────────────────
              _InfoCard(
                name: record.linkedEntityName,
                period: period,
                dueDate: dueFormatted,
                amountDue: record.amount,
                alreadyPaid: record.amountPaid,
                remaining: _remaining,
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Quick amount buttons ─────────────────────────────────
              QuickAmountButtons(
                fullAmount: _remaining,
                onAmountSelected: _setAmount,
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Amount field ─────────────────────────────────────────
              HmsCurrencyField(
                label: 'Amount Paying',
                controller: _amountCtrl,
                onChanged: (v) => setState(() => _amount = v),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Amount is required';
                  }
                  final raw = double.tryParse(value.replaceAll(',', '')) ?? 0;
                  if (raw <= 0) return 'Amount must be greater than 0';
                  if (raw > widget.record.amount) {
                    return 'Cannot exceed total rent amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Payment method ───────────────────────────────────────
              HmsDropdown<String>(
                label: 'Payment Method',
                value: _paymentMethod,
                items: const [
                  DropdownMenuItem(value: 'cash', child: Text('Cash')),
                  DropdownMenuItem(
                    value: 'mobile_money',
                    child: Text('Mobile Money (M-Pesa / Tigo Pesa)'),
                  ),
                  DropdownMenuItem(
                    value: 'bank_transfer',
                    child: Text('Bank Transfer'),
                  ),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _paymentMethod = v);
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Notes ────────────────────────────────────────────────
              HmsTextField(
                label: 'Notes (optional)',
                controller: _notesCtrl,
                hint: 'e.g. receipt #1234',
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Status preview ───────────────────────────────────────
              if (_amount > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _StatusPreview(
                    amount: _amount,
                    remaining: _remaining,
                    status: _calcStatus(),
                  ),
                ),

              // ── Confirm button ───────────────────────────────────────
              FilledButton(
                onPressed: _amount > 0 && !_submitting ? _submit : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: AppColors.success,
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Confirm Payment',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Info card widget
// ---------------------------------------------------------------------------

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.name,
    required this.period,
    required this.dueDate,
    required this.amountDue,
    required this.alreadyPaid,
    required this.remaining,
  });

  final String name;
  final String period;
  final String dueDate;
  final double amountDue;
  final double alreadyPaid;
  final double remaining;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final secondaryTextColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        color: isDark ? AppColors.darkSurface : AppColors.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Rent for $period',
            style: theme.textTheme.bodySmall?.copyWith(
              color: secondaryTextColor,
            ),
          ),
          Text(
            'Due: $dueDate',
            style: theme.textTheme.bodySmall?.copyWith(
              color: secondaryTextColor,
            ),
          ),
          const Divider(height: AppSpacing.lg),
          _AmountRow(label: 'Amount Due', value: formatTZS(amountDue)),
          if (alreadyPaid > 0) ...[
            const SizedBox(height: AppSpacing.xs),
            _AmountRow(
              label: 'Already Paid',
              value: formatTZS(alreadyPaid),
              valueColor: AppColors.success,
            ),
          ],
          const SizedBox(height: AppSpacing.xs),
          _AmountRow(
            label: 'Remaining',
            value: formatTZS(remaining),
            valueColor: remaining > 0 ? AppColors.error : AppColors.success,
            bold: true,
          ),
        ],
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  const _AmountRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = bold
        ? theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)
        : theme.textTheme.bodyMedium;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style?.copyWith(color: valueColor)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Status preview
// ---------------------------------------------------------------------------

class _StatusPreview extends StatelessWidget {
  const _StatusPreview({
    required this.amount,
    required this.remaining,
    required this.status,
  });

  final double amount;
  final double remaining;
  final String status;

  @override
  Widget build(BuildContext context) {
    final isPaid = status == 'paid';
    final color = isPaid ? AppColors.success : AppColors.warning;
    final label = isPaid ? 'Will be marked PAID' : 'Will be marked PARTIAL';
    final icon = isPaid ? Icons.check_circle_outline : Icons.timelapse_outlined;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
