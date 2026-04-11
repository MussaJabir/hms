import 'package:hms/core/models/recurring_record.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/features/rent/services/rent_config_service.dart';

/// Aggregates rent data for dashboard display and health scoring.
///
/// All methods accept an optional [groundId] parameter. When provided, only
/// records whose parent config's [collectionPath] falls under that ground are
/// counted.
class RentSummaryService {
  RentSummaryService(this._rentConfigService, this._recurringService);

  final RentConfigService _rentConfigService;
  final RecurringTransactionService _recurringService;

  static String _currentPeriod() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  // ---------------------------------------------------------------------------
  // Current-month expected rent
  // ---------------------------------------------------------------------------

  /// Sum of all active rent config amounts, optionally filtered by ground.
  Future<double> getCurrentMonthExpected({String? groundId}) async {
    final configs = await _rentConfigService.getAllActiveRentConfigs();
    return configs
        .where((c) => _matchesGround(c.collectionPath, groundId))
        .fold<double>(0.0, (sum, c) => sum + c.amount);
  }

  // ---------------------------------------------------------------------------
  // Current-month collected rent
  // ---------------------------------------------------------------------------

  /// Sum of [amountPaid] across all current-month records, optionally filtered.
  Future<double> getCurrentMonthCollected({String? groundId}) async {
    final records = await _getRecordsForCurrentPeriod(groundId: groundId);
    return records.fold<double>(0.0, (sum, r) => sum + r.amountPaid);
  }

  // ---------------------------------------------------------------------------
  // Outstanding amount
  // ---------------------------------------------------------------------------

  Future<double> getCurrentMonthOutstanding({String? groundId}) async {
    final expected = await getCurrentMonthExpected(groundId: groundId);
    final collected = await getCurrentMonthCollected(groundId: groundId);
    return (expected - collected).clamp(0.0, double.infinity);
  }

  // ---------------------------------------------------------------------------
  // Collection rate
  // ---------------------------------------------------------------------------

  /// Percentage of expected rent that has been collected (0–100).
  /// Returns 0 when expected is 0 to avoid division-by-zero.
  Future<double> getCurrentMonthCollectionRate({String? groundId}) async {
    final expected = await getCurrentMonthExpected(groundId: groundId);
    if (expected == 0) return 0.0;
    final collected = await getCurrentMonthCollected(groundId: groundId);
    return (collected / expected * 100).clamp(0.0, 100.0);
  }

  // ---------------------------------------------------------------------------
  // Overdue records
  // ---------------------------------------------------------------------------

  Future<List<RecurringRecord>> getOverdueRecords({String? groundId}) async {
    final records = await _getRecordsForCurrentPeriod(groundId: groundId);
    return records.where((r) => r.status == 'overdue').toList();
  }

  Future<int> getOverdueCount({String? groundId}) async {
    return (await getOverdueRecords(groundId: groundId)).length;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Returns all current-month rent records, optionally filtered by ground.
  ///
  /// Strategy: fetch all records for the current period once, then filter by
  /// which config IDs belong to the requested ground.
  Future<List<RecurringRecord>> _getRecordsForCurrentPeriod({
    String? groundId,
  }) async {
    final period = _currentPeriod();

    if (groundId == null) {
      // No filter — return everything.
      return _recurringService.getRecordsForPeriod(
        type: 'rent',
        period: period,
      );
    }

    // Build the set of config IDs that belong to the requested ground.
    final configs = await _rentConfigService.getAllActiveRentConfigs();
    final matchingConfigIds = configs
        .where((c) => _matchesGround(c.collectionPath, groundId))
        .map((c) => c.id)
        .toSet();

    if (matchingConfigIds.isEmpty) return [];

    final allRecords = await _recurringService.getRecordsForPeriod(
      type: 'rent',
      period: period,
    );
    return allRecords
        .where((r) => matchingConfigIds.contains(r.configId))
        .toList();
  }

  /// Returns true when [collectionPath] belongs to [groundId].
  /// Always true when [groundId] is null ("All grounds").
  static bool _matchesGround(String collectionPath, String? groundId) {
    if (groundId == null) return true;
    return collectionPath.startsWith('grounds/$groundId/');
  }
}
