import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/features/water/providers/water_contribution_providers.dart';
import 'package:hms/features/water/screens/water_settings_screen.dart';

Widget _wrap({double defaultAmount = 5000}) {
  return ProviderScope(
    overrides: [
      defaultContributionAmountProvider.overrideWith(
        (ref) async => defaultAmount,
      ),
      authStateProvider.overrideWith((ref) => const Stream.empty()),
    ],
    child: const MaterialApp(home: WaterSettingsScreen()),
  );
}

void main() {
  group('WaterSettingsScreen', () {
    testWidgets('renders with default amount pre-filled', (tester) async {
      await tester.pumpWidget(_wrap(defaultAmount: 8000));
      await tester.pumpAndSettle();

      expect(find.text('Default Monthly Contribution (TZS)'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('validates positive amount — rejects empty input', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      // Clear the field and attempt save
      final field = find.byType(TextFormField);
      await tester.enterText(field.first, '');
      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(find.text('Amount is required'), findsOneWidget);
    });

    testWidgets('validates positive amount — rejects zero', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      final field = find.byType(TextFormField);
      await tester.enterText(field.first, '0');
      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(find.text('Enter a positive amount'), findsOneWidget);
    });
  });
}
