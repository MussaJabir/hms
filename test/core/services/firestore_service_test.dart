import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/firestore_service.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService service;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    service = FirestoreService(firestore: fakeFirestore);
  });

  group('FirestoreService.create', () {
    test('adds metadata fields automatically', () async {
      final id = await service.create(
        collectionPath: 'grounds',
        data: {'name': 'Ground A'},
        userId: 'user-001',
        schemaVersion: 1,
      );

      final snap = await fakeFirestore.collection('grounds').doc(id).get();
      final data = snap.data()!;

      expect(data['name'], equals('Ground A'));
      expect(data['updatedBy'], equals('user-001'));
      expect(data['schemaVersion'], equals(1));
      expect(data['createdAt'], isNotNull);
      expect(data['updatedAt'], isNotNull);
    });

    test('returns the new document ID', () async {
      final id = await service.create(
        collectionPath: 'grounds',
        data: {'name': 'Ground B'},
        userId: 'user-001',
      );

      expect(id, isNotEmpty);
    });

    test('works with subcollection paths', () async {
      final id = await service.create(
        collectionPath: 'grounds/g1/rental_units',
        data: {'unitNumber': '1A'},
        userId: 'user-001',
      );

      final snap = await fakeFirestore
          .collection('grounds/g1/rental_units')
          .doc(id)
          .get();

      expect(snap.exists, isTrue);
      expect(snap.data()!['unitNumber'], equals('1A'));
    });
  });

  group('FirestoreService.set', () {
    test('adds metadata fields automatically', () async {
      await service.set(
        collectionPath: 'grounds',
        documentId: 'doc-123',
        data: {'name': 'Ground C'},
        userId: 'user-002',
        schemaVersion: 2,
      );

      final snap = await fakeFirestore
          .collection('grounds')
          .doc('doc-123')
          .get();
      final data = snap.data()!;

      expect(data['name'], equals('Ground C'));
      expect(data['updatedBy'], equals('user-002'));
      expect(data['schemaVersion'], equals(2));
      expect(data['createdAt'], isNotNull);
      expect(data['updatedAt'], isNotNull);
    });
  });

  group('FirestoreService.update', () {
    test('adds updatedAt and updatedBy', () async {
      await fakeFirestore.collection('grounds').doc('doc-update').set({
        'name': 'Old Name',
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
        'updatedBy': 'user-000',
        'schemaVersion': 1,
      });

      await service.update(
        collectionPath: 'grounds',
        documentId: 'doc-update',
        data: {'name': 'New Name'},
        userId: 'user-999',
      );

      final snap = await fakeFirestore
          .collection('grounds')
          .doc('doc-update')
          .get();
      final data = snap.data()!;

      expect(data['name'], equals('New Name'));
      expect(data['updatedBy'], equals('user-999'));
      expect(data['updatedAt'], isNotNull);
    });
  });

  group('FirestoreService.get', () {
    test('returned document includes the id field', () async {
      await fakeFirestore.collection('grounds').doc('known-id').set({
        'name': 'Test Ground',
      });

      final result = await service.get(
        collectionPath: 'grounds',
        documentId: 'known-id',
      );

      expect(result, isNotNull);
      expect(result!['id'], equals('known-id'));
      expect(result['name'], equals('Test Ground'));
    });

    test('returns null for non-existent document', () async {
      final result = await service.get(
        collectionPath: 'grounds',
        documentId: 'does-not-exist',
      );

      expect(result, isNull);
    });
  });

  group('FirestoreService.getAll', () {
    test('returned documents each include the id field', () async {
      await fakeFirestore.collection('items').doc('item-1').set({'label': 'A'});
      await fakeFirestore.collection('items').doc('item-2').set({'label': 'B'});

      final results = await service.getAll(collectionPath: 'items');

      expect(results.length, equals(2));
      for (final doc in results) {
        expect(doc.containsKey('id'), isTrue);
      }
    });
  });

  group('FirestoreService.delete', () {
    test('removes the document', () async {
      await fakeFirestore.collection('grounds').doc('to-delete').set({
        'name': 'Delete Me',
      });

      await service.delete(collectionPath: 'grounds', documentId: 'to-delete');

      final snap = await fakeFirestore
          .collection('grounds')
          .doc('to-delete')
          .get();
      expect(snap.exists, isFalse);
    });
  });

  group('FirestoreService.stream', () {
    test('emits documents with id field', () async {
      await fakeFirestore.collection('rooms').doc('r1').set({'number': '101'});

      final stream = service.stream(collectionPath: 'rooms');
      final docs = await stream.first;

      expect(docs.length, equals(1));
      expect(docs.first['id'], equals('r1'));
      expect(docs.first['number'], equals('101'));
    });
  });
}
