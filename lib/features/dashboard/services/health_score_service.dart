import 'package:hms/features/dashboard/models/health_score.dart';

/// Calculates the HMS health score from module data.
///
/// Each module's score is computed independently. Real data wiring will be
/// added when each feature module is built. For now, mock data is returned
/// so the UI is visible and testable.
class HealthScoreService {
  const HealthScoreService();

  /// Calculates the rent score independently (0–100).
  /// [paidOnTime] units paid on time, [total] active units.
  double calculateRentScore({required int paidOnTime, required int total}) {
    if (total == 0) return 0;
    return (paidOnTime / total) * 100;
  }

  /// Calculates the bills score independently (0–100).
  double calculateBillsScore({required int paidOnTime, required int total}) {
    if (total == 0) return 0;
    return (paidOnTime / total) * 100;
  }

  /// Calculates the stock score independently (0–100).
  /// [aboveThreshold] items at or above their minimum level.
  double calculateStockScore({
    required int aboveThreshold,
    required int total,
  }) {
    if (total == 0) return 0;
    return (aboveThreshold / total) * 100;
  }

  /// Calculates the overdue score independently (0–100).
  /// Fewer overdue items → higher score.
  double calculateOverdueScore({required int overdue, required int total}) {
    if (total == 0) return 100;
    return ((total - overdue) / total) * 100;
  }

  /// Calculates the budget score independently (0–100).
  double calculateBudgetScore({required int withinLimit, required int total}) {
    if (total == 0) return 0;
    return (withinLimit / total) * 100;
  }

  /// Builds a [HealthScore] using real rent and bills data.
  ///
  /// [rentRate] is the rent collection rate (0–100).
  /// [rentActive] is true when at least one rent record exists this month.
  /// [billsRate] is the water bills paid-on-time rate (0–100).
  /// [billsActive] is true when at least one water bill exists this month.
  HealthScore buildScore({
    required double rentRate,
    required bool rentActive,
    double billsRate = 0,
    bool billsActive = false,
  }) {
    return HealthScore(
      rentScore: rentRate,
      rentActive: rentActive,
      billsScore: billsRate,
      billsActive: billsActive,
      budgetScore: 60,
      budgetActive: true,
    );
  }
}
