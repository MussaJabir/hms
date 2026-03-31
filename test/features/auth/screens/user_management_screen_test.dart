import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/models/models.dart';
import 'package:hms/core/widgets/shimmer/shimmer_list.dart';
import 'package:hms/features/auth/providers/user_providers.dart';
import 'package:hms/features/auth/screens/user_management_screen.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

AppUser _user({
  required String id,
  required String displayName,
  required String email,
  String role = 'admin',
}) {
  final now = DateTime(2026, 1, 1);
  return AppUser(
    id: id,
    email: email,
    displayName: displayName,
    role: role,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'system',
  );
}

Widget _wrap(Widget child, {required Stream<List<AppUser>> usersStream}) {
  final router = GoRouter(
    initialLocation: '/users',
    routes: [
      GoRoute(path: '/users', builder: (context, _) => child),
      GoRoute(
        path: '/users/add',
        builder: (context, _) => const Scaffold(body: Text('Add User')),
      ),
      GoRoute(
        path: '/users/:userId',
        builder: (context, _) => const Scaffold(body: Text('User Detail')),
      ),
    ],
  );
  return ProviderScope(
    overrides: [
      allUsersProvider.overrideWith((ref) => usersStream),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  // ---------------------------------------------------------------------------
  // App bar
  // ---------------------------------------------------------------------------

  group('UserManagementScreen app bar', () {
    testWidgets('shows add user button', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const UserManagementScreen(),
          usersStream: const Stream.empty(),
        ),
      );
      await tester.pump();
      expect(find.byIcon(Icons.person_add_outlined), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // Loading state
  // ---------------------------------------------------------------------------

  group('UserManagementScreen loading', () {
    testWidgets('shows ShimmerList while stream has no data yet', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const UserManagementScreen(),
          usersStream: const Stream.empty(), // never emits → stays AsyncLoading
        ),
      );
      await tester.pump();
      expect(find.byType(ShimmerList), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // Empty state
  // ---------------------------------------------------------------------------

  group('UserManagementScreen empty state', () {
    testWidgets('shows empty state when user list is empty', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const UserManagementScreen(),
          usersStream: Stream.value([]),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('No Family Members'), findsOneWidget);
      expect(find.text('Add Family Member'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // User list
  // ---------------------------------------------------------------------------

  group('UserManagementScreen user list', () {
    final users = [
      _user(
        id: 'sa1',
        displayName: 'Dutch',
        email: 'dutch@home.com',
        role: 'superAdmin',
      ),
      _user(id: 'a1', displayName: 'Wife', email: 'wife@home.com'),
    ];

    testWidgets('renders all user display names', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const UserManagementScreen(),
          usersStream: Stream.value(users),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Dutch'), findsOneWidget);
      expect(find.text('Wife'), findsOneWidget);
    });

    testWidgets('renders all user emails', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const UserManagementScreen(),
          usersStream: Stream.value(users),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('dutch@home.com'), findsOneWidget);
      expect(find.text('wife@home.com'), findsOneWidget);
    });

    testWidgets('renders role badges for Super Admin and Admin', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const UserManagementScreen(),
          usersStream: Stream.value(users),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Super Admin'), findsOneWidget);
      expect(find.text('Admin'), findsOneWidget);
    });

    testWidgets('tapping a user navigates to detail screen', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const UserManagementScreen(),
          usersStream: Stream.value(users),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Dutch'));
      await tester.pumpAndSettle();
      expect(find.text('User Detail'), findsOneWidget);
    });
  });
}
