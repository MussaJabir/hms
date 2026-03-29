import 'package:flutter/foundation.dart';
import 'package:hms/core/models/recurring_config.dart';
import 'package:hms/core/models/recurring_record.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';

class RecurringTransactionService {
  RecurringTransactionService(this._firestore, this._activityLog);

  final FirestoreService _firestore;
  final ActivityLogService _activityLog;

  static const String configCollection = 'recurring_configs';

  // ---------------------------------------------------------------------------
  // Config management
  // ---------------------------------------------------------------------------

  /// Creates a new recurring configuration.
  /// Called when a tenant moves in, a child is enrolled, or a budget is set up.
  Future<String> createConfig({
    required RecurringConfig config,
    required String userId,
  }) async {
    await _firestore.set(
      collectionPath: configCollection,
      documentId: config.id,
      data: config.toJson()..remove('id'),
      userId: userId,
    );
    await _activityLog.log(
      userId: userId,
      action: 'created',
      module: 'recurring',
      description:
          'Created recurring config: ${config.linkedEntityName} (${config.type})',
      documentId: config.id,
      collectionPath: configCollection,
    );
    return config.id;
  }

  /// Updates fields on an existing config (e.g., rent amount changes).
  Future<void> updateConfig({
    required String configId,
    required Map<String, dynamic> updates,
    required String userId,
  }) async {
    await _firestore.update(
      collectionPath: configCollection,
      documentId: configId,
      data: updates,
      userId: userId,
    );
    await _activityLog.log(
      userId: userId,
      action: 'updated',
      module: 'recurring',
      description: 'Updated recurring config: $configId',
      documentId: configId,
      collectionPath: configCollection,
    );
  }

  /// Deactivates a config. Does NOT delete — sets isActive to false so history is preserved.
  Future<void> deactivateConfig({
    required String configId,
    required String userId,
  }) async {
    await _firestore.update(
      collectionPath: configCollection,
      documentId: configId,
      data: {'isActive': false},
      userId: userId,
    );
    await _activityLog.log(
      userId: userId,
      action: 'updated',
      module: 'recurring',
      description: 'Deactivated recurring config: $configId',
      documentId: configId,
      collectionPath: configCollection,
    );
  }

  /// Returns all active configs of a specific type.
  Future<List<RecurringConfig>> getActiveConfigs({required String type}) async {
    final results = await _firestore.query(
      collectionPath: configCollection,
      field: 'type',
      isEqualTo: type,
    );
    return results.map(_configFromMap).where((c) => c.isActive).toList();
  }

  // ---------------------------------------------------------------------------
  // Record generation
  // ---------------------------------------------------------------------------

  /// Generates records for the current (or specified) month for all active configs.
  /// Idempotent — safe to call multiple times; will not create duplicates.
  /// Returns the list of newly created record IDs.
  Future<List<String>> generateMonthlyRecords({
    required String userId,
    DateTime? forDate,
  }) async {
    final now = forDate ?? DateTime.now();
    final period = _periodString(now);
    final createdIds = <String>[];

    // Fetch all active configs across all types
    final allConfigs = await _firestore.getAll(
      collectionPath: configCollection,
    );
    final activeConfigs = allConfigs
        .map(_configFromMap)
        .where((c) => c.isActive)
        .toList();

    for (final config in activeConfigs) {
      // Determine collection path for existing record check
      final recordPath = config.collectionPath;

      // Check if a record already exists for this config + period
      final existing = await _firestore.query(
        collectionPath: recordPath,
        field: 'configId',
        isEqualTo: config.id,
      );
      final alreadyExists = existing.any((r) => r['period'] == period);
      if (alreadyExists) continue;

      // Calculate due date from config.dayOfMonth, clamped to valid range
      final day = config.dayOfMonth.clamp(1, 28);
      final dueDate = DateTime(now.year, now.month, day);

      final record = RecurringRecord(
        id: '${config.id}_$period',
        configId: config.id,
        type: config.type,
        linkedEntityId: config.linkedEntityId,
        linkedEntityName: config.linkedEntityName,
        amount: config.amount,
        period: period,
        status: 'pending',
        dueDate: dueDate,
        createdAt: now,
        updatedAt: now,
        updatedBy: userId,
      );

      await _firestore.set(
        collectionPath: recordPath,
        documentId: record.id,
        data: record.toJson()..remove('id'),
        userId: userId,
      );

      await _activityLog.log(
        userId: userId,
        action: 'created',
        module: config.type,
        description:
            'Generated $period record for ${config.linkedEntityName} — TZS ${config.amount.toStringAsFixed(0)}',
        documentId: record.id,
        collectionPath: recordPath,
      );

      createdIds.add(record.id);
    }

    debugPrint(
      'RecurringTransactionService: generated ${createdIds.length} records for $period',
    );
    return createdIds;
  }

