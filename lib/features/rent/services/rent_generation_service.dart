import 'package:flutter/foundation.dart';
import 'package:hms/core/models/recurring_record.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/features/rent/services/rent_notification_service.dart';

class RentGenerationService {
  RentGenerationService(
    this._recurringService,
    this._activityLogService, {
    this.notificationService,
  });

  final RecurringTransactionService _recurringService;
  final ActivityLogService _activityLogService;

  /// Optional — injected after the notification service is ready.
  /// Null in tests that don't need notification side-effects.
  final RentNotificationService? notificationService;

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
  /// Schedules due-reminder notifications for each newly created record.
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

    final period = _periodFor(year, month);
    final rentRecords = await _recurringService.getRecordsForPeriod(
      type: 'rent',
      period: period,
    );

    final newRecords = rentRecords
        .where((r) => createdIds.contains(r.id))
        .toList();

    if (newRecords.isNotEmpty) {
      debugPrint(
        'RentGenerationService: ${newRecords.length} rent records created for $period',
      );
      await _activityLogService.log(
        userId: userId,
        action: 'created',
        module: 'rent',
        description:
            'Auto-generated ${newRecords.length} rent records for $period',
      );

      // Schedule due-reminder notifications for each new record.
      if (notificationService != null) {
        for (final record in newRecords) {
          notificationService!
              .scheduleRentDueReminder(rentRecord: record, userId: userId)
              .catchError((e) {
                debugPrint(
                  'Failed to schedule due reminder for ${record.id}: $e',
                );
                return;
              });
        }
      }
    }

    return newRecords.length;
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
