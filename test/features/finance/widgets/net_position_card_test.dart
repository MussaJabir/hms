import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/theme/app_colors.dart';
import 'package:hms/features/finance/widgets/net_position_card.dart';

Widget _wrap(double income, double expenses) {
  return MaterialApp(
    theme: ThemeData(splashFactory: NoSplash.splashFactory),
    home: Scaffold(
      body: NetPositionCard(totalIncome: income, totalExpenses: expenses),
    ),
  );
}

/// The most-saturated Card colour is the net-position tint; compare to the
/// expected success/error alpha tint.
Color _cardColor(WidgetTester tester) {
  final card = tester.widget<Card>(find.byType(Card).first);
  return card.color!;
}

void main() {
  group('NetPositionCard', () {
    testWidgets('uses a green tint when positive', (tester) async {
      await tester.pumpWidget(_wrap(800000, 500000));
      await tester.pump();

      expect(_cardColor(tester), AppColors.success.withValues(alpha: 0.08));
      expect(find.textContaining('+'), findsWidgets);
    });

    testWidgets('uses a red tint when negative', (tester) async {
      await tester.pumpWidget(_wrap(300000, 500000));
      await tester.pump();

      expect(_cardColor(tester), AppColors.error.withValues(alpha: 0.08));
    });

    testWidgets('shows income, expenses, and net lines', (tester) async {
      await tester.pumpWidget(_wrap(800000, 500000));
      await tester.pump();

      expect(find.text('Income'), findsOneWidget);
      expect(find.text('Expenses'), findsOneWidget);
      expect(find.text('Net'), findsOneWidget);
    });
  });
}
