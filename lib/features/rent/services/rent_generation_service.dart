import 'package:flutter/foundation.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/models/recurring_record.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';

class RentGenerationService {
  RentGenerationService(this._recurringService, this._activityLogService);

  final RecurringTransactionService _recurringService;
  final ActivityLogService _activityLogService;

  /// Returns the current period string in "YYYY-MM" format.
  String getCurrentPeriod() {
    final now = DateTime.now();
    final mm = now.month.toString().padLeft(2, '0');
    return '${now.year}-$mm';
  }

  /// Returns the period string for a given year/month.
  String _periodFor(int year, int month) {
    final mm = month.toString().padLeft(2, '0');
    return '$year-$mm';
  }

  /// Generates rent records for the current month.
  /// Delegates to [RecurringTransactionService.generateMonthlyRecords] and
  /// filters to count only records of type "rent".
  /// Idempotent — safe to call on every app startup.
  Future<int> generateCurrentMonth({required String userId}) async {
    return generateForMonth(
      userId: userId,
      year: DateTime.now().year,
      month: DateTime.now().month,
    );
  }

  /// Generates rent records for a specific month (useful for backfilling).
  /// Returns the number of rent records newly created.
  Future<int> generateForMonth({
    required String userId,
    required int year,
    required int month,
  }) async {
    final forDate = DateTime(year, month, 1);
    final createdIds = await _recurringService.generateMonthlyRecords(
      userId: userId,
      forDate: forDate,
    );

    // Count only rent-type records by fetching what was created.
    // generateMonthlyRecords creates records across all config types; we need
    // just the rent count for the caller.
    final period = _periodFor(year, month);
    final rentRecords = await _recurringService.getRecordsForPeriod(
      type: 'rent',
      period: period,
    );

    final newRentCount = rentRecords
        .where((r) => createdIds.contains(r.id))
        .length;

    if (newRentCount > 0) {
      debugPrint(
        'RentGenerationService: $newRentCount rent records created for $period',
      );
      await _activityLogService.log(
        userId: userId,
        action: 'created',
        module: 'rent',
        description: 'Auto-generated $newRentCount rent records for $period',
      );
    }

    return newRentCount;
  }

  /// Returns true if at least one rent record exists for the current month.
  Future<bool> isCurrentMonthGenerated() async {
    final period = getCurrentPeriod();
    final records = await _recurringService.getRecordsForPeriod(
      type: 'rent',
      period: period,
    );
    return records.isNotEmpty;
  }

  /// Returns all rent records for the given period.
  Future<List<RecurringRecord>> getRecordsForPeriod(String period) {
    return _recurringService.getRecordsForPeriod(type: 'rent', period: period);
  }

  /// Streams rent records for a period from Firestore in real-time.
  Stream<List<RecurringRecord>> streamRecordsForPeriod(String period) {
    return _recurringService.streamRecordsForPeriod(
      type: 'rent',
      period: period,
    );
  }
}
