import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/auth_exception.dart';
import 'package:hms/core/services/auth_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/features/auth/providers/first_time_setup_provider.dart';
import 'package:hms/features/auth/screens/first_time_setup_screen.dart';
import 'package:hms/features/auth/services/first_time_setup_service.dart';
import 'package:hms/features/auth/services/user_service.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class _FakeFirstTimeSetupService extends FirstTimeSetupService {
  _FakeFirstTimeSetupService({this.onCreateSuperAdmin})
    : super(
        AuthService(auth: MockFirebaseAuth()),
        UserService(
          FirestoreService(firestore: FakeFirebaseFirestore()),
          ActivityLogService(
            FirestoreService(firestore: FakeFirebaseFirestore()),
          ),
        ),
      );

  final Future<void> Function({
    required String email,
    required String password,
    required String displayName,
  })?
  onCreateSuperAdmin;

  @override
  Future<void> createSuperAdmin({
    required String email,
    required String password,
    required String displayName,
  }) async {
    if (onCreateSuperAdmin != null) {
      return onCreateSuperAdmin!(
        email: email,
        password: password,
        displayName: displayName,
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _wrap(Widget child, {FirstTimeSetupService? service}) {
  return ProviderScope(
    overrides: [
      if (service != null)
        firstTimeSetupServiceProvider.overrideWithValue(service),
    ],
    child: MaterialApp(home: child),
  );
}

void main() {
  late _FakeFirstTimeSetupService fakeService;

  setUp(() {
    fakeService = _FakeFirstTimeSetupService();
  });

  // ---------------------------------------------------------------------------
  // Fields
  // ---------------------------------------------------------------------------

  group('FirstTimeSetupScreen fields', () {
    testWidgets('all 4 fields are displayed', (tester) async {
      await tester.pumpWidget(
        _wrap(const FirstTimeSetupScreen(), service: fakeService),
      );
      await tester.pump();
      expect(find.text('Display Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('create account button is displayed', (tester) async {
      await tester.pumpWidget(
        _wrap(const FirstTimeSetupScreen(), service: fakeService),
      );
      await tester.pump();
      expect(find.text('Create Account'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // Validation
  // ---------------------------------------------------------------------------

  group('FirstTimeSetupScreen validation', () {
    testWidgets('shows error when display name is too short', (tester) async {
      await tester.pumpWidget(
        _wrap(const FirstTimeSetupScreen(), service: fakeService),
      );
      await tester.pump();

      // Enter single character display name
      await tester.enterText(find.byType(TextFormField).first, 'A');
      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pump();

      expect(find.text('Must be at least 2 characters'), findsOneWidget);
    });

    testWidgets('shows error when display name is empty', (tester) async {
      await tester.pumpWidget(
        _wrap(const FirstTimeSetupScreen(), service: fakeService),
      );
      await tester.pump();

      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pump();

      expect(find.text('Display name is required'), findsOneWidget);
    });

    testWidgets('shows error when passwords do not match', (tester) async {
      await tester.pumpWidget(
        _wrap(const FirstTimeSetupScreen(), service: fakeService),
      );
      await tester.pump();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'John Doe');
      await tester.enterText(fields.at(1), 'boss@home.com');
      await tester.enterText(fields.at(2), 'password123');
      await tester.enterText(fields.at(3), 'differentpass');

      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pump();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // Loading state
  // ---------------------------------------------------------------------------

  group('FirstTimeSetupScreen loading state', () {
    testWidgets('shows loading indicator when submitting', (tester) async {
      final slowService = _FakeFirstTimeSetupService(
        onCreateSuperAdmin: ({required email, required password, required displayName}) async {
          await Future<void>.delayed(const Duration(seconds: 30));
        },
      );

      await tester.pumpWidget(
        _wrap(const FirstTimeSetupScreen(), service: slowService),
      );
      await tester.pump();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'John Doe');
      await tester.enterText(fields.at(1), 'boss@home.com');
      await tester.enterText(fields.at(2), 'password123');
      await tester.enterText(fields.at(3), 'password123');

      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pump(); // trigger setState → loading

      expect(find.text('Create Account'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsWidgets);

      final button = tester.widget<FilledButton>(
        find.byType(FilledButton).first,
      );
      expect(button.onPressed, isNull);

      // Drain the pending 30-second timer to avoid test teardown assertion
      await tester.pump(const Duration(seconds: 31));
    });
  });

  // ---------------------------------------------------------------------------
  // Error display
  // ---------------------------------------------------------------------------

  group('FirstTimeSetupScreen error display', () {
    testWidgets('shows error when createSuperAdmin throws AuthException', (
      tester,
    ) async {
      final errorService = _FakeFirstTimeSetupService(
        onCreateSuperAdmin: ({required email, required password, required displayName}) async =>
            throw const AuthException('Email already in use'),
      );

      await tester.pumpWidget(
        _wrap(const FirstTimeSetupScreen(), service: errorService),
      );
      await tester.pump();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'John Doe');
      await tester.enterText(fields.at(1), 'boss@home.com');
      await tester.enterText(fields.at(2), 'password123');
      await tester.enterText(fields.at(3), 'password123');

      await tester.ensureVisible(find.text('Create Account'));
      await tester.tap(find.text('Create Account'));
      await tester.pump(); // start async chain
      await tester.pump(); // future completes with error
      await tester.pump(); // catch block + setState + rebuild

      expect(find.text('Email already in use'), findsOneWidget);
    });
  });
}
