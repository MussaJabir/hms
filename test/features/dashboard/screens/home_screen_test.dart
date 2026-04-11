import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/models/app_user.dart';
import 'package:hms/core/models/ground.dart';
import 'package:hms/core/providers/connectivity_provider.dart';
import 'package:hms/core/widgets/alert_severity.dart';
import 'package:hms/features/auth/providers/user_providers.dart';
import 'package:hms/features/dashboard/models/dashboard_alert.dart';
import 'package:hms/features/dashboard/providers/alert_provider.dart';
import 'package:hms/features/dashboard/screens/home_screen.dart';
import 'package:hms/features/dashboard/widgets/alert_feed.dart';
import 'package:hms/features/dashboard/widgets/grounds_selector.dart';
import 'package:hms/features/dashboard/widgets/health_score_card.dart';
import 'package:hms/features/dashboard/widgets/quick_add_fab.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';

// ── Test data ──────────────────────────────────────────────────────────────

final _now = DateTime(2026, 4, 9);

Ground _makeGround(String id, String name) => Ground(
  id: id,
  name: name,
  location: 'Dar es Salaam',
  numberOfUnits: 5,
  createdAt: _now,
  updatedAt: _now,
  updatedBy: 'user-1',
);

final _defaultGrounds = [
  _makeGround('g-1', 'Main Ground'),
  _makeGround('g-2', 'Minor Ground'),
];

final _adminUser = AppUser(
  id: 'admin-id',
  email: 'admin@example.com',
  displayName: 'Admin User',
  role: 'admin',
  createdAt: DateTime(2026, 1, 1),
  updatedAt: DateTime(2026, 1, 1),
  updatedBy: 'system',
);

final _superAdminUser = AppUser(
  id: 'super-id',
  email: 'super@example.com',
  displayName: 'Super Admin',
  role: 'superAdmin',
  createdAt: DateTime(2026, 1, 1),
  updatedAt: DateTime(2026, 1, 1),
  updatedBy: 'system',
);

final _sampleAlert = DashboardAlert(
  id: 'test-alert',
  title: 'Test Alert',
  message: 'Test message',
  severity: AlertSeverity.critical,
  icon: Icons.warning,
  module: 'rent',
  createdAt: DateTime(2026, 4, 1),
);

// ── Test wrapper ───────────────────────────────────────────────────────────

Widget _wrap({
  AppUser? user,
  List<DashboardAlert>? alerts,
  List<Ground>? grounds,
}) {
  final groundList = grounds ?? _defaultGrounds;
  return ProviderScope(
    overrides: [
      currentUserProfileProvider.overrideWith(
        (ref) => Stream.value(user ?? _adminUser),
      ),
      connectivityProvider.overrideWith((ref) => Stream.value(true)),
      allGroundsProvider.overrideWith((ref) => Stream.value(groundList)),
      if (alerts != null)
        alertsProvider.overrideWith((ref) => Future.value(alerts)),
    ],
    child: const MaterialApp(home: HomeScreen()),
  );
}

// ── Tests ──────────────────────────────────────────────────────────────────

void main() {
  group('HomeScreen', () {
    testWidgets('renders AppBar with HMS title', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.widgetWithText(AppBar, 'HMS'), findsOneWidget);
    });

    testWidgets('renders GroundsSelector', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.byType(GroundsSelector), findsOneWidget);
    });

    testWidgets('renders HealthScoreCard', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.byType(HealthScoreCard), findsOneWidget);
    });

    testWidgets('renders AlertFeed and Needs Attention section header', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.byType(AlertFeed), findsOneWidget);
      expect(find.text('Needs Attention'), findsOneWidget);
    });

    testWidgets('renders QuickAddFab', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.byType(QuickAddFab), findsOneWidget);
    });

    testWidgets('notification bell shows count badge when alerts present', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(alerts: [_sampleAlert]));
      await tester.pump();

      // The badge shows '1' — find it as a text widget inside the bell stack
      expect(find.text('1'), findsWidgets);
    });
  });

  group('HomeScreen Drawer', () {
    Future<void> openDrawer(WidgetTester tester) async {
      final scaffold = tester.firstState<ScaffoldState>(find.byType(Scaffold));
      scaffold.openDrawer();
      await tester.pumpAndSettle();
    }

    testWidgets('drawer shows Dashboard, Monthly Report, Settings, Sign Out', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();
      await openDrawer(tester);

      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Monthly Report'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Sign Out'), findsOneWidget);
    });

    testWidgets('drawer does NOT show User Management for regular admin', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(user: _adminUser));
      await tester.pump();
      await openDrawer(tester);

      expect(find.text('User Management'), findsNothing);
    });

    testWidgets('drawer shows User Management for Super Admin', (tester) async {
      await tester.pumpWidget(_wrap(user: _superAdminUser));
      await tester.pump();
      await openDrawer(tester);

      expect(find.text('User Management'), findsOneWidget);
    });

    testWidgets('drawer header shows user display name', (tester) async {
      await tester.pumpWidget(_wrap(user: _adminUser));
      await tester.pump();
      await openDrawer(tester);

      expect(find.text('Admin User'), findsOneWidget);
    });
  });

  group('HomeScreen — setup prompt (no grounds)', () {
    testWidgets('shows welcome prompt when no grounds exist', (tester) async {
      await tester.pumpWidget(_wrap(grounds: []));
      await tester.pumpAndSettle();

      expect(find.text('Add Your First Property'), findsOneWidget);
    });

    testWidgets('hides HealthScoreCard when no grounds exist', (tester) async {
      await tester.pumpWidget(_wrap(grounds: []));
      await tester.pumpAndSettle();

      expect(find.byType(HealthScoreCard), findsNothing);
    });

    testWidgets('hides AlertFeed when no grounds exist', (tester) async {
      await tester.pumpWidget(_wrap(grounds: []));
      await tester.pumpAndSettle();

      expect(find.byType(AlertFeed), findsNothing);
    });

    testWidgets('hides QuickAddFab when no grounds exist', (tester) async {
      await tester.pumpWidget(_wrap(grounds: []));
      await tester.pumpAndSettle();

      expect(find.byType(QuickAddFab), findsNothing);
    });

    testWidgets('shows HealthScoreCard when grounds exist', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.byType(HealthScoreCard), findsOneWidget);
    });
  });
}
