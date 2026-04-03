import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/theme/theme.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/auth/providers/user_providers.dart';
import 'package:hms/features/dashboard/widgets/alert_feed.dart';
import 'package:hms/features/dashboard/widgets/grounds_selector.dart';
import 'package:hms/features/dashboard/widgets/health_score_card.dart';
import 'package:hms/features/dashboard/widgets/quick_add_fab.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Watch the stream directly — avoids the FutureProvider race condition
    // where isSuperAdminProvider resolves false before the Firestore profile loads.
    final profileAsync = ref.watch(currentUserProfileProvider);
    final isSuperAdmin = profileAsync.asData?.value?.isSuperAdmin ?? false;
    final displayName = profileAsync.asData?.value?.displayName ?? 'Loading...';

    return Scaffold(
      appBar: AppBar(
        title: const Text('HMS'),
        actions: const [
          ConnectionStatus(compact: true),
          SizedBox(width: AppSpacing.sm),
        ],
      ),
      drawer: isSuperAdmin ? _AdminDrawer(displayName: displayName) : null,
      floatingActionButton: const QuickAddFab(),
      body: OfflineBanner(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const GroundsSelector(),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      AppSpacing.md,
                      AppSpacing.screenPadding,
                      0,
                    ),
                    child: const HealthScoreCard(),
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
                  const Divider(height: AppSpacing.lg),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      0,
                      AppSpacing.screenPadding,
                      AppSpacing.xs,
                    ),
                    child: Text(
                      'Alerts',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: AlertFeed()),
            if (isSuperAdmin)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    AppSpacing.md,
                    AppSpacing.screenPadding,
                    AppSpacing.screenPadding,
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppSpacing.borderRadius,
                      ),
                      side: BorderSide(color: AppColors.border),
                    ),
                    leading: const Icon(
                      Icons.group_outlined,
                      color: AppColors.primary,
                    ),
                    title: const Text('User Management'),
                    subtitle: const Text('Add and manage family members'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.go('/users'),
                  ),
                ),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
          ],
        ),
      ),
    );
  }
}

class _AdminDrawer extends StatelessWidget {
  const _AdminDrawer({required this.displayName});

  final String displayName;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    displayName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Super Admin',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () {
                Navigator.of(context).pop();
                context.go('/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.group_outlined),
              title: const Text('User Management'),
              onTap: () {
                Navigator.of(context).pop();
                context.go('/users');
              },
            ),
          ],
        ),
      ),
    );
  }
}
