import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/electricity/providers/meter_providers.dart';
import 'package:hms/features/grounds/models/rental_unit.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';
import 'package:hms/features/grounds/providers/rental_unit_providers.dart';
import 'package:hms/features/grounds/providers/tenant_providers.dart';

class UnitListScreen extends ConsumerWidget {
  const UnitListScreen({super.key, required this.groundId});

  final String groundId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groundAsync = ref.watch(groundByIdProvider(groundId));
    final unitsAsync = ref.watch(allUnitsProvider(groundId));

    final groundName = groundAsync.asData?.value?.name ?? 'Units';

    return Scaffold(
      appBar: AppBar(
        title: Text('$groundName — Units'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Unit',
            onPressed: () => context.push('/grounds/$groundId/units/add'),
          ),
        ],
      ),
      body: unitsAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: ShimmerList(itemCount: 5),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
        ),
        data: (units) {
          if (units.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: EmptyState(
                  icon: Icons.door_front_door_outlined,
                  title: 'No Units Yet',
                  message: 'Add your first rental unit to this property.',
                  actionLabel: 'Add Unit',
                  onAction: () => context.push('/grounds/$groundId/units/add'),
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: units.length,
            separatorBuilder: (ctx, idx) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              return _UnitCard(groundId: groundId, unit: units[index]);
            },
          );
        },
      ),
    );
  }
}

class _UnitCard extends ConsumerWidget {
  const _UnitCard({required this.groundId, required this.unit});

  final String groundId;
  final RentalUnit unit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tenantAsync = ref.watch(currentTenantProvider(groundId, unit.id));
    final tenant = tenantAsync.asData?.value;
    final meterAsync = ref.watch(activeMeterProvider(groundId, unit.id));
    final hasMeter = meterAsync.asData?.value != null;

    final String subtitle;
    final VoidCallback onTap;

    if (unit.isOccupied && tenant != null) {
      subtitle = tenant.fullName;
      onTap = () => context.push('/grounds/$groundId/units/${unit.id}/tenant');
    } else if (unit.isOccupied) {
      subtitle = '${formatTZS(unit.rentAmount)} /month';
      onTap = () => context.push('/grounds/$groundId/units/${unit.id}/tenant');
    } else {
      subtitle = hasMeter ? 'Vacant' : 'Vacant — no meter';
      onTap = () =>
          context.push('/grounds/$groundId/units/${unit.id}/tenant/add');
    }

    final status = unit.isOccupied
        ? PaymentStatus.active
        : PaymentStatus.vacant;

    return AppCard(
      leadingIcon: Icons.door_front_door_outlined,
      title: unit.name,
      subtitle: subtitle,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasMeter)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: Icon(
                Icons.electric_meter_outlined,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          StatusBadge(status: status),
        ],
      ),
      showChevron: true,
      onTap: onTap,
    );
  }
}
