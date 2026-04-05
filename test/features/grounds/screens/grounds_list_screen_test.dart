import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/models/ground.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';
import 'package:hms/features/grounds/screens/grounds_list_screen.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Ground _ground({required String id, required String name}) {
  final now = DateTime(2026, 4, 5);
  return Ground(
    id: id,
    name: name,
    location: 'Dar es Salaam',
    numberOfUnits: 4,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

Widget _wrap(Stream<List<Ground>> groundsStream) {
  final router = GoRouter(
    initialLocation: '/grounds',
    routes: [
      GoRoute(
        path: '/grounds',
        builder: (ctx, st) => const GroundsListScreen(),
      ),
      GoRoute(
        path: '/grounds/add',
        builder: (ctx, st) => const Scaffold(body: Text('Add Ground')),
      ),
      GoRoute(
        path: '/grounds/:groundId',
        builder: (ctx, st) => const Scaffold(body: Text('Ground Detail')),
      ),
    ],
  );
  return ProviderScope(
    overrides: [allGroundsProvider.overrideWith((ref) => groundsStream)],
    child: MaterialApp.router(routerConfig: router),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('GroundsListScreen — empty state', () {
    testWidgets('shows empty state when grounds list is empty', (tester) async {
      await tester.pumpWidget(_wrap(Stream.value([])));
      await tester.pump();

      expect(find.text('No Properties Set Up'), findsOneWidget);
      expect(find.text('Add Property'), findsWidgets);
    });
  });

  group('GroundsListScreen — with data', () {
    testWidgets('renders a card for each ground', (tester) async {
      final grounds = [
        _ground(id: 'g1', name: 'Main Ground'),
        _ground(id: 'g2', name: 'Minor Ground'),
      ];

      await tester.pumpWidget(_wrap(Stream.value(grounds)));
      await tester.pump();

      expect(find.text('Main Ground'), findsOneWidget);
      expect(find.text('Minor Ground'), findsOneWidget);
    });

    testWidgets('shows unit count as trailing text', (tester) async {
      final grounds = [_ground(id: 'g1', name: 'Main Ground')];

      await tester.pumpWidget(_wrap(Stream.value(grounds)));
      await tester.pump();

      expect(find.text('4 units'), findsOneWidget);
    });
  });

  group('GroundsListScreen — app bar', () {
    testWidgets('shows add button', (tester) async {
      await tester.pumpWidget(_wrap(const Stream.empty()));
      await tester.pump();

      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}
