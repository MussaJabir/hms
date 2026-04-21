import 'package:hms/features/dashboard/models/health_score.dart';
import 'package:hms/features/dashboard/services/health_score_service.dart';
import 'package:hms/features/rent/providers/rent_summary_providers.dart';
import 'package:hms/features/water/providers/water_summary_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'health_score_provider.g.dart';

@riverpod
HealthScoreService healthScoreService(Ref ref) {
  return const HealthScoreService();
}

/// Health score computed with real rent and water bills data.
///
/// Watches async providers and falls back to 0 while loading/error,
/// so the card always renders synchronously.
@riverpod
HealthScore healthScore(Ref ref) {
  final service = ref.watch(healthScoreServiceProvider);

  final rate =
      ref.watch(currentMonthCollectionRateProvider).asData?.value ?? 0.0;
  final hasRentRecords = rate > 0;

  // Bills score: unpaid count 0 → 100, each unpaid bill deducts points.
  // If no bills this month, billsActive = false (module excluded from score).
  final overdueBills = ref.watch(overdueWaterBillsProvider).asData?.value ?? [];
  final unpaidCount =
      ref.watch(unpaidWaterBillsCountProvider).asData?.value ?? 0;

  // billsActive when there's any unpaid/overdue bills data loaded.
  final billsActive = overdueBills.isNotEmpty || unpaidCount > 0;
  // 100 when no overdue bills, 0 per overdue bill (clamped at 0).
  final billsRate = (100.0 - overdueBills.length * 25.0)
      .clamp(0.0, 100.0)
      .toDouble();

  return service.buildScore(
    rentRate: rate,
    rentActive: hasRentRecords,
    billsRate: billsRate,
    billsActive: billsActive,
  );
}
