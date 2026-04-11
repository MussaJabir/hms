import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/features/auth/providers/first_time_setup_provider.dart';
import 'package:hms/features/auth/screens/screens.dart';
import 'package:hms/features/dashboard/screens/home_screen.dart';
import 'package:hms/features/dashboard/screens/monthly_report_screen.dart';
import 'package:hms/core/models/ground.dart';
import 'package:hms/features/electricity/models/electricity_meter.dart';
import 'package:hms/features/electricity/screens/screens.dart';
import 'package:hms/features/grounds/models/rental_unit.dart';
import 'package:hms/features/grounds/models/tenant.dart';
import 'package:hms/features/grounds/screens/screens.dart';
import 'package:hms/features/rent/screens/screens.dart';
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

    // Authenticated users always go home — check this first so a logged-in
    // user is never trapped in firstTimeSetup state.
    final user = authAsync.asData?.value;
    if (user != null) return AuthState.authenticated;

    // No authenticated user — check if initial setup is still needed.
    final isSetup = setupAsync.asData?.value ?? false;
    if (isSetup) return AuthState.firstTimeSetup;

    return AuthState.unauthenticated;
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
    AuthState.firstTimeSetup =>
      (currentPath != '/setup' && currentPath != '/login') ? '/setup' : null,
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
        path: '/report',
        builder: (context, state) => const MonthlyReportScreen(),
      ),
      GoRoute(
        path: '/grounds',
        builder: (context, state) => const GroundsListScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddGroundScreen(),
          ),
          GoRoute(
            path: ':groundId',
            builder: (context, state) =>
                GroundDetailScreen(groundId: state.pathParameters['groundId']!),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) =>
                    AddGroundScreen(ground: state.extra as Ground?),
              ),
              GoRoute(
                path: 'electricity',
                builder: (context, state) => ElectricityOverviewScreen(
                  groundId: state.pathParameters['groundId']!,
                ),
              ),
              GoRoute(
                path: 'units',
                builder: (context, state) =>
                    UnitListScreen(groundId: state.pathParameters['groundId']!),
                routes: [
                  GoRoute(
                    path: 'add',
                    builder: (context, state) => AddUnitScreen(
                      groundId: state.pathParameters['groundId']!,
                    ),
                  ),
                  GoRoute(
                    path: ':unitId/edit',
                    builder: (context, state) => AddUnitScreen(
                      groundId: state.pathParameters['groundId']!,
                      unit: state.extra as RentalUnit?,
                    ),
                  ),
                  GoRoute(
                    path: ':unitId/meter/register',
                    builder: (context, state) => MeterRegistrationScreen(
                      groundId: state.pathParameters['groundId']!,
                      unitId: state.pathParameters['unitId']!,
                    ),
                  ),
                  GoRoute(
                    path: ':unitId/meter/edit',
                    builder: (context, state) => MeterRegistrationScreen(
                      groundId: state.pathParameters['groundId']!,
                      unitId: state.pathParameters['unitId']!,
                      meter: state.extra as ElectricityMeter?,
                    ),
                  ),
                  GoRoute(
                    path: ':unitId/meter/replace',
                    builder: (context, state) => MeterReplacementScreen(
                      groundId: state.pathParameters['groundId']!,
                      unitId: state.pathParameters['unitId']!,
                      currentMeterId: state.extra as String,
                    ),
                  ),
                  GoRoute(
                    path: ':unitId/tenant',
                    builder: (context, state) => TenantDetailScreen(
                      groundId: state.pathParameters['groundId']!,
                      unitId: state.pathParameters['unitId']!,
                    ),
                  ),
                  GoRoute(
                    path: ':unitId/tenant/add',
                    builder: (context, state) => AddTenantScreen(
                      groundId: state.pathParameters['groundId']!,
                      unitId: state.pathParameters['unitId']!,
                    ),
                  ),
                  GoRoute(
                    path: ':unitId/tenant/edit',
                    builder: (context, state) => AddTenantScreen(
                      groundId: state.pathParameters['groundId']!,
                      unitId: state.pathParameters['unitId']!,
                      tenant: state.extra as Tenant?,
                    ),
                  ),
                  GoRoute(
                    path: ':unitId/tenant/:tenantId/rent-history',
                    builder: (context, state) => TenantRentHistoryScreen(
                      groundId: state.pathParameters['groundId']!,
                      unitId: state.pathParameters['unitId']!,
                      tenantId: state.pathParameters['tenantId']!,
                      tenantName: state.extra as String? ?? '',
                    ),
                  ),
                  GoRoute(
                    path: ':unitId/move-out',
                    builder: (context, state) {
                      final extra = state.extra as (Tenant, RentalUnit);
                      return MoveOutScreen(
                        groundId: state.pathParameters['groundId']!,
                        unitId: state.pathParameters['unitId']!,
                        tenant: extra.$1,
                        unit: extra.$2,
                      );
                    },
                  ),
                  GoRoute(
                    path: ':unitId/settlements',
                    builder: (context, state) => SettlementHistoryScreen(
                      groundId: state.pathParameters['groundId']!,
                      unitId: state.pathParameters['unitId']!,
                      unitName: state.extra as String? ?? 'Unit',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/rent',
        builder: (context, state) => const RentListScreen(),
        routes: [
          GoRoute(
            path: 'pay',
            builder: (context, state) {
              final args = state.extra as RentPaymentArgs;
              return RentPaymentScreen(
                record: args.record,
                collectionPath: args.collectionPath,
              );
            },
          ),
        ],
      ),
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
            builder: (context, state) =>
                UserDetailScreen(userId: state.pathParameters['userId']!),
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
