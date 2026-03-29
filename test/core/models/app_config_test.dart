import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/models/app_config.dart';

void main() {
  final now = DateTime(2026, 3, 25, 10, 0, 0);

  group('AppConfig', () {
    test('tanescoTiers defaults to empty list', () {
      final config = AppConfig(
        id: 'config-1',
        updatedAt: now,
        updatedBy: 'system',
      );

      expect(config.tanescoTiers, isEmpty);
    });

    test('defaultWaterContribution defaults to 0', () {
      final config = AppConfig(
        id: 'config-1',
        updatedAt: now,
        updatedBy: 'system',
      );

      expect(config.defaultWaterContribution, 0.0);
    });

    test('schemaVersion defaults to 1', () {
      final config = AppConfig(
        id: 'config-1',
        updatedAt: now,
        updatedBy: 'system',
      );

      expect(config.schemaVersion, 1);
    });

    test('creates with TanescoTier objects', () {
      final tiers = [
        const TanescoTier(minUnits: 0, maxUnits: 50, ratePerUnit: 100),
        const TanescoTier(minUnits: 51, maxUnits: 200, ratePerUnit: 150),
      ];

      final config = AppConfig(
        id: 'config-2',
        tanescoTiers: tiers,
        defaultWaterContribution: 5000.0,
        updatedAt: now,
        updatedBy: 'user-1',
      );

      expect(config.tanescoTiers.length, 2);
      expect(config.tanescoTiers[0].ratePerUnit, 100);
      expect(config.tanescoTiers[1].ratePerUnit, 150);
      expect(config.defaultWaterContribution, 5000.0);
    });

    test('fromJson/toJson round-trip with nested TanescoTier list', () {
      final original = AppConfig(
        id: 'rt-config',
        tanescoTiers: [
          const TanescoTier(minUnits: 0, maxUnits: 50, ratePerUnit: 100),
          const TanescoTier(minUnits: 51, maxUnits: 200, ratePerUnit: 150),
          const TanescoTier(
            minUnits: 201,
            maxUnits: double.infinity,
            ratePerUnit: 250,
          ),
        ],
        defaultWaterContribution: 3000.0,
        updatedAt: now,
        updatedBy: 'system',
      );

      final restored = AppConfig.fromJson(original.toJson());

      expect(restored.id, original.id);
      expect(restored.tanescoTiers.length, 3);
      expect(restored.tanescoTiers[0].minUnits, 0);
      expect(restored.tanescoTiers[2].ratePerUnit, 250);
      expect(restored.defaultWaterContribution, 3000.0);
      expect(restored.schemaVersion, original.schemaVersion);
    });
  });

  group('TanescoTier', () {
    test('creates with required fields', () {
      const tier = TanescoTier(minUnits: 0, maxUnits: 50, ratePerUnit: 100.5);

      expect(tier.minUnits, 0);
      expect(tier.maxUnits, 50);
      expect(tier.ratePerUnit, 100.5);
    });

    test('fromJson/toJson round-trip', () {
      const original = TanescoTier(
        minUnits: 51,
        maxUnits: 200,
        ratePerUnit: 175.0,
      );

      final restored = TanescoTier.fromJson(original.toJson());

      expect(restored.minUnits, original.minUnits);
      expect(restored.maxUnits, original.maxUnits);
      expect(restored.ratePerUnit, original.ratePerUnit);
    });
  });
}
