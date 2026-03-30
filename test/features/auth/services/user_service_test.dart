import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/auth/services/user_service.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late ActivityLogService activityLogService;
  late UserService service;

  const adminId = 'super-admin-uid';
  const userId = 'user-uid-123';

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
    activityLogService = ActivityLogService(firestoreService);
    service = UserService(firestoreService, activityLogService);
  });

  // ---------------------------------------------------------------------------
  // createUserProfile
  // ---------------------------------------------------------------------------

  group('UserService.createUserProfile', () {
    test('writes to the users collection', () async {
      await service.createUserProfile(
        userId: userId,
        email: 'member@home.com',
        displayName: 'Jane Doe',
        role: 'admin',
        createdBy: adminId,
      );

      final snap = await fakeFirestore.collection('users').get();
      expect(snap.docs.length, 1);
    });

    test('uses userId as document ID — not auto-generated', () async {
      await service.createUserProfile(
        userId: userId,
        email: 'member@home.com',
        displayName: 'Jane Doe',
        role: 'admin',
        createdBy: adminId,
      );

      final doc = await fakeFirestore.collection('users').doc(userId).get();
      expect(doc.exists, isTrue);
      expect(doc.id, userId);
    });

    test('stores all required fields', () async {
      await service.createUserProfile(
        userId: userId,
        email: 'member@home.com',
        displayName: 'Jane Doe',
        role: 'admin',
        createdBy: adminId,
      );

      final doc = await fakeFirestore.collection('users').doc(userId).get();
      final data = doc.data()!;
      expect(data['email'], 'member@home.com');
      expect(data['displayName'], 'Jane Doe');
      expect(data['role'], 'admin');
    });

    test('logs the action to activity_logs', () async {
      await service.createUserProfile(
        userId: userId,
        email: 'member@home.com',
        displayName: 'Jane Doe',
        role: 'admin',
        createdBy: adminId,
      );

      final logs = await fakeFirestore.collection('activity_logs').get();
      expect(logs.docs.length, 1);
      final logData = logs.docs.first.data();
      expect(logData['action'], 'created');
      expect(logData['module'], 'auth');
    });
  });

  // ---------------------------------------------------------------------------
  // getUserProfile
  // ---------------------------------------------------------------------------

  group('UserService.getUserProfile', () {
    test('returns AppUser when document exists', () async {
      await service.createUserProfile(
        userId: userId,
        email: 'member@home.com',
        displayName: 'Jane Doe',
        role: 'admin',
        createdBy: adminId,
      );

      final user = await service.getUserProfile(userId);
      expect(user, isNotNull);
      expect(user!.id, userId);
      expect(user.email, 'member@home.com');
      expect(user.displayName, 'Jane Doe');
      expect(user.role, 'admin');
    });

    test('returns null when document does not exist', () async {
      final user = await service.getUserProfile('nonexistent-uid');
      expect(user, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // updateUserRole
  // ---------------------------------------------------------------------------

  group('UserService.updateUserRole', () {
    setUp(() async {
      await service.createUserProfile(
        userId: userId,
        email: 'member@home.com',
        displayName: 'Jane Doe',
        role: 'admin',
        createdBy: adminId,
      );
    });

    test('updates the role field in Firestore', () async {
      await service.updateUserRole(
        userId: userId,
        newRole: 'superAdmin',
        updatedBy: adminId,
      );

      final doc = await fakeFirestore.collection('users').doc(userId).get();
      expect(doc.data()!['role'], 'superAdmin');
    });

    test('logs the action via ActivityLogService', () async {
      // Clear logs from createUserProfile (1 log already there)
      await service.updateUserRole(
        userId: userId,
        newRole: 'superAdmin',
        updatedBy: adminId,
      );

      final logs = await fakeFirestore.collection('activity_logs').get();
      // 1 from create + 1 from update
      expect(logs.docs.length, 2);
      final updateLog = logs.docs.firstWhere(
        (d) => d.data()['action'] == 'updated',
      );
      expect(updateLog.data()['module'], 'auth');
    });
  });

  // ---------------------------------------------------------------------------
  // deleteUserProfile
  // ---------------------------------------------------------------------------

  group('UserService.deleteUserProfile', () {
    setUp(() async {
      await service.createUserProfile(
        userId: userId,
        email: 'member@home.com',
        displayName: 'Jane Doe',
        role: 'admin',
        createdBy: adminId,
      );
    });

    test('removes the document from Firestore', () async {
      await service.deleteUserProfile(userId: userId, deletedBy: adminId);

      final doc = await fakeFirestore.collection('users').doc(userId).get();
      expect(doc.exists, isFalse);
    });

    test('logs the deletion action before deleting', () async {
      await service.deleteUserProfile(userId: userId, deletedBy: adminId);

      final logs = await fakeFirestore.collection('activity_logs').get();
      final deleteLog = logs.docs.firstWhere(
        (d) => d.data()['action'] == 'deleted',
      );
      expect(deleteLog.data()['module'], 'auth');
      expect(deleteLog.data()['documentId'], userId);
    });
  });

  // ---------------------------------------------------------------------------
  // isSuperAdmin
  // ---------------------------------------------------------------------------

  group('UserService.isSuperAdmin', () {
    test('returns true when user has superAdmin role', () async {
      await service.createUserProfile(
        userId: userId,
        email: 'boss@home.com',
        displayName: 'Boss',
        role: 'superAdmin',
        createdBy: userId,
      );

      expect(await service.isSuperAdmin(userId), isTrue);
    });

    test('returns false when user has admin role', () async {
      await service.createUserProfile(
        userId: userId,
        email: 'member@home.com',
        displayName: 'Member',
        role: 'admin',
        createdBy: adminId,
      );

      expect(await service.isSuperAdmin(userId), isFalse);
    });

    test('returns false when user does not exist', () async {
      expect(await service.isSuperAdmin('nonexistent'), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // superAdminExists
  // ---------------------------------------------------------------------------

  group('UserService.superAdminExists', () {
    test('returns false when no users exist', () async {
      expect(await service.superAdminExists(), isFalse);
    });

    test('returns false when only admin users exist', () async {
      await service.createUserProfile(
        userId: userId,
        email: 'member@home.com',
        displayName: 'Member',
        role: 'admin',
        createdBy: adminId,
      );

      expect(await service.superAdminExists(), isFalse);
    });

    test('returns true when a superAdmin user exists', () async {
      await service.createUserProfile(
        userId: adminId,
        email: 'boss@home.com',
        displayName: 'Boss',
        role: 'superAdmin',
        createdBy: adminId,
      );

      expect(await service.superAdminExists(), isTrue);
    });
  });
}
