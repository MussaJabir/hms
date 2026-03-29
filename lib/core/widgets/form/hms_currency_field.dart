import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../theme/app_spacing.dart';

/// Formats input as a comma-separated integer (no decimals) as the user types.
class TzsInputFormatter extends TextInputFormatter {
  static final _digitOnly = RegExp(r'[^0-9]');
  static final _formatter = NumberFormat('#,##0', 'en_US');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(_digitOnly, '');

    if (digits.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final number = int.tryParse(digits) ?? 0;
    final formatted = _formatter.format(number);

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class HmsCurrencyField extends StatelessWidget {
  const HmsCurrencyField({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.onChanged,
    this.autofocus = false,
    this.enabled = true,
    this.focusNode,
  });

  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<double>? onChanged;
  final bool autofocus;
  final bool enabled;
  final FocusNode? focusNode;

  String? _defaultValidator(String? value) {
    if (value == null || value.isEmpty) return 'Amount is required';
    final raw = double.tryParse(value.replaceAll(',', ''));
    if (raw == null || raw <= 0) return 'Amount must be greater than 0';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        autofocus: autofocus,
        focusNode: focusNode,
        enabled: enabled,
        inputFormatters: [TzsInputFormatter()],
        validator: validator ?? _defaultValidator,
        onChanged: (value) {
          if (onChanged != null) {
            final raw = double.tryParse(value.replaceAll(',', '')) ?? 0.0;
            onChanged!(raw);
          }
        },
        decoration: InputDecoration(
          labelText: label,
          prefixText: 'TZS ',
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
        ),
      ),
    );
  }
}
