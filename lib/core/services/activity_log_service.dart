import 'package:hms/core/models/activity_log.dart';
import 'package:hms/core/services/firestore_service.dart';

class ActivityLogService {
  ActivityLogService(this._firestore);

  final FirestoreService _firestore;

  static const String collection = 'activity_logs';

  /// Records a user action to the activity_logs collection.
  /// Called by other services whenever data is created, updated, or deleted.
  Future<void> log({
    required String userId,
    required String action,
    required String module,
    required String description,
    String? documentId,
    String? collectionPath,
  }) async {
    await _firestore.create(
      collectionPath: collection,
      data: {
        'userId': userId,
        'action': action,
        'module': module,
        'description': description,
        // ignore: use_null_aware_elements
        if (documentId != null) 'documentId': documentId,
        // ignore: use_null_aware_elements
        if (collectionPath != null) 'collectionPath': collectionPath,
      },
      userId: userId,
    );
  }

  /// Returns all logs, newest first.
  Future<List<ActivityLog>> getAll({int? limit}) async {
    final results = await _firestore.getAll(
      collectionPath: collection,
      orderBy: 'createdAt',
      descending: true,
      limit: limit,
    );
    return results.map(_fromMap).toList();
  }

  /// Returns logs filtered by userId, newest first.
  Future<List<ActivityLog>> getByUser({
    required String userId,
    int? limit,
  }) async {
    final results = await _firestore.query(
      collectionPath: collection,
      field: 'userId',
      isEqualTo: userId,
      orderBy: 'createdAt',
      descending: true,
    );
    final logs = results.map(_fromMap).toList();
    if (limit != null) return logs.take(limit).toList();
    return logs;
  }

  /// Returns logs filtered by module, newest first.
  Future<List<ActivityLog>> getByModule({
    required String module,
    int? limit,
  }) async {
    final results = await _firestore.query(
      collectionPath: collection,
      field: 'module',
      isEqualTo: module,
      orderBy: 'createdAt',
      descending: true,
    );
    final logs = results.map(_fromMap).toList();
    if (limit != null) return logs.take(limit).toList();
    return logs;
  }

  /// Returns logs within a date range, newest first.
  Future<List<ActivityLog>> getByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    int? limit,
  }) async {
    final all = await _firestore.getAll(
      collectionPath: collection,
      orderBy: 'createdAt',
      descending: true,
    );
    final filtered = all.map(_fromMap).where((log) {
      return !log.createdAt.isBefore(startDate) &&
          !log.createdAt.isAfter(endDate);
    }).toList();
    if (limit != null) return filtered.take(limit).toList();
    return filtered;
  }

  /// Streams all logs in real-time, newest first.
  Stream<List<ActivityLog>> streamAll() {
    return _firestore
        .stream(
          collectionPath: collection,
          orderBy: 'createdAt',
          descending: true,
        )
        .map((list) => list.map(_fromMap).toList());
  }

  ActivityLog _fromMap(Map<String, dynamic> map) {
    // FirestoreService returns Timestamp objects for server timestamps.
    // Convert them to DateTime before passing to Freezed fromJson.
    return ActivityLog.fromJson(_normalizeTimestamps(map));
  }

  Map<String, dynamic> _normalizeTimestamps(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is DateTime) return MapEntry(key, value.toIso8601String());
      // cloud_firestore Timestamp
      if (value != null && value.runtimeType.toString() == 'Timestamp') {
        return MapEntry(key, (value as dynamic).toDate().toIso8601String());
      }
      return MapEntry(key, value);
    });
  }
}
