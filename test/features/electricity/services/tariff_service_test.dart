import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/models/app_config.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/electricity/services/tariff_service.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

const _userId = 'user-1';
const _collection = 'app_config';
const _docId = TariffService.configDocId;

Future<TariffService> _makeService({
  FakeFirebaseFirestore? fakeFirestore,
}) async {
  final fb = fakeFirestore ?? FakeFirebaseFirestore();
  final firestoreService = FirestoreService(firestore: fb);
  final activityLog = ActivityLogService(firestoreService);
  return TariffService(firestoreService, activityLog);
}

List<TanescoTier> _sampleTiers() => const [
  TanescoTier(minUnits: 0, maxUnits: 75, ratePerUnit: 100),
  TanescoTier(minUnits: 76, maxUnits: 200, ratePerUnit: 292),
  TanescoTier(minUnits: 201, maxUnits: double.infinity, ratePerUnit: 356),
];

void main() {
  // ── getDefaultTariffs ────────────────────────────────────────────────────

  group('getDefaultTariffs', () {
    test('returns 3 tiers', () async {
      final service = await _makeService();
      final tiers = service.getDefaultTariffs();
      expect(tiers.length, 3);
    });

    test('first tier starts at 0 with rate 100', () async {
      final service = await _makeService();
      final tiers = service.getDefaultTariffs();
      expect(tiers.first.minUnits, 0);
      expect(tiers.first.ratePerUnit, 100);
    });

    test('last tier has double.infinity maxUnits', () async {
      final service = await _makeService();
      final tiers = service.getDefaultTariffs();
      expect(tiers.last.maxUnits, double.infinity);
    });
  });

  // ── calculateCostWithTiers ───────────────────────────────────────────────

  group('calculateCostWithTiers', () {
    test('returns 0 for 0 units', () async {
      final service = await _makeService();
      final cost = service.calculateCostWithTiers(
        unitsConsumed: 0,
        tiers: _sampleTiers(),
      );
      expect(cost, 0.0);
    });

    test('single-tier: 50 units at 100/u = 5,000', () async {
      final service = await _makeService();
      final tiers = const [
        TanescoTier(minUnits: 0, maxUnits: double.infinity, ratePerUnit: 100),
      ];
      final cost = service.calculateCostWithTiers(
        unitsConsumed: 50,
        tiers: tiers,
      );
      expect(cost, 5000.0);
    });

    test('tier transition: 150 units with default tiers = 29,400', () async {
      final service = await _makeService();
      // Tier 1: 75 × 100 = 7,500
      // Tier 2: 75 × 292 = 21,900
      // Total = 29,400
      final cost = service.calculateCostWithTiers(
        unitsConsumed: 150,
        tiers: _sampleTiers(),
      );
      expect(cost, 29400.0);
    });

    test('units exceeding top tier boundary uses top tier rate', () async {
      final service = await _makeService();
      // Tier 1: 75 × 100 = 7,500
      // Tier 2: 125 × 292 = 36,500
      // Tier 3: 100 × 356 = 35,600
      // Total = 79,600
      final cost = service.calculateCostWithTiers(
        unitsConsumed: 300,
        tiers: _sampleTiers(),
      );
      expect(cost, 79600.0);
    });

    test('exactly at tier boundary uses correct tiers', () async {
      final service = await _makeService();
      // Exactly 75 units: all in tier 1 → 75 × 100 = 7,500
      final cost = service.calculateCostWithTiers(
        unitsConsumed: 75,
        tiers: _sampleTiers(),
      );
      expect(cost, 7500.0);
    });
  });

  // ── updateTariffs ────────────────────────────────────────────────────────

  group('updateTariffs', () {
    test('logs action to activity_logs', () async {
      final fb = FakeFirebaseFirestore();
      final service = await _makeService(fakeFirestore: fb);

      await service.updateTariffs(tiers: _sampleTiers(), userId: _userId);

      final logs = await fb.collection('activity_logs').get();
      expect(logs.docs.length, 1);
      expect(logs.docs.first.data()['module'], 'electricity');
      expect(logs.docs.first.data()['action'], 'update');
    });

    test('writes tiers to Firestore under app_config/tanesco_config', () async {
      final fb = FakeFirebaseFirestore();
      final service = await _makeService(fakeFirestore: fb);

      await service.updateTariffs(tiers: _sampleTiers(), userId: _userId);

      final snap = await fb.collection(_collection).doc(_docId).get();
      expect(snap.exists, isTrue);
      final tiers = snap.data()!['tiers'] as List;
      expect(tiers.length, 3);
      expect(tiers.first['ratePerUnit'], 100.0);
    });

    test('serialises top tier maxUnits as null', () async {
      final fb = FakeFirebaseFirestore();
      final service = await _makeService(fakeFirestore: fb);

      await service.updateTariffs(tiers: _sampleTiers(), userId: _userId);

      final snap = await fb.collection(_collection).doc(_docId).get();
      final tiers = snap.data()!['tiers'] as List;
      expect(tiers.last['maxUnits'], isNull);
    });
  });

  // ── getCurrentTariffs / round-trip ───────────────────────────────────────

  group('getCurrentTariffs', () {
    test('returns empty list when no config exists', () async {
      final service = await _makeService();
      final tiers = await service.getCurrentTariffs();
      expect(tiers, isEmpty);
    });

    test('round-trip: save then load preserves tier values', () async {
      final fb = FakeFirebaseFirestore();
      final service = await _makeService(fakeFirestore: fb);
      final original = _sampleTiers();

      await service.updateTariffs(tiers: original, userId: _userId);
      final loaded = await service.getCurrentTariffs();

      expect(loaded.length, original.length);
      expect(loaded.first.ratePerUnit, original.first.ratePerUnit);
      expect(loaded.last.maxUnits, double.infinity);
    });
  });
}
