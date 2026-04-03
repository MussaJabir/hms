import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/features/dashboard/models/health_score.dart';
import 'package:hms/features/dashboard/providers/health_score_provider.dart';
import 'package:hms/features/dashboard/widgets/health_score_card.dart';

Widget _wrap(Widget child, {HealthScore? score}) {
  return ProviderScope(
    overrides: [
      if (score != null) healthScoreProvider.overrideWithValue(score),
    ],
    child: MaterialApp(
      home: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );
}

void main() {
  group('HealthScoreCard', () {
    testWidgets('renders the percentage number', (tester) async {
      const score = HealthScore(rentScore: 80, rentActive: true);
      await tester.pumpWidget(_wrap(const HealthScoreCard(), score: score));
      await tester.pump();

      // totalScore for single active module = 80, rounded = 80
      expect(find.text('80'), findsOneWidget);
    });

    testWidgets('renders the correct label — Excellent', (tester) async {
      const score = HealthScore(rentScore: 90, rentActive: true);
      await tester.pumpWidget(_wrap(const HealthScoreCard(), score: score));
      await tester.pump();

      expect(find.text('Excellent'), findsOneWidget);
    });

    testWidgets('renders the correct label — Good', (tester) async {
      const score = HealthScore(rentScore: 65, rentActive: true);
      await tester.pumpWidget(_wrap(const HealthScoreCard(), score: score));
      await tester.pump();

      expect(find.text('Good'), findsOneWidget);
    });

    testWidgets('renders the correct label — Needs Attention', (tester) async {
      const score = HealthScore(rentScore: 20, rentActive: true);
      await tester.pumpWidget(_wrap(const HealthScoreCard(), score: score));
      await tester.pump();

      expect(find.text('Needs Attention'), findsOneWidget);
    });

    testWidgets('tapping card shows breakdown bottom sheet', (tester) async {
      const score = HealthScore(
        rentScore: 75,
        rentActive: true,
        budgetScore: 60,
        budgetActive: true,
      );
      await tester.pumpWidget(_wrap(const HealthScoreCard(), score: score));
      await tester.pump();

      await tester.tap(find.byType(HealthScoreCard));
      await tester.pumpAndSettle();

      expect(find.text('Health Score Breakdown'), findsOneWidget);
    });

    testWidgets('breakdown sheet shows active module names', (tester) async {
      const score = HealthScore(
        rentScore: 75,
        rentActive: true,
        budgetScore: 60,
        budgetActive: true,
      );
      await tester.pumpWidget(_wrap(const HealthScoreCard(), score: score));
      await tester.pump();

      await tester.tap(find.byType(HealthScoreCard));
      await tester.pumpAndSettle();

      expect(find.text('Rent Collection'), findsOneWidget);
      expect(find.text('Budget Compliance'), findsOneWidget);
    });

    testWidgets('breakdown sheet shows "Not set up" for inactive modules', (
      tester,
    ) async {
      const score = HealthScore(rentScore: 75, rentActive: true);
      await tester.pumpWidget(_wrap(const HealthScoreCard(), score: score));
      await tester.pump();

      await tester.tap(find.byType(HealthScoreCard));
      await tester.pumpAndSettle();

      // bills, stock, overdue, budget are all inactive
      expect(find.text('Not set up'), findsNWidgets(4));
    });

    testWidgets('renders Health Score label text', (tester) async {
      const score = HealthScore(rentScore: 80, rentActive: true);
      await tester.pumpWidget(_wrap(const HealthScoreCard(), score: score));
      await tester.pump();

      expect(find.text('Health Score'), findsOneWidget);
    });
  });
}
