import 'package:flutter_test/flutter_test.dart';
import 'package:hms/features/dashboard/models/health_score.dart';

void main() {
  group('HealthScore.totalScore', () {
    test('all modules active calculates correct weighted average', () {
      const score = HealthScore(
        rentScore: 80,
        rentActive: true,
        billsScore: 70,
        billsActive: true,
        stockScore: 60,
        stockActive: true,
        overdueScore: 50,
        overdueActive: true,
        budgetScore: 40,
        budgetActive: true,
      );

      // weights: rent=0.35, bills=0.20, stock=0.15, overdue=0.15, budget=0.15
      // total weight = 1.0, so no redistribution
      final expected =
          80 * 0.35 + 70 * 0.20 + 60 * 0.15 + 50 * 0.15 + 40 * 0.15;
      expect(score.totalScore, closeTo(expected, 0.001));
    });

    test('only 2 active modules redistributes weights correctly', () {
      const score = HealthScore(
        rentScore: 80,
        rentActive: true,
        budgetScore: 60,
        budgetActive: true,
      );

      // Active weights: rent=0.35, budget=0.15 → total=0.50
      // Normalised: rent=0.35/0.5=0.70, budget=0.15/0.5=0.30
      final expected = 80 * (0.35 / 0.50) + 60 * (0.15 / 0.50);
      expect(score.totalScore, closeTo(expected, 0.001));
    });

    test('no active modules returns 0', () {
      const score = HealthScore();
      expect(score.totalScore, 0);
    });

    test('single active module returns its score directly', () {
      const score = HealthScore(rentScore: 72, rentActive: true);
      expect(score.totalScore, closeTo(72.0, 0.001));
    });

    test('score is clamped to 0–100', () {
      const score = HealthScore(rentScore: 100, rentActive: true);
      expect(score.totalScore, lessThanOrEqualTo(100));
      expect(score.totalScore, greaterThanOrEqualTo(0));
    });
  });

  group('HealthScore.label', () {
    test('returns Excellent for score >= 80', () {
      const score = HealthScore(rentScore: 90, rentActive: true);
      expect(score.label, 'Excellent');
    });

    test('returns Good for score 60–79', () {
      const score = HealthScore(rentScore: 65, rentActive: true);
      expect(score.label, 'Good');
    });

    test('returns Fair for score 40–59', () {
      const score = HealthScore(rentScore: 50, rentActive: true);
      expect(score.label, 'Fair');
    });

    test('returns Needs Attention for score < 40', () {
      const score = HealthScore(rentScore: 20, rentActive: true);
      expect(score.label, 'Needs Attention');
    });

    test('returns Needs Attention when no modules active', () {
      const score = HealthScore();
      expect(score.label, 'Needs Attention');
    });

    test('boundary: 80 returns Excellent', () {
      const score = HealthScore(rentScore: 80, rentActive: true);
      expect(score.label, 'Excellent');
    });

    test('boundary: 60 returns Good', () {
      const score = HealthScore(rentScore: 60, rentActive: true);
      expect(score.label, 'Good');
    });

    test('boundary: 40 returns Fair', () {
      const score = HealthScore(rentScore: 40, rentActive: true);
      expect(score.label, 'Fair');
    });
  });
}
