import 'package:hms/core/models/ground.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';

class GroundService {
  GroundService(this._firestore, this._activityLog);

  final FirestoreService _firestore;
  final ActivityLogService _activityLog;

  static const String _collection = 'grounds';

  // ---------------------------------------------------------------------------
  // Write operations
  // ---------------------------------------------------------------------------

  Future<String> createGround(Ground ground, String userId) async {
    final id = await _firestore.create(
      collectionPath: _collection,
      data: {
        'name': ground.name,
        'location': ground.location,
        'numberOfUnits': ground.numberOfUnits,
      },
      userId: userId,
    );
    await _activityLog.log(
      userId: userId,
      action: 'create',
      module: 'grounds',
      description: 'Created property "${ground.name}"',
      documentId: id,
      collectionPath: _collection,
    );
    return id;
  }

  Future<void> updateGround(
    String groundId,
    Map<String, dynamic> updates,
    String userId,
  ) async {
    await _firestore.update(
      collectionPath: _collection,
      documentId: groundId,
      data: updates,
      userId: userId,
    );
    await _activityLog.log(
      userId: userId,
      action: 'update',
      module: 'grounds',
      description: 'Updated property $groundId',
      documentId: groundId,
      collectionPath: _collection,
    );
  }

  /// Super Admin only — caller is responsible for checking role.
  Future<void> deleteGround(String groundId, String userId) async {
    await _firestore.delete(collectionPath: _collection, documentId: groundId);
    await _activityLog.log(
      userId: userId,
      action: 'delete',
      module: 'grounds',
      description: 'Deleted property $groundId',
      documentId: groundId,
      collectionPath: _collection,
    );
  }

  // ---------------------------------------------------------------------------
  // Read operations
  // ---------------------------------------------------------------------------

  Future<Ground?> getGround(String groundId) async {
    final data = await _firestore.get(
      collectionPath: _collection,
      documentId: groundId,
    );
    if (data == null) return null;
    return Ground.fromJson(_normalizeTimestamps(data));
  }

  Future<List<Ground>> getAllGrounds() async {
    final results = await _firestore.getAll(
      collectionPath: _collection,
      orderBy: 'createdAt',
    );
    return results
        .map((d) => Ground.fromJson(_normalizeTimestamps(d)))
        .toList();
  }

  Stream<List<Ground>> streamAllGrounds() {
    return _firestore
        .stream(collectionPath: _collection, orderBy: 'createdAt')
        .map(
          (list) => list
              .map((d) => Ground.fromJson(_normalizeTimestamps(d)))
              .toList(),
        );
  }

  Stream<Ground?> streamGround(String groundId) {
    return _firestore
        .streamDocument(collectionPath: _collection, documentId: groundId)
        .map(
          (data) =>
              data == null ? null : Ground.fromJson(_normalizeTimestamps(data)),
        );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

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
