import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/widgets/form/hms_text_field.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Padding(padding: const EdgeInsets.all(16), child: child),
    ),
  );
}

void main() {
  group('HmsTextField', () {
    testWidgets('displays label', (tester) async {
      await tester.pumpWidget(_wrap(const HmsTextField(label: 'Full Name')));
      expect(find.text('Full Name'), findsOneWidget);
    });

    testWidgets('displays hint text when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(const HmsTextField(label: 'Full Name', hint: 'Enter your name')),
      );
      // Tap to focus so hint shows (hint only shows when focused and empty)
      await tester.tap(find.byType(HmsTextField));
      await tester.pump();
      expect(find.text('Enter your name'), findsOneWidget);
    });

    testWidgets('displays validator error on invalid input', (tester) async {
      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: HmsTextField(
                  label: 'Name',
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Name is required' : null,
                ),
              ),
            ),
          ),
        ),
      );
      formKey.currentState!.validate();
      await tester.pump();
      expect(find.text('Name is required'), findsOneWidget);
    });

    testWidgets('onChanged fires with typed text', (tester) async {
      String? captured;
      final controller = TextEditingController();
      await tester.pumpWidget(
        _wrap(
          HmsTextField(
            label: 'Name',
            controller: controller,
            onChanged: (v) => captured = v,
          ),
        ),
      );
      await tester.enterText(find.byType(TextFormField), 'John');
      expect(captured, 'John');
    });

    testWidgets('obscureText hides characters', (tester) async {
      await tester.pumpWidget(
        _wrap(const HmsTextField(label: 'Password', obscureText: true)),
      );
      final field = tester.widget<EditableText>(find.byType(EditableText));
      expect(field.obscureText, isTrue);
    });

    testWidgets('readOnly prevents editing', (tester) async {
      await tester.pumpWidget(
        _wrap(const HmsTextField(label: 'Name', readOnly: true)),
      );
      // EditableText exposes readOnly
      final field = tester.widget<EditableText>(find.byType(EditableText));
      expect(field.readOnly, isTrue);
    });

    testWidgets('disabled state shows reduced opacity', (tester) async {
      await tester.pumpWidget(
        _wrap(const HmsTextField(label: 'Name', enabled: false)),
      );
      final opacity = tester.widget<Opacity>(find.byType(Opacity));
      expect(opacity.opacity, 0.5);
    });
  });
}
