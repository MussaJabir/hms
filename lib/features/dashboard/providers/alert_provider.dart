import 'package:hms/features/dashboard/models/dashboard_alert.dart';
import 'package:hms/features/dashboard/services/alert_generator_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'alert_provider.g.dart';

@riverpod
List<DashboardAlert> alerts(Ref ref) {
  final service = const AlertGeneratorService();
  final generated = service.getAllAlerts();

  // Use sample alerts until real data modules are wired up.
  if (generated.isEmpty) {
    return sampleAlerts();
  }
  return generated;
}
