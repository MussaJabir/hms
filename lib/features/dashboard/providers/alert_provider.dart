import 'package:hms/core/providers/providers.dart';
import 'package:hms/features/dashboard/models/dashboard_alert.dart';
import 'package:hms/features/dashboard/services/alert_generator_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'alert_provider.g.dart';

@riverpod
List<DashboardAlert> alerts(Ref ref) {
  // Watch the selected ground so the provider re-computes on ground change.
  // When real module data is wired up, each generator will receive groundId
  // and return only alerts relevant to that ground.
  final groundId = ref.watch(currentGroundProvider);

  final service = const AlertGeneratorService();
  final generated = service.getAllAlerts(groundId: groundId);

  // Use sample alerts until real data modules are wired up.
  if (generated.isEmpty) {
    return sampleAlerts(groundId: groundId);
  }
  return generated;
}
