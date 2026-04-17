import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/services/services.dart';
import 'package:hms/features/electricity/models/consumption_warning.dart';
import 'package:hms/features/electricity/providers/meter_providers.dart';
import 'package:hms/features/electricity/providers/meter_reading_providers.dart';
import 'package:hms/features/electricity/services/consumption_alert_service.dart';
import 'package:hms/features/electricity/services/electricity_notification_service.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';
import 'package:hms/features/grounds/providers/rental_unit_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'alert_providers.g.dart';

@riverpod
ConsumptionAlertService consumptionAlertService(Ref ref) {
  return ConsumptionAlertService(
    ref.watch(meterServiceProvider),
    ref.watch(meterReadingServiceProvider),
    ref.watch(rentalUnitServiceProvider),
    ref.watch(groundServiceProvider),
  );
}

@riverpod
Future<ElectricityNotificationService> electricityNotificationService(
  Ref ref,
) async {
  final notificationService = await ref.watch(
    notificationServiceProvider.future,
  );
  return ElectricityNotificationService(
    notificationService,
    ref.watch(consumptionAlertServiceProvider),
  );
}

/// Returns all active consumption warnings, filtered by the currently selected
/// ground when one is selected.
@riverpod
Future<List<ConsumptionWarning>> activeWarnings(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(consumptionAlertServiceProvider)
      .getActiveWarnings(groundId: groundId);
}

/// Returns how many units the latest reading for a specific meter is over
/// its threshold (0 when under or when no threshold is set).
@riverpod
Future<double> overThreshold(
  Ref ref,
  String groundId,
  String unitId,
  String meterId,
) {
  return ref
      .watch(consumptionAlertServiceProvider)
      .getOverThreshold(groundId: groundId, unitId: unitId, meterId: meterId);
}
