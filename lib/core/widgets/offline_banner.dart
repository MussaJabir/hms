import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class OfflineBanner extends ConsumerStatefulWidget {
  const OfflineBanner({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends ConsumerState<OfflineBanner> {
  // null = not yet received, true = online, false = offline
  bool? _isOnline;
  bool _isSyncing = false;
  Timer? _syncTimer;

  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }

  void _handleConnectivityChange(bool isOnline) {
    if (_isOnline == false && isOnline) {
      // Transitioning offline → online: show syncing briefly
      setState(() {
        _isOnline = true;
        _isSyncing = true;
      });
      _syncTimer?.cancel();
      _syncTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isSyncing = false);
        }
      });
    } else {
      setState(() {
        _isOnline = isOnline;
        if (isOnline) _isSyncing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<bool>>(connectivityProvider, (_, next) {
      next.whenData(_handleConnectivityChange);
    });

    final showOffline = _isOnline == false;
    final showSyncing = _isOnline == true && _isSyncing;

    Widget? banner;
    if (showOffline) {
      banner = const _OfflineBannerContent(key: ValueKey('offline'));
    } else if (showSyncing) {
      banner = const _SyncingBanner(key: ValueKey('syncing'));
    }

    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, -1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  ),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: banner ?? const SizedBox.shrink(key: ValueKey('none')),
        ),
        Expanded(child: widget.child),
      ],
    );
  }
}

class _OfflineBannerContent extends StatelessWidget {
  const _OfflineBannerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        width: double.infinity,
        color: AppColors.warning,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.cloud_off, size: 16, color: AppColors.textPrimary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                'You are offline — changes will sync when connection is restored',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SyncingBanner extends StatefulWidget {
  const _SyncingBanner({super.key});

  @override
  State<_SyncingBanner> createState() => _SyncingBannerState();
}

class _SyncingBannerState extends State<_SyncingBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        width: double.infinity,
        color: AppColors.primaryLight,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.md,
        ),
        child: Row(
          children: [
            RotationTransition(
              turns: _controller,
              child: const Icon(Icons.sync, size: 16, color: Colors.white),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Syncing...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
