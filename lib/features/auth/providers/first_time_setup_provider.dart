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
Future<bool> isFirstTimeSetup(Ref ref) {
  return ref.watch(firstTimeSetupServiceProvider).isFirstTimeSetup();
}
