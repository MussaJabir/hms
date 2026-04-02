import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/features/dashboard/widgets/grounds_selector.dart';
import 'package:hms/features/grounds/models/ground_filter.dart';

Widget _wrap(Widget child) => ProviderScope(
  child: MaterialApp(home: Scaffold(body: child)),
);

void main() {
  group('GroundFilter enum', () {
    test('has correct labels', () {
      expect(GroundFilter.all.label, 'All');
      expect(GroundFilter.mainGround.label, 'Main Ground');
      expect(GroundFilter.minorGround.label, 'Minor Ground');
    });

    test('has correct values', () {
      expect(GroundFilter.all.value, 'all');
      expect(GroundFilter.mainGround.value, 'main');
      expect(GroundFilter.minorGround.value, 'minor');
    });

    test('has exactly 3 options', () {
      expect(GroundFilter.values.length, 3);
    });
  });

  group('GroundsSelector widget', () {
    testWidgets('renders all 3 filter options', (tester) async {
      await tester.pumpWidget(_wrap(const GroundsSelector()));

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Main Ground'), findsOneWidget);
      expect(find.text('Minor Ground'), findsOneWidget);
    });

    testWidgets('defaults to All selected', (tester) async {
      await tester.pumpWidget(_wrap(const GroundsSelector()));

      final container = ProviderScope.containerOf(
        tester.element(find.byType(GroundsSelector)),
      );
      expect(container.read(currentGroundProvider), GroundFilter.all);
    });

    testWidgets('tapping Main Ground updates selection', (tester) async {
      await tester.pumpWidget(_wrap(const GroundsSelector()));

      await tester.tap(find.text('Main Ground'));
      await tester.pump();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(GroundsSelector)),
      );
      expect(container.read(currentGroundProvider), GroundFilter.mainGround);
    });

    testWidgets('tapping Minor Ground updates selection', (tester) async {
      await tester.pumpWidget(_wrap(const GroundsSelector()));

      await tester.tap(find.text('Minor Ground'));
      await tester.pump();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(GroundsSelector)),
      );
      expect(container.read(currentGroundProvider), GroundFilter.minorGround);
    });

    testWidgets('selected option has primary color background', (tester) async {
      await tester.pumpWidget(_wrap(const GroundsSelector()));

      // Tap Main Ground so it becomes selected
      await tester.tap(find.text('Main Ground'));
      await tester.pumpAndSettle();

      // Selected chip uses AppColors.primary (0xFF1B4F72) as background
      final containers = tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .toList();

      // The selected one should have primary color decoration
      final selectedContainer = containers[1]; // index 1 = Main Ground
      final decoration = selectedContainer.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFF1B4F72));
    });

    testWidgets('unselected options have surface color background', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const GroundsSelector()));

      // Default: All is selected, others should be surface color
      final containers = tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .toList();

      final unselectedContainer = containers[1]; // Main Ground, not selected
      final decoration = unselectedContainer.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFFFFFFFF)); // AppColors.surface
    });
  });
}
