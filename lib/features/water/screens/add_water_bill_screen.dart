import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/water/models/water_bill.dart';
import 'package:hms/features/water/providers/water_bill_providers.dart';

class AddWaterBillScreen extends ConsumerStatefulWidget {
  const AddWaterBillScreen({
    super.key,
    required this.groundId,
    this.existingBill,
  });

  final String groundId;
  final WaterBill? existingBill;

  @override
  ConsumerState<AddWaterBillScreen> createState() => _AddWaterBillScreenState();
}

class _AddWaterBillScreenState extends ConsumerState<AddWaterBillScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  String? _selectedPeriod;
  final _prevReadingCtrl = TextEditingController();
  final _currReadingCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  DateTime? _dueDate;
  final _notesCtrl = TextEditingController();
  final _smsCtrl = TextEditingController();
  String? _rawSmsText;

  bool _saving = false;

  List<String> get _periodOptions {
    final now = DateTime.now();
    final List<String> options = [];
    for (int i = 0; i < 12; i++) {
      final month = DateTime(now.year, now.month - i, 1);
      options.add(DateFormat('yyyy-MM').format(month));
    }
    return options;
  }

  String _formatPeriodLabel(String period) {
    try {
      return DateFormat(
        'MMMM yyyy',
      ).format(DateFormat('yyyy-MM').parse(period));
    } catch (_) {
      return period;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    final bill = widget.existingBill;
    if (bill != null) {
      _selectedPeriod = bill.billingPeriod;
      _prevReadingCtrl.text = bill.previousMeterReading.toString();
      _currReadingCtrl.text = bill.currentMeterReading.toString();
      _amountCtrl.text = bill.totalAmount.toStringAsFixed(0);
      _dueDate = bill.dueDate;
      _notesCtrl.text = bill.notes;
      _rawSmsText = bill.rawSmsText;
    } else {
      _selectedPeriod = _periodOptions.first;
      _dueDate = DateTime.now().add(const Duration(days: 30));
      // Pre-fill previous reading from latest bill
      WidgetsBinding.instance.addPostFrameCallback((_) => _prefillFromLatest());
    }
  }

  Future<void> _prefillFromLatest() async {
    final service = ref.read(waterBillServiceProvider);
    final latest = await service.getLatestBill(widget.groundId);
    if (!mounted) return;
    if (latest != null && _prevReadingCtrl.text.isEmpty) {
      setState(() {
        _prevReadingCtrl.text = latest.currentMeterReading.toString();
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _prevReadingCtrl.dispose();
    _currReadingCtrl.dispose();
    _amountCtrl.dispose();
    _notesCtrl.dispose();
    _smsCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dueDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a due date')));
      return;
    }

    setState(() => _saving = true);

    try {
      final userId =
          ref.read(authStateProvider).asData?.value?.uid ?? 'unknown';
      final service = ref.read(waterBillServiceProvider);

      final now = DateTime.now();
      final prevReading = double.parse(_prevReadingCtrl.text);
      final currReading = double.parse(_currReadingCtrl.text);
      final amount = double.parse(_amountCtrl.text.replaceAll(',', ''));

      if (widget.existingBill != null) {
        await service.updateBill(
          groundId: widget.groundId,
          billId: widget.existingBill!.id,
          updates: {
            'billingPeriod': _selectedPeriod,
            'previousMeterReading': prevReading,
            'currentMeterReading': currReading,
            'totalAmount': amount,
            'dueDate': _dueDate!.toIso8601String(),
            'notes': _notesCtrl.text.trim(),
            if (_rawSmsText != null) 'rawSmsText': _rawSmsText,
          },
          userId: userId,
        );
      } else {
        final bill = WaterBill(
          id: '',
          groundId: widget.groundId,
          billingPeriod: _selectedPeriod!,
          previousMeterReading: prevReading,
          currentMeterReading: currReading,
          totalAmount: amount,
          dueDate: _dueDate!,
          status: 'unpaid',
          rawSmsText: _rawSmsText,
          notes: _notesCtrl.text.trim(),
          createdAt: now,
          updatedAt: now,
          updatedBy: userId,
        );

        await service.createBill(
          groundId: widget.groundId,
          bill: bill,
          userId: userId,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.existingBill != null
                ? 'Bill updated successfully'
                : 'Bill saved successfully',
          ),
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

  void _parseSms() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('SMS parsing coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingBill != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Water Bill' : 'Add Water Bill'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Manual Entry'),
            Tab(text: 'Paste SMS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ManualEntryTab(
            formKey: _formKey,
            periodOptions: _periodOptions,
            selectedPeriod: _selectedPeriod,
            onPeriodChanged: (v) => setState(() => _selectedPeriod = v),
            formatPeriodLabel: _formatPeriodLabel,
            prevReadingCtrl: _prevReadingCtrl,
            currReadingCtrl: _currReadingCtrl,
            amountCtrl: _amountCtrl,
            dueDate: _dueDate,
            onDueDateChanged: (d) => setState(() => _dueDate = d),
            notesCtrl: _notesCtrl,
            saving: _saving,
            onSave: _save,
          ),
          _SmsTab(smsCtrl: _smsCtrl, onParse: _parseSms),
        ],
      ),
    );
  }
}

class _ManualEntryTab extends StatelessWidget {
  const _ManualEntryTab({
    required this.formKey,
    required this.periodOptions,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    required this.formatPeriodLabel,
    required this.prevReadingCtrl,
    required this.currReadingCtrl,
    required this.amountCtrl,
    required this.dueDate,
    required this.onDueDateChanged,
    required this.notesCtrl,
    required this.saving,
    required this.onSave,
  });

  final GlobalKey<FormState> formKey;
  final List<String> periodOptions;
  final String? selectedPeriod;
  final ValueChanged<String?> onPeriodChanged;
  final String Function(String) formatPeriodLabel;
  final TextEditingController prevReadingCtrl;
  final TextEditingController currReadingCtrl;
  final TextEditingController amountCtrl;
  final DateTime? dueDate;
  final ValueChanged<DateTime?> onDueDateChanged;
  final TextEditingController notesCtrl;
  final bool saving;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HmsDropdown<String>(
              label: 'Billing Period',
              value: selectedPeriod,
              items: periodOptions
                  .map(
                    (p) => DropdownMenuItem(
                      value: p,
                      child: Text(formatPeriodLabel(p)),
                    ),
                  )
                  .toList(),
              onChanged: onPeriodChanged,
              validator: (v) => v == null ? 'Select billing period' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            HmsTextField(
              label: 'Previous Meter Reading',
              controller: prevReadingCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                if (double.tryParse(v) == null) return 'Enter a valid number';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            HmsTextField(
              label: 'Current Meter Reading',
              controller: currReadingCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                final curr = double.tryParse(v);
                if (curr == null) return 'Enter a valid number';
                final prev = double.tryParse(prevReadingCtrl.text) ?? 0;
                if (curr < prev) return 'Must be ≥ previous reading ($prev)';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            HmsCurrencyField(
              label: 'Bill Amount (TZS)',
              controller: amountCtrl,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                final cleaned = v.replaceAll(',', '');
                if (double.tryParse(cleaned) == null) {
                  return 'Enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            HmsDatePicker(
              label: 'Due Date',
              selectedDate: dueDate,
              onDateSelected: onDueDateChanged,
              validator: (v) => v == null ? 'Select due date' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            HmsTextField(
              label: 'Notes (optional)',
              controller: notesCtrl,
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.xl),
            ElevatedButton(
              onPressed: saving ? null : onSave,
              child: saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save Bill'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmsTab extends StatelessWidget {
  const _SmsTab({required this.smsCtrl, required this.onParse});

  final TextEditingController smsCtrl;
  final VoidCallback onParse;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Paste your DAWASCO bill SMS below and tap Parse.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: HmsTextField(
              label: 'DAWASCO Bill SMS',
              controller: smsCtrl,
              maxLines: 15,
              hint: 'Paste the DAWASCO bill SMS here...',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton.icon(
            onPressed: onParse,
            icon: const Icon(Icons.auto_fix_high_outlined),
            label: const Text('Parse SMS'),
          ),
        ],
      ),
    );
  }
}
