import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/theme/app_colors.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/auth/providers/user_providers.dart';

class UserManagementScreen extends ConsumerWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allUsersAsync = ref.watch(allUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_outlined),
            tooltip: 'Add Family Member',
            onPressed: () => context.push('/users/add'),
          ),
        ],
      ),
      body: OfflineBanner(
        child: allUsersAsync.when(
          loading: () => const ShimmerList(itemCount: 4),
          error: (e, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: AppColors.error,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Failed to load users',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text('$e', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: AppSpacing.md),
                FilledButton(
                  onPressed: () => ref.refresh(allUsersProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (users) {
            if (users.isEmpty) {
              return EmptyState(
                icon: Icons.group_outlined,
                title: 'No Family Members',
                message:
                    'Add your first family member to share household management.',
                actionLabel: 'Add Family Member',
                onAction: () => context.push('/users/add'),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              itemCount: users.length,
              separatorBuilder: (context, _) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final user = users[index];
                return AppCard(
                  leadingIcon: Icons.person_outline,
                  title: user.displayName,
                  subtitle: user.email,
                  trailing: _RoleBadge(role: user.role),
                  showChevron: true,
                  onTap: () => context.push('/users/${user.id}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});

  final String role;

  @override
  Widget build(BuildContext context) {
    final isSuperAdmin = role == 'superAdmin';
    final label = isSuperAdmin ? 'Super Admin' : 'Admin';
    final color = isSuperAdmin ? AppColors.primary : AppColors.success;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
