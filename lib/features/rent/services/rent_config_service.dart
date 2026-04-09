import 'package:hms/core/models/recurring_config.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';

class RentConfigService {
  RentConfigService(this._recurringService);

  final RecurringTransactionService _recurringService;

  /// Returns the active rent config for the given tenant, or null if none exists.
  Future<RecurringConfig?> getConfigForTenant(String tenantId) async {
    final configs = await _recurringService.getActiveConfigs(type: 'rent');
    return configs.where((c) => c.linkedEntityId == tenantId).firstOrNull;
  }

  /// Returns all active rent configs across all tenants.
  Future<List<RecurringConfig>> getAllActiveRentConfigs() {
    return _recurringService.getActiveConfigs(type: 'rent');
  }

  /// Updates the rent amount on the active config for a tenant.
  /// No-op if no active config is found.
  Future<void> updateRentAmount({
    required String tenantId,
    required double newAmount,
    required String userId,
  }) async {
    final config = await getConfigForTenant(tenantId);
    if (config == null) return;
    await _recurringService.updateConfig(
      configId: config.id,
      updates: {'amount': newAmount},
      userId: userId,
    );
  }
}
