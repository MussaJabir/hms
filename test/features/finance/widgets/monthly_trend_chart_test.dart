import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/features/finance/models/monthly_trend.dart';
import 'package:hms/features/finance/widgets/monthly_trend_chart.dart';

const _trends = [
  MonthlyTrend(period: '2026-04', income: 600000, expenses: 400000),
  MonthlyTrend(period: '2026-05', income: 700000, expenses: 550000),
  MonthlyTrend(period: '2026-06', income: 800000, expenses: 500000),
];

Widget _wrap(List<MonthlyTrend> trends) {
  return MaterialApp(
    home: Scaffold(body: MonthlyTrendChart(trends: trends)),
  );
}

void main() {
  group('MonthlyTrendChart', () {
    testWidgets('renders two lines (income + expenses)', (tester) async {
      await tester.pumpWidget(_wrap(_trends));
      await tester.pump();

      final chart = tester.widget<LineChart>(find.byType(LineChart));
      expect(chart.data.lineBarsData, hasLength(2));
      // Each line has one spot per month.
      expect(chart.data.lineBarsData[0].spots, hasLength(3));
      expect(chart.data.lineBarsData[1].spots, hasLength(3));
    });

    testWidgets('renders Income and Expenses legend labels', (tester) async {
      await tester.pumpWidget(_wrap(_trends));
      await tester.pump();

      expect(find.text('Income'), findsOneWidget);
      expect(find.text('Expenses'), findsOneWidget);
    });

    testWidgets('renders nothing when there are no trends', (tester) async {
      await tester.pumpWidget(_wrap(const []));
      await tester.pump();

      expect(find.byType(LineChart), findsNothing);
    });
  });
}
