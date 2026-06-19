import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/finance/models/expense.dart';

/// CRUD and aggregation for expense entries, stored in the top-level `expenses`
/// collection. Auto-linked entries (created by another module such as water
/// bills or school fees) are protected: they cannot be updated or deleted from
/// here — manage them from their source module instead.
class ExpenseService {
  ExpenseService(this._firestoreService, this._activityLogService);

  final FirestoreService _firestoreService;
  final ActivityLogService _activityLogService;

  static const String collection = 'expenses';

  // ---------------------------------------------------------------------------
  // Write
  // ---------------------------------------------------------------------------

  /// Creates an expense entry and returns the new document ID.
  Future<String> createExpense({
    required Expense expense,
    required String userId,
  }) async {
    final id = await _firestoreService.create(
      collectionPath: collection,
      data: _toMap(expense),
      userId: userId,
    );

    await _activityLogService.log(
      userId: userId,
      action: 'create',
      module: 'finance',
      description:
          'Recorded ${expense.category} expense: ${expense.description} '
          '(${expense.amount.toStringAsFixed(0)})',
      documentId: id,
      collectionPath: collection,
    );

    return id;
  }

  /// Updates a manual expense entry. Auto-linked entries are rejected.
  Future<void> updateExpense({
    required String expenseId,
    required Map<String, dynamic> updates,
    required String userId,
  }) async {
    await _assertNotAutoLinked(expenseId, action: 'edited');

    await _firestoreService.update(
      collectionPath: collection,
      documentId: expenseId,
      data: updates,
      userId: userId,
    );

    await _activityLogService.log(
      userId: userId,
      action: 'update',
      module: 'finance',
      description: 'Updated expense $expenseId',
      documentId: expenseId,
      collectionPath: collection,
    );
  }

  /// Deletes an expense entry. Auto-linked entries are rejected. Super Admin
  /// enforcement lives at the UI layer.
  Future<void> deleteExpense({
    required String expenseId,
    required String userId,
  }) async {
    await _assertNotAutoLinked(expenseId, action: 'deleted');

    await _firestoreService.delete(
      collectionPath: collection,
      documentId: expenseId,
    );

    await _activityLogService.log(
      userId: userId,
      action: 'delete',
      module: 'finance',
      description: 'Deleted expense $expenseId',
      documentId: expenseId,
      collectionPath: collection,
    );
  }

  /// Creates an auto-linked expense from another module (water bill, school
  /// fee, etc.). The entry is flagged [Expense.isAutoLinked] so Finance keeps
  /// it read-only and records the originating [module] + [linkedDocumentId].
  Future<String> createAutoLinkedExpense({
    required String category,
    required String description,
    required double amount,
    required DateTime date,
    required String module,
    required String linkedDocumentId,
    String? groundId,
    required String userId,
  }) async {
    final now = DateTime.now();
    final expense = Expense(
      id: '',
      category: category,
      description: description,
      amount: amount,
      date: date,
      groundId: groundId,
      module: module,
      linkedDocumentId: linkedDocumentId,
      isAutoLinked: true,
      createdAt: now,
      updatedAt: now,
      updatedBy: userId,
    );

    return createExpense(expense: expense, userId: userId);
  }

  // ---------------------------------------------------------------------------
  // Read
  // ---------------------------------------------------------------------------

  /// All expense entries, newest first.
  Future<List<Expense>> getAllExpenses({int? limit}) async {
    final docs = await _firestoreService.getAll(
      collectionPath: collection,
      orderBy: 'date',
      descending: true,
      limit: limit,
    );
    return docs.map(Expense.fromJson).toList();
  }

  /// Streams all expense entries, newest first.
  Stream<List<Expense>> streamAllExpenses() {
    return _firestoreService
        .stream(collectionPath: collection, orderBy: 'date', descending: true)
        .map((docs) => docs.map(Expense.fromJson).toList());
  }

  /// Expenses whose date falls within [period] ("yyyy-MM"), newest first.
  Future<List<Expense>> getExpensesForMonth(String period) async {
    final all = await getAllExpenses();
    return all.where((e) => _periodOf(e.date) == period).toList();
  }

  /// Streams expenses whose date falls within [period] ("yyyy-MM").
  Stream<List<Expense>> streamExpensesForMonth(String period) {
    return streamAllExpenses().map(
      (all) => all.where((e) => _periodOf(e.date) == period).toList(),
    );
  }

