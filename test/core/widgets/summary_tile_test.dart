import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/theme/app_colors.dart';
import 'package:hms/core/widgets/summary_tile.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('SummaryTile', () {
    testWidgets('renders label and value', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SummaryTile(label: 'Rent Collected', value: 'TZS 1,250,000'),
        ),
      );
      expect(find.text('Rent Collected'), findsOneWidget);
      expect(find.text('TZS 1,250,000'), findsOneWidget);
    });

    testWidgets('renders icon when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SummaryTile(
            label: 'Health Score',
            value: '85%',
            icon: Icons.favorite,
          ),
        ),
      );
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('does NOT render icon when null', (tester) async {
      await tester.pumpWidget(
        _wrap(const SummaryTile(label: 'Health Score', value: '85%')),
      );
      expect(find.byType(Icon), findsNothing);
    });

    testWidgets('trend up shows green Icons.trending_up', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SummaryTile(
            label: 'Revenue',
            value: 'TZS 500,000',
            trend: TrendDirection.up,
            trendText: '+12% from last month',
          ),
        ),
      );
      final icon = tester.widget<Icon>(find.byIcon(Icons.trending_up));
      expect(icon.color, AppColors.success);
    });

    testWidgets('trend down shows red Icons.trending_down', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SummaryTile(
            label: 'Revenue',
            value: 'TZS 500,000',
            trend: TrendDirection.down,
            trendText: '-5% from last month',
          ),
        ),
      );
      final icon = tester.widget<Icon>(find.byIcon(Icons.trending_down));
      expect(icon.color, AppColors.error);
    });

    testWidgets('trend flat shows gray Icons.trending_flat', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SummaryTile(
            label: 'Revenue',
            value: 'TZS 500,000',
            trend: TrendDirection.flat,
            trendText: 'No change',
          ),
        ),
      );
      final icon = tester.widget<Icon>(find.byIcon(Icons.trending_flat));
      expect(icon.color, AppColors.textSecondary);
    });

    testWidgets('trendText is displayed when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SummaryTile(
            label: 'Revenue',
            value: 'TZS 500,000',
            trend: TrendDirection.up,
            trendText: '+12% from last month',
          ),
        ),
      );
      expect(find.text('+12% from last month'), findsOneWidget);
    });

    testWidgets('trendText is NOT displayed when trend is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const SummaryTile(
            label: 'Revenue',
            value: 'TZS 500,000',
            trendText: '+12% from last month',
            // trend intentionally omitted
          ),
        ),
      );
      expect(find.text('+12% from last month'), findsNothing);
    });

    testWidgets('onTap fires when tile is tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          SummaryTile(
            label: 'Revenue',
            value: 'TZS 500,000',
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.tap(find.byType(SummaryTile));
      expect(tapped, isTrue);
    });

    testWidgets('compact mode renders icon and value on the same Row', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const SummaryTile(
            label: 'Expenses',
            value: 'TZS 50K',
            icon: Icons.money_off,
            compact: true,
          ),
        ),
      );
      // In compact mode, the icon and value are siblings in the same Row
      final row = tester.widget<Row>(
        find
            .descendant(
              of: find.byType(SummaryTile),
              matching: find.byType(Row),
            )
            .first,
      );
      final iconFinder = find.byIcon(Icons.money_off);
      final textFinder = find.text('TZS 50K');
      expect(iconFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
      // Both icon and value text must be descendants of the same Row
      expect(
        find.descendant(of: find.byWidget(row), matching: iconFinder),
        findsOneWidget,
      );
      expect(
        find.descendant(of: find.byWidget(row), matching: textFinder),
        findsOneWidget,
      );
    });

    testWidgets('valueColor is applied to the value text', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const SummaryTile(
            label: 'Balance',
            value: 'TZS 0',
            valueColor: Colors.red,
          ),
        ),
      );
      final texts = tester
          .widgetList<Text>(find.byType(Text))
          .where((t) => t.data == 'TZS 0')
          .toList();
      expect(texts, isNotEmpty);
      expect(texts.first.style?.color, Colors.red);
    });
  });
}
