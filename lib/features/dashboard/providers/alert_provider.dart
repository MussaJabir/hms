import 'package:hms/core/providers/providers.dart';
import 'package:hms/features/dashboard/models/dashboard_alert.dart';
import 'package:hms/features/dashboard/services/alert_generator_service.dart';
import 'package:hms/features/electricity/providers/alert_providers.dart';
import 'package:hms/features/electricity/providers/electricity_summary_providers.dart';
import 'package:hms/features/rent/providers/rent_summary_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'alert_provider.g.dart';

@riverpod
AlertGeneratorService alertGeneratorService(Ref ref) {
  return AlertGeneratorService(
    ref.watch(rentSummaryServiceProvider),
    ref.watch(consumptionAlertServiceProvider),
    ref.watch(electricitySummaryServiceProvider),
  );
}

/// Async provider — returns real alerts from all module generators.
/// Re-runs when the selected ground changes.
@riverpod
Future<List<DashboardAlert>> alerts(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(alertGeneratorServiceProvider)
      .getAllAlerts(groundId: groundId);
}
