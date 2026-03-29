import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/widgets/app_card.dart';
import 'package:hms/core/widgets/app_card_shimmer.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('AppCard', () {
    testWidgets('renders title text', (tester) async {
      await tester.pumpWidget(_wrap(const AppCard(title: 'Unit 3A')));
      expect(find.text('Unit 3A'), findsOneWidget);
    });

    testWidgets('displays subtitle when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(const AppCard(title: 'Unit 3A', subtitle: 'John Doe')),
      );
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('does not display subtitle when null', (tester) async {
      await tester.pumpWidget(_wrap(const AppCard(title: 'Unit 3A')));
      expect(find.byType(Text), findsOneWidget); // only title
    });

    testWidgets('displays trailingText when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AppCard(
            title: 'Unit 3A',
            trailingText: 'TZS 150,000',
            trailingTextColor: Colors.green,
          ),
        ),
      );
      expect(find.text('TZS 150,000'), findsOneWidget);
    });

    testWidgets('trailingText uses provided color', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AppCard(
            title: 'Unit 3A',
            trailingText: '3 days overdue',
            trailingTextColor: Colors.red,
          ),
        ),
      );
      final text = tester.widget<Text>(find.text('3 days overdue'));
      expect(text.style?.color, Colors.red);
    });

    testWidgets('displays leadingIcon when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(const AppCard(title: 'Unit 3A', leadingIcon: Icons.home)),
      );
      expect(find.byIcon(Icons.home), findsOneWidget);
    });

    testWidgets('does not display icon container when leadingIcon is null', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const AppCard(title: 'Unit 3A')));
      expect(find.byIcon(Icons.home), findsNothing);
    });

    testWidgets('fires onTap callback when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(AppCard(title: 'Unit 3A', onTap: () => tapped = true)),
      );
      await tester.tap(find.byType(AppCard));
      expect(tapped, isTrue);
    });

    testWidgets('fires onLongPress callback on long press', (tester) async {
      var longPressed = false;
      await tester.pumpWidget(
        _wrap(AppCard(title: 'Unit 3A', onLongPress: () => longPressed = true)),
      );
      await tester.longPress(find.byType(AppCard));
      expect(longPressed, isTrue);
    });

    testWidgets('shows chevron when onTap is set and showChevron is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(AppCard(title: 'Unit 3A', onTap: () {}, showChevron: true)),
      );
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('does not show chevron when showChevron is false', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(AppCard(title: 'Unit 3A', onTap: () {})));
      expect(find.byIcon(Icons.chevron_right), findsNothing);
    });

    testWidgets('does not show chevron when onTap is null', (tester) async {
      await tester.pumpWidget(
        _wrap(const AppCard(title: 'Unit 3A', showChevron: true)),
      );
      expect(find.byIcon(Icons.chevron_right), findsNothing);
    });

    testWidgets('renders bottom widget when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AppCard(
            title: 'Unit 3A',
            bottom: LinearProgressIndicator(key: Key('progress')),
          ),
        ),
      );
      expect(find.byKey(const Key('progress')), findsOneWidget);
    });

    testWidgets('renders custom trailing widget when provided', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AppCard(
            title: 'Unit 3A',
            trailing: Chip(key: Key('chip'), label: Text('Paid')),
          ),
        ),
      );
      expect(find.byKey(const Key('chip')), findsOneWidget);
    });

    testWidgets('prefers trailing widget over trailingText', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AppCard(
            title: 'Unit 3A',
            trailingText: 'Should not show',
            trailing: Chip(label: Text('Paid')),
          ),
        ),
      );
      expect(find.text('Should not show'), findsNothing);
      expect(find.text('Paid'), findsOneWidget);
    });
  });

  group('AppCardShimmer', () {
    testWidgets('renders without errors', (tester) async {
      await tester.pumpWidget(_wrap(const AppCardShimmer()));
      expect(find.byType(AppCardShimmer), findsOneWidget);
    });

    testWidgets('renders with all optional flags disabled', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AppCardShimmer(
            showLeadingIcon: false,
            showSubtitle: false,
            showTrailing: false,
          ),
        ),
      );
      expect(find.byType(AppCardShimmer), findsOneWidget);
    });

    testWidgets('animation runs without errors', (tester) async {
      await tester.pumpWidget(_wrap(const AppCardShimmer()));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.byType(AppCardShimmer), findsOneWidget);
    });
  });
}
