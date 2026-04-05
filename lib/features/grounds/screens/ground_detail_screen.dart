import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/auth/providers/user_providers.dart';
import 'package:hms/features/dashboard/widgets/widgets.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';

class GroundDetailScreen extends ConsumerWidget {
  const GroundDetailScreen({super.key, required this.groundId});

  final String groundId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groundAsync = ref.watch(groundByIdProvider(groundId));
    final isSuperAdmin =
        ref.watch(currentUserProfileProvider).asData?.value?.isSuperAdmin ??
        false;

    return groundAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
        ),
      ),
      data: (ground) {
        if (ground == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Property not found.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(ground.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit',
                onPressed: () =>
                    context.push('/grounds/${ground.id}/edit', extra: ground),
              ),
              if (isSuperAdmin)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Delete',
                  color: Theme.of(context).colorScheme.error,
                  onPressed: () => _confirmDelete(context, ref),
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Property info ──────────────────────────────────────────
                AppCard(
                  leadingIcon: Icons.home_work_outlined,
                  title: ground.name,
                  subtitle: ground.location,
                  trailingText: '${ground.numberOfUnits} units',
                ),
                const SizedBox(height: AppSpacing.lg),
                // ── Rental Units section ───────────────────────────────────
                const DashboardSectionHeader(title: 'Rental Units'),
                const SizedBox(height: AppSpacing.sm),
                EmptyStatePresets.noTenants(),
                const SizedBox(height: 80),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Property'),
        content: const Text(
          'This will permanently delete this property. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final userId = ref.read(authStateProvider).asData?.value?.uid ?? 'unknown';

    try {
      await ref.read(groundServiceProvider).deleteGround(groundId, userId);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Property deleted.')));
        context.go('/grounds');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
