import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/services/services.dart';
import 'package:hms/core/theme/theme.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/features/auth/providers/user_providers.dart';
import 'package:hms/features/dashboard/providers/alert_provider.dart';
import 'package:hms/features/dashboard/widgets/widgets.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';
import 'package:hms/features/rent/providers/rent_summary_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the stream profile directly to avoid FutureProvider race condition.
    final profileAsync = ref.watch(currentUserProfileProvider);
    final profile = profileAsync.asData?.value;
    final isSuperAdmin = profile?.isSuperAdmin ?? false;
    final displayName = profile?.displayName ?? '';
    final email = profile?.email ?? '';
    final alertCount = ref.watch(alertsProvider).asData?.value.length ?? 0;
    final groundsAsync = ref.watch(allGroundsProvider);
    final hasGrounds = groundsAsync.asData?.value.isNotEmpty ?? true;

    return Scaffold(
      appBar: AppBar(
        title: const Text('HMS'),
        actions: [
          _NotificationBell(alertCount: alertCount),
          const ConnectionStatus(compact: true),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      drawer: _AppDrawer(
        displayName: displayName,
        email: email,
        isSuperAdmin: isSuperAdmin,
      ),
      floatingActionButton: hasGrounds ? const QuickAddFab() : null,
      body: OfflineBanner(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const GroundsSelector(),
              const Divider(height: 1),
              // ── First-time setup prompt ─────────────────────────────────
              if (groundsAsync.asData?.value.isEmpty == true)
                _SetupPrompt(displayName: displayName)
              else ...[
                // ── Health Score ──────────────────────────────────────────
                const Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    AppSpacing.md,
                    AppSpacing.screenPadding,
                    0,
                  ),
                  child: HealthScoreCard(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    AppSpacing.sm,
                    AppSpacing.screenPadding,
                    0,
                  ),
                  child: TextButton.icon(
                    onPressed: () => context.push('/report'),
                    icon: const Icon(Icons.bar_chart_outlined, size: 18),
                    label: const Text('View Monthly Report →'),
                    style: TextButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
                // ── Rent Summary ─────────────────────────────────────────
                const _RentSummaryTile(),
                // ── Needs Attention ───────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    AppSpacing.lg,
                    AppSpacing.screenPadding,
                    0,
                  ),
                  child: DashboardSectionHeader(
                    title: 'Needs Attention',
                    badgeCount: alertCount > 0 ? alertCount : null,
                  ),
                ),
                const AlertFeed(),
              ],
              // FAB clearance
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Rent summary tile ─────────────────────────────────────────────────────

class _RentSummaryTile extends ConsumerWidget {
  const _RentSummaryTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectedAsync = ref.watch(currentMonthCollectedProvider);
    final expectedAsync = ref.watch(currentMonthExpectedProvider);
    final rateAsync = ref.watch(currentMonthCollectionRateProvider);

    final collected = collectedAsync.asData?.value ?? 0.0;
    final expected = expectedAsync.asData?.value ?? 0.0;
    final rate = rateAsync.asData?.value ?? 0.0;

    final isLoading = collectedAsync.isLoading || expectedAsync.isLoading;

    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.md,
          AppSpacing.screenPadding,
          0,
        ),
        child: ShimmerBox(height: 72, borderRadius: AppSpacing.borderRadius),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.md,
        AppSpacing.screenPadding,
        0,
      ),
      child: InkWell(
        onTap: () => context.push('/rent'),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        child: SummaryTile(
          label: 'Rent This Month',
          value:
              '${formatTZS(collected, short: true)} / ${formatTZS(expected, short: true)}',
          icon: Icons.home_work_outlined,
          trend: rate >= 80
              ? TrendDirection.up
              : (rate > 0 ? TrendDirection.flat : null),
          trendText: rate > 0 ? '${rate.toStringAsFixed(0)}% collected' : null,
          compact: true,
        ),
      ),
    );
  }
}

// ── First-time setup prompt ────────────────────────────────────────────────

class _SetupPrompt extends StatelessWidget {
  const _SetupPrompt({required this.displayName});

