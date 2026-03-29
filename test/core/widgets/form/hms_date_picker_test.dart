import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/widgets/form/hms_date_picker.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Padding(padding: const EdgeInsets.all(16), child: child),
    ),
  );
}

void main() {
  group('HmsDatePicker', () {
    testWidgets('displays selected date in dd/MM/yyyy format', (tester) async {
      final date = DateTime(2026, 3, 15);
      await tester.pumpWidget(
        _wrap(
          HmsDatePicker(
            label: 'Due Date',
            selectedDate: date,
            onDateSelected: (_) {},
          ),
        ),
      );
      expect(find.text('15/03/2026'), findsOneWidget);
    });

    testWidgets('shows "Select date" hint when no date is selected', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          HmsDatePicker(
            label: 'Due Date',
            selectedDate: null,
            onDateSelected: (_) {},
          ),
        ),
      );
      // Check the hint is configured on the underlying TextField's decoration
      // (avoids tapping which would trigger showDatePicker in tests)
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.hintText, 'Select date');
    });

    testWidgets('displays calendar icon', (tester) async {
      await tester.pumpWidget(
        _wrap(
          HmsDatePicker(
            label: 'Due Date',
            selectedDate: null,
            onDateSelected: (_) {},
          ),
        ),
      );
      expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);
    });
  });
}
