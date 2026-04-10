import 'package:flutter/material.dart';
import 'package:hms/core/theme/theme.dart';
import 'package:hms/core/utils/currency_formatter.dart';

/// Three quick-select buttons: Full, Half, Custom.
/// Tapping Full or Half calls [onAmountSelected] with the value.
/// Tapping Custom calls [onAmountSelected] with 0 (signals clear-for-entry).
class QuickAmountButtons extends StatelessWidget {
  const QuickAmountButtons({
    super.key,
    required this.fullAmount,
    required this.onAmountSelected,
  });

  final double fullAmount;
  final ValueChanged<double> onAmountSelected;

  @override
  Widget build(BuildContext context) {
    final half = fullAmount / 2;

    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: () => onAmountSelected(fullAmount),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Full',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Text(
                  formatTZS(fullAmount, short: true),
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: OutlinedButton(
            onPressed: () => onAmountSelected(half),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Half',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Text(
                  formatTZS(half, short: true),
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: OutlinedButton(
            onPressed: () => onAmountSelected(0),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSm),
              ),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Custom',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Text('Enter', style: TextStyle(fontSize: 11)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
