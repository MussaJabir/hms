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

  /// Builds a [HealthScore] using real rent data plus mock data for modules
  /// that have not yet been wired (bills, stock, overdue, budget).
  ///
  /// [rentRate] is the rent collection rate (0–100).
  /// [rentActive] is true when at least one rent record exists this month.
  HealthScore buildScore({required double rentRate, required bool rentActive}) {
    return HealthScore(
      rentScore: rentRate,
      rentActive: rentActive,
      // Remaining modules use mock values until their phases are built.
      budgetScore: 60,
      budgetActive: true,
    );
  }
}
