import 'package:hms/core/models/recurring_config.dart';
import 'package:hms/core/services/services.dart';
import 'package:hms/features/rent/services/rent_config_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rent_config_providers.g.dart';

@riverpod
RentConfigService rentConfigService(Ref ref) {
  return RentConfigService(ref.watch(recurringTransactionServiceProvider));
}

@riverpod
Future<List<RecurringConfig>> activeRentConfigs(Ref ref) {
  return ref.watch(rentConfigServiceProvider).getAllActiveRentConfigs();
}

@riverpod
Future<RecurringConfig?> rentConfigForTenant(Ref ref, String tenantId) {
  return ref.watch(rentConfigServiceProvider).getConfigForTenant(tenantId);
}
