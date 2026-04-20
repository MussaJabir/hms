import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/auth/providers/user_providers.dart';
import 'package:hms/features/water/models/water_bill.dart';
import 'package:hms/features/water/models/water_surplus_deficit.dart';
import 'package:hms/features/water/providers/water_bill_providers.dart';
import 'package:hms/features/water/providers/water_contribution_providers.dart';
import 'package:hms/features/water/screens/water_bill_detail_screen.dart';
import 'package:hms/features/water/services/water_bill_service.dart';

const _groundId = 'g-1';

WaterBill _bill({String status = 'unpaid'}) {
  final now = DateTime(2026, 4, 18);
  return WaterBill(
    id: 'b-1',
    groundId: _groundId,
    billingPeriod: '2026-03',
    previousMeterReading: 100,
    currentMeterReading: 160,
    totalAmount: 25000,
    dueDate: now.add(const Duration(days: 10)),
    status: status,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

Widget _wrap(WaterBill bill) {
  final fakeFirestore = FakeFirebaseFirestore();
  final firestoreService = FirestoreService(firestore: fakeFirestore);
  final service = WaterBillService(
    firestoreService,
    ActivityLogService(firestoreService),
    firestore: fakeFirestore,
  );

  final noSurplus = WaterSurplusDeficit(
    period: bill.billingPeriod,
    groundId: _groundId,
    totalCollected: 0,
    actualBillAmount: 0,
    totalTenants: 0,
    paidTenants: 0,
  );

  return ProviderScope(
    overrides: [
      waterBillServiceProvider.overrideWithValue(service),
      authStateProvider.overrideWith((ref) => const Stream.empty()),
      currentUserProfileProvider.overrideWith((ref) => Stream.value(null)),
      surplusDeficitProvider(
        _groundId,
        bill.billingPeriod,
      ).overrideWith((ref) async => noSurplus),
    ],
    child: MaterialApp(
      home: WaterBillDetailScreen(
        groundId: _groundId,
        billId: 'b-1',
        bill: bill,
      ),
    ),
  );
}

void main() {
  group('WaterBillDetailScreen', () {
    testWidgets('shows bill amount at top', (tester) async {
      await tester.pumpWidget(_wrap(_bill()));
      await tester.pump();

      expect(find.textContaining('25,000'), findsAtLeast(1));
    });

    testWidgets('shows Mark as Paid button for unpaid bills', (tester) async {
      await tester.pumpWidget(_wrap(_bill(status: 'unpaid')));
      await tester.pump();

      expect(find.text('Mark as Paid'), findsOneWidget);
    });

    testWidgets('does not show Mark as Paid for paid bills', (tester) async {
      await tester.pumpWidget(_wrap(_bill(status: 'paid')));
      await tester.pump();

      expect(find.text('Mark as Paid'), findsNothing);
    });

    testWidgets('shows billing period and meter readings', (tester) async {
      await tester.pumpWidget(_wrap(_bill()));
      await tester.pump();

      expect(find.text('Billing Period'), findsOneWidget);
      expect(find.text('Previous Reading'), findsOneWidget);
      expect(find.text('Current Reading'), findsOneWidget);
      expect(find.text('Units Consumed'), findsOneWidget);
    });

    testWidgets('shows edit icon button', (tester) async {
      await tester.pumpWidget(_wrap(_bill()));
      await tester.pump();

      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    });
  });
}
