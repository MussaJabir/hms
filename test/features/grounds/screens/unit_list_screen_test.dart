import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/models/ground.dart';
import 'package:hms/features/grounds/models/rental_unit.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';
import 'package:hms/features/grounds/providers/rental_unit_providers.dart';
import 'package:hms/features/grounds/screens/unit_list_screen.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _groundId = 'g-1';

Ground _ground() {
  final now = DateTime(2026, 4, 5);
  return Ground(
    id: _groundId,
    name: 'Main Ground',
    location: 'Dar es Salaam',
    numberOfUnits: 3,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

RentalUnit _unit({
  required String id,
  required String name,
  String status = 'vacant',
}) {
  final now = DateTime(2026, 4, 5);
  return RentalUnit(
    id: id,
    groundId: _groundId,
    name: name,
    rentAmount: 150000,
    status: status,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

Widget _wrap(Stream<List<RentalUnit>> unitsStream) {
  final router = GoRouter(
    initialLocation: '/grounds/$_groundId/units',
    routes: [
      GoRoute(
        path: '/grounds/:groundId/units',
        builder: (ctx, st) =>
            UnitListScreen(groundId: st.pathParameters['groundId']!),
      ),
      GoRoute(
        path: '/grounds/:groundId/units/add',
        builder: (ctx, st) => const Scaffold(body: Text('Add Unit')),
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      allUnitsProvider(_groundId).overrideWith((ref) => unitsStream),
      groundByIdProvider(
        _groundId,
      ).overrideWith((ref) => Stream.value(_ground())),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('UnitListScreen — empty state', () {
    testWidgets('shows empty state when no units', (tester) async {
      await tester.pumpWidget(_wrap(Stream.value([])));
      await tester.pump();

      expect(find.text('No Units Yet'), findsOneWidget);
      expect(find.text('Add Unit'), findsWidgets);
    });
  });

  group('UnitListScreen — with data', () {
    testWidgets('shows a card for each unit', (tester) async {
      final units = [
        _unit(id: 'u1', name: 'Room 1', status: 'occupied'),
        _unit(id: 'u2', name: 'Room 2', status: 'vacant'),
      ];

      await tester.pumpWidget(_wrap(Stream.value(units)));
      await tester.pump();

      expect(find.text('Room 1'), findsOneWidget);
      expect(find.text('Room 2'), findsOneWidget);
    });

    testWidgets('shows rent amount as subtitle', (tester) async {
      await tester.pumpWidget(
        _wrap(Stream.value([_unit(id: 'u1', name: 'Room 1')])),
      );
      await tester.pump();

      expect(find.textContaining('150,000'), findsOneWidget);
    });

    testWidgets('shows status badge for occupied unit', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Stream.value([_unit(id: 'u1', name: 'Room 1', status: 'occupied')]),
        ),
      );
      await tester.pump();

      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('shows status badge for vacant unit', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Stream.value([_unit(id: 'u1', name: 'Room 1', status: 'vacant')]),
        ),
      );
      await tester.pump();

      expect(find.text('Vacant'), findsOneWidget);
    });
  });

  group('UnitListScreen — app bar', () {
    testWidgets('shows add button', (tester) async {
      await tester.pumpWidget(_wrap(const Stream.empty()));
      await tester.pump();

      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}
