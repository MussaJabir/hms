import 'package:flutter/material.dart';
import 'package:hms/core/theme/app_colors.dart';
import 'package:hms/core/theme/app_spacing.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.home_work_rounded,
              size: 64,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Home Management System',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
