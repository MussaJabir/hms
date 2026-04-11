import 'package:hms/features/dashboard/models/health_score.dart';
import 'package:hms/features/dashboard/services/health_score_service.dart';
import 'package:hms/features/rent/providers/rent_summary_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'health_score_provider.g.dart';

@riverpod
HealthScoreService healthScoreService(Ref ref) {
  return const HealthScoreService();
}

/// Health score computed with real rent data.
///
/// Watches [currentMonthCollectionRateProvider] (async) and falls back to 0
/// while the data is loading or on error, so the card always renders.
@riverpod
HealthScore healthScore(Ref ref) {
  final service = ref.watch(healthScoreServiceProvider);

  // Real rent data — use fallbacks while loading/error so the widget stays sync.
  final rate =
      ref.watch(currentMonthCollectionRateProvider).asData?.value ?? 0.0;
  final hasRentRecords = rate > 0;

  return service.buildScore(rentRate: rate, rentActive: hasRentRecords);
}
