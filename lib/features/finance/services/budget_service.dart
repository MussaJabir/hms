import 'package:hms/core/models/recurring_config.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/features/finance/models/budget.dart';
import 'package:hms/features/finance/services/expense_service.dart';

/// CRUD and aggregation for monthly category budgets, stored in the top-level
/// `budgets` collection. Each budget is keyed by category + period so there is
/// at most one budget per category per month.
///
/// [spentAmount] is not authoritative on write — it is recalculated from actual
/// expenses via [recalculateSpent], which should run whenever expenses change.
class BudgetService {
  BudgetService(
    this._firestoreService,
    this._expenseService,
    this._recurringTransactionService,
    this._activityLogService,
  );

  final FirestoreService _firestoreService;
  final ExpenseService _expenseService;
  final RecurringTransactionService _recurringTransactionService;
  final ActivityLogService _activityLogService;

  static const String collection = 'budgets';

  /// Deterministic document ID so a category + period pair maps to a single
  /// budget (set acts as create-or-update).
  static String docId(String category, String period) => '${period}_$category';

  // ---------------------------------------------------------------------------
  // Write
  // ---------------------------------------------------------------------------

  /// Creates or updates the budget for [category] in [period]. Returns the
  /// document ID. Preserves any already-recorded [Budget.spentAmount].
  Future<String> setBudget({
    required String category,
    required double limitAmount,
    required String period,
    required String userId,
  }) async {
    final id = docId(category, period);
    final existing = await getBudget(category, period);

    await _firestoreService.set(
      collectionPath: collection,
      documentId: id,
      data: {
        'category': category,
        'limitAmount': limitAmount,
        'period': period,
        'spentAmount': existing?.spentAmount ?? 0,
      },
      userId: userId,
    );

    await _activityLogService.log(
      userId: userId,
      action: existing == null ? 'create' : 'update',
      module: 'finance',
      description:
          'Set $category budget for $period: '
          '${limitAmount.toStringAsFixed(0)}',
      documentId: id,
      collectionPath: collection,
    );

    return id;
  }

  /// Deletes a budget. Super Admin enforcement lives at the UI layer.
  Future<void> deleteBudget(String budgetId, String userId) async {
    await _firestoreService.delete(
      collectionPath: collection,
      documentId: budgetId,
    );

    await _activityLogService.log(
      userId: userId,
      action: 'delete',
      module: 'finance',
      description: 'Deleted budget $budgetId',
      documentId: budgetId,
      collectionPath: collection,
    );
  }

  // ---------------------------------------------------------------------------
  // Read
  // ---------------------------------------------------------------------------

  /// All budgets for [period], ordered by category.
  Future<List<Budget>> getBudgetsForPeriod(String period) async {
    final docs = await _firestoreService.query(
      collectionPath: collection,
      field: 'period',
      isEqualTo: period,
    );
    final budgets = docs.map(_fromMap).toList()
      ..sort((a, b) => a.category.compareTo(b.category));
    return budgets;
  }

  /// Streams budgets for [period], ordered by category.
  Stream<List<Budget>> streamBudgetsForPeriod(String period) {
    return _firestoreService.stream(collectionPath: collection).map((docs) {
      final budgets =
          docs.map(_fromMap).where((b) => b.period == period).toList()
            ..sort((a, b) => a.category.compareTo(b.category));
      return budgets;
    });
  }

  /// The budget for [category] in [period], or null if none is set.
  Future<Budget?> getBudget(String category, String period) async {
    final doc = await _firestoreService.get(
      collectionPath: collection,
      documentId: docId(category, period),
    );
    if (doc == null) return null;
    return _fromMap(doc);
  }

  // ---------------------------------------------------------------------------
  // Spend synchronisation
  // ---------------------------------------------------------------------------

