import 'package:hms/core/models/migration.dart';

/// Central registry of all Firestore schema migrations.
///
/// Add new [Migration] entries here as the app schema evolves.
/// Migrations run in fromVersion order, are additive only, and are idempotent.
///
/// Example — add when a schema change is needed:
/// ```dart
/// Migration(
///   collection: 'grounds',
///   fromVersion: 1,
///   toVersion: 2,
///   description: 'Add contactPhone field to grounds',
///   transform: (data) => {
///     ...data,
///     'contactPhone': '',
///   },
/// ),
/// ```
List<Migration> getAllMigrations() {
  return [
    // No migrations yet — schemaVersion starts at 1 for all collections.
    // Add migrations here as the schema evolves.
  ];
}
