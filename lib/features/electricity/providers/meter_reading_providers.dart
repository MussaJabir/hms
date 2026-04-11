import 'package:hms/core/services/services.dart';
import 'package:hms/features/electricity/models/meter_reading.dart';
import 'package:hms/features/electricity/providers/meter_providers.dart';
import 'package:hms/features/electricity/services/meter_reading_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'meter_reading_providers.g.dart';

@riverpod
MeterReadingService meterReadingService(Ref ref) {
  return MeterReadingService(
    ref.watch(firestoreServiceProvider),
    ref.watch(meterServiceProvider),
    ref.watch(activityLogServiceProvider),
  );
}

/// Fetches the latest reading for a meter.
@riverpod
Future<MeterReading?> latestReading(
  Ref ref,
  String groundId,
  String unitId,
  String meterId,
) {
  return ref
      .watch(meterReadingServiceProvider)
      .getLatestReading(groundId: groundId, unitId: unitId, meterId: meterId);
}

/// Streams all readings for a meter, newest first.
@riverpod
Stream<List<MeterReading>> readings(
  Ref ref,
  String groundId,
  String unitId,
  String meterId,
) {
  return ref
      .watch(meterReadingServiceProvider)
      .streamReadings(groundId: groundId, unitId: unitId, meterId: meterId);
}
