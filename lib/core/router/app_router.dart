import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/features/auth/providers/first_time_setup_provider.dart';
import 'package:hms/features/auth/screens/screens.dart';
import 'package:hms/features/dashboard/screens/home_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

// ---------------------------------------------------------------------------
// Auth state
// ---------------------------------------------------------------------------

enum AuthState {
  loading, // still determining auth — show splash
  firstTimeSetup, // no Super Admin exists — show setup
  unauthenticated, // not logged in — show login
  authenticated, // logged in with valid profile — show home
}

// ---------------------------------------------------------------------------
// AuthNotifier — derives current AuthState from async providers
// ---------------------------------------------------------------------------

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    final authAsync = ref.watch(authStateProvider);
    final setupAsync = ref.watch(isFirstTimeSetupProvider);

    if (authAsync.isLoading || setupAsync.isLoading) {
      return AuthState.loading;
    }

    final isSetup = setupAsync.asData?.value ?? false;
    if (isSetup) return AuthState.firstTimeSetup;

    final user = authAsync.asData?.value;
    if (user == null) return AuthState.unauthenticated;

    return AuthState.authenticated;
  }
}

// ---------------------------------------------------------------------------
// Redirect logic — extracted as pure function for testability
// ---------------------------------------------------------------------------

String? authRedirect({
  required AuthState authState,
  required String currentPath,
}) {
  return switch (authState) {
    AuthState.loading => currentPath != '/splash' ? '/splash' : null,
    AuthState.firstTimeSetup => currentPath != '/setup' ? '/setup' : null,
    AuthState.unauthenticated =>
      (currentPath != '/login' && currentPath != '/setup') ? '/login' : null,
    AuthState.authenticated =>
      (currentPath == '/splash' ||
              currentPath == '/login' ||
              currentPath == '/setup')
          ? '/'
          : null,
  };
}

// ---------------------------------------------------------------------------
// Refresh notifier — bridges Riverpod → GoRouter Listenable
// ---------------------------------------------------------------------------

class _RouterRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

// ---------------------------------------------------------------------------
// GoRouter provider
// ---------------------------------------------------------------------------

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final notifier = _RouterRefreshNotifier();

  ref.listen<AuthState>(authProvider, (prev, next) {
    notifier.refresh();
  });

  ref.onDispose(notifier.dispose);

  final router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: (context, state) => authRedirect(
      authState: ref.read(authProvider),
      currentPath: state.matchedLocation,
    ),
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/setup',
        builder: (context, state) => const FirstTimeSetupScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/users',
        builder: (context, state) => const UserManagementScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddUserScreen(),
          ),
          GoRoute(
            path: ':userId',
            builder: (context, state) => UserDetailScreen(
              userId: state.pathParameters['userId']!,
            ),
            routes: [
              GoRoute(
                path: 'activity',
                builder: (context, state) => UserActivityLogScreen(
                  userId: state.pathParameters['userId']!,
                  userName: state.extra as String? ?? '',
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  ref.onDispose(router.dispose);

  return router;
}
