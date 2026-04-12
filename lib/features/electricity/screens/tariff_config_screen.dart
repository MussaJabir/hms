import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/models/app_config.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/features/auth/providers/user_providers.dart';
import 'package:hms/features/electricity/providers/tariff_providers.dart';
import 'package:hms/features/electricity/widgets/tariff_tier_editor.dart';

class TariffConfigScreen extends ConsumerStatefulWidget {
  const TariffConfigScreen({super.key});

  @override
  ConsumerState<TariffConfigScreen> createState() => _TariffConfigScreenState();
}

class _TariffConfigScreenState extends ConsumerState<TariffConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  List<TanescoTier> _tiers = [];
  bool _loading = false;
  bool _initialised = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialised) return;
    // Guard: redirect non-Super-Admin users.
    final profile = ref.read(currentUserProfileProvider).asData?.value;
    if (profile != null && !profile.isSuperAdmin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/');
      });
    }
  }

  void _initTiersIfNeeded(AsyncValue<List<TanescoTier>> tariffsAsync) {
    if (_initialised) return;
    final data = tariffsAsync.asData?.value;
    if (data == null) return; // still loading
    _initialised = true;
    final service = ref.read(tariffServiceProvider);
    // Direct assignment is safe here because this is called during build()
    // when the widget is already being rebuilt due to the provider change.
    // No setState needed — the current frame will pick up the new value.
    _tiers = data.isNotEmpty ? data : service.getDefaultTariffs();
  }

  void _updateTier(int index, TanescoTier updated) {
    setState(() => _tiers[index] = updated);
  }

  void _addTier() {
    final last = _tiers.last;
    final newMin = last.maxUnits == double.infinity
        ? last.minUnits + 100
        : last.maxUnits + 1;
    setState(() {
      // Demote current top tier by giving it a finite maxUnits.
      if (_tiers.last.maxUnits == double.infinity) {
        _tiers[_tiers.length - 1] = TanescoTier(
          minUnits: _tiers.last.minUnits,
          maxUnits: newMin - 1,
          ratePerUnit: _tiers.last.ratePerUnit,
        );
      }
      _tiers.add(
        TanescoTier(
          minUnits: newMin,
          maxUnits: double.infinity,
          ratePerUnit: 0,
        ),
      );
    });
  }

  void _removeTier(int index) {
    if (_tiers.length <= 1) return;
    setState(() {
      _tiers.removeAt(index);
      // Ensure the last tier is the top tier.
      final last = _tiers.last;
      if (last.maxUnits != double.infinity) {
        _tiers[_tiers.length - 1] = TanescoTier(
          minUnits: last.minUnits,
          maxUnits: double.infinity,
          ratePerUnit: last.ratePerUnit,
        );
      }
    });
  }

  bool _tiersAreOrdered() {
    for (var i = 1; i < _tiers.length; i++) {
      if (_tiers[i].minUnits <= _tiers[i - 1].minUnits) return false;
      if (_tiers[i - 1].maxUnits != double.infinity &&
          _tiers[i].minUnits <= _tiers[i - 1].maxUnits) {
        return false;
      }
    }
    return true;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_tiersAreOrdered()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tiers must be in ascending order with no overlaps.'),
        ),
      );
      return;
    }

    final userId = ref.read(authStateProvider).asData?.value?.uid ?? 'unknown';
    final service = ref.read(tariffServiceProvider);
    setState(() => _loading = true);
    try {
      await service.updateTariffs(tiers: _tiers, userId: userId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tariff configuration saved.')),
      );
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
    final tariffsAsync = ref.watch(currentTariffsProvider);
    final profileAsync = ref.watch(currentUserProfileProvider);
    final isSuperAdmin = profileAsync.asData?.value?.isSuperAdmin ?? false;

    // Initialise local state once the provider has data.
    _initTiersIfNeeded(tariffsAsync);

    // Non-Super-Admin guard (while profile is still loading show nothing).
    if (!isSuperAdmin && profileAsync.hasValue) {
      return Scaffold(
        appBar: AppBar(title: const Text('TANESCO Tariff Settings')),
        body: const Center(child: Text('Super Admin access required.')),
      );
    }

    final previewCost = _tiers.isNotEmpty
        ? ref
              .read(tariffServiceProvider)
              .calculateCostWithTiers(unitsConsumed: 150, tiers: _tiers)
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('TANESCO Tariff Settings')),
      body: tariffsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading tariffs: $e')),
        data: (_) => _buildBody(previewCost),
      ),
    );
  }

  Widget _buildBody(double? previewCost) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Description ─────────────────────────────────────────────
            Text(
              'Set the tariff tiers TANESCO uses to calculate estimated '
              'electricity costs for your units.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // ── Tier editors ─────────────────────────────────────────────
            ..._tiers.asMap().entries.map((entry) {
              final index = entry.key;
              final tier = entry.value;
              final isTopTier = index == _tiers.length - 1;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: TariffTierEditor(
                  key: ValueKey('tier-$index-${tier.maxUnits}'),
                  tierNumber: index + 1,
                  tier: tier,
                  isTopTier: isTopTier,
                  onChanged: (updated) => _updateTier(index, updated),
                  onRemove: _tiers.length > 1 ? () => _removeTier(index) : null,
                ),
              );
            }),
            // ── Add tier ────────────────────────────────────────────────
            TextButton.icon(
              onPressed: _addTier,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Tier'),
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // ── Live preview ─────────────────────────────────────────────
            if (previewCost != null) ...[
              const Divider(),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  const Icon(Icons.calculate_outlined, size: 18),
                  const SizedBox(width: AppSpacing.sm),
                  Text.rich(
                    TextSpan(
                      text: 'Preview: ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: 'For 150 units: ${formatTZS(previewCost)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            // ── Save button ──────────────────────────────────────────────
            FilledButton(
              onPressed: _loading ? null : _save,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Save Tariffs'),
            ),
          ],
        ),
      ),
    );
  }
}
