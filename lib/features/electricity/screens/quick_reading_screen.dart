import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/electricity/models/electricity_meter.dart';
import 'package:hms/features/electricity/providers/meter_providers.dart';
import 'package:hms/features/electricity/providers/meter_reading_providers.dart';
import 'package:hms/features/electricity/services/meter_reading_service.dart';
import 'package:hms/features/grounds/models/rental_unit.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';
import 'package:hms/features/grounds/providers/rental_unit_providers.dart';

class QuickReadingScreen extends ConsumerStatefulWidget {
  const QuickReadingScreen({super.key, required this.groundId});

  final String groundId;

  @override
  ConsumerState<QuickReadingScreen> createState() => _QuickReadingScreenState();
}

class _QuickReadingScreenState extends ConsumerState<QuickReadingScreen> {
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final groundAsync = ref.watch(groundByIdProvider(widget.groundId));
    final unitsAsync = ref.watch(allUnitsProvider(widget.groundId));
    final groundName = groundAsync.asData?.value?.name ?? 'Ground';

    return Scaffold(
      appBar: AppBar(title: Text('Quick Reading — $groundName')),
      body: unitsAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: ShimmerList(itemCount: 5),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (units) {
          if (units.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: EmptyState(
                  icon: Icons.electric_meter_outlined,
                  title: 'No Units',
                  message: 'Add rental units to this property first.',
                ),
              ),
            );
          }
          return _UnitReadingList(
            groundId: widget.groundId,
            units: units,
            saving: _saving,
            onSavingChanged: (v) => setState(() => _saving = v),
          );
        },
      ),
    );
  }
}

// ── Unit list with inline reading entry ─────────────────────────────────────

class _UnitReadingList extends ConsumerStatefulWidget {
  const _UnitReadingList({
    required this.groundId,
    required this.units,
    required this.saving,
    required this.onSavingChanged,
  });

  final String groundId;
  final List<RentalUnit> units;
  final bool saving;
  final ValueChanged<bool> onSavingChanged;

  @override
  ConsumerState<_UnitReadingList> createState() => _UnitReadingListState();
}

