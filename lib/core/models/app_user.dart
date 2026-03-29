import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
abstract class AppUser with _$AppUser {
  const AppUser._();

  const factory AppUser({
    required String id,
    required String email,
    required String displayName,
    required String role, // "superAdmin" or "admin"
    required DateTime createdAt,
    required DateTime updatedAt,
    required String updatedBy,
    @Default(1) int schemaVersion,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  bool get isSuperAdmin => role == 'superAdmin';
  bool get isAdmin => role == 'admin';
}
