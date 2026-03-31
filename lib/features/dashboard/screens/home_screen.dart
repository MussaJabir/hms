import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/theme/theme.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/auth/providers/user_providers.dart';

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
      body: OfflineBanner(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Home Management System',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Your household, organized.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
              if (isSuperAdmin) ...[
                const SizedBox(height: AppSpacing.xl),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
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
              ],
            ],
          ),
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
