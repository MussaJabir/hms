import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/auth_exception.dart';
import 'package:hms/core/services/auth_service.dart';
import 'package:mock_exceptions/mock_exceptions.dart';

void main() {
  late MockFirebaseAuth mockAuth;
  late AuthService service;

  const testEmail = 'test@example.com';
  const testPassword = 'password123';

  setUp(() {
    mockAuth = MockFirebaseAuth(
      mockUser: MockUser(uid: 'test-uid', email: testEmail),
    );
    service = AuthService(auth: mockAuth);
  });

  group('AuthService.signInWithEmailAndPassword', () {
    test('returns User on success', () async {
      final user = await service.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      );
      expect(user.uid, equals('test-uid'));
      expect(user.email, equals(testEmail));
    });

    test(
      'throws AuthException with friendly message on user-not-found',
      () async {
        whenCalling(
          Invocation.method(#signInWithEmailAndPassword, [], {
            #email: testEmail,
            #password: testPassword,
          }),
        ).on(mockAuth).thenThrow(FirebaseAuthException(code: 'user-not-found'));

        expect(
          () => service.signInWithEmailAndPassword(
            email: testEmail,
            password: testPassword,
          ),
          throwsA(
            isA<AuthException>().having(
              (e) => e.message,
              'message',
              'No account found with this email',
            ),
          ),
        );
      },
    );

    test(
      'throws AuthException with friendly message on wrong-password',
      () async {
        whenCalling(
          Invocation.method(#signInWithEmailAndPassword, [], {
            #email: testEmail,
            #password: testPassword,
          }),
        ).on(mockAuth).thenThrow(FirebaseAuthException(code: 'wrong-password'));

        expect(
          () => service.signInWithEmailAndPassword(
            email: testEmail,
            password: testPassword,
          ),
          throwsA(
            isA<AuthException>().having(
              (e) => e.message,
              'message',
              'Incorrect password',
            ),
          ),
        );
      },
    );

    test(
      'throws AuthException with friendly message on network-request-failed',
      () async {
        whenCalling(
              Invocation.method(#signInWithEmailAndPassword, [], {
                #email: testEmail,
                #password: testPassword,
              }),
            )
            .on(mockAuth)
            .thenThrow(FirebaseAuthException(code: 'network-request-failed'));

        expect(
          () => service.signInWithEmailAndPassword(
            email: testEmail,
            password: testPassword,
          ),
          throwsA(
            isA<AuthException>().having(
              (e) => e.message,
              'message',
              'No internet connection. Please check your network',
            ),
          ),
        );
      },
    );
  });

  group('AuthService.signOut', () {
    test('signs out the current user', () async {
      // Sign in first
      await mockAuth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      );
      expect(mockAuth.currentUser, isNotNull);

      await service.signOut();

      expect(mockAuth.currentUser, isNull);
    });
  });

  group('AuthService.currentUser', () {
    test('returns null when not signed in', () {
      expect(service.currentUser, isNull);
    });

    test('returns User when signed in', () async {
      await mockAuth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      );
      expect(service.currentUser, isNotNull);
      expect(service.currentUser!.email, equals(testEmail));
    });
  });

  group('AuthService.currentUserId', () {
    test('returns null when not signed in', () {
      expect(service.currentUserId, isNull);
    });

    test('returns uid when signed in', () async {
      await mockAuth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      );
      expect(service.currentUserId, equals('test-uid'));
    });
  });

  group('AuthService.authStateChanges', () {
    test('returns a stream', () {
      expect(service.authStateChanges(), isA<Stream<User?>>());
    });

    test('emits signed-in user after sign in', () async {
      // Collect the first non-null emission after signing in
      final future = service.authStateChanges().firstWhere(
        (user) => user != null,
      );

      await mockAuth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      );

      final user = await future;
      expect(user, isNotNull);
      expect(user!.uid, equals('test-uid'));
    });
  });
}
