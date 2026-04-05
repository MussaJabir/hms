import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';
import 'package:hms/features/grounds/providers/rental_unit_providers.dart';

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
              final unit = units[index];
              final status = unit.isOccupied
                  ? PaymentStatus.active
                  : PaymentStatus.vacant;

              return AppCard(
                leadingIcon: Icons.door_front_door_outlined,
                title: unit.name,
                subtitle: '${formatTZS(unit.rentAmount)} /month',
                trailing: StatusBadge(status: status),
                showChevron: true,
                onTap: () {
                  // Unit detail screen comes in the tenant branch.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Unit details coming in the next phase.'),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