class _UnitReadingListState extends ConsumerState<_UnitReadingList> {
  // Map<unitId, controller>
  final Map<String, TextEditingController> _controllers = {};
  // Map<unitId, bool> — whether save was successful
  final Map<String, bool> _saved = {};
  final List<FocusNode> _focusNodes = [];
  final _readingDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.units.length; i++) {
      _controllers[widget.units[i].id] = TextEditingController();
      _focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  Future<void> _saveAll() async {
    final userId = ref.read(authStateProvider).asData?.value?.uid ?? 'unknown';
    final service = ref.read(meterReadingServiceProvider);

    widget.onSavingChanged(true);
    int savedCount = 0;

    for (final unit in widget.units) {
      final ctrl = _controllers[unit.id];
      if (ctrl == null || ctrl.text.trim().isEmpty) continue;

      final newReading = double.tryParse(ctrl.text.trim());
      if (newReading == null) continue;

      final meterAsync = ref.read(
        activeMeterProvider(widget.groundId, unit.id),
      );
      final meter = meterAsync.asData?.value;
      if (meter == null) continue;

      try {
        await service.recordReading(
          groundId: widget.groundId,
          unitId: unit.id,
          meterId: meter.id,
          newReading: newReading,
          readingDate: _readingDate,
          confirmReset: false,
          userId: userId,
        );
        setState(() => _saved[unit.id] = true);
        savedCount++;
      } on MeterResetRequiredException catch (e) {
        if (!mounted) break;
        final confirmed = await _showResetDialog(
          unit.name,
          e.newReading,
          e.previousReading,
        );
        if (confirmed == true) {
          try {
            await service.recordReading(
              groundId: widget.groundId,
              unitId: unit.id,
              meterId: meter.id,
              newReading: newReading,
              readingDate: _readingDate,
              confirmReset: true,
              userId: userId,
            );
            setState(() => _saved[unit.id] = true);
            savedCount++;
          } catch (_) {}
        }
      } catch (_) {}
    }

    widget.onSavingChanged(false);
    if (!mounted) return;
    if (savedCount > 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$savedCount reading(s) saved.')));
    }
  }

  Future<void> _saveOne(RentalUnit unit, ElectricityMeter meter) async {
    final ctrl = _controllers[unit.id];
    if (ctrl == null || ctrl.text.trim().isEmpty) return;
    final newReading = double.tryParse(ctrl.text.trim());
    if (newReading == null) return;

    final userId = ref.read(authStateProvider).asData?.value?.uid ?? 'unknown';
    final service = ref.read(meterReadingServiceProvider);

    try {
      await service.recordReading(
        groundId: widget.groundId,
        unitId: unit.id,
        meterId: meter.id,
        newReading: newReading,
        readingDate: _readingDate,
        confirmReset: false,
        userId: userId,
      );
      setState(() => _saved[unit.id] = true);
    } on MeterResetRequiredException catch (e) {
      if (!mounted) return;
      final confirmed = await _showResetDialog(
        unit.name,
        e.newReading,
        e.previousReading,
      );
      if (confirmed == true) {
        await service.recordReading(
          groundId: widget.groundId,
          unitId: unit.id,
          meterId: meter.id,
          newReading: newReading,
          readingDate: _readingDate,
          confirmReset: true,
          userId: userId,
        );
        if (mounted) setState(() => _saved[unit.id] = true);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<bool?> _showResetDialog(
    String unitName,
    double newReading,
    double previousReading,
  ) {
    final fmt = NumberFormat('#,##0.##');
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Meter Reset — $unitName?'),
        content: Text(
          'Reading ${fmt.format(newReading)} is less than previous '
          '${fmt.format(previousReading)}. Continue as meter reset?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Skip'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Record'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Only units that have a meter registered.
    final unitsWithMeters = widget.units
        .where(
          (u) =>
              ref
                  .watch(activeMeterProvider(widget.groundId, u.id))
                  .asData
                  ?.value !=
              null,
        )
        .toList();

    return Column(
      children: [
        Expanded(
          child: unitsWithMeters.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    child: EmptyState(
                      icon: Icons.electric_meter_outlined,
                      title: 'No Meters Registered',
                      message:
                          'Register meters for your units to use quick reading.',
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  itemCount: unitsWithMeters.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final unit = unitsWithMeters[index];
                    final meter = ref
                        .watch(activeMeterProvider(widget.groundId, unit.id))
                        .asData!
                        .value!;
                    final focusNode =
                        _focusNodes[widget.units.indexWhere(
                          (u) => u.id == unit.id,
                        )];
                    final nextFocusNode = index < unitsWithMeters.length - 1
                        ? _focusNodes[widget.units.indexWhere(
                            (u) => u.id == unitsWithMeters[index + 1].id,
                          )]
                        : null;
                    return _QuickReadingCard(
                      unit: unit,
                      meter: meter,
                      controller: _controllers[unit.id]!,
                      isSaved: _saved[unit.id] ?? false,
                      focusNode: focusNode,
                      onSubmit: () {
                        if (nextFocusNode != null) {
                          nextFocusNode.requestFocus();
                        } else {
                          FocusScope.of(context).unfocus();
                        }
                      },
                      onSave: () => _saveOne(unit, meter),
                    );
                  },
                ),
        ),
        // ── Save All button ─────────────────────────────────────────────
        if (unitsWithMeters.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: FilledButton.icon(
              onPressed: widget.saving ? null : _saveAll,
              icon: widget.saving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_outlined),
              label: const Text('Save All'),
            ),
          ),
      ],
    );
  }
}

// ── Individual unit reading card ─────────────────────────────────────────────

class _QuickReadingCard extends ConsumerStatefulWidget {
  const _QuickReadingCard({
    required this.unit,
    required this.meter,
    required this.controller,
    required this.isSaved,
    required this.focusNode,
    required this.onSubmit,
    required this.onSave,
  });

  final RentalUnit unit;
  final ElectricityMeter meter;
  final TextEditingController controller;
  final bool isSaved;
  final FocusNode focusNode;
  final VoidCallback onSubmit;
  final VoidCallback onSave;

  @override
  ConsumerState<_QuickReadingCard> createState() => _QuickReadingCardState();
}

class _QuickReadingCardState extends ConsumerState<_QuickReadingCard> {
  double? _liveConsumed;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_recalc);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_recalc);
    super.dispose();
  }

  void _recalc() {
    final raw = double.tryParse(widget.controller.text.trim());
    setState(() => _liveConsumed = raw);
  }

  @override
  Widget build(BuildContext context) {
    final prevReading = widget.meter.currentReading;
    final isNegative = _liveConsumed != null && _liveConsumed! < prevReading;
    final consumed = _liveConsumed == null
        ? null
        : isNegative
        ? null
        : _liveConsumed! - prevReading;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header row ───────────────────────────────────────────────
            Row(
              children: [
                const Icon(Icons.electric_meter_outlined, size: 18),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    '${widget.unit.name} · ${widget.meter.meterNumber}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                if (widget.isSaved)
                  Icon(
                    Icons.check_circle_outline,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
              ],
            ),
            Text(
              'Prev: ${NumberFormat('#,##0.##').format(prevReading)} units',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            // ── Inline input row ─────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: widget.controller,
                    focusNode: widget.focusNode,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    enabled: !widget.isSaved,
                    decoration: const InputDecoration(
                      labelText: 'Current Reading',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                    onFieldSubmitted: (_) => widget.onSubmit(),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton.filled(
                  onPressed: widget.isSaved ? null : widget.onSave,
                  icon: const Icon(Icons.check, size: 18),
                  tooltip: 'Save',
                  style: IconButton.styleFrom(minimumSize: const Size(40, 40)),
                ),
              ],
            ),
            // ── Live calculation ─────────────────────────────────────────
            if (_liveConsumed != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                isNegative
                    ? 'Meter reset or replaced?'
                    : '${consumed!.toStringAsFixed(1)} units consumed',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isNegative
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
