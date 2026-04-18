import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/features/dashboard/models/monthly_report.dart';
import 'package:hms/features/dashboard/providers/monthly_report_provider.dart';
import 'package:hms/features/dashboard/screens/monthly_report_screen.dart';

const _testReport = MonthlyReport(
  period: '2026-03',
  totalIncome: 850000,
  totalExpenses: 620000,
  rentExpected: 750000,
  rentCollected: 650000,
  mainGroundIncome: 540000,
  mainGroundExpenses: 380000,
  minorGroundIncome: 310000,
  minorGroundExpenses: 240000,
);

Widget _wrap(MonthlyReport report) {
  return ProviderScope(
    overrides: [
      // Override the family to return the test report for any period.
      monthlyReportProvider.overrideWith((ref, period) => Future.value(report)),
    ],
    child: const MaterialApp(home: MonthlyReportScreen()),
  );
}

void main() {
  group('MonthlyReportScreen', () {
    testWidgets('renders net position', (tester) async {
      await tester.pumpWidget(_wrap(_testReport));
      await tester.pumpAndSettle();

      // net = 850000 - 620000 = 230000 → "+TZS 230,000"
      expect(find.textContaining('230,000'), findsWidgets);
    });

    testWidgets('renders income value', (tester) async {
      await tester.pumpWidget(_wrap(_testReport));
      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          formatTZS(850000, short: true).replaceAll('TZS ', ''),
        ),
        findsWidgets,
      );
    });

    testWidgets('renders expenses value', (tester) async {
      await tester.pumpWidget(_wrap(_testReport));
      await tester.pumpAndSettle();

      expect(
        find.textContaining(
          formatTZS(620000, short: true).replaceAll('TZS ', ''),
        ),
        findsWidgets,
      );
    });

    testWidgets('month navigation arrows are displayed', (tester) async {
      await tester.pumpWidget(_wrap(_testReport));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('prev_month')), findsOneWidget);
      expect(find.byKey(const Key('next_month')), findsOneWidget);
    });

    testWidgets('renders rent collection section', (tester) async {
      await tester.pumpWidget(_wrap(_testReport));
      await tester.pumpAndSettle();

      expect(find.text('Rent Collection'), findsOneWidget);
    });

    testWidgets('renders top expenses section', (tester) async {
      await tester.pumpWidget(_wrap(_testReport));
      await tester.pumpAndSettle();

      expect(find.text('Top Expenses'), findsOneWidget);
    });

    testWidgets('renders per-ground comparison section', (tester) async {
      await tester.pumpWidget(_wrap(_testReport));
      await tester.pumpAndSettle();

      expect(
        find.text('Per-Ground Comparison', skipOffstage: false),
        findsOneWidget,
      );
      expect(find.text('Main Ground', skipOffstage: false), findsOneWidget);
      expect(find.text('Minor Ground', skipOffstage: false), findsOneWidget);
    });

    testWidgets('shows no overdue message when list is empty', (tester) async {
      const emptyReport = MonthlyReport(period: '2026-03');
      await tester.pumpWidget(_wrap(emptyReport));
      await tester.pumpAndSettle();

      expect(
        find.text('No overdue items', skipOffstage: false),
        findsOneWidget,
      );
    });

    testWidgets('shows electricity section when electricityUnits > 0', (
      tester,
    ) async {
      const reportWithElec = MonthlyReport(
        period: '2026-04',
        totalIncome: 850000,
        totalExpenses: 650000,
        electricityUnits: 120.5,
        electricityEstimatedCost: 25000,
      );
      await tester.pumpWidget(_wrap(reportWithElec));
      await tester.pumpAndSettle();

      // Scroll to bottom to render the electricity section
      await tester.dragUntilVisible(
        find.text('Electricity (Estimated)', skipOffstage: false),
        find.byType(ListView),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      expect(find.text('Electricity (Estimated)'), findsOneWidget);
      expect(find.text('Total Units'), findsOneWidget);
      expect(find.text('Est. Cost'), findsOneWidget);
    });

    testWidgets('hides electricity section when electricityUnits is 0', (
      tester,
    ) async {
      const noElecReport = MonthlyReport(
        period: '2026-04',
        electricityUnits: 0,
      );
      await tester.pumpWidget(_wrap(noElecReport));
      await tester.pumpAndSettle();

      // Scroll to bottom to confirm the section really isn't there
      await tester.drag(find.byType(ListView), const Offset(0, -2000));
      await tester.pumpAndSettle();

      expect(find.text('Electricity (Estimated)'), findsNothing);
    });

    testWidgets('electricity section shows disclaimer text', (tester) async {
      const reportWithElec = MonthlyReport(
        period: '2026-04',
        electricityUnits: 80,
        electricityEstimatedCost: 15000,
      );
      await tester.pumpWidget(_wrap(reportWithElec));
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.textContaining('TANESCO tariff', skipOffstage: false),
        find.byType(ListView),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('TANESCO tariff'), findsOneWidget);
    });
  });
}
