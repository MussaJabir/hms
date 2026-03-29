import 'package:flutter/foundation.dart';
import 'package:hms/core/models/migration.dart';
import 'package:hms/core/models/migration_status.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';

class DataMigrationService {
  DataMigrationService(this._firestore, this._activityLog);

  final FirestoreService _firestore;
  final ActivityLogService _activityLog;

  final List<Migration> _migrations = [];

  // ---------------------------------------------------------------------------
  // Registration
  // ---------------------------------------------------------------------------

  /// Registers a single migration.
  void registerMigration(Migration migration) {
    _migrations.add(migration);
  }

  /// Registers multiple migrations at once.
  void registerMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
  }

  // ---------------------------------------------------------------------------
  // Version inspection
  // ---------------------------------------------------------------------------

  /// Returns the minimum schemaVersion found across all documents in a collection.
  /// Returns 1 if the collection is empty or no schemaVersion field is present.
  Future<int> getCurrentVersion(String collectionPath) async {
    final docs = await _firestore.getAll(collectionPath: collectionPath);
    if (docs.isEmpty) return 1;

    var min = 1;
    var first = true;
    for (final doc in docs) {
      final v = (doc['schemaVersion'] as num?)?.toInt() ?? 1;
      if (first || v < min) {
        min = v;
        first = false;
      }
    }
    return min;
  }

  /// Returns the highest toVersion registered for a collection.
  /// Returns 1 if no migrations are registered for that collection.
  int getLatestVersion(String collection) {
    final relevant = _migrations.where((m) => m.collection == collection);
    if (relevant.isEmpty) return 1;
    return relevant.map((m) => m.toVersion).reduce((a, b) => a > b ? a : b);
  }

  /// Returns true if any document in the collection is below the target version.
  Future<bool> needsMigration(String collectionPath) async {
    final current = await getCurrentVersion(collectionPath);
    final target = getLatestVersion(collectionPath);
    return current < target;
  }

  // ---------------------------------------------------------------------------
  // Migration execution
  // ---------------------------------------------------------------------------

  /// Runs all pending migrations for a collection.
  /// Reads every document, applies transforms in version order, and updates
  /// the document with the new data + incremented schemaVersion.
  /// Idempotent — documents already at the target version are skipped.
  /// Returns the number of documents that were migrated.
  Future<int> migrateCollection({
    required String collectionPath,
    required String userId,
  }) async {
    final targetVersion = getLatestVersion(collectionPath);
    final docs = await _firestore.getAll(collectionPath: collectionPath);

    // Sort migrations for this collection by fromVersion ascending.
    final steps =
        _migrations.where((m) => m.collection == collectionPath).toList()
          ..sort((a, b) => a.fromVersion.compareTo(b.fromVersion));

    if (steps.isEmpty) return 0;

    int migrated = 0;

    for (final doc in docs) {
      final docId = doc['id'] as String;
      var currentVersion = (doc['schemaVersion'] as num?)?.toInt() ?? 1;

      if (currentVersion >= targetVersion) continue;

      var data = Map<String, dynamic>.from(doc)..remove('id');

      // Apply each migration step in order until the document reaches target.
      for (final step in steps) {
        if (step.fromVersion == currentVersion) {
          data = step.transform(data);
          currentVersion = step.toVersion;
        }
        if (currentVersion >= targetVersion) break;
      }

      // Write updated data back, FirestoreService will set updatedAt/updatedBy.
      await _firestore.update(
        collectionPath: collectionPath,
        documentId: docId,
        data: {...data, 'schemaVersion': currentVersion},
        userId: userId,
      );

      migrated++;
    }

    if (migrated > 0) {
      await _activityLog.log(
        userId: userId,
        action: 'updated',
        module: 'migration',
        description:
            'Migrated $migrated document(s) in "$collectionPath" to v$targetVersion',
        collectionPath: collectionPath,
      );
      debugPrint(
        'DataMigrationService: migrated $migrated doc(s) in "$collectionPath" → v$targetVersion',
      );
    }

    return migrated;
  }

  /// Runs migrations for ALL collections that have registered migrations.
  /// Returns a map of collectionPath → number of documents migrated.
  Future<Map<String, int>> migrateAll({required String userId}) async {
    final collections = _migrations.map((m) => m.collection).toSet();
    final results = <String, int>{};

    for (final collection in collections) {
      results[collection] = await migrateCollection(
        collectionPath: collection,
        userId: userId,
      );
    }

    return results;
  }

  // ---------------------------------------------------------------------------
  // Status reporting
  // ---------------------------------------------------------------------------

  /// Returns migration status for every collection that has registered migrations.
  Future<List<MigrationStatus>> getStatus() async {
    final collections = _migrations.map((m) => m.collection).toSet();
    final statuses = <MigrationStatus>[];

    for (final collection in collections) {
      final current = await getCurrentVersion(collection);
      final target = getLatestVersion(collection);
      statuses.add(
        MigrationStatus(
          collection: collection,
          currentVersion: current,
          targetVersion: target,
          needsMigration: current < target,
        ),
      );
    }

    return statuses;
  }
}
