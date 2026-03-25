import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _collection(String path) =>
      _db.collection(path);

  // ---------------------------------------------------------------------------
  // Write operations
  // ---------------------------------------------------------------------------

  /// Creates a document with an auto-generated ID.
  /// Returns the new document's ID.
  Future<String> create({
    required String collectionPath,
    required Map<String, dynamic> data,
    required String userId,
    int schemaVersion = 1,
  }) async {
    try {
      final doc = _collection(collectionPath).doc();
      await doc.set({
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': userId,
        'schemaVersion': schemaVersion,
      });
      return doc.id;
    } on FirebaseException catch (e) {
      debugPrint('FirestoreService.create error: ${e.message}');
      throw Exception('Failed to create document: ${e.message}');
    }
  }

  /// Creates or overwrites a document with a specific ID.
  Future<void> set({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> data,
    required String userId,
    int schemaVersion = 1,
  }) async {
    try {
      await _collection(collectionPath).doc(documentId).set({
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': userId,
        'schemaVersion': schemaVersion,
      });
    } on FirebaseException catch (e) {
      debugPrint('FirestoreService.set error: ${e.message}');
      throw Exception('Failed to set document: ${e.message}');
    }
  }

  /// Updates specific fields on a document.
  Future<void> update({
    required String collectionPath,
    required String documentId,
    required Map<String, dynamic> data,
    required String userId,
  }) async {
    try {
      await _collection(collectionPath).doc(documentId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': userId,
      });
    } on FirebaseException catch (e) {
      debugPrint('FirestoreService.update error: ${e.message}');
      throw Exception('Failed to update document: ${e.message}');
    }
  }

  /// Deletes a document.
  Future<void> delete({
    required String collectionPath,
    required String documentId,
  }) async {
    try {
      await _collection(collectionPath).doc(documentId).delete();
    } on FirebaseException catch (e) {
      debugPrint('FirestoreService.delete error: ${e.message}');
      throw Exception('Failed to delete document: ${e.message}');
    }
  }

  // ---------------------------------------------------------------------------
  // Read operations
  // ---------------------------------------------------------------------------

  /// Reads a single document by ID. Returns null if not found.
  Future<Map<String, dynamic>?> get({
    required String collectionPath,
    required String documentId,
  }) async {
    try {
      final snap = await _collection(collectionPath).doc(documentId).get();
      if (!snap.exists || snap.data() == null) return null;
      return {'id': snap.id, ...snap.data()!};
    } on FirebaseException catch (e) {
      debugPrint('FirestoreService.get error: ${e.message}');
      throw Exception('Failed to get document: ${e.message}');
    }
  }

  /// Reads all documents in a collection.
  Future<List<Map<String, dynamic>>> getAll({
    required String collectionPath,
    String? orderBy,
    bool descending = false,
    int? limit,
  }) async {
    try {
      Query<Map<String, dynamic>> q = _collection(collectionPath);
      if (orderBy != null) q = q.orderBy(orderBy, descending: descending);
      if (limit != null) q = q.limit(limit);
      final snap = await q.get();
      return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
    } on FirebaseException catch (e) {
      debugPrint('FirestoreService.getAll error: ${e.message}');
      throw Exception('Failed to get documents: ${e.message}');
    }
  }

  /// Queries documents by a single field equality.
  Future<List<Map<String, dynamic>>> query({
    required String collectionPath,
    required String field,
    required dynamic isEqualTo,
    String? orderBy,
    bool descending = false,
  }) async {
    try {
      Query<Map<String, dynamic>> q = _collection(
        collectionPath,
      ).where(field, isEqualTo: isEqualTo);
      if (orderBy != null) q = q.orderBy(orderBy, descending: descending);
      final snap = await q.get();
      return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
    } on FirebaseException catch (e) {
      debugPrint('FirestoreService.query error: ${e.message}');
      throw Exception('Failed to query documents: ${e.message}');
    }
  }

  // ---------------------------------------------------------------------------
  // Stream operations
  // ---------------------------------------------------------------------------

  /// Streams all documents in a collection in real time.
  Stream<List<Map<String, dynamic>>> stream({
    required String collectionPath,
    String? orderBy,
    bool descending = false,
  }) {
    Query<Map<String, dynamic>> q = _collection(collectionPath);
    if (orderBy != null) q = q.orderBy(orderBy, descending: descending);
    return q.snapshots().map(
      (snap) => snap.docs.map((d) => {'id': d.id, ...d.data()}).toList(),
    );
  }

  /// Streams a single document in real time.
  Stream<Map<String, dynamic>?> streamDocument({
    required String collectionPath,
    required String documentId,
  }) {
    return _collection(collectionPath).doc(documentId).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return {'id': snap.id, ...snap.data()!};
    });
  }
}
