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

  /// Maps a total overdue-item count to a score: 100 when nothing is overdue,
  /// dropping 10 points per overdue item, floored at 0.
  double scoreFromOverdueCount(int overdueCount) {
    return (100 - overdueCount * 10).clamp(0, 100).toDouble();
  }

  /// Builds a [HealthScore] from real module data.
  ///
  /// [rentRate] rent collection rate (0–100); [rentActive] true when rent
  /// records exist this month. [billsRate]/[billsActive] mirror that for water
  /// bills. [overdueScore]/[overdueActive] come from aggregated overdue items.
  /// [budgetScore]/[budgetActive] come from budget compliance. Stock is wired
  /// in Phase 8, so [stockActive] is always false here.
  HealthScore buildScore({
    required double rentRate,
    required bool rentActive,
    double billsRate = 0,
    bool billsActive = false,
    double overdueScore = 100,
    bool overdueActive = false,
    double budgetScore = 0,
    bool budgetActive = false,
  }) {
    return HealthScore(
      rentScore: rentRate,
      rentActive: rentActive,
      billsScore: billsRate,
      billsActive: billsActive,
      stockScore: 0,
      stockActive: false,
      overdueScore: overdueScore,
      overdueActive: overdueActive,
      budgetScore: budgetScore,
      budgetActive: budgetActive,
    );
  }
}
