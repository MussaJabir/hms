import 'package:flutter_test/flutter_test.dart';
import 'package:hms/features/dashboard/services/health_score_service.dart';

void main() {
  const service = HealthScoreService();

  group('scoreFromOverdueCount', () {
    test('is 100 when nothing is overdue', () {
      expect(service.scoreFromOverdueCount(0), 100);
    });

    test('drops 10 points per overdue item, floored at 0', () {
      expect(service.scoreFromOverdueCount(3), 70);
      expect(service.scoreFromOverdueCount(10), 0);
      expect(service.scoreFromOverdueCount(15), 0);
    });
  });

  group('buildScore', () {
    test('wires real rent, bills, overdue, and budget scores', () {
      final score = service.buildScore(
        rentRate: 90,
        rentActive: true,
        billsRate: 75,
        billsActive: true,
        overdueScore: 80,
        overdueActive: true,
        budgetScore: 65,
        budgetActive: true,
      );

      expect(score.rentScore, 90);
      expect(score.rentActive, isTrue);
      expect(score.billsScore, 75);
      expect(score.billsActive, isTrue);
      expect(score.overdueScore, 80);
      expect(score.overdueActive, isTrue);
      expect(score.budgetScore, 65);
      expect(score.budgetActive, isTrue);
    });

    test('stock is never active (wired in Phase 8)', () {
      final score = service.buildScore(rentRate: 50, rentActive: true);
      expect(score.stockActive, isFalse);
      expect(score.stockScore, 0);
    });

    test('budget is inactive by default when no budgets exist', () {
      final score = service.buildScore(rentRate: 50, rentActive: true);
      expect(score.budgetActive, isFalse);
    });
  });
}
