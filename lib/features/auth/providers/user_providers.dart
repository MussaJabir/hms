import 'package:hms/core/models/models.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/services/services.dart';
import 'package:hms/features/auth/services/user_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_providers.g.dart';

@riverpod
UserService userService(Ref ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  final activityLog = ref.watch(activityLogServiceProvider);
  return UserService(firestore, activityLog);
}

/// Streams the current logged-in user's Firestore profile.
/// Returns null when not authenticated.
@riverpod
Stream<AppUser?> currentUserProfile(Ref ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return ref.watch(userServiceProvider).streamUserProfile(user.uid);
    },
    loading: () => Stream.value(null),
    error: (_, e) => Stream.value(null),
  );
}

/// Streams all user profiles (for user management screen).
@riverpod
Stream<List<AppUser>> allUsers(Ref ref) {
  return ref.watch(userServiceProvider).streamAllUsers();
}

/// Returns true if the current user is Super Admin.
@riverpod
Future<bool> isSuperAdmin(Ref ref) async {
  final profile = await ref.watch(currentUserProfileProvider.future);
  return profile?.isSuperAdmin ?? false;
}

/// Streams a specific user's profile by userId in real-time.
@riverpod
Stream<AppUser?> userProfile(Ref ref, String userId) {
  return ref.watch(userServiceProvider).streamUserProfile(userId);
}
