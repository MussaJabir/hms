import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/models/migration.dart';
import 'package:hms/core/models/migration_status.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/data_migration_service.dart';
import 'package:hms/core/services/firestore_service.dart';

/// Stub that silently swallows log calls.
class _StubActivityLogService extends ActivityLogService {
  _StubActivityLogService()
    : super(FirestoreService(firestore: FakeFirebaseFirestore()));

  @override
  Future<void> log({
    required String userId,
    required String action,
    required String module,
    required String description,
    String? documentId,
    String? collectionPath,
  }) async {}
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Seeds a document at [collection]/[docId] with [data] + schemaVersion.
Future<void> _seed(
  FakeFirebaseFirestore db,
  String collection,
  String docId,
  Map<String, dynamic> data, {
  int schemaVersion = 1,
}) async {
  await db.collection(collection).doc(docId).set({
    ...data,
    'schemaVersion': schemaVersion,
    'createdAt': DateTime.now().toIso8601String(),
    'updatedAt': DateTime.now().toIso8601String(),
    'updatedBy': 'system',
  });
}

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late _StubActivityLogService activityLogService;
  late DataMigrationService service;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
    activityLogService = _StubActivityLogService();
    service = DataMigrationService(firestoreService, activityLogService);
  });

  // ---------------------------------------------------------------------------
  // registerMigration / registerMigrations
  // ---------------------------------------------------------------------------
  group('registerMigration', () {
    test(
      'adds migration to the internal list (reflected in getLatestVersion)',
      () {
        expect(service.getLatestVersion('grounds'), 1); // nothing registered

        service.registerMigration(
          Migration(
            collection: 'grounds',
            fromVersion: 1,
            toVersion: 2,
            description: 'Test migration',
            transform: (data) => {...data, 'newField': 'default'},
          ),
        );

        expect(service.getLatestVersion('grounds'), 2);
      },
    );

    test('registerMigrations adds all entries', () {
      service.registerMigrations([
        Migration(
          collection: 'users',
          fromVersion: 1,
          toVersion: 2,
          description: 'Step 1',
          transform: (data) => {...data, 'a': 1},
        ),
        Migration(
          collection: 'users',
          fromVersion: 2,
          toVersion: 3,
          description: 'Step 2',
          transform: (data) => {...data, 'b': 2},
        ),
      ]);

      expect(service.getLatestVersion('users'), 3);
    });
  });

  // ---------------------------------------------------------------------------
  // getLatestVersion
  // ---------------------------------------------------------------------------
  group('getLatestVersion', () {
    test('returns 1 when no migrations registered for a collection', () {
      expect(service.getLatestVersion('unknown_collection'), 1);
    });

    test(
      'returns the highest toVersion across all migrations for a collection',
      () {
        service.registerMigrations([
          Migration(
            collection: 'items',
            fromVersion: 1,
            toVersion: 2,
            description: 'v1→v2',
            transform: (d) => d,
          ),
          Migration(
            collection: 'items',
            fromVersion: 2,
            toVersion: 3,
            description: 'v2→v3',
            transform: (d) => d,
          ),
        ]);

        expect(service.getLatestVersion('items'), 3);
      },
    );
  });

  // ---------------------------------------------------------------------------
  // getCurrentVersion
  // ---------------------------------------------------------------------------
  group('getCurrentVersion', () {
    test('returns 1 for an empty collection', () async {
      final v = await service.getCurrentVersion('empty_collection');
      expect(v, 1);
    });

    test('returns the schemaVersion of the single document', () async {
      await _seed(fakeFirestore, 'grounds', 'g1', {
        'name': 'Ground A',
      }, schemaVersion: 2);
      final v = await service.getCurrentVersion('grounds');
      expect(v, 2);
    });

    test(
      'returns the minimum schemaVersion when multiple documents exist',
      () async {
        await _seed(fakeFirestore, 'grounds', 'g1', {
          'name': 'A',
        }, schemaVersion: 2);
        await _seed(fakeFirestore, 'grounds', 'g2', {
          'name': 'B',
        }, schemaVersion: 1);
        final v = await service.getCurrentVersion('grounds');
        expect(v, 1); // minimum
      },
    );
  });

  // ---------------------------------------------------------------------------
  // migrateCollection
  // ---------------------------------------------------------------------------
  group('migrateCollection', () {
    test('applies transform and updates schemaVersion', () async {
      await _seed(fakeFirestore, 'grounds', 'g1', {'name': 'Ground A'});

      service.registerMigration(
        Migration(
          collection: 'grounds',
          fromVersion: 1,
          toVersion: 2,
          description: 'Add contactPhone',
          transform: (data) => {...data, 'contactPhone': ''},
        ),
      );

      final count = await service.migrateCollection(
        collectionPath: 'grounds',
        userId: 'user-1',
      );

      expect(count, 1);

      final snap = await fakeFirestore.collection('grounds').doc('g1').get();
      expect(snap.data()!['contactPhone'], '');
      expect(snap.data()!['schemaVersion'], 2);
    });

    test(
      'applies transforms in order for multi-step migrations (v1→v2→v3)',
      () async {
        await _seed(fakeFirestore, 'items', 'i1', {'name': 'Widget'});

        service.registerMigrations([
          Migration(
            collection: 'items',
            fromVersion: 1,
            toVersion: 2,
            description: 'Add fieldA',
            transform: (data) => {...data, 'fieldA': 'alpha'},
          ),
          Migration(
            collection: 'items',
            fromVersion: 2,
            toVersion: 3,
            description: 'Add fieldB',
            transform: (data) => {...data, 'fieldB': 'beta'},
          ),
        ]);

        final count = await service.migrateCollection(
          collectionPath: 'items',
          userId: 'user-1',
        );

        expect(count, 1);

        final snap = await fakeFirestore.collection('items').doc('i1').get();
        expect(snap.data()!['fieldA'], 'alpha');
        expect(snap.data()!['fieldB'], 'beta');
        expect(snap.data()!['schemaVersion'], 3);
      },
    );

    test('skips documents already at the target version', () async {
      await _seed(fakeFirestore, 'grounds', 'g1', {
        'name': 'A',
      }, schemaVersion: 2);

      service.registerMigration(
        Migration(
          collection: 'grounds',
          fromVersion: 1,
          toVersion: 2,
          description: 'Already done',
          transform: (data) => {...data, 'contactPhone': ''},
        ),
      );

      final count = await service.migrateCollection(
        collectionPath: 'grounds',
        userId: 'user-1',
      );

      expect(count, 0);
    });

    test(
      'is idempotent — running twice does not change documents again',
      () async {
        await _seed(fakeFirestore, 'grounds', 'g1', {'name': 'A'});

        service.registerMigration(
          Migration(
            collection: 'grounds',
            fromVersion: 1,
            toVersion: 2,
            description: 'Add tag',
            transform: (data) => {...data, 'tag': 'migrated'},
          ),
        );

        await service.migrateCollection(
          collectionPath: 'grounds',
          userId: 'user-1',
        );
        final secondRun = await service.migrateCollection(
          collectionPath: 'grounds',
          userId: 'user-1',
        );

        expect(secondRun, 0);
      },
    );

    test(
      'returns 0 when no migrations are registered for the collection',
      () async {
        await _seed(fakeFirestore, 'unmapped', 'doc1', {'x': 1});
        final count = await service.migrateCollection(
          collectionPath: 'unmapped',
          userId: 'user-1',
        );
        expect(count, 0);
      },
    );

    test('transform receives old data and returns new data', () async {
      await _seed(fakeFirestore, 'widgets', 'w1', {'price': 1000});

      service.registerMigration(
        Migration(
          collection: 'widgets',
          fromVersion: 1,
          toVersion: 2,
          description: 'Double the price',
          transform: (data) {
            final oldPrice = (data['price'] as num).toDouble();
            return {...data, 'price': oldPrice * 2};
          },
        ),
      );

      await service.migrateCollection(
        collectionPath: 'widgets',
        userId: 'user-1',
      );

      final snap = await fakeFirestore.collection('widgets').doc('w1').get();
      expect(snap.data()!['price'], 2000.0);
    });
  });

  // ---------------------------------------------------------------------------
  // migrateAll
  // ---------------------------------------------------------------------------
  group('migrateAll', () {
    test('migrates all registered collections and returns counts', () async {
      await _seed(fakeFirestore, 'col_a', 'a1', {'x': 1});
      await _seed(fakeFirestore, 'col_b', 'b1', {'y': 2});

      service.registerMigrations([
        Migration(
          collection: 'col_a',
          fromVersion: 1,
          toVersion: 2,
          description: 'Col A migration',
          transform: (data) => {...data, 'newA': true},
        ),
        Migration(
          collection: 'col_b',
          fromVersion: 1,
          toVersion: 2,
          description: 'Col B migration',
          transform: (data) => {...data, 'newB': true},
        ),
      ]);

      final results = await service.migrateAll(userId: 'user-1');

      expect(results['col_a'], 1);
      expect(results['col_b'], 1);
    });

    test('returns empty map when no migrations are registered', () async {
      final results = await service.migrateAll(userId: 'user-1');
      expect(results, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // getStatus
  // ---------------------------------------------------------------------------
  group('getStatus', () {
    test('reports needsMigration=true when documents are behind', () async {
      await _seed(fakeFirestore, 'grounds', 'g1', {
        'name': 'A',
      }, schemaVersion: 1);

      service.registerMigration(
        Migration(
          collection: 'grounds',
          fromVersion: 1,
          toVersion: 2,
          description: 'Pending migration',
          transform: (data) => {...data, 'tag': ''},
        ),
      );

      final statuses = await service.getStatus();
      expect(statuses, hasLength(1));

      final status = statuses.first;
      expect(status, isA<MigrationStatus>());
      expect(status.collection, 'grounds');
      expect(status.currentVersion, 1);
      expect(status.targetVersion, 2);
      expect(status.needsMigration, isTrue);
    });

    test(
      'reports needsMigration=false when all documents are up to date',
      () async {
        await _seed(fakeFirestore, 'grounds', 'g1', {
          'name': 'A',
        }, schemaVersion: 2);

        service.registerMigration(
          Migration(
            collection: 'grounds',
            fromVersion: 1,
            toVersion: 2,
            description: 'Already done',
            transform: (data) => data,
          ),
        );

        final statuses = await service.getStatus();
        expect(statuses.first.needsMigration, isFalse);
      },
    );
  });
}
