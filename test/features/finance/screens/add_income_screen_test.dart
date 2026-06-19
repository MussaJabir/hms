import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/models/ground.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/finance/providers/income_providers.dart';
import 'package:hms/features/finance/screens/add_income_screen.dart';
import 'package:hms/features/finance/services/income_service.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';

Ground _ground(String id, String name) {
  final now = DateTime(2026, 6, 19);
  return Ground(
    id: id,
    name: name,
    location: 'Dar es Salaam',
    numberOfUnits: 5,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

Widget _wrap({List<Ground> grounds = const []}) {
  final fake = FakeFirebaseFirestore();
  final firestore = FirestoreService(firestore: fake);
  final service = IncomeService(firestore, ActivityLogService(firestore));

  return ProviderScope(
    overrides: [
      incomeServiceProvider.overrideWithValue(service),
      authStateProvider.overrideWith((ref) => const Stream.empty()),
      allGroundsProvider.overrideWith((ref) => Stream.value(grounds)),
    ],
    child: const MaterialApp(home: AddIncomeScreen()),
  );
}

void main() {
  group('AddIncomeScreen', () {
    testWidgets('renders all form fields', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.text('Source'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Amount (TZS)'), findsOneWidget);
      expect(find.text('Date'), findsOneWidget);
      expect(find.text('Ground (optional)'), findsOneWidget);
      expect(find.text('Notes (optional)'), findsOneWidget);
      expect(find.text('Save Income'), findsOneWidget);
    });

    testWidgets('excludes rent from the source dropdown', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      // Open the source dropdown.
      await tester.tap(find.text('Freelance'));
      await tester.pumpAndSettle();

      // Rent is auto-linked only — it must never appear as a choice.
      expect(find.text('Rent'), findsNothing);
      // Other sources are present.
      expect(find.text('Bodaboda'), findsOneWidget);
      expect(find.text('Salary'), findsOneWidget);
    });

    testWidgets('lists grounds in the ground dropdown', (tester) async {
      await tester.pumpWidget(_wrap(grounds: [_ground('g-1', 'Main Ground')]));
      await tester.pump();

      // "None" is the default selection shown in the field.
      expect(find.text('None'), findsOneWidget);

      await tester.tap(find.text('None'));
      await tester.pumpAndSettle();

      expect(find.text('Main Ground'), findsOneWidget);
    });
  });
}
