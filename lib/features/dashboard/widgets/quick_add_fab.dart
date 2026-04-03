import 'package:flutter/material.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/features/dashboard/widgets/quick_add_bottom_sheet.dart';

class QuickAddFab extends StatelessWidget {
  const QuickAddFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showSheet(context),
      tooltip: 'Quick Add',
      child: const Icon(Icons.add),
    );
  }

  void _showSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.borderRadiusLg),
        ),
      ),
      builder: (_) => const QuickAddBottomSheet(),
    );
  }
}
