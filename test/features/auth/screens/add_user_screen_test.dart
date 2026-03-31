import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/auth_service.dart';
import 'package:hms/core/services/auth_service_provider.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/auth/providers/user_providers.dart';
import 'package:hms/features/auth/screens/add_user_screen.dart';
import 'package:hms/features/auth/services/user_service.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _wrap({
  AuthService? authService,
  UserService? userService,
}) {
  final fakeFirestore = FakeFirebaseFirestore();
  final fakeAuth = MockFirebaseAuth();
  final fs = FirestoreService(firestore: fakeFirestore);

  final auth = authService ?? AuthService(auth: fakeAuth);
  final users = userService ??
      UserService(fs, ActivityLogService(FirestoreService(firestore: fakeFirestore)));

  return ProviderScope(
    overrides: [
      authServiceProvider.overrideWithValue(auth),
      userServiceProvider.overrideWithValue(users),
    ],
    child: const MaterialApp(home: AddUserScreen()),
  );
}

void main() {
  // ---------------------------------------------------------------------------
  // Field visibility
  // ---------------------------------------------------------------------------

  group('AddUserScreen fields', () {
    testWidgets('displays all 3 text fields and role dropdown', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.text('Display Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Role'), findsOneWidget);
    });

    testWidgets('displays create account button', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      expect(find.text('Create Account'), findsOneWidget);
    });

    testWidgets('role dropdown defaults to Admin', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      // Admin should appear as selected value
      expect(find.text('Admin'), findsWidgets);
    });
  });

  // ---------------------------------------------------------------------------
  // Validation
  // ---------------------------------------------------------------------------

  group('AddUserScreen validation', () {
    testWidgets('shows required error when display name is empty', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pump();

      expect(find.text('Display name is required'), findsOneWidget);
    });

    testWidgets('shows min-length error for short display name', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      await tester.enterText(find.byType(TextFormField).first, 'A');
      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pump();

      expect(find.text('Must be at least 2 characters'), findsOneWidget);
    });

    testWidgets('shows email validation error for invalid email', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'John Doe');
      await tester.enterText(fields.at(1), 'not-an-email');

      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pump();

      expect(find.text('Invalid email address'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // Loading state
  // ---------------------------------------------------------------------------

  group('AddUserScreen loading state', () {
    testWidgets('shows loading indicator when submitting', (tester) async {
      final slowAuth = _SlowAuthService();

      await tester.pumpWidget(_wrap(authService: slowAuth));
      await tester.pump();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'John Doe');
      await tester.enterText(fields.at(1), 'john@home.com');
      await tester.enterText(fields.at(2), 'password123');

      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pump();

      expect(find.text('Create Account'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsWidgets);

      final button = tester.widget<FilledButton>(find.byType(FilledButton).first);
      expect(button.onPressed, isNull);

      await tester.pump(const Duration(seconds: 31));
    });
  });
}

class _SlowAuthService extends AuthService {
  _SlowAuthService() : super(auth: MockFirebaseAuth());

  @override
  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(seconds: 30));
    return super.createUserWithEmailAndPassword(email: email, password: password);
  }
}
