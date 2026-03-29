/// Defines a single schema migration step for a Firestore collection.
///
/// Not a Freezed class — contains a Function field that cannot be serialized.
class Migration {
  const Migration({
    required this.collection,
    required this.fromVersion,
    required this.toVersion,
    required this.description,
    required this.transform,
  });

  /// The Firestore collection this migration applies to.
  final String collection;

  /// The schemaVersion this migration upgrades FROM.
  final int fromVersion;

  /// The schemaVersion this migration upgrades TO.
  final int toVersion;

  /// Human-readable description, e.g. "Add paymentMethod field to rent_payments".
  final String description;

  /// Pure function: takes old document data, returns new document data.
  /// Must never delete fields — only add or restructure.
  final Map<String, dynamic> Function(Map<String, dynamic> data) transform;
}
