import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/electricity/models/electricity_meter.dart';
import 'package:hms/features/electricity/services/meter_service.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _groundId = 'g-1';
const _unitId = 'u-1';
const _userId = 'user-1';

ElectricityMeter _meter({
  String meterNumber = 'TZ-001',
  double initialReading = 0,
  double threshold = 0,
}) {
  final now = DateTime(2026, 4, 12);
  return ElectricityMeter(
    id: '',
    groundId: _groundId,
    unitId: _unitId,
    meterNumber: meterNumber,
    initialReading: initialReading,
    weeklyThreshold: threshold,
    createdAt: now,
    updatedAt: now,
    updatedBy: _userId,
  );
}

const _meterCol = 'grounds/$_groundId/rental_units/$_unitId/meter_registry';
const _unitCol = 'grounds/$_groundId/rental_units';

/// Seeds a meter document directly into FakeFirebaseFirestore.
Future<String> _seedMeter(
  FakeFirebaseFirestore fakeFirestore, {
  required String meterNumber,
  double initialReading = 0,
  bool isActive = true,
}) async {
  final ref = fakeFirestore.collection(_meterCol).doc();
  await ref.set({
    'groundId': _groundId,
    'unitId': _unitId,
    'meterNumber': meterNumber,
    'initialReading': initialReading,
    'currentReading': initialReading,
    'weeklyThreshold': 0.0,
    'isActive': isActive,
    'createdAt': DateTime.now().toIso8601String(),
    'updatedAt': DateTime.now().toIso8601String(),
    'updatedBy': _userId,
    'schemaVersion': 1,
  });
  return ref.id;
}

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late MeterService service;

  setUp(() async {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
    service = MeterService(
      firestoreService,
      ActivityLogService(firestoreService),
    );
    // Pre-create unit doc so registerMeter can update meterId on it.
    await fakeFirestore.collection(_unitCol).doc(_unitId).set({
      'name': 'Room 1',
      'groundId': _groundId,
      'status': 'vacant',
    });
  });

  // ---------------------------------------------------------------------------
  // registerMeter
  // ---------------------------------------------------------------------------

  group('registerMeter', () {
    test('writes to correct subcollection path', () async {
      await service.registerMeter(_groundId, _unitId, _meter(), _userId);

      final snap = await fakeFirestore.collection(_meterCol).get();
      expect(snap.docs.length, 1);
      expect(snap.docs.first.data()['meterNumber'], 'TZ-001');
    });

    test('new meter has isActive = true', () async {
      await service.registerMeter(_groundId, _unitId, _meter(), _userId);

      final snap = await fakeFirestore.collection(_meterCol).get();
      expect(snap.docs.first.data()['isActive'], isTrue);
    });

    test('sets currentReading equal to initialReading', () async {
      await service.registerMeter(
        _groundId,
        _unitId,
        _meter(initialReading: 150),
        _userId,
      );

      final snap = await fakeFirestore.collection(_meterCol).get();
      expect(snap.docs.first.data()['currentReading'], 150.0);
    });

    test('syncs meterId on the unit document', () async {
      final meterId = await service.registerMeter(
        _groundId,
        _unitId,
        _meter(),
        _userId,
      );

      final unitSnap = await fakeFirestore
          .collection(_unitCol)
          .doc(_unitId)
          .get();
      expect(unitSnap.data()!['meterId'], meterId);
    });
  });

  // ---------------------------------------------------------------------------
  // replaceMeter
  // ---------------------------------------------------------------------------

  group('replaceMeter', () {
    test('marks old meter inactive', () async {
      final oldId = await _seedMeter(fakeFirestore, meterNumber: 'TZ-001');

      await service.replaceMeter(
        _groundId,
        _unitId,
        oldId,
        _meter(meterNumber: 'TZ-002'),
        _userId,
      );

      final oldSnap = await fakeFirestore
          .collection(_meterCol)
          .doc(oldId)
          .get();
      expect(oldSnap.data()!['isActive'], isFalse);
    });

    test('creates new meter with isActive = true', () async {
      final oldId = await _seedMeter(fakeFirestore, meterNumber: 'TZ-001');

      final newId = await service.replaceMeter(
        _groundId,
        _unitId,
        oldId,
        _meter(meterNumber: 'TZ-002'),
        _userId,
      );

      final newSnap = await fakeFirestore
          .collection(_meterCol)
          .doc(newId)
          .get();
      expect(newSnap.data()!['isActive'], isTrue);
      expect(newSnap.data()!['meterNumber'], 'TZ-002');
    });

    test('preserves old meter data in history', () async {
      final oldId = await _seedMeter(fakeFirestore, meterNumber: 'TZ-001');

      await service.replaceMeter(
        _groundId,
        _unitId,
        oldId,
        _meter(meterNumber: 'TZ-002'),
        _userId,
      );

      final allSnap = await fakeFirestore.collection(_meterCol).get();
      expect(allSnap.docs.length, 2);
    });
  });

  // ---------------------------------------------------------------------------
  // getActiveMeter
  // ---------------------------------------------------------------------------

  group('getActiveMeter', () {
    test('returns null when no meters registered', () async {
      final result = await service.getActiveMeter(_groundId, _unitId);
      expect(result, isNull);
    });

    test('filters by isActive = true and returns active meter', () async {
      final oldId = await _seedMeter(
        fakeFirestore,
        meterNumber: 'TZ-001',
        isActive: true,
      );

      await service.replaceMeter(
        _groundId,
        _unitId,
        oldId,
        _meter(meterNumber: 'TZ-002'),
        _userId,
      );

      final active = await service.getActiveMeter(_groundId, _unitId);
      expect(active, isNotNull);
      expect(active!.meterNumber, 'TZ-002');
      expect(active.isActive, isTrue);
    });
  });
}
