import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/auth_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/auth/services/first_time_setup_service.dart';
import 'package:hms/features/auth/services/user_service.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class _FakeAuthService extends AuthService {
  _FakeAuthService({
    Future<User> Function(String email, String password)? onCreate,
  }) : _onCreate = onCreate,
       super(auth: MockFirebaseAuth());

  final Future<User> Function(String email, String password)? _onCreate;
  bool updateDisplayNameCalled = false;

  @override
  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (_onCreate != null) return _onCreate(email, password);
    throw UnsupportedError('No onCreate configured');
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    updateDisplayNameCalled = true;
  }
}

class _FakeUserService extends UserService {
  _FakeUserService(super.firestore, super.activityLog);

  String? capturedRole;
  String? capturedUserId;
  bool superAdminExistsResult = false;

  @override
  Future<bool> superAdminExists() async => superAdminExistsResult;

  @override
  Future<void> createUserProfile({
    required String userId,
    required String email,
    required String displayName,
    required String role,
    required String createdBy,
  }) async {
    capturedUserId = userId;
    capturedRole = role;
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late ActivityLogService activityLogService;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
    activityLogService = ActivityLogService(firestoreService);
  });

  // ---------------------------------------------------------------------------
  // isFirstTimeSetup
  // ---------------------------------------------------------------------------

  group('FirstTimeSetupService.isFirstTimeSetup', () {
    test('returns true when no Super Admin exists', () async {
      final fakeUserService = _FakeUserService(
        firestoreService,
        activityLogService,
      )..superAdminExistsResult = false;

      final setupService = FirstTimeSetupService(
        _FakeAuthService(),
        fakeUserService,
      );

      expect(await setupService.isFirstTimeSetup(), isTrue);
    });

    test('returns false when a Super Admin already exists', () async {
      final fakeUserService = _FakeUserService(
        firestoreService,
        activityLogService,
      )..superAdminExistsResult = true;

      final setupService = FirstTimeSetupService(
        _FakeAuthService(),
        fakeUserService,
      );

      expect(await setupService.isFirstTimeSetup(), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // createSuperAdmin
  // ---------------------------------------------------------------------------

  group('FirstTimeSetupService.createSuperAdmin', () {
    test('calls authService.createUserWithEmailAndPassword', () async {
      bool createCalled = false;
      final fakeAuth = _FakeAuthService(
        onCreate: (email, password) async {
          createCalled = true;
          return MockUser(uid: 'super-uid', email: email);
        },
      );
      final fakeUserService = _FakeUserService(
        firestoreService,
        activityLogService,
      );

      await FirstTimeSetupService(fakeAuth, fakeUserService).createSuperAdmin(
        email: 'boss@home.com',
        password: 'securepassword',
        displayName: 'Boss',
      );

      expect(createCalled, isTrue);
    });

    test('calls authService.updateDisplayName', () async {
      final fakeAuth = _FakeAuthService(
        onCreate: (email, password) async =>
            MockUser(uid: 'super-uid', email: email),
      );
      final fakeUserService = _FakeUserService(
        firestoreService,
        activityLogService,
      );

      await FirstTimeSetupService(fakeAuth, fakeUserService).createSuperAdmin(
        email: 'boss@home.com',
        password: 'securepassword',
        displayName: 'Boss',
      );

      expect(fakeAuth.updateDisplayNameCalled, isTrue);
    });

    test('calls userService.createUserProfile with role superAdmin', () async {
      final fakeAuth = _FakeAuthService(
        onCreate: (email, password) async =>
            MockUser(uid: 'super-uid', email: email),
      );
      final fakeUserService = _FakeUserService(
        firestoreService,
        activityLogService,
      );

      await FirstTimeSetupService(fakeAuth, fakeUserService).createSuperAdmin(
        email: 'boss@home.com',
        password: 'securepassword',
        displayName: 'Boss',
      );

      expect(fakeUserService.capturedRole, 'superAdmin');
      expect(fakeUserService.capturedUserId, 'super-uid');
    });
  });
}
