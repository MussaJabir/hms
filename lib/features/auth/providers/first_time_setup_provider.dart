import 'dart:async';

import 'package:hms/core/services/services.dart';
import 'package:hms/features/auth/providers/user_providers.dart';
import 'package:hms/features/auth/services/first_time_setup_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'first_time_setup_provider.g.dart';

@riverpod
FirstTimeSetupService firstTimeSetupService(Ref ref) {
  final auth = ref.watch(authServiceProvider);
  final users = ref.watch(userServiceProvider);
  return FirstTimeSetupService(auth, users);
}

@riverpod
Future<bool> isFirstTimeSetup(Ref ref) async {
  try {
    return await ref
        .watch(firstTimeSetupServiceProvider)
        .isFirstTimeSetup()
        .timeout(const Duration(seconds: 5));
  } on TimeoutException {
    // Can't confirm no Super Admin exists — assume one does and show login.
    return false;
  }
}
