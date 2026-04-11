import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/utils/validators.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/electricity/models/electricity_meter.dart';
import 'package:hms/features/electricity/providers/meter_providers.dart';

class MeterRegistrationScreen extends ConsumerStatefulWidget {
  const MeterRegistrationScreen({
    super.key,
    required this.groundId,
    required this.unitId,
    this.meter,
  });

  final String groundId;
  final String unitId;

  /// When provided the screen operates in edit mode.
  final ElectricityMeter? meter;

  @override
  ConsumerState<MeterRegistrationScreen> createState() =>
      _MeterRegistrationScreenState();
}

class _MeterRegistrationScreenState
    extends ConsumerState<MeterRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _meterNumberController;
  late final TextEditingController _initialReadingController;
  late final TextEditingController _thresholdController;
  bool _loading = false;

  bool get _isEditing => widget.meter != null;

  @override
  void initState() {
    super.initState();
    final m = widget.meter;
    _meterNumberController = TextEditingController(text: m?.meterNumber ?? '');
    _initialReadingController = TextEditingController(
      text: m != null ? m.initialReading.toStringAsFixed(0) : '',
    );
    _thresholdController = TextEditingController(
      text: (m != null && m.weeklyThreshold > 0)
          ? m.weeklyThreshold.toStringAsFixed(0)
          : '',
    );
  }

  @override
  void dispose() {
    _meterNumberController.dispose();
    _initialReadingController.dispose();
    _thresholdController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final userId = ref.read(authStateProvider).asData?.value?.uid ?? 'unknown';
    final service = ref.read(meterServiceProvider);
    final meterNumber = _meterNumberController.text.trim();
    final initialReading =
        double.tryParse(_initialReadingController.text.trim()) ?? 0;
    final threshold = double.tryParse(_thresholdController.text.trim()) ?? 0;

    try {
      if (_isEditing) {
        await service.updateMeter(
          widget.groundId,
          widget.unitId,
          widget.meter!.id,
          {'meterNumber': meterNumber, 'weeklyThreshold': threshold},
          userId,
        );
      } else {
        final meter = ElectricityMeter(
          id: '',
          groundId: widget.groundId,
          unitId: widget.unitId,
          meterNumber: meterNumber,
          initialReading: initialReading,
          weeklyThreshold: threshold,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          updatedBy: userId,
        );
        await service.registerMeter(
          widget.groundId,
          widget.unitId,
          meter,
          userId,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing ? 'Meter updated.' : 'Meter registered.'),
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
      appBar: AppBar(title: Text(_isEditing ? 'Edit Meter' : 'Register Meter')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HmsTextField(
                label: 'Meter Number',
                hint: 'Physical meter ID printed on the meter',
                controller: _meterNumberController,
                validator: (v) =>
                    Validators.required(v, fieldName: 'Meter number'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              HmsTextField(
                label: 'Initial Reading (units)',
                hint: '0',
                controller: _initialReadingController,
                keyboardType: TextInputType.number,
                enabled: !_isEditing,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  final parsed = double.tryParse(v.trim());
                  if (parsed == null || parsed < 0) {
                    return 'Enter a valid reading (0 or more)';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              HmsTextField(
                label: 'Weekly Threshold (units, optional)',
                hint: 'e.g. 50',
                controller: _thresholdController,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  final parsed = double.tryParse(v.trim());
                  if (parsed == null || parsed < 0) {
                    return 'Enter a valid threshold (0 or more)';
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Get alerts when usage exceeds this per week',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
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
                    : Text(_isEditing ? 'Save Changes' : 'Register Meter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
