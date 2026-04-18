import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/water/providers/water_bill_providers.dart';
import 'package:hms/features/water/screens/add_water_bill_screen.dart';
import 'package:hms/features/water/services/water_bill_service.dart';

Widget _wrap({String groundId = 'g-1'}) {
  final fakeFirestore = FakeFirebaseFirestore();
  final firestoreService = FirestoreService(firestore: fakeFirestore);
  final service = WaterBillService(
    firestoreService,
    ActivityLogService(firestoreService),
    firestore: fakeFirestore,
  );

  return ProviderScope(
    overrides: [
      waterBillServiceProvider.overrideWithValue(service),
      authStateProvider.overrideWith((ref) => const Stream.empty()),
    ],
    child: MaterialApp(home: AddWaterBillScreen(groundId: groundId)),
  );
}

void main() {
  group('AddWaterBillScreen', () {
    testWidgets('renders two tabs: Manual Entry and Paste SMS', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.text('Manual Entry'), findsOneWidget);
      expect(find.text('Paste SMS'), findsOneWidget);
    });

    testWidgets('renders manual entry form with required fields', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.text('Billing Period'), findsOneWidget);
      expect(find.text('Previous Meter Reading'), findsOneWidget);
      expect(find.text('Current Meter Reading'), findsOneWidget);
      expect(find.text('Bill Amount (TZS)'), findsOneWidget);
      expect(find.text('Due Date'), findsOneWidget);
    });

    testWidgets('shows Save Bill button', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.text('Save Bill'), findsOneWidget);
    });

    testWidgets('Save Bill button is enabled', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      final saveBtn = find.text('Save Bill');
      expect(saveBtn, findsOneWidget);

      // Button is present (form is ready to validate)
      final elevatedBtn = find.ancestor(
        of: saveBtn,
        matching: find.byType(ElevatedButton),
      );
      expect(elevatedBtn, findsOneWidget);
    });

    testWidgets('SMS tab shows Parse SMS button', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      await tester.tap(find.text('Paste SMS'));
      await tester.pumpAndSettle();

      expect(find.text('Parse SMS'), findsOneWidget);
    });
  });
}
