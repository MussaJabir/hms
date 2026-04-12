import 'package:flutter/material.dart';
import 'package:hms/core/models/app_config.dart';
import 'package:hms/core/theme/app_spacing.dart';

/// Editable row for a single TANESCO tariff tier.
///
/// Manages its own [TextEditingController]s internally and fires [onChanged]
/// whenever any field value changes.
class TariffTierEditor extends StatefulWidget {
  const TariffTierEditor({
    super.key,
    required this.tierNumber,
    required this.tier,
    required this.isTopTier,
    required this.onChanged,
    this.onRemove,
  });

  final int tierNumber;
  final TanescoTier tier;
  final bool isTopTier;
  final ValueChanged<TanescoTier> onChanged;

  /// Null means this tier cannot be removed (minimum tier count enforced by
  /// the parent).
  final VoidCallback? onRemove;

  @override
  State<TariffTierEditor> createState() => _TariffTierEditorState();
}

class _TariffTierEditorState extends State<TariffTierEditor> {
  late final TextEditingController _fromCtrl;
  late final TextEditingController _toCtrl;
  late final TextEditingController _rateCtrl;

  @override
  void initState() {
    super.initState();
    _fromCtrl = TextEditingController(
      text: widget.tier.minUnits.toStringAsFixed(0),
    );
    _toCtrl = TextEditingController(
      text: widget.isTopTier ? '∞' : widget.tier.maxUnits.toStringAsFixed(0),
    );
    _rateCtrl = TextEditingController(
      text: widget.tier.ratePerUnit.toStringAsFixed(0),
    );

    _fromCtrl.addListener(_notify);
    _toCtrl.addListener(_notify);
    _rateCtrl.addListener(_notify);
  }

  @override
  void didUpdateWidget(TariffTierEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Temporarily remove listeners so that programmatic text changes don't
    // trigger _notify (which calls onChanged → setState during build).
    _fromCtrl.removeListener(_notify);
    _toCtrl.removeListener(_notify);
    _rateCtrl.removeListener(_notify);

    final newFrom = widget.tier.minUnits.toStringAsFixed(0);
    if (_fromCtrl.text != newFrom) _fromCtrl.text = newFrom;

    final newTo = widget.isTopTier
        ? '∞'
        : widget.tier.maxUnits.toStringAsFixed(0);
    if (_toCtrl.text != newTo) _toCtrl.text = newTo;

    final newRate = widget.tier.ratePerUnit.toStringAsFixed(0);
    if (_rateCtrl.text != newRate) _rateCtrl.text = newRate;

    _fromCtrl.addListener(_notify);
    _toCtrl.addListener(_notify);
    _rateCtrl.addListener(_notify);
  }

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    _rateCtrl.dispose();
    super.dispose();
  }

  void _notify() {
    final from = double.tryParse(_fromCtrl.text.trim()) ?? widget.tier.minUnits;
    final to = widget.isTopTier
        ? double.infinity
        : (double.tryParse(_toCtrl.text.trim()) ?? widget.tier.maxUnits);
    final rate =
        double.tryParse(_rateCtrl.text.trim()) ?? widget.tier.ratePerUnit;
    widget.onChanged(
      TanescoTier(minUnits: from, maxUnits: to, ratePerUnit: rate),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Tier label + remove button ──────────────────────────────────
        Row(
          children: [
            Text(
              'Tier ${widget.tierNumber}',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            if (widget.onRemove != null)
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, size: 18),
                color: theme.colorScheme.error,
                tooltip: 'Remove tier',
                onPressed: widget.onRemove,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        // ── Three inline fields ─────────────────────────────────────────
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _fromCtrl,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'From',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (double.tryParse(v.trim()) == null) return 'Invalid';
                  return null;
                },
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: TextFormField(
                controller: _toCtrl,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                readOnly: widget.isTopTier,
                decoration: InputDecoration(
                  labelText: 'To',
                  isDense: true,
                  border: const OutlineInputBorder(),
                  fillColor: widget.isTopTier
                      ? Theme.of(context).colorScheme.surfaceContainerHighest
                      : null,
                  filled: widget.isTopTier,
                ),
                validator: widget.isTopTier
                    ? null
                    : (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        if (double.tryParse(v.trim()) == null) return 'Invalid';
                        return null;
                      },
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: TextFormField(
                controller: _rateCtrl,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'TZS/unit',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  final rate = double.tryParse(v.trim());
                  if (rate == null || rate <= 0) return 'Must be > 0';
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
