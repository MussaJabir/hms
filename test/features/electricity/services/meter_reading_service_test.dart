import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/electricity/services/meter_reading_service.dart';
import 'package:hms/features/electricity/services/meter_service.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _groundId = 'g-1';
const _unitId = 'u-1';
const _meterId = 'm-1';
const _userId = 'user-1';
const _meterCol = 'grounds/$_groundId/rental_units/$_unitId/meter_registry';
const _unitCol = 'grounds/$_groundId/rental_units';
const _readingCol = 'grounds/$_groundId/rental_units/$_unitId/meter_readings';

Future<void> _seedMeter(
  FakeFirebaseFirestore fakeFirestore, {
  double initialReading = 0,
  double currentReading = 0,
}) async {
  await fakeFirestore.collection(_meterCol).doc(_meterId).set({
    'groundId': _groundId,
    'unitId': _unitId,
    'meterNumber': 'TZ-001',
    'initialReading': initialReading,
    'currentReading': currentReading,
    'weeklyThreshold': 0.0,
    'isActive': true,
    'createdAt': DateTime(2026, 4, 1).toIso8601String(),
    'updatedAt': DateTime(2026, 4, 1).toIso8601String(),
    'updatedBy': _userId,
    'schemaVersion': 1,
  });
  await fakeFirestore.collection(_unitCol).doc(_unitId).set({
    'name': 'Room 1',
    'groundId': _groundId,
    'status': 'occupied',
    'meterId': _meterId,
  });
}

Future<void> _seedReading(
  FakeFirebaseFirestore fakeFirestore, {
  required double reading,
  DateTime? readingDate,
}) async {
  await fakeFirestore.collection(_readingCol).add({
    'groundId': _groundId,
    'unitId': _unitId,
    'meterId': _meterId,
    'reading': reading,
    'previousReading': 0.0,
    'unitsConsumed': reading,
    'readingDate': (readingDate ?? DateTime(2026, 4, 10)).toIso8601String(),
    'isMeterReset': false,
    'notes': '',
    'createdAt': (readingDate ?? DateTime(2026, 4, 10)).toIso8601String(),
    'updatedAt': (readingDate ?? DateTime(2026, 4, 10)).toIso8601String(),
    'updatedBy': _userId,
    'schemaVersion': 1,
  });
}

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late MeterService meterService;
  late MeterReadingService service;

  setUp(() async {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
    final activityLog = ActivityLogService(firestoreService);
    meterService = MeterService(firestoreService, activityLog);
    service = MeterReadingService(firestoreService, meterService, activityLog);
    await _seedMeter(fakeFirestore, initialReading: 1000, currentReading: 1000);
  });

  // ---------------------------------------------------------------------------
  // recordReading
  // ---------------------------------------------------------------------------

  group('recordReading', () {
    test('calculates unitsConsumed correctly', () async {
      await service.recordReading(
        groundId: _groundId,
        unitId: _unitId,
        meterId: _meterId,
        newReading: 1150,
        readingDate: DateTime(2026, 4, 12),
        confirmReset: false,
        userId: _userId,
      );

      final snap = await fakeFirestore.collection(_readingCol).get();
      expect(snap.docs.length, 1);
      expect(snap.docs.first.data()['unitsConsumed'], 150.0);
      expect(snap.docs.first.data()['previousReading'], 1000.0);
    });

    test('uses meter.initialReading when no previous readings exist', () async {
      await service.recordReading(
        groundId: _groundId,
        unitId: _unitId,
        meterId: _meterId,
        newReading: 1050,
        readingDate: DateTime(2026, 4, 12),
        confirmReset: false,
        userId: _userId,
      );

      final snap = await fakeFirestore.collection(_readingCol).get();
      expect(snap.docs.first.data()['previousReading'], 1000.0);
      expect(snap.docs.first.data()['unitsConsumed'], 50.0);
    });

    test(
      'throws MeterResetRequiredException when current < previous and confirmReset=false',
      () async {
        await _seedReading(fakeFirestore, reading: 1200);

        expect(
          () => service.recordReading(
            groundId: _groundId,
            unitId: _unitId,
            meterId: _meterId,
            newReading: 500,
            readingDate: DateTime(2026, 4, 12),
            confirmReset: false,
            userId: _userId,
          ),
          throwsA(isA<MeterResetRequiredException>()),
        );
      },
    );

    test('records with isMeterReset=true when confirmReset=true', () async {
      await _seedReading(fakeFirestore, reading: 1200);

      await service.recordReading(
        groundId: _groundId,
        unitId: _unitId,
        meterId: _meterId,
        newReading: 50,
        readingDate: DateTime(2026, 4, 12),
        confirmReset: true,
        userId: _userId,
      );

      final snap = await fakeFirestore.collection(_readingCol).get();
      final resetDoc = snap.docs.firstWhere(
        (d) => d.data()['isMeterReset'] == true,
      );
      expect(resetDoc.data()['isMeterReset'], isTrue);
      // On reset, unitsConsumed = newReading
      expect(resetDoc.data()['unitsConsumed'], 50.0);
    });

    test('updates meter currentReading and lastReadingDate', () async {
      await service.recordReading(
        groundId: _groundId,
        unitId: _unitId,
        meterId: _meterId,
        newReading: 1300,
        readingDate: DateTime(2026, 4, 12),
        confirmReset: false,
        userId: _userId,
      );

      final meterSnap = await fakeFirestore
          .collection(_meterCol)
          .doc(_meterId)
          .get();
      expect(meterSnap.data()!['currentReading'], 1300.0);
      expect(
        meterSnap.data()!['lastReadingDate'],
        DateTime(2026, 4, 12).toIso8601String(),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // getTotalConsumption
  // ---------------------------------------------------------------------------

  group('getTotalConsumption', () {
    test('sums unitsConsumed within date range', () async {
      await _seedReading(
        fakeFirestore,
        reading: 100,
        readingDate: DateTime(2026, 4, 5),
      );
      await _seedReading(
        fakeFirestore,
        reading: 200,
        readingDate: DateTime(2026, 4, 10),
      );
      await _seedReading(
        fakeFirestore,
        reading: 50,
        readingDate: DateTime(2026, 3, 15), // outside range
      );

      final total = await service.getTotalConsumption(
        groundId: _groundId,
        unitId: _unitId,
        meterId: _meterId,
        start: DateTime(2026, 4, 1),
        end: DateTime(2026, 4, 30),
      );

      // 100 + 200 = 300 (the March one is excluded)
      expect(total, 300.0);
    });

    test('returns 0 when no readings in range', () async {
      final total = await service.getTotalConsumption(
        groundId: _groundId,
        unitId: _unitId,
        meterId: _meterId,
        start: DateTime(2026, 4, 1),
        end: DateTime(2026, 4, 30),
      );
      expect(total, 0.0);
    });
  });
}
