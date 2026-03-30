import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/router/app_router.dart';

void main() {
  // ---------------------------------------------------------------------------
  // authRedirect — pure function, no Riverpod/GoRouter setup needed
  // ---------------------------------------------------------------------------

  group('authRedirect — loading state', () {
    test('stays on /splash when already there', () {
      expect(
        authRedirect(authState: AuthState.loading, currentPath: '/splash'),
        isNull,
      );
    });

    test('redirects to /splash from any other path', () {
      expect(
        authRedirect(authState: AuthState.loading, currentPath: '/'),
        '/splash',
      );
      expect(
        authRedirect(authState: AuthState.loading, currentPath: '/login'),
        '/splash',
      );
      expect(
        authRedirect(authState: AuthState.loading, currentPath: '/setup'),
        '/splash',
      );
    });
  });

  group('authRedirect — unauthenticated state', () {
    test('redirects to /login from home', () {
      expect(
        authRedirect(authState: AuthState.unauthenticated, currentPath: '/'),
        '/login',
      );
    });

    test('redirects to /login from splash', () {
      expect(
        authRedirect(
          authState: AuthState.unauthenticated,
          currentPath: '/splash',
        ),
        '/login',
      );
    });

    test('stays on /login when already there', () {
      expect(
        authRedirect(
          authState: AuthState.unauthenticated,
          currentPath: '/login',
        ),
        isNull,
      );
    });

    test('stays on /setup (allows access during setup flow)', () {
      expect(
        authRedirect(
          authState: AuthState.unauthenticated,
          currentPath: '/setup',
        ),
        isNull,
      );
    });
  });

  group('authRedirect — firstTimeSetup state', () {
    test('redirects to /setup from any other path', () {
      expect(
        authRedirect(
          authState: AuthState.firstTimeSetup,
          currentPath: '/login',
        ),
        '/setup',
      );
      expect(
        authRedirect(authState: AuthState.firstTimeSetup, currentPath: '/'),
        '/setup',
      );
      expect(
        authRedirect(
          authState: AuthState.firstTimeSetup,
          currentPath: '/splash',
        ),
        '/setup',
      );
    });

    test('stays on /setup when already there', () {
      expect(
        authRedirect(
          authState: AuthState.firstTimeSetup,
          currentPath: '/setup',
        ),
        isNull,
      );
    });
  });

  group('authRedirect — authenticated state', () {
    test('redirects from /splash to home', () {
      expect(
        authRedirect(authState: AuthState.authenticated, currentPath: '/splash'),
        '/',
      );
    });

    test('redirects from /login to home', () {
      expect(
        authRedirect(authState: AuthState.authenticated, currentPath: '/login'),
        '/',
      );
    });

    test('redirects from /setup to home', () {
      expect(
        authRedirect(authState: AuthState.authenticated, currentPath: '/setup'),
        '/',
      );
    });

    test('stays on / when already on home', () {
      expect(
        authRedirect(authState: AuthState.authenticated, currentPath: '/'),
        isNull,
      );
    });

    test('stays on any other authenticated path', () {
      expect(
        authRedirect(
          authState: AuthState.authenticated,
          currentPath: '/settings',
        ),
        isNull,
      );
    });
  });
}
