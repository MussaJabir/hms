import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/theme/theme.dart';
import 'package:hms/core/utils/validators.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/finance/models/models.dart';
import 'package:hms/features/finance/providers/income_providers.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';

/// Add or edit a manual income entry. Rent is excluded as a source because rent
/// income is auto-linked from the rent module, never entered by hand.
class AddIncomeScreen extends ConsumerStatefulWidget {
  const AddIncomeScreen({super.key, this.income});

  /// When provided the screen is in edit mode.
  final Income? income;

  @override
  ConsumerState<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends ConsumerState<AddIncomeScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _source;
  final _descCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  late DateTime _date;
  String _groundId = ''; // '' = None
  final _notesCtrl = TextEditingController();

  bool _saving = false;

  /// Selectable sources — rent is auto-linked only, so it is excluded here.
  static final List<IncomeSource> _sourceOptions = IncomeSource.values
      .where((s) => s != IncomeSource.rent)
      .toList();

  bool get _isEdit => widget.income != null;

  @override
  void initState() {
    super.initState();
    final income = widget.income;
    if (income != null) {
      _source = income.source == 'rent'
          ? IncomeSource.other.value
          : income.source;
      _descCtrl.text = income.description;
      _amountCtrl.text = income.amount.toStringAsFixed(0);
      _date = income.date;
      _groundId = income.groundId ?? '';
      _notesCtrl.text = income.notes;
    } else {
      _source = IncomeSource.freelance.value;
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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      final userId =
          ref.read(authStateProvider).asData?.value?.uid ?? 'unknown';
      final service = ref.read(incomeServiceProvider);
      final amount = double.parse(_amountCtrl.text.replaceAll(',', ''));
      final groundId = _groundId.isEmpty ? null : _groundId;
      final notes = _notesCtrl.text.trim();

      if (_isEdit) {
        await service.updateIncome(
          incomeId: widget.income!.id,
          updates: {
            'source': _source,
            'description': _descCtrl.text.trim(),
            'amount': amount,
            'date': _date.toIso8601String(),
            'groundId': groundId,
            'notes': notes,
          },
          userId: userId,
        );
      } else {
        final now = DateTime.now();
        final income = Income(
          id: '',
          source: _source,
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
        await service.createIncome(income: income, userId: userId);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEdit ? 'Income updated' : 'Income added'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final groundsAsync = ref.watch(allGroundsProvider);
    final grounds = groundsAsync.asData?.value ?? [];
    final groundValues = {'', ...grounds.map((g) => g.id)};
    final safeGroundValue = groundValues.contains(_groundId) ? _groundId : '';

    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Income' : 'Add Income')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HmsDropdown<String>(
                label: 'Source',
                value: _source,
                items: _sourceOptions
                    .map(
                      (s) => DropdownMenuItem(
                        value: s.value,
                        child: Row(
                          children: [
                            Icon(s.icon, size: 18),
                            const SizedBox(width: AppSpacing.sm),
                            Text(s.label),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _source = v ?? _source),
                validator: (v) => v == null ? 'Select a source' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              HmsTextField(
                label: 'Description',
                controller: _descCtrl,
                validator: (v) =>
                    Validators.required(v, fieldName: 'Description'),
              ),
              const SizedBox(height: AppSpacing.md),
              HmsCurrencyField(
                label: 'Amount (TZS)',
                controller: _amountCtrl,
                validator: Validators.positiveAmount,
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
                  const DropdownMenuItem(value: '', child: Text('None')),
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
                    : Text(_isEdit ? 'Update Income' : 'Save Income'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
