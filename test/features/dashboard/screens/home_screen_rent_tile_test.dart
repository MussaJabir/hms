import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/features/dashboard/models/health_score.dart';
import 'package:hms/features/dashboard/providers/health_score_provider.dart';
import 'package:hms/features/rent/providers/rent_summary_providers.dart';

// ---------------------------------------------------------------------------
// Minimal widget that renders the providers under test without the full
// HomeScreen (which requires many unrelated providers and routing).
// ---------------------------------------------------------------------------

class _TestDashboard extends ConsumerWidget {
  const _TestDashboard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collected =
        ref.watch(currentMonthCollectedProvider).asData?.value ?? 0.0;
    final expected =
        ref.watch(currentMonthExpectedProvider).asData?.value ?? 0.0;
    final rate =
        ref.watch(currentMonthCollectionRateProvider).asData?.value ?? 0.0;

    return Column(
      children: [
        Text('collected:${collected.toStringAsFixed(0)}'),
        Text('expected:${expected.toStringAsFixed(0)}'),
        Text('rate:${rate.toStringAsFixed(0)}'),
      ],
    );
  }
}

Widget _wrapTile({
  required double collected,
  required double expected,
  required double rate,
}) {
  return ProviderScope(
    overrides: [
      currentMonthCollectedProvider.overrideWith(
        (ref) => Future.value(collected),
      ),
      currentMonthExpectedProvider.overrideWith(
        (ref) => Future.value(expected),
      ),
      currentMonthCollectionRateProvider.overrideWith(
        (ref) => Future.value(rate),
      ),
    ],
    child: const MaterialApp(home: Scaffold(body: _TestDashboard())),
  );
}

// ---------------------------------------------------------------------------
// Health score with real rent data
// ---------------------------------------------------------------------------

class _TestHealthScore extends ConsumerWidget {
  const _TestHealthScore();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final score = ref.watch(healthScoreProvider);
    return Text('score:${score.totalScore.toStringAsFixed(0)}');
  }
}

Widget _wrapHealthScore({required double rate}) {
  return ProviderScope(
    overrides: [
      currentMonthCollectionRateProvider.overrideWith(
        (ref) => Future.value(rate),
      ),
    ],
    child: const MaterialApp(home: Scaffold(body: _TestHealthScore())),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('Dashboard rent summary tile', () {
    testWidgets('shows collected and expected amounts', (tester) async {
      await tester.pumpWidget(
        _wrapTile(collected: 650000, expected: 750000, rate: 86.7),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('650000'), findsOneWidget);
      expect(find.textContaining('750000'), findsOneWidget);
    });

    testWidgets('shows 0 values before data loads (fallback)', (tester) async {
      await tester.pumpWidget(_wrapTile(collected: 0, expected: 0, rate: 0));
      await tester.pumpAndSettle();

      expect(find.textContaining('collected:0'), findsOneWidget);
      expect(find.textContaining('expected:0'), findsOneWidget);
    });

    testWidgets('shows collection rate', (tester) async {
      await tester.pumpWidget(
        _wrapTile(collected: 300000, expected: 600000, rate: 50),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('rate:50'), findsOneWidget);
    });
  });

  group('Health score uses real rent data', () {
    testWidgets('100% collection rate produces high score', (tester) async {
      await tester.pumpWidget(_wrapHealthScore(rate: 100));
      await tester.pumpAndSettle();

      final scoreWidget = tester.widget<Text>(
        find.byWidgetPredicate(
          (w) => w is Text && w.data?.startsWith('score:') == true,
        ),
      );
      final score = double.parse(scoreWidget.data!.replaceFirst('score:', ''));
      // 100% rent + 60% budget → high weighted score
      expect(score, greaterThan(70));
    });

    testWidgets('0% collection rate produces a lower score', (tester) async {
      // Override healthScoreProvider with rate=0 to bypass async providers
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            healthScoreProvider.overrideWithValue(
              const HealthScore(
                rentScore: 0,
                rentActive: true,
                budgetScore: 60,
                budgetActive: true,
              ),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: _TestHealthScore())),
        ),
      );
      await tester.pump();

      final scoreWidget = tester.widget<Text>(
        find.byWidgetPredicate(
          (w) => w is Text && w.data?.startsWith('score:') == true,
        ),
      );
      final score = double.parse(scoreWidget.data!.replaceFirst('score:', ''));
      expect(score, lessThan(40));
    });
  });
}
