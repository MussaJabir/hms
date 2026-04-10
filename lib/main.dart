import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/router/app_router.dart';
import 'package:hms/core/theme/theme.dart';
import 'package:hms/features/rent/providers/rent_generation_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(const ProviderScope(child: HmsApp()));
}

class HmsApp extends ConsumerWidget {
  const HmsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    // Auto-generate rent records for the current month on every startup.
    // Idempotent — only creates records that don't exist yet.
    ref.listen<AsyncValue>(authStateProvider, (prev, next) {
      final uid = next.asData?.value?.uid;
      if (uid != null && prev?.asData?.value?.uid == null) {
        // User just signed in — trigger generation in the background.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final svc = ref.read(rentGenerationServiceProvider);
          svc.generateCurrentMonth(userId: uid).catchError((e) {
            debugPrint('Auto rent generation failed: $e');
            return 0;
          });
        });
      }
    });

    return MaterialApp.router(
      title: 'HMS',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