  // ---------------------------------------------------------------------------
  // Record queries
  // ---------------------------------------------------------------------------

  /// Returns all records for a specific period and type.
  Future<List<RecurringRecord>> getRecordsForPeriod({
    required String type,
    required String period,
  }) async {
    // Records live under each config's collectionPath; fetch active configs by type
    final configs = await getActiveConfigs(type: type);
    final records = <RecurringRecord>[];
    for (final config in configs) {
      final results = await _firestore.query(
        collectionPath: config.collectionPath,
        field: 'period',
        isEqualTo: period,
      );
      records.addAll(results.map(_recordFromMap));
    }
    return records;
  }

  /// Returns all records for a specific linked entity (e.g., all rent records for a tenant).
  Future<List<RecurringRecord>> getRecordsForEntity({
    required String linkedEntityId,
    String? type,
  }) async {
    final allConfigs = await _firestore.getAll(
      collectionPath: configCollection,
    );
    final configs = allConfigs
        .map(_configFromMap)
        .where(
          (c) =>
              c.linkedEntityId == linkedEntityId &&
              (type == null || c.type == type),
        )
        .toList();

    final records = <RecurringRecord>[];
    for (final config in configs) {
      final results = await _firestore.query(
        collectionPath: config.collectionPath,
        field: 'linkedEntityId',
        isEqualTo: linkedEntityId,
      );
      records.addAll(results.map(_recordFromMap));
    }
    return records;
  }

  /// Streams records for a specific type and period in real-time.
  Stream<List<RecurringRecord>> streamRecordsForPeriod({
    required String type,
    required String period,
  }) async* {
    final configs = await getActiveConfigs(type: type);
    if (configs.isEmpty) {
      yield [];
      return;
    }
    // Stream from the first config's collection path for simplicity.
    // Feature modules that need multi-path streaming should compose this themselves.
    yield* _firestore
        .stream(collectionPath: configs.first.collectionPath)
        .map(
          (list) => list
              .map(_recordFromMap)
              .where((r) => r.period == period && r.type == type)
              .toList(),
        );
  }

  // ---------------------------------------------------------------------------
  // Payment operations
  // ---------------------------------------------------------------------------

  /// Marks a record as paid, partial, or overdue and records the payment details.
  Future<void> updateRecordPayment({
    required String collectionPath,
    required String recordId,
    required String status,
    required double amountPaid,
    String? paymentMethod,
    String? notes,
    required String userId,
  }) async {
    final updates = <String, dynamic>{
      'status': status,
      'amountPaid': amountPaid,
      if (status == 'paid') 'paidDate': DateTime.now().toIso8601String(),
      // ignore: use_null_aware_elements
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
      // ignore: use_null_aware_elements
      if (notes != null) 'notes': notes,
    };

    await _firestore.update(
      collectionPath: collectionPath,
      documentId: recordId,
      data: updates,
      userId: userId,
    );

    await _activityLog.log(
      userId: userId,
      action: 'updated',
      module: 'recurring',
      description: 'Payment updated for record $recordId — status: $status',
      documentId: recordId,
      collectionPath: collectionPath,
    );
  }

  // ---------------------------------------------------------------------------
  // Overdue detection
  // ---------------------------------------------------------------------------

  /// Checks all pending records where dueDate is past and updates them to "overdue".
  /// Returns the count of records marked as overdue.
  Future<int> markOverdueRecords({required String userId}) async {
    final now = DateTime.now();
    int count = 0;

    final allConfigs = await _firestore.getAll(
      collectionPath: configCollection,
    );
    final activeConfigs = allConfigs
        .map(_configFromMap)
        .where((c) => c.isActive);

    for (final config in activeConfigs) {
      final results = await _firestore.query(
        collectionPath: config.collectionPath,
        field: 'status',
        isEqualTo: 'pending',
      );
      for (final map in results) {
        final record = _recordFromMap(map);
        if (record.dueDate.isBefore(now)) {
          await _firestore.update(
            collectionPath: config.collectionPath,
            documentId: record.id,
            data: {'status': 'overdue'},
            userId: userId,
          );
          count++;
        }
      }
    }

    if (count > 0) {
      await _activityLog.log(
        userId: userId,
        action: 'updated',
        module: 'recurring',
        description: 'Marked $count records as overdue',
      );
    }

    return count;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Returns a period string in "YYYY-MM" format.
  String _periodString(DateTime date) {
    final mm = date.month.toString().padLeft(2, '0');
    return '${date.year}-$mm';
  }

  RecurringConfig _configFromMap(Map<String, dynamic> map) {
    return RecurringConfig.fromJson(_normalizeTimestamps(map));
  }

  RecurringRecord _recordFromMap(Map<String, dynamic> map) {
    return RecurringRecord.fromJson(_normalizeTimestamps(map));
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
