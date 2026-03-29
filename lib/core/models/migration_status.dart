/// Reports the migration state of a single Firestore collection.
///
/// Not a Freezed class — simple immutable data holder.
class MigrationStatus {
  const MigrationStatus({
    required this.collection,
    required this.currentVersion,
    required this.targetVersion,
    required this.needsMigration,
  });

  /// The Firestore collection path.
  final String collection;

  /// The lowest schemaVersion found across documents in this collection.
  final int currentVersion;

  /// The highest toVersion registered for this collection.
  final int targetVersion;

  /// True when currentVersion < targetVersion.
  final bool needsMigration;
}
