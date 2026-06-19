import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/services/services.dart';
import 'package:hms/features/finance/models/income.dart';
import 'package:hms/features/finance/services/income_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'income_providers.g.dart';

/// Current calendar month as a "yyyy-MM" period string.
String currentIncomePeriod() {
  final now = DateTime.now();
  final mm = now.month.toString().padLeft(2, '0');
  return '${now.year}-$mm';
}

@riverpod
IncomeService incomeService(Ref ref) {
  return IncomeService(
    ref.watch(firestoreServiceProvider),
    ref.watch(activityLogServiceProvider),
  );
}

/// Streams every income entry, newest first.
@riverpod
Stream<List<Income>> allIncome(Ref ref) {
  return ref.watch(incomeServiceProvider).streamAllIncome();
}

/// Streams income for the current calendar month.
@riverpod
Stream<List<Income>> currentMonthIncome(Ref ref) {
  return ref
      .watch(incomeServiceProvider)
      .streamIncomeForMonth(currentIncomePeriod());
}

/// Total income for the current month, scoped to the selected ground.
@riverpod
Future<double> currentMonthIncomeTotal(Ref ref) {
  final groundId = ref.watch(currentGroundProvider);
  return ref
      .watch(incomeServiceProvider)
      .getCurrentMonthTotal(groundId: groundId);
}

/// Income grouped by source value for a given "yyyy-MM" period.
@riverpod
Future<Map<String, double>> incomeBySource(Ref ref, String period) {
  return ref.watch(incomeServiceProvider).getIncomeBySourceForPeriod(period);
}
