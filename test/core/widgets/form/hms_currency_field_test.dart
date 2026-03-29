import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/widgets/form/hms_currency_field.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Padding(padding: const EdgeInsets.all(16), child: child),
    ),
  );
}

void main() {
  group('HmsCurrencyField', () {
    testWidgets('displays "TZS" prefix', (tester) async {
      await tester.pumpWidget(_wrap(const HmsCurrencyField(label: 'Amount')));
      expect(find.text('TZS '), findsOneWidget);
    });

    testWidgets('uses numeric keyboard', (tester) async {
      await tester.pumpWidget(_wrap(const HmsCurrencyField(label: 'Amount')));
      final field = tester.widget<EditableText>(find.byType(EditableText));
      expect(field.keyboardType, TextInputType.number);
    });

    testWidgets('formats typed digits with thousand separators', (
      tester,
    ) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        _wrap(HmsCurrencyField(label: 'Amount', controller: controller)),
      );
      await tester.enterText(find.byType(TextFormField), '150000');
      await tester.pump();
      expect(controller.text, '150,000');
    });

    testWidgets('onChanged returns raw double value', (tester) async {
      double? captured;
      await tester.pumpWidget(
        _wrap(
          HmsCurrencyField(label: 'Amount', onChanged: (v) => captured = v),
        ),
      );
      await tester.enterText(find.byType(TextFormField), '150000');
      await tester.pump();
      expect(captured, 150000.0);
    });

    testWidgets('default validator rejects negative/zero amounts', (
      tester,
    ) async {
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController(text: '0');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: HmsCurrencyField(
                  label: 'Amount',
                  controller: controller,
                ),
              ),
            ),
          ),
        ),
      );
      formKey.currentState!.validate();
      await tester.pump();
      expect(find.text('Amount must be greater than 0'), findsOneWidget);
    });
  });
}
