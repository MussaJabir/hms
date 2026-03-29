import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/models/activity_log.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late ActivityLogService service;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
    service = ActivityLogService(firestoreService);
  });

  group('ActivityLogService.log', () {
    test('writes to the activity_logs collection', () async {
      await service.log(
        userId: 'user-1',
        action: 'created',
        module: 'rent',
        description: 'Marked rent paid for Room 3 — TZS 150,000',
      );

      final snap = await fakeFirestore.collection('activity_logs').get();
      expect(snap.docs.length, 1);
    });

    test('stores all required fields in the document', () async {
      await service.log(
        userId: 'user-1',
        action: 'updated',
        module: 'electricity',
        description: 'Updated meter reading for Room 5',
        documentId: 'doc-123',
        collectionPath: 'grounds/g1/meter_readings',
      );

      final snap = await fakeFirestore.collection('activity_logs').get();
      final data = snap.docs.first.data();

      expect(data['userId'], 'user-1');
      expect(data['action'], 'updated');
      expect(data['module'], 'electricity');
      expect(data['description'], 'Updated meter reading for Room 5');
      expect(data['documentId'], 'doc-123');
      expect(data['collectionPath'], 'grounds/g1/meter_readings');
    });

    test('works without optional documentId and collectionPath', () async {
      await service.log(
        userId: 'user-2',
        action: 'deleted',
        module: 'inventory',
        description: 'Deleted stock item: Rice 5kg',
      );

      final snap = await fakeFirestore.collection('activity_logs').get();
      final data = snap.docs.first.data();

      expect(data['userId'], 'user-2');
      expect(data.containsKey('documentId'), isFalse);
      expect(data.containsKey('collectionPath'), isFalse);
    });

    test(
      'FirestoreService adds metadata fields (createdAt, updatedBy)',
      () async {
        await service.log(
          userId: 'user-1',
          action: 'created',
          module: 'finance',
          description: 'Added income: TZS 500,000',
        );

        final snap = await fakeFirestore.collection('activity_logs').get();
        final data = snap.docs.first.data();

        expect(data['createdAt'], isNotNull);
        expect(data['updatedBy'], 'user-1');
        expect(data['schemaVersion'], 1);
      },
    );
  });

  group('ActivityLogService.getAll', () {
    setUp(() async {
      await service.log(
        userId: 'user-1',
        action: 'created',
        module: 'rent',
        description: 'Log entry 1',
      );
      await service.log(
        userId: 'user-2',
        action: 'updated',
        module: 'electricity',
        description: 'Log entry 2',
      );
    });

    test('returns a list of ActivityLog objects', () async {
      final logs = await service.getAll();
      expect(logs, isA<List<ActivityLog>>());
      expect(logs.length, 2);
    });

    test('respects the limit parameter', () async {
      final logs = await service.getAll(limit: 1);
      expect(logs.length, 1);
    });

    test('each returned log has required fields populated', () async {
      final logs = await service.getAll();
      for (final log in logs) {
        expect(log.id, isNotEmpty);
        expect(log.userId, isNotEmpty);
        expect(log.action, isNotEmpty);
        expect(log.module, isNotEmpty);
        expect(log.description, isNotEmpty);
      }
    });
  });

  group('ActivityLogService.getByUser', () {
    setUp(() async {
      await service.log(
        userId: 'user-1',
        action: 'created',
        module: 'rent',
        description: 'User 1 action',
      );
      await service.log(
        userId: 'user-2',
        action: 'updated',
        module: 'rent',
        description: 'User 2 action',
      );
    });

    test('returns only logs for the specified user', () async {
      final logs = await service.getByUser(userId: 'user-1');
      expect(logs.length, 1);
      expect(logs.first.userId, 'user-1');
    });

    test('returns empty list when user has no logs', () async {
      final logs = await service.getByUser(userId: 'user-99');
      expect(logs, isEmpty);
    });
  });

  group('ActivityLogService.getByModule', () {
    setUp(() async {
      await service.log(
        userId: 'user-1',
        action: 'created',
        module: 'rent',
        description: 'Rent action 1',
      );
      await service.log(
        userId: 'user-1',
        action: 'updated',
        module: 'rent',
        description: 'Rent action 2',
      );
      await service.log(
        userId: 'user-1',
        action: 'created',
        module: 'electricity',
        description: 'Electricity action',
      );
    });

    test('returns only logs for the specified module', () async {
      final logs = await service.getByModule(module: 'rent');
      expect(logs.length, 2);
      expect(logs.every((l) => l.module == 'rent'), isTrue);
    });

    test('returns empty list when module has no logs', () async {
      final logs = await service.getByModule(module: 'water');
      expect(logs, isEmpty);
    });
  });

  group('ActivityLogService.streamAll', () {
    test('emits a list of ActivityLog objects', () async {
      await service.log(
        userId: 'user-1',
        action: 'created',
        module: 'inventory',
        description: 'Added item',
      );

      final stream = service.streamAll();
      final logs = await stream.first;

      expect(logs, isA<List<ActivityLog>>());
      expect(logs.length, 1);
      expect(logs.first.module, 'inventory');
    });
  });
}