  /// Expenses for a single category, newest first. Optionally scoped to a
  /// "yyyy-MM" [period].
  Future<List<Expense>> getExpensesByCategory(
    String category, {
    String? period,
  }) async {
    final docs = await _firestoreService.query(
      collectionPath: collection,
      field: 'category',
      isEqualTo: category,
    );
    var expenses = docs.map(Expense.fromJson).toList();
    if (period != null) {
      expenses = expenses.where((e) => _periodOf(e.date) == period).toList();
    }
    expenses.sort((a, b) => b.date.compareTo(a.date));
    return expenses;
  }

  /// Expenses for a single ground, newest first. Optionally scoped to a
  /// "yyyy-MM" [period].
  Future<List<Expense>> getExpensesByGround(
    String groundId, {
    String? period,
  }) async {
    final docs = await _firestoreService.query(
      collectionPath: collection,
      field: 'groundId',
      isEqualTo: groundId,
    );
    var expenses = docs.map(Expense.fromJson).toList();
    if (period != null) {
      expenses = expenses.where((e) => _periodOf(e.date) == period).toList();
    }
    expenses.sort((a, b) => b.date.compareTo(a.date));
    return expenses;
  }

  /// Total expenses for the current calendar month, optionally scoped to a
  /// ground.
  Future<double> getCurrentMonthTotal({String? groundId}) {
    return getTotalForPeriod(_periodOf(DateTime.now()), groundId: groundId);
  }

  /// Total expenses for [period] ("yyyy-MM"), optionally scoped to a ground.
  Future<double> getTotalForPeriod(String period, {String? groundId}) async {
    final expenses = await getExpensesForMonth(period);
    final scoped = groundId == null
        ? expenses
        : expenses.where((e) => e.groundId == groundId);
    return scoped.fold<double>(0, (sum, e) => sum + e.amount);
  }

  /// Expenses for [period] grouped by category value → summed amount,
  /// optionally scoped to a ground.
  Future<Map<String, double>> getExpensesByCategoryForPeriod(
    String period, {
    String? groundId,
  }) async {
    final expenses = await getExpensesForMonth(period);
    final scoped = groundId == null
        ? expenses
        : expenses.where((e) => e.groundId == groundId);
    final Map<String, double> totals = {};
    for (final entry in scoped) {
      totals[entry.category] = (totals[entry.category] ?? 0) + entry.amount;
    }
    return totals;
  }

  /// Top [top] categories by total amount for [period], highest first.
  Future<List<MapEntry<String, double>>> getTopCategories(
    String period, {
    int top = 5,
    String? groundId,
  }) async {
    final totals = await getExpensesByCategoryForPeriod(
      period,
      groundId: groundId,
    );
    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries.take(top).toList();
  }

  /// Daily spending for [period] ("yyyy-MM"): date (at midnight) → summed
  /// amount for that day. Useful for a trend chart.
  Future<Map<DateTime, double>> getDailySpendingForMonth(String period) async {
    final expenses = await getExpensesForMonth(period);
    final Map<DateTime, double> daily = {};
    for (final e in expenses) {
      final day = DateTime(e.date.year, e.date.month, e.date.day);
      daily[day] = (daily[day] ?? 0) + e.amount;
    }
    return daily;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<void> _assertNotAutoLinked(
    String expenseId, {
    required String action,
  }) async {
    final doc = await _firestoreService.get(
      collectionPath: collection,
      documentId: expenseId,
    );
    if (doc == null) throw Exception('Expense $expenseId not found');
    final isAutoLinked = (doc['isAutoLinked'] as bool?) ?? false;
    if (isAutoLinked) {
      throw Exception(
        'Auto-linked expenses cannot be $action. '
        'Manage them from their source module.',
      );
    }
  }

  String _periodOf(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    return '${date.year}-$mm';
  }

  Map<String, dynamic> _toMap(Expense expense) => {
    'category': expense.category,
    'description': expense.description,
    'amount': expense.amount,
    'date': expense.date.toIso8601String(),
    if (expense.groundId != null) 'groundId': expense.groundId,
    if (expense.module != null) 'module': expense.module,
    if (expense.linkedDocumentId != null)
      'linkedDocumentId': expense.linkedDocumentId,
    'isAutoLinked': expense.isAutoLinked,
    'notes': expense.notes,
  };
}
