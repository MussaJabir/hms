import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hms/core/theme/theme.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/auth/providers/user_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isSuperAdminAsync = ref.watch(isSuperAdminProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('HMS'),
        actions: const [
          ConnectionStatus(compact: true),
          SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: OfflineBanner(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Home Management System',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Your household, organized.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
              // Temporary Super Admin navigation — replaced by Dashboard in Phase 2
              isSuperAdminAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (e, _) => const SizedBox.shrink(),
                data: (isSuperAdmin) {
                  if (!isSuperAdmin) return const SizedBox.shrink();
                  return Column(
                    children: [
                      const SizedBox(height: AppSpacing.xl),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.group_outlined),
                        label: const Text('Manage Users'),
                        onPressed: () => context.push('/users'),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
