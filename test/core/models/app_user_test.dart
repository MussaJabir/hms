import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/models/app_user.dart';

void main() {
  final now = DateTime(2026, 3, 25, 10, 0, 0);

  group('AppUser', () {
    test('creates with all required fields', () {
      final user = AppUser(
        id: 'user-1',
        email: 'admin@hms.com',
        displayName: 'Dutch',
        role: 'superAdmin',
        createdAt: now,
        updatedAt: now,
        updatedBy: 'system',
      );

      expect(user.id, 'user-1');
      expect(user.email, 'admin@hms.com');
      expect(user.displayName, 'Dutch');
      expect(user.role, 'superAdmin');
      expect(user.createdAt, now);
      expect(user.updatedAt, now);
      expect(user.updatedBy, 'system');
    });

    test('schemaVersion defaults to 1', () {
      final user = AppUser(
        id: 'u1',
        email: 'a@b.com',
        displayName: 'A',
        role: 'admin',
        createdAt: now,
        updatedAt: now,
        updatedBy: 'system',
      );

      expect(user.schemaVersion, 1);
    });

    test('isSuperAdmin returns true when role is superAdmin', () {
      final user = AppUser(
        id: 'u1',
        email: 'a@b.com',
        displayName: 'A',
        role: 'superAdmin',
        createdAt: now,
        updatedAt: now,
        updatedBy: 'system',
      );

      expect(user.isSuperAdmin, isTrue);
      expect(user.isAdmin, isFalse);
    });

    test('isAdmin returns true when role is admin', () {
      final user = AppUser(
        id: 'u1',
        email: 'a@b.com',
        displayName: 'A',
        role: 'admin',
        createdAt: now,
        updatedAt: now,
        updatedBy: 'system',
      );

      expect(user.isAdmin, isTrue);
      expect(user.isSuperAdmin, isFalse);
    });

    test('fromJson creates AppUser from Map', () {
      final json = {
        'id': 'user-2',
        'email': 'test@hms.com',
        'displayName': 'Tester',
        'role': 'admin',
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
        'updatedBy': 'user-1',
        'schemaVersion': 1,
      };

      final user = AppUser.fromJson(json);

      expect(user.id, 'user-2');
      expect(user.email, 'test@hms.com');
      expect(user.displayName, 'Tester');
      expect(user.role, 'admin');
      expect(user.updatedBy, 'user-1');
      expect(user.schemaVersion, 1);
    });

    test('toJson produces correct Map', () {
      final user = AppUser(
        id: 'user-3',
        email: 'out@hms.com',
        displayName: 'Output',
        role: 'superAdmin',
        createdAt: now,
        updatedAt: now,
        updatedBy: 'system',
        schemaVersion: 2,
      );

      final json = user.toJson();

      expect(json['id'], 'user-3');
      expect(json['email'], 'out@hms.com');
      expect(json['displayName'], 'Output');
      expect(json['role'], 'superAdmin');
      expect(json['schemaVersion'], 2);
    });

    test('fromJson/toJson round-trip preserves all fields', () {
      final original = AppUser(
        id: 'rt-1',
        email: 'rt@hms.com',
        displayName: 'RoundTrip',
        role: 'admin',
        createdAt: now,
        updatedAt: now,
        updatedBy: 'system',
      );

      final restored = AppUser.fromJson(original.toJson());

      expect(restored.id, original.id);
      expect(restored.email, original.email);
      expect(restored.role, original.role);
      expect(restored.schemaVersion, original.schemaVersion);
    });
  });
}
