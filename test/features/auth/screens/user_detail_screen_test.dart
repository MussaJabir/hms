import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/models/models.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/auth_service.dart';
import 'package:hms/core/services/auth_service_provider.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/auth/providers/user_providers.dart';
import 'package:hms/features/auth/screens/user_detail_screen.dart';
import 'package:hms/features/auth/services/user_service.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

AppUser _testUser({
  String id = 'u1',
  String displayName = 'Wife',
  String email = 'wife@home.com',
  String role = 'admin',
}) {
  final now = DateTime(2026, 3, 15);
  return AppUser(
    id: id,
    email: email,
    displayName: displayName,
    role: role,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'sa1',
  );
}

AppUser _superAdmin() => _testUser(
  id: 'sa1',
  displayName: 'Dutch',
  email: 'dutch@home.com',
  role: 'superAdmin',
);

Widget _wrap({required AppUser viewedUser, required AppUser currentUser}) {
  final fakeFirestore = FakeFirebaseFirestore();
  final fakeAuth = MockFirebaseAuth();
  final fs = FirestoreService(firestore: fakeFirestore);
  final users = UserService(
    fs,
    ActivityLogService(FirestoreService(firestore: fakeFirestore)),
  );
  final auth = AuthService(auth: fakeAuth);

  final router = GoRouter(
    initialLocation: '/users/${viewedUser.id}',
    routes: [
      GoRoute(
        path: '/users/:userId',
        builder: (context, state) =>
            UserDetailScreen(userId: state.pathParameters['userId']!),
      ),
      GoRoute(
        path: '/users/:userId/activity',
        builder: (context, _) => const Scaffold(body: Text('Activity Log')),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      authServiceProvider.overrideWithValue(auth),
      userServiceProvider.overrideWithValue(users),
      userProfileProvider(
        viewedUser.id,
      ).overrideWith((ref) => Stream.value(viewedUser)),
      currentUserProfileProvider.overrideWith(
        (ref) => Stream.value(currentUser),
      ),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  // ---------------------------------------------------------------------------
  // Profile display
  // ---------------------------------------------------------------------------

  group('UserDetailScreen profile', () {
    testWidgets('shows user display name, email, role, and member since', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(viewedUser: _testUser(), currentUser: _superAdmin()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Wife'), findsOneWidget);
      expect(find.text('wife@home.com'), findsOneWidget);
      expect(find.text('Role: Admin'), findsOneWidget);
      expect(find.text('Member since: 15/03/2026'), findsOneWidget);
    });

    testWidgets('shows Super Admin role label for superAdmin user', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(viewedUser: _superAdmin(), currentUser: _superAdmin()),
      );
      await tester.pumpAndSettle();
      expect(find.text('Role: Super Admin'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // Action items
  // ---------------------------------------------------------------------------

  group('UserDetailScreen actions', () {
    testWidgets('shows all 4 action items for a different user', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(viewedUser: _testUser(), currentUser: _superAdmin()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Change Role'), findsOneWidget);
      expect(find.text('View Activity Log'), findsOneWidget);
      expect(find.text('Reset Password'), findsOneWidget);
      expect(find.text('Delete Account'), findsOneWidget);
    });

    testWidgets('does not show delete action for self', (tester) async {
      await tester.pumpWidget(
        _wrap(viewedUser: _superAdmin(), currentUser: _superAdmin()),
      );
      await tester.pumpAndSettle();
      expect(find.text('Delete Account'), findsNothing);
    });

    testWidgets('change role is disabled for self', (tester) async {
      await tester.pumpWidget(
        _wrap(viewedUser: _superAdmin(), currentUser: _superAdmin()),
      );
      await tester.pumpAndSettle();

      // Change Role card should still appear but have null subtitle hint
      expect(find.text('Change Role'), findsOneWidget);
      expect(find.text('Cannot change your own role'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // Delete confirmation dialog
  // ---------------------------------------------------------------------------

  group('UserDetailScreen delete dialog', () {
    testWidgets('shows confirmation dialog when delete is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(viewedUser: _testUser(), currentUser: _superAdmin()),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Delete Account'));
      await tester.tap(find.text('Delete Account'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Account'), findsWidgets); // title + button
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('dismissing dialog with Cancel keeps user on screen', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(viewedUser: _testUser(), currentUser: _superAdmin()),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Delete Account'));
      await tester.tap(find.text('Delete Account'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Still on user detail, not navigated away
      expect(find.text('Wife'), findsOneWidget);
    });
  });
}
