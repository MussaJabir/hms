import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/finance/models/income.dart';

/// CRUD and aggregation for income entries, stored in the top-level `incomes`
/// collection. Auto-linked rent entries are protected: they cannot be updated
/// or deleted from here (manage them from the rent module instead).
class IncomeService {
  IncomeService(this._firestoreService, this._activityLogService);

  final FirestoreService _firestoreService;
  final ActivityLogService _activityLogService;

  static const String collection = 'incomes';

  // ---------------------------------------------------------------------------
  // Write
  // ---------------------------------------------------------------------------

  /// Creates an income entry and returns the new document ID.
  Future<String> createIncome({
    required Income income,
    required String userId,
  }) async {
    final id = await _firestoreService.create(
      collectionPath: collection,
      data: _toMap(income),
      userId: userId,
    );

    await _activityLogService.log(
      userId: userId,
      action: 'create',
      module: 'finance',
      description:
          'Recorded ${income.source} income: ${income.description} '
          '(${income.amount.toStringAsFixed(0)})',
      documentId: id,
      collectionPath: collection,
    );

    return id;
  }

  /// Updates a manual income entry. Auto-linked rent entries are rejected.
  Future<void> updateIncome({
    required String incomeId,
    required Map<String, dynamic> updates,
    required String userId,
  }) async {
    await _assertNotAutoLinked(incomeId, action: 'edited');

    await _firestoreService.update(
      collectionPath: collection,
      documentId: incomeId,
      data: updates,
      userId: userId,
    );

    await _activityLogService.log(
      userId: userId,
      action: 'update',
      module: 'finance',
      description: 'Updated income $incomeId',
      documentId: incomeId,
      collectionPath: collection,
    );
  }

  /// Deletes an income entry. Auto-linked rent entries are rejected. Super
  /// Admin enforcement lives at the UI layer.
  Future<void> deleteIncome({
    required String incomeId,
    required String userId,
  }) async {
    await _assertNotAutoLinked(incomeId, action: 'deleted');

    await _firestoreService.delete(
      collectionPath: collection,
      documentId: incomeId,
    );

    await _activityLogService.log(
      userId: userId,
      action: 'delete',
      module: 'finance',
      description: 'Deleted income $incomeId',
      documentId: incomeId,
      collectionPath: collection,
    );
  }

  // ---------------------------------------------------------------------------
  // Read
  // ---------------------------------------------------------------------------

  /// All income entries, newest first.
  Future<List<Income>> getAllIncome({int? limit}) async {
    final docs = await _firestoreService.getAll(
      collectionPath: collection,
      orderBy: 'date',
      descending: true,
      limit: limit,
    );
    return docs.map(Income.fromJson).toList();
  }

  /// Streams all income entries, newest first.
  Stream<List<Income>> streamAllIncome() {
    return _firestoreService
        .stream(collectionPath: collection, orderBy: 'date', descending: true)
        .map((docs) => docs.map(Income.fromJson).toList());
  }

  /// Income for a single ground, newest first.
  Future<List<Income>> getIncomeByGround(String groundId, {int? limit}) async {
    final docs = await _firestoreService.query(
      collectionPath: collection,
      field: 'groundId',
      isEqualTo: groundId,
    );
    final income = docs.map(Income.fromJson).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    if (limit != null) return income.take(limit).toList();
    return income;
  }

  /// Income for a single source, newest first.
  Future<List<Income>> getIncomeBySource(String source, {int? limit}) async {
    final docs = await _firestoreService.query(
      collectionPath: collection,
      field: 'source',
      isEqualTo: source,
    );
    final income = docs.map(Income.fromJson).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    if (limit != null) return income.take(limit).toList();
    return income;
  }

  /// Income whose date falls within [period] ("yyyy-MM"), newest first.
  Future<List<Income>> getIncomeForMonth(String period) async {
    final all = await getAllIncome();
    return all.where((i) => _periodOf(i.date) == period).toList();
  }

  /// Streams income whose date falls within [period] ("yyyy-MM").
  Stream<List<Income>> streamIncomeForMonth(String period) {
    return streamAllIncome().map(
      (all) => all.where((i) => _periodOf(i.date) == period).toList(),
    );
  }

  /// Total income for the current calendar month, optionally scoped to a ground.
  Future<double> getCurrentMonthTotal({String? groundId}) {
    return getTotalForPeriod(_periodOf(DateTime.now()), groundId: groundId);
  }

  /// Total income for [period] ("yyyy-MM"), optionally scoped to a ground.
  Future<double> getTotalForPeriod(String period, {String? groundId}) async {
    final income = await getIncomeForMonth(period);
    final scoped = groundId == null
        ? income
        : income.where((i) => i.groundId == groundId);
    return scoped.fold<double>(0, (sum, i) => sum + i.amount);
  }

  /// Income for [period] grouped by source value → summed amount.
  Future<Map<String, double>> getIncomeBySourceForPeriod(String period) async {
    final income = await getIncomeForMonth(period);
    final Map<String, double> totals = {};
    for (final entry in income) {
      totals[entry.source] = (totals[entry.source] ?? 0) + entry.amount;
    }
    return totals;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<void> _assertNotAutoLinked(
    String incomeId, {
    required String action,
  }) async {
    final doc = await _firestoreService.get(
      collectionPath: collection,
      documentId: incomeId,
    );
    if (doc == null) throw Exception('Income $incomeId not found');
    final isAutoLinked = (doc['isAutoLinked'] as bool?) ?? false;
    if (isAutoLinked) {
      throw Exception(
        'Auto-linked rent income cannot be $action. Manage it from the rent module.',
      );
    }
  }

  String _periodOf(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    return '${date.year}-$mm';
  }

  Map<String, dynamic> _toMap(Income income) => {
    'source': income.source,
    'description': income.description,
    'amount': income.amount,
    'date': income.date.toIso8601String(),
    if (income.groundId != null) 'groundId': income.groundId,
    if (income.linkedTenantId != null) 'linkedTenantId': income.linkedTenantId,
    if (income.linkedRentRecordId != null)
      'linkedRentRecordId': income.linkedRentRecordId,
    'isAutoLinked': income.isAutoLinked,
    'notes': income.notes,
  };
}
