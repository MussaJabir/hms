import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hms/core/models/models.dart';
import 'package:hms/core/services/services.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/utils/time_ago.dart';
import 'package:hms/core/widgets/widgets.dart';

class UserActivityLogScreen extends ConsumerWidget {
  const UserActivityLogScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  final String userId;
  final String userName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Activity Log — $userName')),
      body: OfflineBanner(child: _ActivityLogBody(userId: userId)),
    );
  }
}

class _ActivityLogBody extends ConsumerStatefulWidget {
  const _ActivityLogBody({required this.userId});

  final String userId;

  @override
  ConsumerState<_ActivityLogBody> createState() => _ActivityLogBodyState();
}

class _ActivityLogBodyState extends ConsumerState<_ActivityLogBody> {
  late Future<List<ActivityLog>> _logsFuture;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  void _loadLogs() {
    _logsFuture = ref
        .read(activityLogServiceProvider)
        .getByUser(userId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ActivityLog>>(
      future: _logsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ShimmerList(itemCount: 6);
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Failed to load activity logs'),
                const SizedBox(height: AppSpacing.sm),
                FilledButton(
                  onPressed: () => setState(_loadLogs),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final logs = snapshot.data ?? [];

        if (logs.isEmpty) {
          return EmptyStatePresets.noActivityLogs();
        }

        return ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          itemCount: logs.length,
          separatorBuilder: (context, _) =>
              const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final log = logs[index];
            return AppCard(
              leadingIcon: _iconForAction(log.action),
              title: log.description,
              subtitle:
                  '${_capitalizeModule(log.module)} module · ${timeAgo(log.createdAt)}',
            );
          },
        );
      },
    );
  }

  IconData _iconForAction(String action) {
    return switch (action) {
      'created' => Icons.add_circle_outline,
      'updated' => Icons.edit_outlined,
      'deleted' => Icons.delete_outline,
      _ => Icons.circle_outlined,
    };
  }

  String _capitalizeModule(String module) {
    if (module.isEmpty) return module;
    return module[0].toUpperCase() + module.substring(1);
  }
}
