import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/theme/theme.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';

class GroundsSelector extends ConsumerWidget {
  const GroundsSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groundsAsync = ref.watch(allGroundsProvider);
    final selectedId = ref.watch(currentGroundProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return groundsAsync.when(
      loading: () => const SizedBox(height: 48),
      error: (e, st) => const SizedBox.shrink(),
      data: (grounds) {
        // No grounds yet — show "Add Property" prompt instead of selector
        if (grounds.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
              vertical: AppSpacing.sm,
            ),
            child: OutlinedButton.icon(
              onPressed: () => context.push('/grounds/add'),
              icon: const Icon(Icons.add_home_outlined, size: 18),
              label: const Text('Add Property'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
            ),
          );
        }

        // Build chip list: "All" + one per ground
        final chips = <({String? id, String label})>[
          (id: null, label: 'All'),
          ...grounds.map((g) => (id: g.id, label: g.name)),
        ];

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.sm,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: chips.asMap().entries.map((entry) {
                final index = entry.key;
                final chip = entry.value;
                final isSelected = selectedId == chip.id;
                return Padding(
                  padding: EdgeInsets.only(
                    right: index < chips.length - 1 ? AppSpacing.xs : 0,
                  ),
                  child: _GroundChip(
                    label: chip.label,
                    isSelected: isSelected,
                    isDark: isDark,
                    onTap: () => ref
                        .read(currentGroundProvider.notifier)
                        .select(chip.id),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class _GroundChip extends StatelessWidget {
  const _GroundChip({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selectedBg = AppColors.primary;
    final unselectedBg = isDark ? AppColors.darkSurface : AppColors.surface;
    final selectedBorder = AppColors.primary;
    final unselectedBorder = isDark ? AppColors.darkBorder : AppColors.border;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : unselectedBg,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
          border: Border.all(
            color: isSelected ? selectedBorder : unselectedBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? Colors.white
                : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
