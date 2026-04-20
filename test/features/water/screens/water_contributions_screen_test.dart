import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/models/recurring_record.dart';
import 'package:hms/features/water/models/water_surplus_deficit.dart';
import 'package:hms/features/water/providers/water_contribution_providers.dart';
import 'package:hms/features/water/screens/water_contributions_screen.dart';

const _groundId = 'g-1';

WaterSurplusDeficit _surplus({
  double totalCollected = 30000,
  double actualBillAmount = 25000,
  int totalTenants = 3,
  int paidTenants = 2,
}) => WaterSurplusDeficit(
  period: '2026-04',
  groundId: _groundId,
  totalCollected: totalCollected,
  actualBillAmount: actualBillAmount,
  totalTenants: totalTenants,
  paidTenants: paidTenants,
);

RecurringRecord _record({
  String id = 'water_t-1_2026-04',
  String status = 'pending',
}) {
  final now = DateTime(2026, 4, 5);
  return RecurringRecord(
    id: id,
    configId: 'water_t-1',
    type: 'water_contribution',
    linkedEntityId: 't-1',
    linkedEntityName: 'Amina Salim — Room 1',
    amount: 5000,
    period: '2026-04',
    status: status,
    dueDate: now.add(const Duration(days: 10)),
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

Widget _wrap({
  List<RecurringRecord> records = const [],
  WaterSurplusDeficit? surplus,
}) {
  final now = DateTime.now();
  final period = '${now.year}-${now.month.toString().padLeft(2, '0')}';
  final sd = surplus ?? _surplus();

  final router = GoRouter(
    initialLocation: '/grounds/$_groundId/water/contributions',
    routes: [
      GoRoute(
        path: '/grounds/:groundId/water/contributions',
        builder: (ctx, st) =>
            WaterContributionsScreen(groundId: st.pathParameters['groundId']!),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      monthContributionsProvider(
        _groundId,
        period,
      ).overrideWith((ref) => Stream.value(records)),
      surplusDeficitProvider(_groundId, period).overrideWith((ref) async => sd),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  group('WaterContributionsScreen', () {
    testWidgets('shows summary tiles including surplus/deficit', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          records: [
            _record(status: 'paid'),
            _record(id: 'r2', status: 'pending'),
          ],
          surplus: _surplus(
            totalCollected: 5000,
            actualBillAmount: 25000,
            totalTenants: 2,
            paidTenants: 1,
          ),
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Collected'), findsOneWidget);
      expect(find.text('Bill Amount'), findsOneWidget);
      expect(find.text('Collection Rate'), findsOneWidget);
      // Deficit since collected < bill
      expect(find.text('Deficit'), findsOneWidget);
    });

    testWidgets('shows tenant cards with status badges', (tester) async {
      await tester.pumpWidget(
        _wrap(
          records: [
            _record(id: 'r1', status: 'paid'),
            _record(id: 'r2', status: 'pending'),
          ],
        ),
      );
      await tester.pump();
      await tester.pump();

      expect(find.text('Amina Salim — Room 1'), findsNWidgets(2));
      expect(find.text('Paid'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('shows empty state when no records', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      await tester.pump();

      expect(find.text('No contributions yet'), findsOneWidget);
    });

    testWidgets('quick payment bottom sheet shows amount and method', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(records: [_record(status: 'pending')]));
      await tester.pump();
      await tester.pump();

      // Tap a pending card to open the payment sheet
      await tester.tap(find.text('Amina Salim — Room 1').first);
      await tester.pumpAndSettle();

      expect(find.text('Record Payment'), findsOneWidget);
      expect(find.text('TZS 5,000'), findsAtLeast(1));
      expect(find.text('Confirm Payment'), findsOneWidget);
    });
  });
}
