import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/water/providers/water_contribution_providers.dart';

class WaterSettingsScreen extends ConsumerStatefulWidget {
  const WaterSettingsScreen({super.key});

  @override
  ConsumerState<WaterSettingsScreen> createState() =>
      _WaterSettingsScreenState();
}

class _WaterSettingsScreenState extends ConsumerState<WaterSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  bool _loading = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultAmountAsync = ref.watch(defaultContributionAmountProvider);

    // Pre-fill once when data loads
    defaultAmountAsync.whenData((amount) {
      if (!_initialized) {
        _initialized = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _amountController.text = amount > 0
                ? amount.toStringAsFixed(0)
                : '';
          }
        });
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Water Contribution Settings')),
      body: defaultAmountAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (_) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HmsCurrencyField(
                  controller: _amountController,
                  label: 'Default Monthly Contribution (TZS)',
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Amount is required';
                    }
                    final cleaned = v.replaceAll(RegExp(r'[^0-9.]'), '');
                    final parsed = double.tryParse(cleaned);
                    if (parsed == null || parsed <= 0) {
                      return 'Enter a positive amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'This amount is used when setting up contributions for new tenants. Existing contributions are not affected.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.xl),
                ElevatedButton(
                  onPressed: _loading ? null : _save,
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final cleaned = _amountController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final amount = double.parse(cleaned);

    setState(() => _loading = true);
    try {
      final userId =
          ref.read(authStateProvider).asData?.value?.uid ?? 'unknown';
      await ref
          .read(waterContributionServiceProvider)
          .setDefaultAmount(amount: amount, userId: userId);
      ref.invalidate(defaultContributionAmountProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Default contribution saved')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
