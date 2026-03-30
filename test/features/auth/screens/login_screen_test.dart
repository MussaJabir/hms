import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/auth_exception.dart';
import 'package:hms/core/services/auth_service.dart';
import 'package:hms/core/services/auth_service_provider.dart';
import 'package:hms/features/auth/screens/login_screen.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

class _FakeAuthService extends AuthService {
  _FakeAuthService({
    Future<User> Function(String email, String password)? onSignIn,
    Future<void> Function(String email)? onReset,
  }) : _onSignIn = onSignIn,
       _onReset = onReset,
       super(auth: MockFirebaseAuth());

  final Future<User> Function(String email, String password)? _onSignIn;
  final Future<void> Function(String email)? _onReset;

  @override
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (_onSignIn != null) return _onSignIn(email, password);
    throw const AuthException('Not configured');
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    if (_onReset != null) return _onReset(email);
    throw const AuthException('Not configured');
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Widget _wrap(Widget child, {required AuthService authService}) {
  return ProviderScope(
    overrides: [authServiceProvider.overrideWithValue(authService)],
    child: MaterialApp(home: child),
  );
}

void main() {
  // ---------------------------------------------------------------------------
  // Fields
  // ---------------------------------------------------------------------------

  group('LoginScreen fields', () {
    late _FakeAuthService fakeAuth;

    setUp(() {
      fakeAuth = _FakeAuthService();
    });

    testWidgets('email and password fields are displayed', (tester) async {
      await tester.pumpWidget(
        _wrap(const LoginScreen(), authService: fakeAuth),
      );
      await tester.pump();
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('sign in button is displayed', (tester) async {
      await tester.pumpWidget(
        _wrap(const LoginScreen(), authService: fakeAuth),
      );
      await tester.pump();
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('forgot password link is displayed', (tester) async {
      await tester.pumpWidget(
        _wrap(const LoginScreen(), authService: fakeAuth),
      );
      await tester.pump();
      expect(find.text('Forgot password?'), findsOneWidget);
    });

    testWidgets('app branding is displayed', (tester) async {
      await tester.pumpWidget(
        _wrap(const LoginScreen(), authService: fakeAuth),
      );
      await tester.pump();
      expect(find.text('Home Management System'), findsOneWidget);
      expect(find.text('Your household, organized.'), findsOneWidget);
      expect(find.byIcon(Icons.home_work_rounded), findsOneWidget);
    });
  });

  // ---------------------------------------------------------------------------
  // Validation
  // ---------------------------------------------------------------------------

  group('LoginScreen validation', () {
    late _FakeAuthService fakeAuth;

    setUp(() {
      fakeAuth = _FakeAuthService();
    });

    testWidgets('shows error for empty email on submit', (tester) async {
      await tester.pumpWidget(
        _wrap(const LoginScreen(), authService: fakeAuth),
      );
      await tester.pump();
      await tester.tap(find.text('Sign In'));
      await tester.pump();
      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('shows error for invalid email on submit', (tester) async {
      await tester.pumpWidget(
        _wrap(const LoginScreen(), authService: fakeAuth),
      );
      await tester.pump();
      await tester.enterText(find.byType(TextFormField).first, 'notanemail');
      await tester.tap(find.text('Sign In'));
      await tester.pump();
      expect(find.text('Invalid email address'), findsOneWidget);
    });

    testWidgets('shows error for short password on submit', (tester) async {
      await tester.pumpWidget(
        _wrap(const LoginScreen(), authService: fakeAuth),
      );
      await tester.pump();
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@email.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'short');
      await tester.tap(find.text('Sign In'));
      await tester.pump();
      expect(
        find.text('Password must be at least 8 characters'),
        findsOneWidget,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Password visibility toggle
  // ---------------------------------------------------------------------------

  group('LoginScreen password visibility', () {
    late _FakeAuthService fakeAuth;

    setUp(() {
      fakeAuth = _FakeAuthService();
    });

    testWidgets('password is obscured by default', (tester) async {
      await tester.pumpWidget(
        _wrap(const LoginScreen(), authService: fakeAuth),
      );
      await tester.pump();
      final passwordField = tester.widget<EditableText>(
        find.byType(EditableText).last,
      );
      expect(passwordField.obscureText, isTrue);
    });

    testWidgets('tapping visibility icon reveals password', (tester) async {
      await tester.pumpWidget(
        _wrap(const LoginScreen(), authService: fakeAuth),
      );
      await tester.pump();

      // Default: obscured
      expect(
        tester.widget<EditableText>(find.byType(EditableText).last).obscureText,
        isTrue,
      );

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      // Now revealed
      expect(
        tester.widget<EditableText>(find.byType(EditableText).last).obscureText,
        isFalse,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Loading state
  // ---------------------------------------------------------------------------

  group('LoginScreen loading state', () {
    testWidgets('button is disabled and shows spinner while signing in', (
      tester,
    ) async {
      final completer = Completer<User>();
      final fakeAuth = _FakeAuthService(
        onSignIn: (email, password) => completer.future,
      );

      await tester.pumpWidget(
        _wrap(const LoginScreen(), authService: fakeAuth),
      );
      await tester.pump();

      await tester.enterText(
        find.byType(TextFormField).first,
        'test@email.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Sign In'));
      await tester.pump(); // trigger setState → loading

      // Button text gone, spinner present
      expect(find.text('Sign In'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsWidgets);

      // Button is disabled
      final button = tester.widget<FilledButton>(
        find.byType(FilledButton).first,
      );
      expect(button.onPressed, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // Error display
  // ---------------------------------------------------------------------------

  group('LoginScreen error display', () {
    testWidgets('shows auth error message when sign in fails', (tester) async {
      final fakeAuth = _FakeAuthService(
        onSignIn: (email, password) async =>
            throw const AuthException('No account found with this email'),
      );

      await tester.pumpWidget(
        _wrap(const LoginScreen(), authService: fakeAuth),
      );
      await tester.pump();

      await tester.enterText(
        find.byType(TextFormField).first,
        'test@email.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Sign In'));
      await tester.pump(); // sign in future
      await tester.pump(); // setState with error

      expect(find.text('No account found with this email'), findsOneWidget);
    });

    testWidgets('error clears when user types in email field', (tester) async {
      final fakeAuth = _FakeAuthService(
        onSignIn: (email, password) async =>
            throw const AuthException('No account found with this email'),
      );

      await tester.pumpWidget(
        _wrap(const LoginScreen(), authService: fakeAuth),
      );
      await tester.pump();

      await tester.enterText(
        find.byType(TextFormField).first,
        'test@email.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Sign In'));
      await tester.pump();
      await tester.pump();

      // Error shown
      expect(find.text('No account found with this email'), findsOneWidget);

      // Type in email field to clear it
      await tester.enterText(
        find.byType(TextFormField).first,
        'other@email.com',
      );
      await tester.pump();

      expect(find.text('No account found with this email'), findsNothing);
    });
  });
}
