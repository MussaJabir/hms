import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/theme/app_colors.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/grounds/models/rental_unit.dart';
import 'package:hms/features/grounds/models/tenant.dart';
import 'package:hms/features/grounds/providers/move_out_providers.dart';
import 'package:intl/intl.dart';

class MoveOutScreen extends ConsumerStatefulWidget {
  const MoveOutScreen({
    super.key,
    required this.groundId,
    required this.unitId,
    required this.tenant,
    required this.unit,
  });

  final String groundId;
  final String unitId;
  final Tenant tenant;
  final RentalUnit unit;

  @override
  ConsumerState<MoveOutScreen> createState() => _MoveOutScreenState();
}

class _MoveOutScreenState extends ConsumerState<MoveOutScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _rentController;
  late final TextEditingController _waterController;
  late final TextEditingController _otherController;
  late final TextEditingController _notesController;

  DateTime _moveOutDate = DateTime.now();
  bool _loading = false;

  static final _dateFmt = DateFormat('dd/MM/yyyy');

  double get _rent =>
      double.tryParse(
        _rentController.text.replaceAll(',', '').replaceAll('TZS ', ''),
      ) ??
      0;
  double get _water =>
      double.tryParse(
        _waterController.text.replaceAll(',', '').replaceAll('TZS ', ''),
      ) ??
      0;
  double get _other =>
      double.tryParse(
        _otherController.text.replaceAll(',', '').replaceAll('TZS ', ''),
      ) ??
      0;
  double get _total => _rent + _water + _other;

  @override
  void initState() {
    super.initState();
    _rentController = TextEditingController(text: '0');
    _waterController = TextEditingController(text: '0');
    _otherController = TextEditingController(text: '0');
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _rentController.dispose();
    _waterController.dispose();
    _otherController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Process Move-Out')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Summary card ──────────────────────────────────────────────
              Card(
                color: theme.colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.exit_to_app_outlined,
                            color: theme.colorScheme.onErrorContainer,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'Moving ${widget.tenant.fullName} out of'
                              ' ${widget.unit.name} on'
                              ' ${_dateFmt.format(_moveOutDate)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onErrorContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'This will mark the unit as vacant and stop all'
                        ' recurring charges for this tenant.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onErrorContainer.withValues(
                            alpha: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Move-out date ──────────────────────────────────────────────
              HmsDatePicker(
                label: 'Move-Out Date',
                selectedDate: _moveOutDate,
                onDateSelected: (date) => setState(() => _moveOutDate = date),
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Outstanding balances ───────────────────────────────────────
              Text(
                'Outstanding Balances',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              HmsCurrencyField(
                label: 'Outstanding Rent',
                controller: _rentController,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.md),
              HmsCurrencyField(
                label: 'Outstanding Water',
                controller: _waterController,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.md),
              HmsCurrencyField(
                label: 'Other Charges',
                controller: _otherController,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Total outstanding ──────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: _total > 0
                      ? theme.colorScheme.errorContainer
                      : theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Outstanding',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      formatTZS(_total),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _total > 0
                            ? theme.colorScheme.onErrorContainer
                            : theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Notes ─────────────────────────────────────────────────────
              HmsTextField(
                label: 'Notes (optional)',
                hint: 'e.g. Returned keys, minor wall damage noted.',
                controller: _notesController,
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Action button ──────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                  ),
                  onPressed: _loading ? null : _confirmAndProcess,
                  icon: _loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.exit_to_app_outlined),
                  label: Text(_loading ? 'Processing…' : 'Process Move-Out'),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmAndProcess() async {
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Move-Out'),
        content: Text(
          'Move out ${widget.tenant.fullName} from ${widget.unit.name}?\n\n'
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Yes, Move Out'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _loading = true);
    final userId = ref.read(authStateProvider).asData?.value?.uid ?? 'unknown';
    final groundId = widget.groundId;
    final unitId = widget.unitId;

    try {
      await ref
          .read(moveOutServiceProvider)
          .processMoveOut(
            groundId: groundId,
            unitId: unitId,
            tenantId: widget.tenant.id,
            tenantName: widget.tenant.fullName,
            moveOutDate: _moveOutDate,
            outstandingRent: _rent,
            outstandingWater: _water,
            otherCharges: _other,
            notes: _notesController.text.trim(),
            userId: userId,
          );

      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Move-out processed. ${widget.unit.name} is now vacant.',
          ),
        ),
      );
      router.go('/grounds/$groundId/units');
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
