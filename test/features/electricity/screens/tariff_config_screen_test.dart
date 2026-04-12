import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/models/app_config.dart';
import 'package:hms/core/models/app_user.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/auth/providers/user_providers.dart';
import 'package:hms/features/electricity/providers/tariff_providers.dart';
import 'package:hms/features/electricity/screens/tariff_config_screen.dart';
import 'package:hms/features/electricity/services/tariff_service.dart';
import 'package:hms/features/electricity/widgets/tariff_tier_editor.dart';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

final _defaultTiers = [
  const TanescoTier(minUnits: 0, maxUnits: 75, ratePerUnit: 100),
  const TanescoTier(minUnits: 76, maxUnits: 200, ratePerUnit: 292),
  const TanescoTier(minUnits: 201, maxUnits: double.infinity, ratePerUnit: 356),
];

AppUser _user({required bool superAdmin}) {
  final now = DateTime(2026, 4, 1);
  return AppUser(
    id: 'u-1',
    email: 'test@hms.app',
    displayName: 'Test User',
    role: superAdmin ? 'superAdmin' : 'admin',
    createdAt: now,
    updatedAt: now,
    updatedBy: 'system',
  );
}

TariffService _fakeTariffService() {
  final fb = FakeFirebaseFirestore();
  final fs = FirestoreService(firestore: fb);
  return TariffService(fs, ActivityLogService(fs));
}

Widget _wrap({List<TanescoTier>? tiers, bool isSuperAdmin = true}) {
  final router = GoRouter(
    initialLocation: '/settings/tariffs',
    routes: [
      GoRoute(
        path: '/settings/tariffs',
        builder: (ctx, st) => const TariffConfigScreen(),
      ),
      GoRoute(path: '/', builder: (ctx, st) => const Scaffold()),
    ],
  );

  return ProviderScope(
    overrides: [
      tariffServiceProvider.overrideWith((_) => _fakeTariffService()),
      currentTariffsProvider.overrideWith(
        (ref) => Stream.value(tiers ?? _defaultTiers),
      ),
      currentUserProfileProvider.overrideWith(
        (ref) => Stream.value(_user(superAdmin: isSuperAdmin)),
      ),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

Future<void> _settle(WidgetTester tester) async {
  await tester.pump(); // stream emits
  await tester.pump(); // whenData fires, addPostFrameCallback scheduled
  await tester.pump(); // postFrameCallback fires, setState called
  await tester.pump(); // rebuild with tiers
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('TariffConfigScreen — display', () {
    testWidgets('shows current tiers', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.byType(TariffTierEditor), findsNWidgets(3));
    });

    testWidgets('shows live preview for 150 units', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      // Default tiers: 75×100 + 75×292 = 7,500 + 21,900 = 29,400
      expect(find.textContaining('29,400'), findsOneWidget);
    });

    testWidgets('shows Super Admin access required for non-admin', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(isSuperAdmin: false));
      await _settle(tester);

      expect(find.textContaining('Super Admin'), findsWidgets);
    });

    testWidgets('shows Save Tariffs button', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.text('Save Tariffs'), findsOneWidget);
    });

    testWidgets('shows Add Tier button', (tester) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.textContaining('Add Tier'), findsOneWidget);
    });
  });

  group('TariffConfigScreen — interactions', () {
    testWidgets('tapping Add Tier appends a new TariffTierEditor', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap());
      await _settle(tester);

      expect(find.byType(TariffTierEditor), findsNWidgets(3));

      await tester.tap(find.textContaining('Add Tier'));
      await tester.pump();

      expect(find.byType(TariffTierEditor), findsNWidgets(4));
    });

    testWidgets('live preview shows correct cost for single-tier config', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          tiers: [
            const TanescoTier(
              minUnits: 0,
              maxUnits: double.infinity,
              ratePerUnit: 100,
            ),
          ],
        ),
      );
      await _settle(tester);

      // Single tier 100/u: 150 units = 15,000
      expect(find.textContaining('15,000'), findsOneWidget);
    });
  });
}
