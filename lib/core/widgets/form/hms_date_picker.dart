import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'hms_text_field.dart';

class HmsDatePicker extends StatelessWidget {
  const HmsDatePicker({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    this.firstDate,
    this.lastDate,
    this.enabled = true,
    this.validator,
  });

  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool enabled;
  final String? Function(DateTime?)? validator;

  static final _dateFormat = DateFormat('dd/MM/yyyy');

  String? _validate(String? _) {
    if (validator != null) return validator!(selectedDate);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return HmsTextField(
      label: label,
      hint: 'Select date',
      controller: TextEditingController(
        text: selectedDate != null ? _dateFormat.format(selectedDate!) : '',
      ),
      readOnly: true,
      enabled: enabled,
      validator: _validate,
      suffixIcon: const Icon(Icons.calendar_today_outlined),
      onTap: enabled
          ? () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: firstDate ?? DateTime(2020),
                lastDate: lastDate ?? DateTime(2030, 12, 31),
              );
              if (picked != null) onDateSelected(picked);
            }
          : null,
    );
  }
}
