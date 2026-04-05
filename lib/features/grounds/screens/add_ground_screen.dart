import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hms/core/models/ground.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/utils/validators.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';

class AddGroundScreen extends ConsumerStatefulWidget {
  const AddGroundScreen({super.key, this.ground});

  /// When provided the screen operates in edit mode.
  final Ground? ground;

  @override
  ConsumerState<AddGroundScreen> createState() => _AddGroundScreenState();
}

class _AddGroundScreenState extends ConsumerState<AddGroundScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  late final TextEditingController _unitsController;

  bool _loading = false;

  bool get _isEditing => widget.ground != null;

  @override
  void initState() {
    super.initState();
    final g = widget.ground;
    _nameController = TextEditingController(text: g?.name ?? '');
    _locationController = TextEditingController(text: g?.location ?? '');
    _unitsController = TextEditingController(
      text: g != null ? '${g.numberOfUnits}' : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _unitsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final authAsync = ref.read(authStateProvider);
    final userId = authAsync.asData?.value?.uid ?? 'unknown';
    final service = ref.read(groundServiceProvider);

    try {
      if (_isEditing) {
        await service.updateGround(widget.ground!.id, {
          'name': _nameController.text.trim(),
          'location': _locationController.text.trim(),
          'numberOfUnits': int.parse(_unitsController.text.trim()),
        }, userId);
      } else {
        final ground = Ground(
          id: '',
          name: _nameController.text.trim(),
          location: _locationController.text.trim(),
          numberOfUnits: int.parse(_unitsController.text.trim()),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          updatedBy: userId,
        );
        await service.createGround(ground, userId);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing ? 'Property updated.' : 'Property added.'),
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
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Property' : 'Add Property'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HmsTextField(
                label: 'Property Name',
                hint: 'e.g. Main Ground',
                controller: _nameController,
                validator: (v) => Validators.required(v, fieldName: 'Name'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              HmsTextField(
                label: 'Location',
                hint: 'e.g. Sinza, Dar es Salaam',
                controller: _locationController,
                validator: (v) => Validators.required(v, fieldName: 'Location'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              HmsTextField(
                label: 'Number of Units',
                hint: 'e.g. 8',
                controller: _unitsController,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Number of units is required';
                  }
                  final n = int.tryParse(v.trim());
                  if (n == null || n <= 0) {
                    return 'Must be a positive whole number';
                  }
                  return null;
                },
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
                    : Text(_isEditing ? 'Save Changes' : 'Add Property'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
