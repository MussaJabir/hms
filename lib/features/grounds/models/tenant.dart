import 'package:freezed_annotation/freezed_annotation.dart';

part 'tenant.freezed.dart';
part 'tenant.g.dart';

@freezed
abstract class Tenant with _$Tenant {
  const Tenant._();

  const factory Tenant({
    required String id,
    required String groundId,
    required String unitId,
    required String fullName,
    required String phoneNumber,
    String? nationalId,
    required DateTime moveInDate,
    DateTime? leaseEndDate,
    @Default('') String notes,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String updatedBy,
    @Default(1) int schemaVersion,
  }) = _Tenant;

  factory Tenant.fromJson(Map<String, dynamic> json) => _$TenantFromJson(json);

  bool get hasLeaseExpired =>
      leaseEndDate != null && leaseEndDate!.isBefore(DateTime.now());

  bool get hasNationalId => nationalId != null && nationalId!.isNotEmpty;
}
