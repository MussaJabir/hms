import 'package:hms/core/services/services.dart';
import 'package:hms/features/electricity/models/electricity_meter.dart';
import 'package:hms/features/electricity/services/meter_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meter_providers.g.dart';

@riverpod
MeterService meterService(Ref ref) {
  return MeterService(
    ref.watch(firestoreServiceProvider),
    ref.watch(activityLogServiceProvider),
  );
}

/// Streams the active meter for a unit in real time.
@riverpod
Stream<ElectricityMeter?> activeMeter(Ref ref, String groundId, String unitId) {
  return ref.watch(meterServiceProvider).streamActiveMeter(groundId, unitId);
}

/// Fetches all meters (including inactive history) for a unit.
@riverpod
Future<List<ElectricityMeter>> allMeters(
  Ref ref,
  String groundId,
  String unitId,
) {
  return ref.watch(meterServiceProvider).getAllMeters(groundId, unitId);
}
