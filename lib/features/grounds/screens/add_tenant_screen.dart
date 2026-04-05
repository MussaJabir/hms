import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/utils/validators.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/grounds/models/tenant.dart';
import 'package:hms/features/grounds/providers/tenant_providers.dart';

class AddTenantScreen extends ConsumerStatefulWidget {
  const AddTenantScreen({
    super.key,
    required this.groundId,
    required this.unitId,
    this.tenant,
  });

  final String groundId;
  final String unitId;

  /// Provided in edit mode.
  final Tenant? tenant;

  @override
  ConsumerState<AddTenantScreen> createState() => _AddTenantScreenState();
}

class _AddTenantScreenState extends ConsumerState<AddTenantScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _nidController;

  DateTime? _moveInDate;
  DateTime? _leaseEndDate;
  bool _loading = false;

  bool get _isEditing => widget.tenant != null;

  @override
  void initState() {
    super.initState();
    final t = widget.tenant;
    _nameController = TextEditingController(text: t?.fullName ?? '');
    _phoneController = TextEditingController(text: t?.phoneNumber ?? '');
    _nidController = TextEditingController(text: t?.nationalId ?? '');
    _moveInDate = t?.moveInDate;
    _leaseEndDate = t?.leaseEndDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _nidController.dispose();
    super.dispose();
  }

  String? _validateNid(String? value) {
    if (value == null || value.trim().isEmpty) return null; // optional
    return Validators.nationalId(value);
  }

  String? _validateLeaseEnd(DateTime? value) {
    if (value == null) return null; // optional
    return Validators.dateAfter(
      value,
      _moveInDate,
      fieldName: 'Lease end date',
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_moveInDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Move-in date is required')));
      return;
    }

    setState(() => _loading = true);
    final userId = ref.read(authStateProvider).asData?.value?.uid ?? 'unknown';
    final service = ref.read(tenantServiceProvider);
    final nid = _nidController.text.trim();

    try {
      if (_isEditing) {
        await service
            .updateTenant(widget.groundId, widget.unitId, widget.tenant!.id, {
              'fullName': _nameController.text.trim(),
              'phoneNumber': _phoneController.text.trim(),
              if (nid.isNotEmpty) 'nationalId': nid,
              'moveInDate': _moveInDate!.toIso8601String(),
              if (_leaseEndDate != null)
                'leaseEndDate': _leaseEndDate!.toIso8601String(),
            }, userId);
      } else {
        final tenant = Tenant(
          id: '',
          groundId: widget.groundId,
          unitId: widget.unitId,
          fullName: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          nationalId: nid.isEmpty ? null : nid,
          moveInDate: _moveInDate!,
          leaseEndDate: _leaseEndDate,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          updatedBy: userId,
        );
        await service.createTenant(
          widget.groundId,
          widget.unitId,
          tenant,
          userId,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing ? 'Tenant updated.' : 'Tenant added.'),
        ),
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
      appBar: AppBar(title: Text(_isEditing ? 'Edit Tenant' : 'Add Tenant')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HmsTextField(
                label: 'Full Name',
                hint: 'e.g. Juma Mkamwa',
                controller: _nameController,
                validator: (v) =>
                    Validators.required(v, fieldName: 'Full name'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              HmsTextField(
                label: 'Phone Number',
                hint: '07XXXXXXXX',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: Validators.phone,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              HmsTextField(
                label: 'National ID (optional)',
                hint: '20-character NIDA number',
                controller: _nidController,
                validator: _validateNid,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              HmsDatePicker(
                label: 'Move-in Date',
                selectedDate: _moveInDate,
                onDateSelected: (d) => setState(() {
                  _moveInDate = d;
                  // Reset lease end if it's now before move-in
                  if (_leaseEndDate != null &&
                      !_leaseEndDate!.isAfter(_moveInDate!)) {
                    _leaseEndDate = null;
                  }
                }),
                validator: (d) => d == null ? 'Move-in date is required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              HmsDatePicker(
                label: 'Lease End Date (optional)',
                selectedDate: _leaseEndDate,
                firstDate: _moveInDate ?? DateTime.now(),
                onDateSelected: (d) => setState(() => _leaseEndDate = d),
                validator: _validateLeaseEnd,
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
                    : Text(_isEditing ? 'Save Changes' : 'Add Tenant'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