  /// Recomputes [Budget.spentAmount] for every budget in [period] by summing
  /// the matching category's expenses for that period. Safe to call repeatedly.
  Future<void> recalculateSpent(String period, String userId) async {
    final budgets = await getBudgetsForPeriod(period);
    if (budgets.isEmpty) return;

    final byCategory = await _expenseService.getExpensesByCategoryForPeriod(
      period,
    );

    for (final budget in budgets) {
      final spent = byCategory[budget.category] ?? 0;
      if (spent == budget.spentAmount) continue;
      await _firestoreService.update(
        collectionPath: collection,
        documentId: budget.id,
        data: {'spentAmount': spent},
        userId: userId,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Copy-forward / recurring
  // ---------------------------------------------------------------------------

  /// Copies the previous month's budget limits into [currentPeriod]. Existing
  /// budgets in [currentPeriod] are left untouched. Returns the number created.
  Future<int> copyFromPreviousMonth({
    required String currentPeriod,
    required String userId,
  }) async {
    final previous = _previousPeriod(currentPeriod);
    final previousBudgets = await getBudgetsForPeriod(previous);
    if (previousBudgets.isEmpty) return 0;

    final existing = await getBudgetsForPeriod(currentPeriod);
    final existingCategories = existing.map((b) => b.category).toSet();

    var created = 0;
    for (final budget in previousBudgets) {
      if (existingCategories.contains(budget.category)) continue;
      await setBudget(
        category: budget.category,
        limitAmount: budget.limitAmount,
        period: currentPeriod,
        userId: userId,
      );
      created++;
    }
    return created;
  }

  /// Registers a recurring config per budget so limits auto-generate monthly
  /// via the recurring transaction engine. Idempotent per category.
  Future<void> setupRecurringBudgets({
    required List<Budget> budgets,
    required String userId,
  }) async {
    final now = DateTime.now();
    for (final budget in budgets) {
      final config = RecurringConfig(
        id: 'budget_${budget.category}',
        type: 'budget_reset',
        collectionPath: collection,
        linkedEntityId: budget.category,
        linkedEntityName: '${budget.category} budget',
        amount: budget.limitAmount,
        frequency: 'monthly',
        dayOfMonth: 1,
        createdAt: now,
        updatedAt: now,
        updatedBy: userId,
      );
      await _recurringTransactionService.createConfig(
        config: config,
        userId: userId,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Aggregation
  // ---------------------------------------------------------------------------

  /// Sum of all category limits for [period].
  Future<double> getTotalLimit(String period) async {
    final budgets = await getBudgetsForPeriod(period);
    return budgets.fold<double>(0, (sum, b) => sum + b.limitAmount);
  }

  /// Sum of recorded spending across all categories for [period].
  Future<double> getTotalSpent(String period) async {
    final budgets = await getBudgetsForPeriod(period);
    return budgets.fold<double>(0, (sum, b) => sum + b.spentAmount);
  }

  /// Budgets that are near or over their limit (>= 80%).
  Future<List<Budget>> getWarningBudgets(String period) async {
    final budgets = await getBudgetsForPeriod(period);
    return budgets.where((b) => b.spentPercentage >= 80).toList();
  }

  /// Budgets that are over their limit (>= 100%).
  Future<List<Budget>> getOverBudgets(String period) async {
    final budgets = await getBudgetsForPeriod(period);
    return budgets.where((b) => b.isOverLimit).toList();
  }

  /// Overall compliance score for [period] (0–100): the share of categories
  /// that are on track (< 80%). 100 = all on track, 0 = none on track. Returns
  /// 100 when no budgets are set (nothing to breach).
  Future<double> getBudgetComplianceScore(String period) async {
    final budgets = await getBudgetsForPeriod(period);
    if (budgets.isEmpty) return 100;
    final onTrack = budgets.where((b) => b.isOnTrack).length;
    return onTrack / budgets.length * 100;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// "yyyy-MM" of the month before [period].
  String _previousPeriod(String period) {
    final parts = period.split('-');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final prev = DateTime(year, month - 1, 1);
    final mm = prev.month.toString().padLeft(2, '0');
    return '${prev.year}-$mm';
  }

  Budget _fromMap(Map<String, dynamic> map) {
    return Budget.fromJson(_normalizeTimestamps(map));
  }

  Map<String, dynamic> _normalizeTimestamps(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is DateTime) return MapEntry(key, value.toIso8601String());
      if (value != null && value.runtimeType.toString() == 'Timestamp') {
        return MapEntry(key, (value as dynamic).toDate().toIso8601String());
      }
      return MapEntry(key, value);
    });
  }
}
