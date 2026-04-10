import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/theme/app_colors.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/utils/time_ago.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/dashboard/widgets/widgets.dart';
import 'package:hms/features/grounds/models/tenant.dart';
import 'package:hms/features/grounds/providers/rental_unit_providers.dart';
import 'package:hms/features/grounds/providers/tenant_providers.dart';
import 'package:intl/intl.dart';

class TenantDetailScreen extends ConsumerWidget {
  const TenantDetailScreen({
    super.key,
    required this.groundId,
    required this.unitId,
  });

  final String groundId;
  final String unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tenantAsync = ref.watch(currentTenantProvider(groundId, unitId));

    return tenantAsync.when(
      loading: () => const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: ShimmerCard(),
        ),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
        ),
      ),
      data: (tenant) {
        if (tenant == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Tenant')),
            body: Center(
              child: EmptyStatePresets.noTenants(
                onAdd: () =>
                    context.push('/grounds/$groundId/units/$unitId/tenant/add'),
              ),
            ),
          );
        }
        return _TenantView(groundId: groundId, unitId: unitId, tenant: tenant);
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Loaded view
// ---------------------------------------------------------------------------

class _TenantView extends ConsumerStatefulWidget {
  const _TenantView({
    required this.groundId,
    required this.unitId,
    required this.tenant,
  });

  final String groundId;
  final String unitId;
  final Tenant tenant;

  @override
  ConsumerState<_TenantView> createState() => _TenantViewState();
}

class _TenantViewState extends ConsumerState<_TenantView> {
  static final _dateFmt = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tenant = widget.tenant;
    final leaseStatus = tenant.hasLeaseExpired
        ? PaymentStatus.overdue
        : PaymentStatus.active;

    return Scaffold(
      appBar: AppBar(
        title: Text(tenant.fullName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
            onPressed: () => context.push(
              '/grounds/${widget.groundId}/units/${widget.unitId}/tenant/edit',
              extra: tenant,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile card ────────────────────────────────────────────────
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            tenant.fullName,
                            style: theme.textTheme.headlineMedium,
                          ),
                        ),
                        StatusBadge(status: leaseStatus),
                      ],
                    ),
                    if (tenant.hasLeaseExpired)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.xs),
                        child: Text(
                          'Lease Expired',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.md),
                    _InfoRow(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: tenant.phoneNumber,
                    ),
                    if (tenant.hasNationalId) ...[
                      const SizedBox(height: AppSpacing.sm),
                      _InfoRow(
                        icon: Icons.badge_outlined,
                        label: 'National ID',
                        value: tenant.nationalId!,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    _InfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Move-in',
                      value: _dateFmt.format(tenant.moveInDate),
                    ),
                    if (tenant.leaseEndDate != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      _InfoRow(
                        icon: Icons.event_outlined,
                        label: 'Lease ends',
                        value: _dateFmt.format(tenant.leaseEndDate!),
                        valueColor: tenant.hasLeaseExpired
                            ? AppColors.error
                            : null,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // ── Rent history shortcut ────────────────────────────────────────
            AppCard(
              leadingIcon: Icons.receipt_long_outlined,
              leadingIconColor: AppColors.primary,
              title: 'Rent History',
              subtitle: 'View all payment records',
              showChevron: true,
              onTap: () => context.push(
                '/grounds/${widget.groundId}/units/${widget.unitId}'
                '/tenant/${tenant.id}/rent-history',
                extra: tenant.fullName,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            // ── Communication log section ────────────────────────────────────
            DashboardSectionHeader(
              title: 'Communication Log',
              actionText: 'Add Note',
              onAction: () => _showAddNoteDialog(context),
            ),
            const SizedBox(height: AppSpacing.sm),
            _CommunicationLogList(
              groundId: widget.groundId,
              unitId: widget.unitId,
              tenantId: tenant.id,
            ),
            const SizedBox(height: AppSpacing.xl),
            // ── Move Out action ──────────────────────────────────────────────
            _MoveOutButton(
              groundId: widget.groundId,
              unitId: widget.unitId,
              tenant: tenant,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddNoteDialog(BuildContext context) async {
    final controller = TextEditingController();
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Note'),
        content: HmsTextField(
          label: 'Note',
          hint: 'e.g. Called re: Oct payment. Resolved.',
          controller: controller,
          maxLines: 3,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (confirmed != true || controller.text.trim().isEmpty) {
      controller.dispose();
      return;
    }

    final userId = ref.read(authStateProvider).asData?.value?.uid ?? 'unknown';
    try {
      await ref
          .read(tenantServiceProvider)
          .addCommunicationLog(
            widget.groundId,
            widget.unitId,
            widget.tenant.id,
            controller.text.trim(),
            userId,
          );
      if (mounted) {
        messenger.showSnackBar(const SnackBar(content: Text('Note saved.')));
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      controller.dispose();
    }
  }
}

// ---------------------------------------------------------------------------
// Communication log list (streams from Firestore)
// ---------------------------------------------------------------------------

class _CommunicationLogList extends ConsumerWidget {
  const _CommunicationLogList({
    required this.groundId,
    required this.unitId,
    required this.tenantId,
  });

  final String groundId;
  final String unitId;
  final String tenantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(tenantServiceProvider);

    return StreamBuilder(
      stream: service.streamCommunicationLogs(groundId, unitId, tenantId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ShimmerList(itemCount: 2);
        }
        final logs = snapshot.data ?? [];
        if (logs.isEmpty) {
          return const EmptyState(
            icon: Icons.chat_bubble_outline,
            title: 'No Notes Yet',
            message: 'Tap "Add Note" to log a communication with this tenant.',
            compact: true,
          );
        }
        return Column(
          children: logs
              .map(
                (log) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: AppCard(
                    title: log.note,
                    subtitle: timeAgo(log.createdAt),
                    leadingIcon: Icons.chat_bubble_outline,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Move Out button — watches unit to pass it to MoveOutScreen
// ---------------------------------------------------------------------------

class _MoveOutButton extends ConsumerWidget {
  const _MoveOutButton({
    required this.groundId,
    required this.unitId,
    required this.tenant,
  });

  final String groundId;
  final String unitId;
  final Tenant tenant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitAsync = ref.watch(unitByIdProvider(groundId, unitId));
    final unit = unitAsync.asData?.value;

    if (unit == null || !unit.isOccupied) return const SizedBox.shrink();

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.error,
          side: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        onPressed: () => context.push(
          '/grounds/$groundId/units/$unitId/move-out',
          extra: (tenant, unit),
        ),
        icon: const Icon(Icons.exit_to_app_outlined),
        label: const Text('Move Out'),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Info row widget
// ---------------------------------------------------------------------------

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: valueColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
