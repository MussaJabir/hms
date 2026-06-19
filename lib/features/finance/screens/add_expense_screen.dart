import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/theme/theme.dart';
import 'package:hms/core/utils/validators.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/finance/models/models.dart';
import 'package:hms/features/finance/providers/expense_providers.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';

/// Add or edit an expense. Speed-optimised: the amount field autofocuses, the
/// date defaults to today, and only a description and amount are required —
/// category defaults to "Uncategorized" and ground is optional. After a new
/// entry is saved the user can immediately "Add Another" without leaving.
class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key, this.expense, this.presetCategory});

  /// When provided the screen is in edit mode.
  final Expense? expense;

  /// Optional category value to pre-select (e.g. from a quick-add shortcut).
  final String? presetCategory;

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _category;
  final _descCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  late DateTime _date;
  String _groundId = ''; // '' = General Household
  final _notesCtrl = TextEditingController();

  bool _saving = false;

  bool get _isEdit => widget.expense != null;

  @override
  void initState() {
    super.initState();
    final expense = widget.expense;
    if (expense != null) {
      _category = expense.category;
      _descCtrl.text = expense.description;
      _amountCtrl.text = expense.amount.toStringAsFixed(0);
      _date = expense.date;
      _groundId = expense.groundId ?? '';
      _notesCtrl.text = expense.notes;
    } else {
      _category = widget.presetCategory ?? ExpenseCategory.uncategorized.value;
      _date = DateTime.now();
    }
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _amountCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  /// A description hint tailored to the selected category.
  String get _descriptionHint {
    switch (ExpenseCategory.fromString(_category)) {
      case ExpenseCategory.groceries:
        return 'Which items?';
      case ExpenseCategory.maintenance:
        return 'What was repaired?';
      case ExpenseCategory.transport:
        return 'Trip or fare for?';
      case ExpenseCategory.health:
        return 'Treatment or medicine?';
      case ExpenseCategory.school:
        return 'Which fee or item?';
      case ExpenseCategory.utilities:
        return 'Which bill?';
      case ExpenseCategory.food:
        return 'Where or what?';
      case ExpenseCategory.airtime:
        return 'Which line or bundle?';
      default:
        return 'What was this for?';
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      final userId =
          ref.read(authStateProvider).asData?.value?.uid ?? 'unknown';
      final service = ref.read(expenseServiceProvider);
      final amount = double.parse(_amountCtrl.text.replaceAll(',', ''));
      final groundId = _groundId.isEmpty ? null : _groundId;
      final notes = _notesCtrl.text.trim();

      if (_isEdit) {
        await service.updateExpense(
          expenseId: widget.expense!.id,
          updates: {
            'category': _category,
            'description': _descCtrl.text.trim(),
            'amount': amount,
            'date': _date.toIso8601String(),
            'groundId': groundId,
            'notes': notes,
          },
          userId: userId,
        );

        if (!mounted) return;
        _snack('Expense updated');
        context.pop();
      } else {
        final now = DateTime.now();
        final expense = Expense(
          id: '',
          category: _category,
          description: _descCtrl.text.trim(),
          amount: amount,
          date: _date,
          groundId: groundId,
          isAutoLinked: false,
          notes: notes,
          createdAt: now,
          updatedAt: now,
          updatedBy: userId,
        );
        await service.createExpense(expense: expense, userId: userId);

        if (!mounted) return;
        // Stop the spinner before the prompt so the dialog isn't shown on top
        // of an animating button (which would never settle).
        setState(() => _saving = false);
        await _promptAddAnother();
      }
    } catch (e) {
      if (!mounted) return;
      _snack('Error: $e', error: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _snack(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? null : AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// After a new expense is saved, let the user log another straight away or
  /// return to the list.
  Future<void> _promptAddAnother() async {
    final addAnother = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Expense saved'),
        content: const Text('Add another expense or return to the list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Done'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Add Another'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    if (addAnother ?? false) {
      _resetForm();
    } else {
      context.pop();
    }
  }

  /// Clears the entry fields for a fresh expense, keeping the category and
  /// ground context (handy when logging a batch), and refocuses the amount.
  void _resetForm() {
    setState(() {
      _descCtrl.clear();
      _amountCtrl.clear();
      _notesCtrl.clear();
      _date = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final groundsAsync = ref.watch(allGroundsProvider);
    final grounds = groundsAsync.asData?.value ?? [];
    final groundValues = {'', ...grounds.map((g) => g.id)};
    final safeGroundValue = groundValues.contains(_groundId) ? _groundId : '';

    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Expense' : 'Add Expense')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HmsDropdown<String>(
                label: 'Category',
                value: _category,
                items: ExpenseCategory.values
                    .map(
                      (c) => DropdownMenuItem(
                        value: c.value,
                        child: Row(
                          children: [
                            Icon(c.icon, size: 18),
                            const SizedBox(width: AppSpacing.sm),
                            Flexible(
                              child: Text(
                                c.label,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _category = v ?? _category),
                validator: (v) => v == null ? 'Select a category' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              HmsCurrencyField(
                label: 'Amount (TZS)',
                controller: _amountCtrl,
                autofocus: !_isEdit,
                validator: Validators.positiveAmount,
              ),
              const SizedBox(height: AppSpacing.md),
              HmsTextField(
                label: 'Description',
                hint: _descriptionHint,
                controller: _descCtrl,
                validator: (v) =>
                    Validators.required(v, fieldName: 'Description'),
              ),
              const SizedBox(height: AppSpacing.md),
              HmsDatePicker(
                label: 'Date',
                selectedDate: _date,
                onDateSelected: (d) => setState(() => _date = d),
                validator: (v) => v == null ? 'Select a date' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              HmsDropdown<String>(
                label: 'Ground (optional)',
                value: safeGroundValue,
                items: [
                  const DropdownMenuItem(
                    value: '',
                    child: Text('General Household'),
                  ),
                  ...grounds.map(
                    (g) => DropdownMenuItem(value: g.id, child: Text(g.name)),
                  ),
                ],
                onChanged: (v) => setState(() => _groundId = v ?? ''),
              ),
              const SizedBox(height: AppSpacing.md),
              HmsTextField(
                label: 'Notes (optional)',
                controller: _notesCtrl,
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_isEdit ? 'Update Expense' : 'Save Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
