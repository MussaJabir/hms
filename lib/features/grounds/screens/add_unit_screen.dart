import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/utils/validators.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/grounds/models/rental_unit.dart';
import 'package:hms/features/grounds/providers/rental_unit_providers.dart';

class AddUnitScreen extends ConsumerStatefulWidget {
  const AddUnitScreen({super.key, required this.groundId, this.unit});

  final String groundId;

  /// When provided the screen operates in edit mode.
  final RentalUnit? unit;

  @override
  ConsumerState<AddUnitScreen> createState() => _AddUnitScreenState();
}

class _AddUnitScreenState extends ConsumerState<AddUnitScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _rentController;
  late final TextEditingController _meterIdController;

  String _status = 'vacant';
  bool _loading = false;

  bool get _isEditing => widget.unit != null;

  @override
  void initState() {
    super.initState();
    final u = widget.unit;
    _nameController = TextEditingController(text: u?.name ?? '');
    _rentController = TextEditingController(
      text: u != null ? u.rentAmount.toInt().toString() : '',
    );
    _meterIdController = TextEditingController(text: u?.meterId ?? '');
    _status = u?.status ?? 'vacant';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rentController.dispose();
    _meterIdController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final userId = ref.read(authStateProvider).asData?.value?.uid ?? 'unknown';
    final service = ref.read(rentalUnitServiceProvider);
    final meterId = _meterIdController.text.trim();
    final rawRent =
        double.tryParse(_rentController.text.replaceAll(',', '')) ?? 0;

    try {
      if (_isEditing) {
        await service.updateUnit(widget.groundId, widget.unit!.id, {
          'name': _nameController.text.trim(),
          'rentAmount': rawRent,
          'status': _status,
          if (meterId.isNotEmpty) 'meterId': meterId,
        }, userId);
      } else {
        final unit = RentalUnit(
          id: '',
          groundId: widget.groundId,
          name: _nameController.text.trim(),
          rentAmount: rawRent,
          status: _status,
          meterId: meterId.isEmpty ? null : meterId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          updatedBy: userId,
        );
        await service.createUnit(widget.groundId, unit, userId);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? 'Unit updated.' : 'Unit added.')),
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
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Unit' : 'Add Unit')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HmsTextField(
                label: 'Unit Name',
                hint: 'e.g. Room 1, Shop A',
                controller: _nameController,
                validator: (v) => Validators.required(v, fieldName: 'Name'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              HmsCurrencyField(
                label: 'Monthly Rent (TZS)',
                controller: _rentController,
                validator: Validators.positiveAmount,
              ),
              const SizedBox(height: AppSpacing.md),
              HmsDropdown<String>(
                label: 'Status',
                value: _status,
                items: const [
                  DropdownMenuItem(value: 'vacant', child: Text('Vacant')),
                  DropdownMenuItem(value: 'occupied', child: Text('Occupied')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _status = v);
                },
              ),
              const SizedBox(height: AppSpacing.md),
              HmsTextField(
                label: 'Meter ID (optional)',
                hint: 'Electricity meter ID',
                controller: _meterIdController,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(_isEditing ? 'Save Changes' : 'Add Unit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
