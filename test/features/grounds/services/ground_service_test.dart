import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/models/ground.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/grounds/services/ground_service.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late ActivityLogService activityLogService;
  late GroundService groundService;

  final now = DateTime(2026, 4, 5);

  Ground makeGround({String name = 'Test Ground'}) => Ground(
    id: '',
    name: name,
    location: 'Dar es Salaam',
    numberOfUnits: 5,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
    activityLogService = ActivityLogService(firestoreService);
    groundService = GroundService(firestoreService, activityLogService);
  });

  group('GroundService.createGround', () {
    test('writes document to grounds collection with correct fields', () async {
      final ground = makeGround(name: 'Main Ground');
      final id = await groundService.createGround(ground, 'user-1');

      final snap = await fakeFirestore.collection('grounds').doc(id).get();
      final data = snap.data()!;

      expect(snap.exists, isTrue);
      expect(data['name'], equals('Main Ground'));
      expect(data['location'], equals('Dar es Salaam'));
      expect(data['numberOfUnits'], equals(5));
      expect(data['updatedBy'], equals('user-1'));
    });

    test('returns a non-empty document ID', () async {
      final id = await groundService.createGround(makeGround(), 'user-1');
      expect(id, isNotEmpty);
    });

    test('logs activity after create', () async {
      await groundService.createGround(makeGround(name: 'Log Test'), 'user-1');

      final logs = await fakeFirestore.collection('activity_logs').get();
      expect(logs.docs.length, equals(1));

      final log = logs.docs.first.data();
      expect(log['module'], equals('grounds'));
      expect(log['action'], equals('create'));
    });
  });
}
