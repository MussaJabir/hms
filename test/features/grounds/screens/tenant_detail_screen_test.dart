import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/features/grounds/models/tenant.dart';
import 'package:hms/features/grounds/providers/tenant_providers.dart';
import 'package:hms/features/grounds/screens/tenant_detail_screen.dart';
import 'package:hms/features/grounds/services/rental_unit_service.dart';
import 'package:hms/features/grounds/services/tenant_service.dart';
import 'package:hms/features/rent/services/rent_config_service.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _groundId = 'g-1';
const _unitId = 'u-1';

Tenant _tenant({DateTime? leaseEndDate}) {
  final now = DateTime(2026, 4, 5);
  return Tenant(
    id: 't-1',
    groundId: _groundId,
    unitId: _unitId,
    fullName: 'Amina Salim',
    phoneNumber: '0712345678',
    moveInDate: DateTime(2025, 6, 1),
    leaseEndDate: leaseEndDate,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

Widget _wrap(Tenant? tenant) {
  // Use fake Firestore so communication logs don't hit real Firebase
  final fakeFirestore = FakeFirebaseFirestore();
  final firestoreService = FirestoreService(firestore: fakeFirestore);
  final activityLogService = ActivityLogService(firestoreService);
  final recurringService = RecurringTransactionService(
    firestoreService,
    activityLogService,
  );
  final rentConfigService = RentConfigService(recurringService);
  final rentalUnitService = RentalUnitService(
    firestoreService,
    activityLogService,
    rentConfigService,
  );
  final fakeTenantService = TenantService(
    firestoreService,
    activityLogService,
    rentalUnitService,
    recurringService,
  );

  final router = GoRouter(
    initialLocation: '/grounds/$_groundId/units/$_unitId/tenant',
    routes: [
      GoRoute(
        path: '/grounds/:groundId/units/:unitId/tenant',
        builder: (ctx, st) => TenantDetailScreen(
          groundId: st.pathParameters['groundId']!,
          unitId: st.pathParameters['unitId']!,
        ),
      ),
      GoRoute(
        path: '/grounds/:groundId/units/:unitId/tenant/add',
        builder: (ctx, st) => const Scaffold(body: Text('Add Tenant')),
      ),
      GoRoute(
        path: '/grounds/:groundId/units/:unitId/tenant/edit',
        builder: (ctx, st) => const Scaffold(body: Text('Edit Tenant')),
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      currentTenantProvider(
        _groundId,
        _unitId,
      ).overrideWith((ref) => Stream.value(tenant)),
      tenantServiceProvider.overrideWithValue(fakeTenantService),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('TenantDetailScreen — renders tenant info', () {
    testWidgets('shows tenant name', (tester) async {
      await tester.pumpWidget(_wrap(_tenant()));
      await tester.pump();

      expect(find.text('Amina Salim'), findsWidgets);
    });

    testWidgets('shows phone number', (tester) async {
      await tester.pumpWidget(_wrap(_tenant()));
      await tester.pump();

      expect(find.textContaining('0712345678'), findsOneWidget);
    });

    testWidgets('shows move-in date formatted as dd/MM/yyyy', (tester) async {
      await tester.pumpWidget(_wrap(_tenant()));
      await tester.pump();

      expect(find.textContaining('01/06/2025'), findsOneWidget);
    });

    testWidgets('shows Active status badge when lease not expired', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(_tenant(leaseEndDate: DateTime(2027, 12, 31))),
      );
      await tester.pump();

      expect(find.text('Active'), findsOneWidget);
    });

    testWidgets('shows Overdue badge when lease expired', (tester) async {
      await tester.pumpWidget(
        _wrap(_tenant(leaseEndDate: DateTime(2024, 1, 1))),
      );
      await tester.pump();

      expect(find.text('Overdue'), findsOneWidget);
    });
  });

  group('TenantDetailScreen — communication log section', () {
    testWidgets('shows Communication Log section header', (tester) async {
      await tester.pumpWidget(_wrap(_tenant()));
      await tester.pump();

      expect(find.text('Communication Log'), findsOneWidget);
    });

    testWidgets('shows Add Note button', (tester) async {
      await tester.pumpWidget(_wrap(_tenant()));
      await tester.pump();

      expect(find.text('Add Note'), findsOneWidget);
    });
  });

  group('TenantDetailScreen — no tenant', () {
    testWidgets('shows empty state when no tenant', (tester) async {
      await tester.pumpWidget(_wrap(null));
      await tester.pump();

      expect(find.text('No Tenants Yet'), findsOneWidget);
    });
  });
}
