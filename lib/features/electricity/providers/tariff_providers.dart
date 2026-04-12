import 'package:hms/core/models/app_config.dart';
import 'package:hms/core/services/services.dart';
import 'package:hms/features/electricity/services/tariff_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tariff_providers.g.dart';

@riverpod
TariffService tariffService(Ref ref) {
  return TariffService(
    ref.watch(firestoreServiceProvider),
    ref.watch(activityLogServiceProvider),
  );
}

/// Streams the current TANESCO tariff tiers in real time.
/// Emits an empty list when no configuration has been saved yet.
@riverpod
Stream<List<TanescoTier>> currentTariffs(Ref ref) {
  return ref.watch(tariffServiceProvider).streamTariffs();
}

/// Calculates the estimated electricity cost for [unitsConsumed].
@riverpod
Future<double> calculateCost(Ref ref, double unitsConsumed) {
  return ref.watch(tariffServiceProvider).calculateCost(unitsConsumed);
}
