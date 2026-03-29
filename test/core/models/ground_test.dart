import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/models/ground.dart';

void main() {
  final now = DateTime(2026, 3, 25, 10, 0, 0);

  group('Ground', () {
    test('creates with all required fields', () {
      final ground = Ground(
        id: 'ground-1',
        name: 'Mwanakwerekwe Ground',
        location: 'Mwanakwerekwe, Zanzibar',
        numberOfUnits: 8,
        createdAt: now,
        updatedAt: now,
        updatedBy: 'user-1',
      );

      expect(ground.id, 'ground-1');
      expect(ground.name, 'Mwanakwerekwe Ground');
      expect(ground.location, 'Mwanakwerekwe, Zanzibar');
      expect(ground.numberOfUnits, 8);
      expect(ground.createdAt, now);
      expect(ground.updatedAt, now);
      expect(ground.updatedBy, 'user-1');
    });

    test('schemaVersion defaults to 1', () {
      final ground = Ground(
        id: 'g1',
        name: 'Test',
        location: 'Somewhere',
        numberOfUnits: 4,
        createdAt: now,
        updatedAt: now,
        updatedBy: 'system',
      );

      expect(ground.schemaVersion, 1);
    });

    test('fromJson creates Ground from Map', () {
      final json = {
        'id': 'ground-2',
        'name': 'Stone Town Ground',
        'location': 'Stone Town',
        'numberOfUnits': 7,
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
        'updatedBy': 'user-1',
        'schemaVersion': 1,
      };

      final ground = Ground.fromJson(json);

      expect(ground.id, 'ground-2');
      expect(ground.name, 'Stone Town Ground');
      expect(ground.numberOfUnits, 7);
      expect(ground.schemaVersion, 1);
    });

    test('toJson produces correct Map', () {
      final ground = Ground(
        id: 'ground-3',
        name: 'Output Ground',
        location: 'Somewhere',
        numberOfUnits: 10,
        createdAt: now,
        updatedAt: now,
        updatedBy: 'system',
      );

      final json = ground.toJson();

      expect(json['id'], 'ground-3');
      expect(json['name'], 'Output Ground');
      expect(json['numberOfUnits'], 10);
    });

    test('fromJson/toJson round-trip preserves all fields', () {
      final original = Ground(
        id: 'rt-1',
        name: 'Round Trip Ground',
        location: 'RT Location',
        numberOfUnits: 5,
        createdAt: now,
        updatedAt: now,
        updatedBy: 'user-1',
      );

      final restored = Ground.fromJson(original.toJson());

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.location, original.location);
      expect(restored.numberOfUnits, original.numberOfUnits);
      expect(restored.schemaVersion, original.schemaVersion);
    });
  });
}