  final String displayName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final greeting = displayName.isEmpty
        ? 'Welcome!'
        : 'Welcome, $displayName!';
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.xl),
          Icon(
            Icons.home_work_outlined,
            size: 64,
            color: AppColors.primary.withValues(alpha: 0.6),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            greeting,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Start by adding your first property to manage\nyour rental units and tenants.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton.icon(
            onPressed: () => context.push('/grounds/add'),
            icon: const Icon(Icons.add_home_outlined),
            label: const Text('Add Your First Property'),
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: () => context.go('/grounds'),
            icon: const Icon(Icons.home_work_outlined, size: 18),
            label: const Text('Go to Properties'),
          ),
        ],
      ),
    );
  }
}

// ── Notification bell with alert count badge ───────────────────────────────

class _NotificationBell extends StatelessWidget {
  const _NotificationBell({required this.alertCount});

  final int alertCount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          tooltip: 'Alerts',
          onPressed: () {
            // Placeholder — notification centre comes in a later phase.
          },
        ),
        if (alertCount > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  alertCount > 9 ? '9+' : '$alertCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ── App drawer ─────────────────────────────────────────────────────────────

class _AppDrawer extends ConsumerWidget {
  const _AppDrawer({
    required this.displayName,
    required this.email,
    required this.isSuperAdmin,
  });

  final String displayName;
  final String email;
  final bool isSuperAdmin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentGroundId = ref.watch(currentGroundProvider);

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ──────────────────────────────────────────────────
            _DrawerHeader(displayName: displayName, email: email),
            const Divider(height: 1),
            // ── Navigation items ────────────────────────────────────────
            _DrawerNavItem(
              icon: Icons.dashboard_outlined,
              title: 'Dashboard',
              onTap: () {
                Navigator.of(context).pop();
                context.go('/');
              },
            ),
            _DrawerNavItem(
              icon: Icons.assessment_outlined,
              title: 'Monthly Report',
              onTap: () {
                Navigator.of(context).pop();
                context.push('/report');
              },
            ),
            _DrawerNavItem(
              icon: Icons.home_work_outlined,
              title: 'Properties',
              onTap: () {
                Navigator.of(context).pop();
                context.go('/grounds');
              },
            ),
            _DrawerNavItem(
              icon: Icons.payments_outlined,
              title: 'Rent',
              onTap: () {
                Navigator.of(context).pop();
                context.go('/rent');
              },
            ),
            _DrawerNavItem(
              icon: Icons.electric_meter_outlined,
              title: 'Electricity',
              onTap: () {
                Navigator.of(context).pop();
                if (currentGroundId != null) {
                  context.push('/grounds/$currentGroundId/electricity');
                } else {
                  context.go('/grounds');
                }
              },
            ),
            if (isSuperAdmin) ...[
              _DrawerNavItem(
                icon: Icons.people_outlined,
                title: 'User Management',
                onTap: () {
                  Navigator.of(context).pop();
                  context.go('/users');
                },
              ),
              _DrawerNavItem(
                icon: Icons.tune_outlined,
                title: 'TANESCO Settings',
                onTap: () {
                  Navigator.of(context).pop();
                  context.push('/settings/tariffs');
                },
              ),
            ],
            _DrawerNavItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {
                final messenger = ScaffoldMessenger.of(context);
                Navigator.of(context).pop();
                messenger.showSnackBar(
                  const SnackBar(content: Text('Coming in Phase 12')),
                );
              },
            ),
            const Spacer(),
            const Divider(height: 1),
            // ── Sign out ────────────────────────────────────────────────
            _DrawerNavItem(
              icon: Icons.logout,
              title: 'Sign Out',
              iconColor: AppColors.error,
              titleColor: AppColors.error,
              onTap: () async {
                Navigator.of(context).pop();
                await ref.read(authServiceProvider).signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({required this.displayName, required this.email});

  final String displayName;
  final String email;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            child: const Icon(Icons.person, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName.isEmpty ? 'HMS' : displayName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (email.isNotEmpty)
                  Text(
                    email,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerNavItem extends StatelessWidget {
  const _DrawerNavItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.titleColor,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = theme.colorScheme.onSurface;

    return ListTile(
      leading: Icon(icon, color: iconColor ?? defaultColor),
      title: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: titleColor ?? defaultColor,
        ),
      ),
      onTap: onTap,
      dense: true,
    );
  }
}
