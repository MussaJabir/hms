import 'package:hms/core/services/services.dart';
import 'package:hms/features/rent/services/rent_generation_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rent_generation_providers.g.dart';

@riverpod
RentGenerationService rentGenerationService(Ref ref) {
  return RentGenerationService(
    ref.watch(recurringTransactionServiceProvider),
    ref.watch(activityLogServiceProvider),
  );
}

/// Returns true when at least one rent record exists for the current month.
@riverpod
Future<bool> isCurrentMonthGenerated(Ref ref) {
  return ref.watch(rentGenerationServiceProvider).isCurrentMonthGenerated();
}
