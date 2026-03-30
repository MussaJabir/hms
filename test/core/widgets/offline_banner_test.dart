import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/widgets/connection_status.dart';
import 'package:hms/core/widgets/offline_banner.dart';

Widget _wrap(Widget child, {required bool isOnline}) {
  return ProviderScope(
    overrides: [
      connectivityProvider.overrideWith((ref) => Stream.value(isOnline)),
    ],
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  group('OfflineBanner', () {
    testWidgets('always renders the child widget', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const OfflineBanner(child: Text('Screen content')),
          isOnline: true,
        ),
      );
      await tester.pump();
      expect(find.text('Screen content'), findsOneWidget);
    });

    testWidgets('child is rendered when offline too', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const OfflineBanner(child: Text('Screen content')),
          isOnline: false,
        ),
      );
      await tester.pump();
      expect(find.text('Screen content'), findsOneWidget);
    });

    testWidgets('offline banner is NOT visible when online', (tester) async {
      await tester.pumpWidget(
        _wrap(const OfflineBanner(child: SizedBox.shrink()), isOnline: true),
      );
      await tester.pump();
      expect(
        find.text(
          'You are offline — changes will sync when connection is restored',
        ),
        findsNothing,
      );
    });

    testWidgets('offline banner IS visible when offline', (tester) async {
      await tester.pumpWidget(
        _wrap(const OfflineBanner(child: SizedBox.shrink()), isOnline: false),
      );
      await tester.pump();
      expect(
        find.text(
          'You are offline — changes will sync when connection is restored',
        ),
        findsOneWidget,
      );
    });

    testWidgets('offline banner shows cloud_off icon when offline', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const OfflineBanner(child: SizedBox.shrink()), isOnline: false),
      );
      await tester.pump();
      expect(find.byIcon(Icons.cloud_off), findsOneWidget);
    });

    testWidgets('no cloud_off icon when online', (tester) async {
      await tester.pumpWidget(
        _wrap(const OfflineBanner(child: SizedBox.shrink()), isOnline: true),
      );
      await tester.pump();
      expect(find.byIcon(Icons.cloud_off), findsNothing);
    });
  });

  group('ConnectionStatus', () {
    testWidgets('shows green dot and Online label when connected', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const ConnectionStatus(), isOnline: true));
      await tester.pump();
      expect(find.text('Online'), findsOneWidget);

      final dot = tester
          .widgetList<Container>(find.byType(Container))
          .firstWhere(
            (c) =>
                c.decoration is BoxDecoration &&
                (c.decoration as BoxDecoration).shape == BoxShape.circle &&
                (c.decoration as BoxDecoration).color != null,
          );
      expect(
        (dot.decoration as BoxDecoration).color,
        const Color(0xFF27AE60), // AppColors.success
      );
    });

    testWidgets('shows red dot and Offline label when disconnected', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const ConnectionStatus(), isOnline: false));
      await tester.pump();
      expect(find.text('Offline'), findsOneWidget);

      final dot = tester
          .widgetList<Container>(find.byType(Container))
          .firstWhere(
            (c) =>
                c.decoration is BoxDecoration &&
                (c.decoration as BoxDecoration).shape == BoxShape.circle &&
                (c.decoration as BoxDecoration).color != null,
          );
      expect(
        (dot.decoration as BoxDecoration).color,
        const Color(0xFFE74C3C), // AppColors.error
      );
    });

    testWidgets('compact mode shows dot without label', (tester) async {
      await tester.pumpWidget(
        _wrap(const ConnectionStatus(compact: true), isOnline: true),
      );
      await tester.pump();
      expect(find.text('Online'), findsNothing);
      expect(find.text('Offline'), findsNothing);
      // Dot container should still be present
      final dots = tester
          .widgetList<Container>(find.byType(Container))
          .where(
            (c) =>
                c.decoration is BoxDecoration &&
                (c.decoration as BoxDecoration).shape == BoxShape.circle,
          )
          .toList();
      expect(dots, isNotEmpty);
    });

    testWidgets('compact: false with showLabel: false — no text rendered', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const ConnectionStatus(showLabel: false), isOnline: true),
      );
      await tester.pump();
      expect(find.text('Online'), findsNothing);
    });
  });
}
