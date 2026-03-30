import 'package:hms/core/models/models.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';

class UserService {
  UserService(this._firestore, this._activityLog);

  final FirestoreService _firestore;
  final ActivityLogService _activityLog;

  static const String collection = 'users';

  // ---------------------------------------------------------------------------
  // Write operations
  // ---------------------------------------------------------------------------

  /// Creates a new user profile in Firestore.
  /// Called by Super Admin after creating a Firebase Auth account.
  Future<void> createUserProfile({
    required String userId,
    required String email,
    required String displayName,
    required String role,
    required String createdBy,
  }) async {
    await _firestore.set(
      collectionPath: collection,
      documentId: userId,
      data: {
        'email': email,
        'displayName': displayName,
        'role': role,
        'createdBy': createdBy,
      },
      userId: createdBy,
    );

    await _activityLog.log(
      userId: createdBy,
      action: 'created',
      module: 'auth',
      description:
          'Created user profile for $displayName ($email) with role $role',
      documentId: userId,
      collectionPath: collection,
    );
  }

  /// Updates a user's role. Super Admin only.
  Future<void> updateUserRole({
    required String userId,
    required String newRole,
    required String updatedBy,
  }) async {
    await _firestore.update(
      collectionPath: collection,
      documentId: userId,
      data: {'role': newRole},
      userId: updatedBy,
    );

    await _activityLog.log(
      userId: updatedBy,
      action: 'updated',
      module: 'auth',
      description: 'Updated role to $newRole for user $userId',
      documentId: userId,
      collectionPath: collection,
    );
  }

  /// Updates a user's display name.
  Future<void> updateDisplayName({
    required String userId,
    required String displayName,
    required String updatedBy,
  }) async {
    await _firestore.update(
      collectionPath: collection,
      documentId: userId,
      data: {'displayName': displayName},
      userId: updatedBy,
    );

    await _activityLog.log(
      userId: updatedBy,
      action: 'updated',
      module: 'auth',
      description: 'Updated display name to $displayName for user $userId',
      documentId: userId,
      collectionPath: collection,
    );
  }

  /// Deletes a user profile from Firestore. Super Admin only.
  /// Does NOT delete the Firebase Auth account.
  Future<void> deleteUserProfile({
    required String userId,
    required String deletedBy,
  }) async {
    await _activityLog.log(
      userId: deletedBy,
      action: 'deleted',
      module: 'auth',
      description: 'Deleted user profile for $userId',
      documentId: userId,
      collectionPath: collection,
    );

    await _firestore.delete(collectionPath: collection, documentId: userId);
  }

  // ---------------------------------------------------------------------------
  // Read operations
  // ---------------------------------------------------------------------------

  /// Gets a user profile by their Firebase Auth uid. Returns null if not found.
  Future<AppUser?> getUserProfile(String userId) async {
    final data = await _firestore.get(
      collectionPath: collection,
      documentId: userId,
    );
    if (data == null) return null;
    return AppUser.fromJson(_normalizeTimestamps(data));
  }

  /// Gets all user profiles.
  Future<List<AppUser>> getAllUsers() async {
    final results = await _firestore.getAll(
      collectionPath: collection,
      orderBy: 'displayName',
    );
    return results
        .map((d) => AppUser.fromJson(_normalizeTimestamps(d)))
        .toList();
  }

  /// Checks if a user is a Super Admin.
  Future<bool> isSuperAdmin(String userId) async {
    final user = await getUserProfile(userId);
    return user?.isSuperAdmin ?? false;
  }

  /// Returns true if any Super Admin account exists in Firestore.
  /// Used for first-time setup detection.
  Future<bool> superAdminExists() async {
    final results = await _firestore.query(
      collectionPath: collection,
      field: 'role',
      isEqualTo: 'superAdmin',
    );
    return results.isNotEmpty;
  }

  // ---------------------------------------------------------------------------
  // Stream operations
  // ---------------------------------------------------------------------------

  /// Streams a user profile in real-time.
  Stream<AppUser?> streamUserProfile(String userId) {
    return _firestore
        .streamDocument(collectionPath: collection, documentId: userId)
        .map((data) {
          if (data == null) return null;
          return AppUser.fromJson(_normalizeTimestamps(data));
        });
  }

  /// Streams all user profiles in real-time.
  Stream<List<AppUser>> streamAllUsers() {
    return _firestore
        .stream(collectionPath: collection, orderBy: 'displayName')
        .map(
          (list) => list
              .map((d) => AppUser.fromJson(_normalizeTimestamps(d)))
              .toList(),
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
