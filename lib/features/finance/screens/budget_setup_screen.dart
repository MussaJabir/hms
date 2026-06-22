import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/theme/theme.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/finance/models/budget.dart';
import 'package:hms/features/finance/models/expense_category.dart';
import 'package:hms/features/finance/providers/budget_providers.dart';
import 'package:hms/features/finance/services/budget_service.dart';

/// Set or edit the monthly budget limit for each expense category. Categories
/// left blank (or zero) are skipped — no budget is created for them. When
/// editing an existing month the fields pre-fill with current limits; for a
/// fresh month they pre-fill with the previous month's limits as a starting
/// point.
class BudgetSetupScreen extends ConsumerStatefulWidget {
  const BudgetSetupScreen({super.key});

  @override
  ConsumerState<BudgetSetupScreen> createState() => _BudgetSetupScreenState();
}

class _BudgetSetupScreenState extends ConsumerState<BudgetSetupScreen> {
  /// One controller per category, keyed by category value.
  final Map<String, TextEditingController> _controllers = {
    for (final c in ExpenseCategory.values) c.value: TextEditingController(),
  };

  bool _copyForward = false;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _prefill());
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  String get _period => currentBudgetPeriod();

  /// Pre-fill from this month's budgets, or last month's if none exist yet.
  Future<void> _prefill() async {
    final service = ref.read(budgetServiceProvider);
    try {
      var budgets = await service.getBudgetsForPeriod(_period);
      if (budgets.isEmpty) {
        final parts = _period.split('-');
        final prev = DateTime(int.parse(parts[0]), int.parse(parts[1]) - 1, 1);
        final mm = prev.month.toString().padLeft(2, '0');
        budgets = await service.getBudgetsForPeriod('${prev.year}-$mm');
      }
      for (final b in budgets) {
        _controllers[b.category]?.text = b.limitAmount.toStringAsFixed(0);
      }
    } catch (_) {
      // Leave fields blank if prefill fails.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final userId =
          ref.read(authStateProvider).asData?.value?.uid ?? 'unknown';
      final service = ref.read(budgetServiceProvider);

      final saved = <Budget>[];
      final now = DateTime.now();
      for (final category in ExpenseCategory.values) {
        final text = _controllers[category.value]!.text.replaceAll(',', '');
        final limit = double.tryParse(text) ?? 0;
        if (limit <= 0) continue;
        await service.setBudget(
          category: category.value,
          limitAmount: limit,
          period: _period,
          userId: userId,
        );
        saved.add(
          Budget(
            id: BudgetService.docId(category.value, _period),
            category: category.value,
            limitAmount: limit,
            period: _period,
            createdAt: now,
            updatedAt: now,
            updatedBy: userId,
          ),
        );
      }

      if (_copyForward && saved.isNotEmpty) {
        await service.setupRecurringBudgets(budgets: saved, userId: userId);
      }

      // Sync spent amounts against existing expenses.
      await service.recalculateSpent(_period, userId);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${saved.length} budgets saved'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Monthly Budgets')),
      body: _loading
          ? const Padding(
              padding: EdgeInsets.all(AppSpacing.screenPadding),
              child: ShimmerList(itemCount: 6),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Set limits for each category you want to track. '
                    'Leave blank to skip.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  for (final category in ExpenseCategory.values) ...[
                    HmsCurrencyField(
                      label: category.label,
                      controller: _controllers[category.value]!,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _copyForward,
                    onChanged: (v) => setState(() => _copyForward = v ?? false),
                    title: const Text('Copy these limits to future months'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save Budgets'),
                  ),
                ],
              ),
            ),
    );
  }
}
