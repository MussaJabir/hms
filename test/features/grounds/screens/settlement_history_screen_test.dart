import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/features/grounds/models/settlement.dart';
import 'package:hms/features/grounds/providers/move_out_providers.dart';
import 'package:hms/features/grounds/screens/settlement_history_screen.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

final _now = DateTime(2026, 4, 9);

Settlement _makeSettlement({
  String id = 's-1',
  String tenantName = 'Amina Salim',
  String status = 'pending',
  double outstandingRent = 50000,
}) => Settlement(
  id: id,
  groundId: 'g-1',
  unitId: 'u-1',
  tenantId: 't-1',
  tenantName: tenantName,
  moveOutDate: _now,
  outstandingRent: outstandingRent,
  status: status,
  createdAt: _now,
  updatedAt: _now,
  updatedBy: 'user-1',
);

Widget _wrap(List<Settlement> settlements) {
  final router = GoRouter(
    initialLocation: '/grounds/g-1/units/u-1/settlements',
    routes: [
      GoRoute(
        path: '/grounds/:groundId/units/:unitId/settlements',
        builder: (ctx, st) => SettlementHistoryScreen(
          groundId: st.pathParameters['groundId']!,
          unitId: st.pathParameters['unitId']!,
          unitName: 'Room 1',
        ),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      settlementsProvider(
        'g-1',
        'u-1',
      ).overrideWith((ref) async => settlements),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('SettlementHistoryScreen', () {
    testWidgets('shows empty state when no settlements', (tester) async {
      await tester.pumpWidget(_wrap([]));
      await tester.pumpAndSettle();

      expect(find.text('No Past Tenants'), findsOneWidget);
    });

    testWidgets('shows settlement card with tenant name', (tester) async {
      await tester.pumpWidget(_wrap([_makeSettlement()]));
      await tester.pumpAndSettle();

      expect(find.textContaining('Amina Salim'), findsWidgets);
    });

    testWidgets('shows Pending status badge for pending settlement', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap([_makeSettlement(status: 'pending')]));
      await tester.pumpAndSettle();

      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('shows Paid status badge for settled settlement', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap([_makeSettlement(status: 'settled')]));
      await tester.pumpAndSettle();

      expect(find.text('Paid'), findsOneWidget);
    });

    testWidgets('shows Waived status badge for waived settlement', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap([_makeSettlement(status: 'waived')]));
      await tester.pumpAndSettle();

      expect(find.text('Waived'), findsOneWidget);
    });

    testWidgets('shows multiple settlement cards', (tester) async {
      await tester.pumpWidget(
        _wrap([
          _makeSettlement(id: 's-1', tenantName: 'Amina Salim'),
          _makeSettlement(id: 's-2', tenantName: 'John Doe', status: 'settled'),
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Amina Salim'), findsWidgets);
      expect(find.textContaining('John Doe'), findsWidgets);
    });
  });
}
