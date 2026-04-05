import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';

class GroundsListScreen extends ConsumerWidget {
  const GroundsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groundsAsync = ref.watch(allGroundsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Properties'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Property',
            onPressed: () => context.push('/grounds/add'),
          ),
        ],
      ),
      body: groundsAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: ShimmerList(itemCount: 4),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
        ),
        data: (grounds) {
          if (grounds.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: EmptyStatePresets.noGrounds(
                  onAdd: () => context.push('/grounds/add'),
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: grounds.length,
            separatorBuilder: (ctx, idx) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final ground = grounds[index];
              return AppCard(
                leadingIcon: Icons.home_work_outlined,
                title: ground.name,
                subtitle: ground.location,
                trailingText: '${ground.numberOfUnits} units',
                showChevron: true,
                onTap: () => context.push('/grounds/${ground.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
