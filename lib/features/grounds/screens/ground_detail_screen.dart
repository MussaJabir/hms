import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/auth/providers/user_providers.dart';
import 'package:hms/features/dashboard/widgets/widgets.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';
import 'package:hms/features/grounds/providers/rental_unit_providers.dart';

class GroundDetailScreen extends ConsumerWidget {
  const GroundDetailScreen({super.key, required this.groundId});

  final String groundId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groundAsync = ref.watch(groundByIdProvider(groundId));
    final unitsAsync = ref.watch(allUnitsProvider(groundId));
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

        final units = unitsAsync.asData?.value ?? [];
        final occupied = units.where((u) => u.isOccupied).length;
        final vacant = units.where((u) => u.isVacant).length;

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
                  trailingText: '${units.length} units',
                ),
                const SizedBox(height: AppSpacing.lg),
                // ── Rental Units section ───────────────────────────────────
                DashboardSectionHeader(
                  title: 'Rental Units',
                  badgeCount: units.isNotEmpty ? units.length : null,
                ),
                const SizedBox(height: AppSpacing.xs),
                if (units.isNotEmpty) ...[
                  Text(
                    '$occupied occupied · $vacant vacant',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                // ── Compact unit list (up to 3) ───────────────────────────
                if (unitsAsync.isLoading)
                  const ShimmerList(itemCount: 3)
                else if (units.isEmpty)
                  EmptyState(
                    icon: Icons.door_front_door_outlined,
                    title: 'No Units Yet',
                    message: 'Add your first rental unit to this property.',
                    actionLabel: 'Add Unit',
                    onAction: () =>
                        context.push('/grounds/$groundId/units/add'),
                  )
                else ...[
                  ...units
                      .take(3)
                      .map(
                        (unit) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: AppCard(
                            leadingIcon: Icons.door_front_door_outlined,
                            title: unit.name,
                            subtitle: '${formatTZS(unit.rentAmount)} /month',
                            trailing: StatusBadge(
                              status: unit.isOccupied
                                  ? PaymentStatus.active
                                  : PaymentStatus.vacant,
                              small: true,
                            ),
                          ),
                        ),
                      ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              context.push('/grounds/$groundId/units'),
                          icon: const Icon(Icons.list_outlined, size: 18),
                          label: const Text('View All Units'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () =>
                              context.push('/grounds/$groundId/units/add'),
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Unit'),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                // ── Settlement History quick link ───────────────────────────
                if (units.isNotEmpty) ...[
                  DashboardSectionHeader(title: 'Settlement History'),
                  const SizedBox(height: AppSpacing.sm),
                  ...units.map(
                    (unit) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: AppCard(
                        leadingIcon: Icons.receipt_long_outlined,
                        title: unit.name,
                        subtitle: 'Past tenant settlements',
                        onTap: () => context.push(
                          '/grounds/$groundId/units/${unit.id}/settlements',
                          extra: unit.name,
                        ),
                      ),
                    ),
                  ),
                ],
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
