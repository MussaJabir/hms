import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/features/grounds/models/rental_unit.dart';
import 'package:hms/features/grounds/models/tenant.dart';
import 'package:hms/features/grounds/providers/move_out_providers.dart';
import 'package:hms/features/grounds/screens/move_out_screen.dart';
import 'package:hms/features/grounds/services/move_out_service.dart';
import 'package:hms/features/grounds/services/rental_unit_service.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

final _now = DateTime(2026, 4, 9);

Tenant _makeTenant() => Tenant(
  id: 't-1',
  groundId: 'g-1',
  unitId: 'u-1',
  fullName: 'Amina Salim',
  phoneNumber: '0712345678',
  moveInDate: DateTime(2025, 6, 1),
  createdAt: _now,
  updatedAt: _now,
  updatedBy: 'user-1',
);

RentalUnit _makeUnit() => RentalUnit(
  id: 'u-1',
  groundId: 'g-1',
  name: 'Room 1',
  rentAmount: 100000,
  status: 'occupied',
  createdAt: _now,
  updatedAt: _now,
  updatedBy: 'user-1',
);

Widget _wrap({MoveOutService? fakeService}) {
  final fakeFirestore = FakeFirebaseFirestore();
  final firestoreService = FirestoreService(firestore: fakeFirestore);
  final activityLogService = ActivityLogService(firestoreService);
  final rentalUnitService = RentalUnitService(
    firestoreService,
    activityLogService,
  );
  final recurringService = RecurringTransactionService(
    firestoreService,
    activityLogService,
  );
  final service =
      fakeService ??
      MoveOutService(
        firestoreService,
        rentalUnitService,
        recurringService,
        activityLogService,
      );

  final tenant = _makeTenant();
  final unit = _makeUnit();

  final router = GoRouter(
    initialLocation: '/grounds/g-1/units/u-1/move-out',
    routes: [
      GoRoute(
        path: '/grounds/:groundId/units/:unitId/move-out',
        builder: (ctx, st) => MoveOutScreen(
          groundId: st.pathParameters['groundId']!,
          unitId: st.pathParameters['unitId']!,
          tenant: tenant,
          unit: unit,
        ),
      ),
      GoRoute(
        path: '/grounds/:groundId/units',
        builder: (ctx, st) => const Scaffold(body: Text('Unit List')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [moveOutServiceProvider.overrideWithValue(service)],
    child: MaterialApp.router(routerConfig: router),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('MoveOutScreen — content', () {
    testWidgets('shows tenant name in summary card', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.textContaining('Amina Salim'), findsWidgets);
    });

    testWidgets('shows unit name in summary card', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.textContaining('Room 1'), findsWidgets);
    });

    testWidgets('shows total outstanding calculation initially as TZS 0', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.text('Total Outstanding'), findsOneWidget);
      expect(find.textContaining('TZS 0'), findsWidgets);
    });

    testWidgets('shows Process Move-Out button', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      // Appears in AppBar title and button label
      expect(find.text('Process Move-Out'), findsWidgets);
    });
  });

  group('MoveOutScreen — confirmation dialog', () {
    testWidgets('shows confirmation dialog on button tap', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      // Scroll to the button (it's at the bottom of the scrollable form)
      final buttonFinder = find.widgetWithText(
        FilledButton,
        'Process Move-Out',
      );
      await tester.ensureVisible(buttonFinder);
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Confirm Move-Out'), findsOneWidget);
      expect(find.text('Yes, Move Out'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('dismisses dialog when Cancel is tapped', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      final buttonFinder = find.widgetWithText(
        FilledButton,
        'Process Move-Out',
      );
      await tester.ensureVisible(buttonFinder);
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Confirm Move-Out'), findsNothing);
    });
  });
}
