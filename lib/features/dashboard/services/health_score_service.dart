import 'package:hms/features/dashboard/models/health_score.dart';

/// Calculates the HMS health score from module data.
///
/// Each module's score is computed independently. Real data wiring will be
/// added when each feature module is built. For now, mock data is returned
/// so the UI is visible and testable.
class HealthScoreService {
  const HealthScoreService();

  /// Returns the current month's health score.
  ///
  /// Scoring logic per module (to be wired later):
  /// - rent:    % of active units with rent paid on time this month
  /// - bills:   % of bills paid before due date
  /// - stock:   % of tracked items above minimum threshold
  /// - overdue: inverse of % overdue items (0 overdue = 100)
  /// - budget:  % of budget categories within planned limit
  HealthScore calculateScore() {
    return _mockScore();
  }

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

  // ---------------------------------------------------------------------------
  // Mock data — remove and replace with real calculations when modules are built
  // ---------------------------------------------------------------------------

  HealthScore _mockScore() {
    return const HealthScore(
      rentScore: 75,
      rentActive: true,
      budgetScore: 60,
      budgetActive: true,
    );
  }
}
