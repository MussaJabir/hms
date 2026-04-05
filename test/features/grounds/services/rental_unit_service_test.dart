import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/grounds/models/rental_unit.dart';
import 'package:hms/features/grounds/services/rental_unit_service.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late ActivityLogService activityLogService;
  late RentalUnitService rentalUnitService;

  const groundId = 'ground-1';
  final now = DateTime(2026, 4, 5);

  RentalUnit makeUnit({String status = 'vacant', String name = 'Room 1'}) =>
      RentalUnit(
        id: '',
        groundId: groundId,
        name: name,
        rentAmount: 200000,
        status: status,
        createdAt: now,
        updatedAt: now,
        updatedBy: 'user-1',
      );

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
    activityLogService = ActivityLogService(firestoreService);
    rentalUnitService = RentalUnitService(firestoreService, activityLogService);
  });

  group('RentalUnitService.createUnit', () {
    test('writes to the correct subcollection path', () async {
      await rentalUnitService.createUnit(groundId, makeUnit(), 'user-1');

      final snap = await fakeFirestore
          .collection('grounds/$groundId/rental_units')
          .get();

      expect(snap.docs.length, equals(1));
      expect(snap.docs.first.data()['name'], equals('Room 1'));
    });

    test('stores all required fields', () async {
      final id = await rentalUnitService.createUnit(
        groundId,
        makeUnit(status: 'occupied', name: 'Shop A'),
        'user-1',
      );

      final snap = await fakeFirestore
          .collection('grounds/$groundId/rental_units')
          .doc(id)
          .get();
      final data = snap.data()!;

      expect(data['name'], equals('Shop A'));
      expect(data['rentAmount'], equals(200000.0));
      expect(data['status'], equals('occupied'));
      expect(data['updatedBy'], equals('user-1'));
    });

    test('logs activity after create', () async {
      await rentalUnitService.createUnit(groundId, makeUnit(), 'user-1');

      final logs = await fakeFirestore.collection('activity_logs').get();
      expect(logs.docs.length, equals(1));

      final log = logs.docs.first.data();
      expect(log['module'], equals('rental_units'));
      expect(log['action'], equals('create'));
    });
  });

  group('RentalUnitService.getVacantUnits', () {
    test('returns only vacant units', () async {
      await rentalUnitService.createUnit(
        groundId,
        makeUnit(status: 'vacant', name: 'Room 1'),
        'user-1',
      );
      await rentalUnitService.createUnit(
        groundId,
        makeUnit(status: 'occupied', name: 'Room 2'),
        'user-1',
      );
      await rentalUnitService.createUnit(
        groundId,
        makeUnit(status: 'vacant', name: 'Room 3'),
        'user-1',
      );

      final vacant = await rentalUnitService.getVacantUnits(groundId);

      expect(vacant.length, equals(2));
      expect(vacant.every((u) => u.isVacant), isTrue);
    });

    test('returns empty list when all units are occupied', () async {
      await rentalUnitService.createUnit(
        groundId,
        makeUnit(status: 'occupied'),
        'user-1',
      );

      final vacant = await rentalUnitService.getVacantUnits(groundId);
      expect(vacant, isEmpty);
    });
  });

  group('RentalUnitService.getOccupiedUnits', () {
    test('returns only occupied units', () async {
      await rentalUnitService.createUnit(
        groundId,
        makeUnit(status: 'occupied', name: 'Room 1'),
        'user-1',
      );
      await rentalUnitService.createUnit(
        groundId,
        makeUnit(status: 'vacant', name: 'Room 2'),
        'user-1',
      );

      final occupied = await rentalUnitService.getOccupiedUnits(groundId);

      expect(occupied.length, equals(1));
      expect(occupied.first.isOccupied, isTrue);
    });

    test('returns empty list when no units are occupied', () async {
      await rentalUnitService.createUnit(
        groundId,
        makeUnit(status: 'vacant'),
        'user-1',
      );

      final occupied = await rentalUnitService.getOccupiedUnits(groundId);
      expect(occupied, isEmpty);
    });
  });
}
