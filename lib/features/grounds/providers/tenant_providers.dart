import 'package:hms/core/services/services.dart';
import 'package:hms/features/grounds/models/tenant.dart';
import 'package:hms/features/grounds/services/tenant_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tenant_providers.g.dart';

@riverpod
TenantService tenantService(Ref ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  final activityLog = ref.watch(activityLogServiceProvider);
  return TenantService(firestore, activityLog);
}

@riverpod
Stream<Tenant?> currentTenant(Ref ref, String groundId, String unitId) {
  return ref.watch(tenantServiceProvider).streamCurrentTenant(groundId, unitId);
}

@riverpod
Future<Tenant?> tenantById(
  Ref ref,
  String groundId,
  String unitId,
  String tenantId,
) {
  return ref.watch(tenantServiceProvider).getTenant(groundId, unitId, tenantId);
}
