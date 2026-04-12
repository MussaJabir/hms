import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/core/utils/validators.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/electricity/providers/meter_providers.dart';
import 'package:hms/features/electricity/providers/meter_reading_providers.dart';
import 'package:hms/features/electricity/providers/tariff_providers.dart';
import 'package:hms/features/electricity/services/meter_reading_service.dart';
import 'package:hms/features/grounds/providers/rental_unit_providers.dart';

class RecordReadingScreen extends ConsumerStatefulWidget {
  const RecordReadingScreen({
    super.key,
    required this.groundId,
    required this.unitId,
    required this.meterId,
  });

  final String groundId;
  final String unitId;
  final String meterId;

  @override
  ConsumerState<RecordReadingScreen> createState() =>
      _RecordReadingScreenState();
}

class _RecordReadingScreenState extends ConsumerState<RecordReadingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _readingController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _readingDate = DateTime.now();
  bool _loading = false;

  // Live-calculated consumption (null until user types something).
  double? _liveConsumed;

  @override
  void initState() {
    super.initState();
    _readingController.addListener(_onReadingChanged);
  }

  void _onReadingChanged() {
    final raw = double.tryParse(_readingController.text.trim());
    setState(() => _liveConsumed = raw);
  }

  @override
  void dispose() {
    _readingController.removeListener(_onReadingChanged);
    _readingController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit({bool confirmReset = false}) async {
    if (!_formKey.currentState!.validate()) return;

    final newReading = double.parse(_readingController.text.trim());
    final userId = ref.read(authStateProvider).asData?.value?.uid ?? 'unknown';
    final service = ref.read(meterReadingServiceProvider);

    setState(() => _loading = true);
    try {
      await service.recordReading(
        groundId: widget.groundId,
        unitId: widget.unitId,
        meterId: widget.meterId,
        newReading: newReading,
        readingDate: _readingDate,
        confirmReset: confirmReset,
        notes: _notesController.text.trim(),
        userId: userId,
      );

      if (!mounted) return;
      // Determine consumed units to show in snackbar.
      final meterAsync = ref.read(
        activeMeterProvider(widget.groundId, widget.unitId),
      );
      final prevReading = meterAsync.asData?.value?.currentReading ?? 0;
      final consumed = newReading >= prevReading
          ? newReading - prevReading
          : newReading;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Reading recorded — ${consumed.toStringAsFixed(1)} units consumed',
          ),
        ),
      );
      Navigator.of(context).pop();
    } on MeterResetRequiredException catch (e) {
      setState(() => _loading = false);
      if (!mounted) return;
      final confirmed = await _showResetDialog(e.newReading, e.previousReading);
      if (confirmed == true) {
        await _submit(confirmReset: true);
      }
    } catch (e) {
      setState(() => _loading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<bool?> _showResetDialog(double newReading, double previousReading) {
    final fmt = NumberFormat('#,##0.##');
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Meter Reset?'),
        content: Text(
          'The reading you entered (${fmt.format(newReading)}) is less than the '
          'previous reading (${fmt.format(previousReading)}). This usually means '
          'the meter was reset or replaced. Continue anyway?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Yes, Record'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final meterAsync = ref.watch(
      activeMeterProvider(widget.groundId, widget.unitId),
    );
    final unitAsync = ref.watch(
      unitByIdProvider(widget.groundId, widget.unitId),
    );

    final meter = meterAsync.asData?.value;
    final unitName = unitAsync.asData?.value?.name ?? 'Unit';
    final prevReading = meter?.currentReading ?? 0;
    final lastDateText = meter?.lastReadingDate != null
        ? DateFormat('dd/MM/yyyy').format(meter!.lastReadingDate!)
        : 'Never';
    final meterNumber = meter?.meterNumber ?? widget.meterId;

    // Live consumption display
    final isNegative = _liveConsumed != null && _liveConsumed! < prevReading;
    final consumedUnits = (!isNegative && _liveConsumed != null)
        ? _liveConsumed! - prevReading
        : null;
    final consumedLabel = _liveConsumed == null
        ? '—'
        : isNegative
        ? 'Meter reset or replaced?'
        : '${consumedUnits!.toStringAsFixed(1)} units';

    // Live cost estimate using current tariff tiers.
    final tariffsAsync = ref.watch(currentTariffsProvider);
    final tiers = tariffsAsync.asData?.value ?? [];
    final liveCost = consumedUnits != null && tiers.isNotEmpty
        ? ref
              .read(tariffServiceProvider)
              .calculateCostWithTiers(
                unitsConsumed: consumedUnits,
                tiers: tiers,
              )
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Record Reading')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Meter info card ──────────────────────────────────────────
              AppCard(
                leadingIcon: Icons.electric_meter_outlined,
                title: '$unitName — $meterNumber',
                subtitle:
                    'Previous: ${NumberFormat('#,##0.##').format(prevReading)} units · Last: $lastDateText',
              ),
              const SizedBox(height: AppSpacing.lg),
              // ── Current reading input ─────────────────────────────────���──
              HmsTextField(
                label: 'Current Reading',
                hint: 'e.g. ${(prevReading + 50).toStringAsFixed(0)}',
                controller: _readingController,
                keyboardType: TextInputType.number,
                autofocus: true,
                validator: (v) => Validators.required(v, fieldName: 'Reading'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.sm),
              // ── Live consumption indicator ────────────────────────────────
              Row(
                children: [
                  const Icon(Icons.bolt_outlined, size: 16),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Units consumed: $consumedLabel',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isNegative
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              // ── Estimated cost ──────────────────────────────────────────
              if (liveCost != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    const Icon(Icons.receipt_outlined, size: 16),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Estimated cost: ${formatTZS(liveCost)} (reference only)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              // ── Date picker ──────────────────────────────────────────────
              HmsDatePicker(
                label: 'Reading Date',
                selectedDate: _readingDate,
                lastDate: DateTime.now(),
                onDateSelected: (d) => setState(() => _readingDate = d),
              ),
              const SizedBox(height: AppSpacing.md),
              // ── Notes ────────────────────────────────────────────────────
              HmsTextField(
                label: 'Notes (optional)',
                hint: 'e.g. Power cut on 3rd, reading estimated',
                controller: _notesController,
                maxLines: 2,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: _loading ? null : () => _submit(),
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save Reading'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
