import 'package:hms/features/dashboard/models/health_score.dart';
import 'package:hms/features/dashboard/services/health_score_service.dart';
import 'package:hms/features/finance/providers/budget_providers.dart';
import 'package:hms/features/rent/providers/rent_summary_providers.dart';
import 'package:hms/features/water/providers/water_summary_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'health_score_provider.g.dart';

@riverpod
HealthScoreService healthScoreService(Ref ref) {
  return const HealthScoreService();
}

/// Health score computed with real rent, water bills, overdue, and budget data.
///
/// Watches async providers and falls back to sensible defaults while
/// loading/error, so the card always renders synchronously.
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

  // Overdue score: aggregate overdue items across rent, water, and budget.
  final overdueRent = ref.watch(overdueRentCountProvider).asData?.value ?? 0;
  final overBudgets = ref.watch(overBudgetsProvider).asData?.value ?? [];
  final overdueCount = overdueRent + overdueBills.length + overBudgets.length;
  final overdueScore = service.scoreFromOverdueCount(overdueCount);
  // Active once any of the contributing modules have data.
  final overdueActive = hasRentRecords || billsActive;

  // Budget score from compliance; active when any budget exists this month.
  final budgets = ref.watch(currentMonthBudgetsProvider).asData?.value ?? [];
  final budgetScore =
      ref.watch(budgetComplianceScoreProvider).asData?.value ?? 0.0;
  final budgetActive = budgets.isNotEmpty;

  return service.buildScore(
    rentRate: rate,
    rentActive: hasRentRecords,
    billsRate: billsRate,
    billsActive: billsActive,
    overdueScore: overdueScore,
    overdueActive: overdueActive,
    budgetScore: budgetScore,
    budgetActive: budgetActive,
  );
}
