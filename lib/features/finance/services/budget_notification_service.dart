import 'package:hms/core/models/notification_type.dart';
import 'package:hms/core/services/notification_service.dart';
import 'package:hms/features/finance/models/budget.dart';
import 'package:hms/features/finance/models/expense_category.dart';
import 'package:hms/features/finance/services/budget_service.dart';

/// Sends local notifications when category budgets approach (>= 80%) or breach
/// (>= 100%) their limit. Intended to run after every expense change.
///
/// Notification ID strategy (avoids collisions with other modules):
///   base = (category+period).hashCode.abs() % 5_000_000 + 40_000_000
///   warning  = base
///   exceeded = base + 1
/// IDs are deterministic so repeated checks update the same notification rather
/// than piling up duplicates.
class BudgetNotificationService {
  BudgetNotificationService(this._notificationService, this._budgetService);

  final NotificationService _notificationService;
  final BudgetService _budgetService;

  /// Checks the current month's budgets and notifies on warnings and overages.
  Future<void> checkAndNotify({required String userId}) async {
    final period = _currentPeriod();

    final over = await _budgetService.getOverBudgets(period);
    final overCategories = over.map((b) => b.category).toSet();
    for (final budget in over) {
      await _notificationService.showImmediateNotification(
        notificationId: _exceededId(budget.category, period),
        type: NotificationType.budgetExceeded,
        title: 'Budget Exceeded',
        body: _body(budget),
        targetRoute: '/finance/budget',
        userId: userId,
      );
    }

    // Warning budgets that are near (80–99%) but not already over.
    final warning = await _budgetService.getWarningBudgets(period);
    for (final budget in warning) {
      if (overCategories.contains(budget.category)) continue;
      await _notificationService.showImmediateNotification(
        notificationId: _warningId(budget.category, period),
        type: NotificationType.budgetWarning,
        title: 'Budget Warning',
        body: _body(budget),
        targetRoute: '/finance/budget',
        userId: userId,
      );
    }
  }

  String _body(Budget budget) {
    final label = ExpenseCategory.fromString(budget.category).label;
    final pct = budget.spentPercentage.round();
    return '$label — TZS ${budget.spentAmount.toStringAsFixed(0)} of '
        'TZS ${budget.limitAmount.toStringAsFixed(0)} spent ($pct%)';
  }

  String _currentPeriod() {
    final now = DateTime.now();
    final mm = now.month.toString().padLeft(2, '0');
    return '${now.year}-$mm';
  }

  static int _base(String category, String period) =>
      ('$category$period'.hashCode.abs() % 5000000) + 40000000;

  static int _warningId(String category, String period) =>
      _base(category, period);

  static int _exceededId(String category, String period) =>
      _base(category, period) + 1;
}
