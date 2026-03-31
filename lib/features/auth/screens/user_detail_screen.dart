import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/models/models.dart';
import 'package:hms/core/services/services.dart';
import 'package:hms/core/theme/app_colors.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/auth/providers/user_providers.dart';
import 'package:intl/intl.dart';

class UserDetailScreen extends ConsumerWidget {
  const UserDetailScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider(userId));

    return Scaffold(
      appBar: AppBar(title: const Text('User Details')),
      body: OfflineBanner(
        child: userAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Failed to load user: $e')),
          data: (user) {
            if (user == null) {
              return const Center(child: Text('User not found'));
            }
            return _UserDetailBody(user: user, userId: userId);
          },
        ),
      ),
    );
  }
}

class _UserDetailBody extends ConsumerWidget {
  const _UserDetailBody({required this.user, required this.userId});

  final AppUser user;
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentUserAsync = ref.watch(currentUserProfileProvider);
    final currentUserId = currentUserAsync.asData?.value?.id ?? '';
    final isSelf = currentUserId == userId;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // User profile header
          Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.12,
                ),
                child: Icon(
                  Icons.person,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                user.displayName,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                user.email,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Role: ${user.isSuperAdmin ? 'Super Admin' : 'Admin'}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: user.isSuperAdmin
                      ? AppColors.primary
                      : AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Member since: ${DateFormat('dd/MM/yyyy').format(user.createdAt)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // Actions section header
          Text(
            'Actions',
            style: theme.textTheme.titleSmall?.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const Divider(height: AppSpacing.lg),

          // Change Role
          AppCard(
            leadingIcon: Icons.swap_horiz_outlined,
            title: 'Change Role',
            subtitle: isSelf ? 'Cannot change your own role' : null,
            showChevron: true,
            onTap: isSelf
                ? null
                : () => _showChangeRoleDialog(context, ref, user),
          ),

          const SizedBox(height: AppSpacing.sm),

          // View Activity Log
          AppCard(
            leadingIcon: Icons.history_outlined,
            title: 'View Activity Log',
            showChevron: true,
            onTap: () => context.push(
              '/users/$userId/activity',
              extra: user.displayName,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Reset Password
          AppCard(
            leadingIcon: Icons.lock_reset_outlined,
            title: 'Reset Password',
            subtitle: 'Sends a password reset email',
            showChevron: true,
            onTap: () => _resetPassword(context, ref, user.email),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Delete Account (disabled for self)
          if (!isSelf)
            AppCard(
              leadingIcon: Icons.delete_outline,
              leadingIconColor: AppColors.error,
              leadingIconBackgroundColor: AppColors.error.withValues(
                alpha: 0.1,
              ),
              title: 'Delete Account',
              subtitle: 'This cannot be undone',
              onTap: () => _showDeleteDialog(context, ref, user),
            ),

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  void _showChangeRoleDialog(
    BuildContext context,
    WidgetRef ref,
    AppUser user,
  ) {
    String selectedRole = user.role;

    showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Change Role'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select a new role for ${user.displayName}:'),
                const SizedBox(height: AppSpacing.md),
                HmsDropdown<String>(
                  label: 'Role',
                  value: selectedRole,
                  items: const [
                    DropdownMenuItem(value: 'admin', child: Text('Admin')),
                    DropdownMenuItem(
                      value: 'superAdmin',
                      child: Text('Super Admin'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() => selectedRole = value);
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  await _updateRole(context, ref, selectedRole);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _updateRole(
    BuildContext context,
    WidgetRef ref,
    String newRole,
  ) async {
    final currentUserId =
        ref.read(currentUserProfileProvider).asData?.value?.id ?? '';
    try {
      await ref
          .read(userServiceProvider)
          .updateUserRole(
            userId: userId,
            newRole: newRole,
            updatedBy: currentUserId,
          );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Role updated successfully')),
        );
      }
    } on AuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update role. Please try again.'),
          ),
        );
      }
    }
  }

  Future<void> _resetPassword(
    BuildContext context,
    WidgetRef ref,
    String email,
  ) async {
    try {
      await ref.read(authServiceProvider).sendPasswordResetEmail(email: email);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset email sent to $email')),
        );
      }
    } on AuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to send reset email. Please try again.'),
          ),
        );
      }
    }
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, AppUser user) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Account'),
        content: Text(
          'Are you sure you want to delete the account for ${user.displayName}? '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await _deleteAccount(context, ref);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final currentUserId =
        ref.read(currentUserProfileProvider).asData?.value?.id ?? '';
    try {
      await ref
          .read(userServiceProvider)
          .deleteUserProfile(userId: userId, deletedBy: currentUserId);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Account deleted')));
        context.pop();
      }
    } on AuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete account. Please try again.'),
          ),
        );
      }
    }
  }
}
