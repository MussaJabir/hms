import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:intl/intl.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/electricity/models/electricity_meter.dart';
import 'package:hms/features/electricity/providers/meter_providers.dart';
import 'package:hms/features/grounds/models/rental_unit.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';
import 'package:hms/features/grounds/providers/rental_unit_providers.dart';

class ElectricityOverviewScreen extends ConsumerWidget {
  const ElectricityOverviewScreen({super.key, required this.groundId});

  final String groundId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groundAsync = ref.watch(groundByIdProvider(groundId));
    final unitsAsync = ref.watch(allUnitsProvider(groundId));

    final groundName = groundAsync.asData?.value?.name ?? 'Ground';

    return Scaffold(
      appBar: AppBar(title: Text('$groundName — Electricity')),
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
                  icon: Icons.electric_meter_outlined,
                  title: 'No Units',
                  message: 'Add rental units to this property first.',
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: units.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              return _UnitMeterCard(groundId: groundId, unit: units[index]);
            },
          );
        },
      ),
    );
  }
}

class _UnitMeterCard extends ConsumerWidget {
  const _UnitMeterCard({required this.groundId, required this.unit});

  final String groundId;
  final RentalUnit unit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meterAsync = ref.watch(activeMeterProvider(groundId, unit.id));

    return meterAsync.when(
      loading: () => const ShimmerCard(),
      error: (e, _) => AppCard(
        leadingIcon: Icons.door_front_door_outlined,
        title: unit.name,
        subtitle: 'Error loading meter',
      ),
      data: (meter) => _buildCard(context, meter),
    );
  }

  Widget _buildCard(BuildContext context, ElectricityMeter? meter) {
    if (meter == null) {
      return AppCard(
        leadingIcon: Icons.door_front_door_outlined,
        title: unit.name,
        subtitle: 'No meter registered',
        trailing: FilledButton.tonal(
          onPressed: () => context.push(
            '/grounds/$groundId/units/${unit.id}/meter/register',
          ),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('Register'),
        ),
      );
    }

    final lastReadingText = meter.lastReadingDate != null
        ? 'Last read: ${DateFormat('dd/MM/yyyy').format(meter.lastReadingDate!)}'
        : 'No readings yet';

    return AppCard(
      leadingIcon: Icons.electric_meter_outlined,
      title: unit.name,
      subtitle:
          '${meter.meterNumber} · ${meter.currentReading.toStringAsFixed(1)} units\n$lastReadingText',
      showChevron: true,
      onTap: () => context.push(
        '/grounds/$groundId/units/${unit.id}/meter/register',
        extra: meter,
      ),
    );
  }
}
