import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/features/auth/providers/user_providers.dart';
import 'package:hms/core/models/models.dart';
import 'package:hms/features/electricity/models/reminder_config.dart';
import 'package:hms/features/electricity/providers/reminder_providers.dart';
import 'package:hms/features/electricity/screens/meter_reminder_settings_screen.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

final _now = DateTime(2026, 4, 17);

ReminderConfig _config({
  bool enabled = true,
  int dayOfWeek = 7,
  int hour = 18,
  int minute = 0,
}) => ReminderConfig(
  id: 'meter_reminder',
  enabled: enabled,
  dayOfWeek: dayOfWeek,
  hour: hour,
  minute: minute,
  updatedAt: _now,
  updatedBy: 'user-1',
);

AppUser _user({bool isSuperAdmin = false}) => AppUser(
  id: 'user-1',
  email: 'test@hms.com',
  displayName: 'Test User',
  role: isSuperAdmin ? 'superAdmin' : 'admin',
  createdAt: _now,
  updatedAt: _now,
  updatedBy: 'user-1',
);

Widget _wrap({
  ReminderConfig? config,
  int pendingCount = 3,
  bool isSuperAdmin = false,
}) {
  final resolvedConfig = config ?? _config();
  final router = GoRouter(
    initialLocation: '/settings/meter-reminder',
    routes: [
      GoRoute(
        path: '/settings/meter-reminder',
        builder: (context, state) => const MeterReminderSettingsScreen(),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      reminderConfigProvider.overrideWith((ref) async => resolvedConfig),
      pendingReadingsCountProvider.overrideWith((ref) async => pendingCount),
      currentUserProfileProvider.overrideWith(
        (ref) => Stream.value(_user(isSuperAdmin: isSuperAdmin)),
      ),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('MeterReminderSettingsScreen', () {
    testWidgets('renders enable switch', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.text('Enable Reminder'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('switch is ON when config.enabled is true', (tester) async {
      await tester.pumpWidget(_wrap(config: _config(enabled: true)));
      await tester.pumpAndSettle();

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isTrue);
    });

    testWidgets('switch is OFF when config.enabled is false', (tester) async {
      await tester.pumpWidget(_wrap(config: _config(enabled: false)));
      await tester.pumpAndSettle();

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isFalse);
    });

    testWidgets('disabling the switch grays out form fields', (tester) async {
      await tester.pumpWidget(_wrap(config: _config(enabled: true)));
      await tester.pumpAndSettle();

      // Toggle switch OFF
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // The Opacity widget wrapping the day/time pickers should be at 0.4
      final opacityWidgets = tester
          .widgetList<Opacity>(find.byType(Opacity))
          .toList();
      final formOpacity = opacityWidgets.firstWhere(
        (o) => o.opacity == 0.4,
        orElse: () => const Opacity(opacity: 1, child: SizedBox()),
      );
      expect(formOpacity.opacity, 0.4);
    });

    testWidgets('changing day dropdown updates local state', (tester) async {
      await tester.pumpWidget(_wrap(config: _config(dayOfWeek: 7)));
      await tester.pumpAndSettle();

      // Open dropdown and pick Monday (index 0 → value 1)
      await tester.tap(find.byType(DropdownButtonFormField<int>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Monday').last);
      await tester.pumpAndSettle();

      // The selected item should now show Monday
      expect(find.text('Monday'), findsWidgets);
    });

    testWidgets('save button is present', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();

      expect(find.widgetWithText(FilledButton, 'Save'), findsOneWidget);
    });

    testWidgets('test notification button shown for super admin only', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(isSuperAdmin: true));
      await tester.pumpAndSettle();

      expect(find.text('Test Notification'), findsOneWidget);
    });

    testWidgets('test notification button hidden for non-super-admin', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(isSuperAdmin: false));
      await tester.pumpAndSettle();

      expect(find.text('Test Notification'), findsNothing);
    });

    testWidgets('shows pending room count in preview', (tester) async {
      await tester.pumpWidget(_wrap(pendingCount: 5));
      await tester.pumpAndSettle();

      expect(find.text('5 rooms currently have active meters'), findsOneWidget);
    });

    testWidgets('shows singular room text for count of 1', (tester) async {
      await tester.pumpWidget(_wrap(pendingCount: 1));
      await tester.pumpAndSettle();

      expect(find.text('1 room currently have active meters'), findsOneWidget);
    });

    testWidgets('preview shows disabled message when reminder is off', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(config: _config(enabled: false)));
      await tester.pumpAndSettle();

      expect(
        find.text('Reminder disabled — no notifications scheduled'),
        findsOneWidget,
      );
    });
  });
}
