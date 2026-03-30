import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/widgets/shimmer/shimmer.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );
}

void main() {
  group('ShimmerBox', () {
    testWidgets('renders with correct width and height', (tester) async {
      await tester.pumpWidget(_wrap(const ShimmerBox(width: 120, height: 20)));
      final container = tester
          .widgetList<Container>(find.byType(Container))
          .firstWhere((c) => c.constraints?.maxWidth == 120);
      expect(container.constraints?.maxWidth, 120);
    });

    testWidgets('renders with specified borderRadius', (tester) async {
      await tester.pumpWidget(
        _wrap(const ShimmerBox(height: 40, borderRadius: 20)),
      );
      final containers = tester
          .widgetList<Container>(find.byType(Container))
          .toList();
      final rounded = containers.firstWhere(
        (c) =>
            c.decoration is BoxDecoration &&
            (c.decoration as BoxDecoration).borderRadius ==
                BorderRadius.circular(20),
        orElse: () => throw TestFailure('No container with borderRadius 20'),
      );
      expect(
        (rounded.decoration as BoxDecoration).borderRadius,
        BorderRadius.circular(20),
      );
    });
  });

  group('ShimmerCard', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(_wrap(const ShimmerCard()));
      expect(find.byType(ShimmerCard), findsOneWidget);
    });

    testWidgets('shows leading icon placeholder when showLeadingIcon is true', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const ShimmerCard(showLeadingIcon: true)));
      // Leading is a 40x40 circle ShimmerBox
      final circles = tester
          .widgetList<Container>(find.byType(Container))
          .where(
            (c) =>
                c.decoration is BoxDecoration &&
                (c.decoration as BoxDecoration).borderRadius ==
                    BorderRadius.circular(20),
          )
          .toList();
      expect(circles, isNotEmpty);
    });

    testWidgets(
      'hides leading icon placeholder when showLeadingIcon is false',
      (tester) async {
        await tester.pumpWidget(
          _wrap(const ShimmerCard(showLeadingIcon: false)),
        );
        final circles = tester
            .widgetList<Container>(find.byType(Container))
            .where(
              (c) =>
                  c.decoration is BoxDecoration &&
                  (c.decoration as BoxDecoration).borderRadius ==
                      BorderRadius.circular(20),
            )
            .toList();
        expect(circles, isEmpty);
      },
    );

    testWidgets('shows trailing placeholder when showTrailing is true', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const ShimmerCard(showTrailing: true)));
      // Trailing is a ShimmerBox with width 80
      final trailing = tester
          .widgetList<Container>(find.byType(Container))
          .where(
            (c) =>
                c.constraints?.maxWidth == 80 && c.constraints?.maxHeight == 14,
          )
          .toList();
      expect(trailing, isNotEmpty);
    });
  });

  group('ShimmerAlertCard', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(_wrap(const ShimmerAlertCard()));
      expect(find.byType(ShimmerAlertCard), findsOneWidget);
    });
  });

  group('ShimmerSummaryTile', () {
    testWidgets('renders in standard mode without errors', (tester) async {
      await tester.pumpWidget(_wrap(const ShimmerSummaryTile()));
      expect(find.byType(ShimmerSummaryTile), findsOneWidget);
    });

    testWidgets('renders in compact mode without errors', (tester) async {
      await tester.pumpWidget(_wrap(const ShimmerSummaryTile(compact: true)));
      expect(find.byType(ShimmerSummaryTile), findsOneWidget);
    });
  });

  group('ShimmerList', () {
    testWidgets('renders correct number of items', (tester) async {
      await tester.pumpWidget(_wrap(const ShimmerList(itemCount: 3)));
      expect(find.byType(ShimmerCard), findsNWidgets(3));
    });

    testWidgets('renders ShimmerCard items when type is card', (tester) async {
      await tester.pumpWidget(
        _wrap(const ShimmerList(itemCount: 2, type: ShimmerListType.card)),
      );
      expect(find.byType(ShimmerCard), findsNWidgets(2));
    });

    testWidgets('renders ShimmerAlertCard items when type is alertCard', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const ShimmerList(itemCount: 2, type: ShimmerListType.alertCard)),
      );
      expect(find.byType(ShimmerAlertCard), findsNWidgets(2));
    });
  });

  group('ShimmerEffect', () {
    testWidgets('creates and disposes without ticker leak', (tester) async {
      await tester.pumpWidget(
        _wrap(
          ShimmerEffect(
            child: Container(width: 100, height: 20, color: Colors.grey),
          ),
        ),
      );
      expect(find.byType(ShimmerEffect), findsOneWidget);
      // Pump a few frames to verify animation runs
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 1000));
      // Dispose by removing the widget — no ticker leak assertion
      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
      expect(find.byType(ShimmerEffect), findsNothing);
    });
  });
}
