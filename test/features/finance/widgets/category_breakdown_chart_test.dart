import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/features/finance/widgets/category_breakdown_chart.dart';

Widget _wrap(Widget child) => MaterialApp(
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void main() {
  group('CategoryBreakdownChart', () {
    testWidgets('renders a pie section and legend per category', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const CategoryBreakdownChart(
            categoryTotals: {
              'groceries': 30000,
              'transport': 20000,
              'utilities': 10000,
            },
            totalAmount: 60000,
          ),
        ),
      );
      await tester.pump();

      final pie = tester.widget<PieChart>(find.byType(PieChart));
      expect(pie.data.sections.length, 3);

      // Legend rows show category labels.
      expect(find.text('Groceries'), findsOneWidget);
      expect(find.text('Transport'), findsOneWidget);
      expect(find.text('Utilities'), findsOneWidget);
    });

    testWidgets('renders nothing when there is no data', (tester) async {
      await tester.pumpWidget(
        _wrap(const CategoryBreakdownChart(categoryTotals: {}, totalAmount: 0)),
      );
      await tester.pump();

      expect(find.byType(PieChart), findsNothing);
    });
  });
}
