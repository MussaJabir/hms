import 'package:hms/core/services/auth_service.dart';

import 'user_service.dart';

class FirstTimeSetupService {
  FirstTimeSetupService(this._authService, this._userService);

  final AuthService _authService;
  final UserService _userService;

  /// Returns true if no Super Admin exists — app needs initial setup.
  Future<bool> isFirstTimeSetup() async {
    final exists = await _userService.superAdminExists();
    return !exists;
  }

  /// Creates the initial Super Admin account.
  /// This is the only self-registration path — all other accounts are
  /// created by the Super Admin after this point.
  Future<void> createSuperAdmin({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final user = await _authService.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _authService.updateDisplayName(displayName);

    await _userService.createUserProfile(
      userId: user.uid,
      email: email,
      displayName: displayName,
      role: 'superAdmin',
      createdBy: user.uid,
    );
  }
}
