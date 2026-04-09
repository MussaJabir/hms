import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/models/ground.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/features/dashboard/widgets/grounds_selector.dart';
import 'package:hms/features/grounds/models/ground_filter.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

final _now = DateTime(2026, 4, 9);

Ground _makeGround(String id, String name) => Ground(
  id: id,
  name: name,
  location: 'Dar es Salaam',
  numberOfUnits: 5,
  createdAt: _now,
  updatedAt: _now,
  updatedBy: 'user-1',
);

Widget _wrap(List<Ground> grounds) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (ctx, st) => Scaffold(body: const GroundsSelector()),
      ),
      GoRoute(
        path: '/grounds/add',
        builder: (ctx, st) => const Scaffold(body: Text('Add Ground')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      allGroundsProvider.overrideWith((ref) => Stream.value(grounds)),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

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

  group('GroundsSelector widget — with grounds', () {
    testWidgets('renders "All" chip plus each ground name', (tester) async {
      await tester.pumpWidget(
        _wrap([
          _makeGround('g-1', 'Main Ground'),
          _makeGround('g-2', 'Minor Ground'),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Main Ground'), findsOneWidget);
      expect(find.text('Minor Ground'), findsOneWidget);
    });

    testWidgets('defaults to "All" selected (currentGroundProvider is null)', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap([_makeGround('g-1', 'Main Ground')]));
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(GroundsSelector)),
      );
      expect(container.read(currentGroundProvider), isNull);
    });

    testWidgets('tapping a ground chip sets currentGroundProvider to its ID', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap([_makeGround('g-1', 'Main Ground')]));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Main Ground'));
      await tester.pump();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(GroundsSelector)),
      );
      expect(container.read(currentGroundProvider), equals('g-1'));
    });

    testWidgets('tapping "All" sets currentGroundProvider back to null', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap([_makeGround('g-1', 'Main Ground')]));
      await tester.pumpAndSettle();

      // First select a ground
      await tester.tap(find.text('Main Ground'));
      await tester.pump();

      // Then tap "All"
      await tester.tap(find.text('All'));
      await tester.pump();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(GroundsSelector)),
      );
      expect(container.read(currentGroundProvider), isNull);
    });

    testWidgets('selected chip has primary color background', (tester) async {
      await tester.pumpWidget(_wrap([_makeGround('g-1', 'Main Ground')]));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Main Ground'));
      await tester.pumpAndSettle();

      final containers = tester
          .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
          .toList();

      // index 1 = Main Ground chip (after "All")
      final decoration = containers[1].decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFF1B4F72)); // AppColors.primary
    });
  });

  group('GroundsSelector widget — no grounds', () {
    testWidgets('shows "Add Property" button when no grounds exist', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap([]));
      await tester.pumpAndSettle();

      expect(find.text('Add Property'), findsOneWidget);
    });

    testWidgets('does not show "All" chip when no grounds exist', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap([]));
      await tester.pumpAndSettle();

      expect(find.text('All'), findsNothing);
    });

    testWidgets('"Add Property" button navigates to /grounds/add', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap([]));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add Property'));
      await tester.pumpAndSettle();

      expect(find.text('Add Ground'), findsOneWidget);
    });
  });
}
