import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/utils/validators.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/electricity/models/electricity_meter.dart';
import 'package:hms/features/electricity/providers/meter_providers.dart';

class MeterReplacementScreen extends ConsumerStatefulWidget {
  const MeterReplacementScreen({
    super.key,
    required this.groundId,
    required this.unitId,
    required this.currentMeterId,
  });

  final String groundId;
  final String unitId;
  final String currentMeterId;

  @override
  ConsumerState<MeterReplacementScreen> createState() =>
      _MeterReplacementScreenState();
}

class _MeterReplacementScreenState
    extends ConsumerState<MeterReplacementScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _newMeterNumberController;
  late final TextEditingController _newInitialReadingController;
  late final TextEditingController _newThresholdController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _newMeterNumberController = TextEditingController();
    _newInitialReadingController = TextEditingController();
    _newThresholdController = TextEditingController();
  }

  @override
  void dispose() {
    _newMeterNumberController.dispose();
    _newInitialReadingController.dispose();
    _newThresholdController.dispose();
    super.dispose();
  }

  Future<void> _confirmAndReplace(ElectricityMeter currentMeter) async {
    if (!_formKey.currentState!.validate()) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Replace Meter?'),
        content: const Text(
          'The old meter will be marked inactive but its data is preserved. '
          'The new meter starts a fresh reading history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Replace'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _loading = true);

    final userId = ref.read(authStateProvider).asData?.value?.uid ?? 'unknown';
    final service = ref.read(meterServiceProvider);
    final initialReading =
        double.tryParse(_newInitialReadingController.text.trim()) ?? 0;
    final threshold =
        double.tryParse(_newThresholdController.text.trim()) ??
        currentMeter.weeklyThreshold;

    final newMeter = ElectricityMeter(
      id: '',
      groundId: widget.groundId,
      unitId: widget.unitId,
      meterNumber: _newMeterNumberController.text.trim(),
      initialReading: initialReading,
      weeklyThreshold: threshold,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      updatedBy: userId,
    );

    try {
      await service.replaceMeter(
        widget.groundId,
        widget.unitId,
        widget.currentMeterId,
        newMeter,
        userId,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meter replaced successfully.')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final meterAsync = ref.watch(
      activeMeterProvider(widget.groundId, widget.unitId),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Replace Meter')),
      body: meterAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
        ),
        data: (currentMeter) {
          if (currentMeter == null) {
            return const Center(child: Text('No active meter found.'));
          }
          return _buildBody(currentMeter);
        },
      ),
    );
  }

  Widget _buildBody(ElectricityMeter currentMeter) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Current meter info ─────────────────────────────────────────
          AppCard(
            leadingIcon: Icons.electric_meter_outlined,
            title: 'Current Meter: ${currentMeter.meterNumber}',
            subtitle: currentMeter.lastReadingDate != null
                ? 'Last reading: ${currentMeter.currentReading.toStringAsFixed(1)} units'
                : 'No readings recorded',
          ),
          const SizedBox(height: AppSpacing.md),
          // ── Warning banner ─────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.warning_amber_outlined,
                  size: 18,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Replacing a meter starts a fresh reading history. '
                    'The old meter\'s data is preserved.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'New Meter Details',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.md),
          // ── New meter form ─────────────────────────────────────────────
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HmsTextField(
                  label: 'New Meter Number',
                  hint: 'Physical meter ID on the new meter',
                  controller: _newMeterNumberController,
                  validator: (v) =>
                      Validators.required(v, fieldName: 'Meter number'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.md),
                HmsTextField(
                  label: 'New Meter Initial Reading (units)',
                  hint: '0',
                  controller: _newInitialReadingController,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return null;
                    final parsed = double.tryParse(v.trim());
                    if (parsed == null || parsed < 0) {
                      return 'Enter a valid reading (0 or more)';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: AppSpacing.md),
                HmsTextField(
                  label: 'Weekly Threshold (units, optional)',
                  hint: currentMeter.hasThreshold
                      ? currentMeter.weeklyThreshold.toStringAsFixed(0)
                      : 'e.g. 50',
                  controller: _newThresholdController,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return null;
                    final parsed = double.tryParse(v.trim());
                    if (parsed == null || parsed < 0) {
                      return 'Enter a valid threshold (0 or more)';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                ),
                if (currentMeter.hasThreshold) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Defaults to old meter threshold: '
                    '${currentMeter.weeklyThreshold.toStringAsFixed(0)} units/week',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  onPressed: _loading
                      ? null
                      : () => _confirmAndReplace(currentMeter),
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Replace Meter'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
