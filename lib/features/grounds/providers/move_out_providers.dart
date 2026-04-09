import 'package:hms/core/services/services.dart';
import 'package:hms/features/grounds/models/settlement.dart';
import 'package:hms/features/grounds/providers/rental_unit_providers.dart';
import 'package:hms/features/grounds/services/move_out_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'move_out_providers.g.dart';

@riverpod
MoveOutService moveOutService(Ref ref) {
  return MoveOutService(
    ref.watch(firestoreServiceProvider),
    ref.watch(rentalUnitServiceProvider),
    ref.watch(recurringTransactionServiceProvider),
    ref.watch(activityLogServiceProvider),
  );
}

@riverpod
Future<List<Settlement>> settlements(Ref ref, String groundId, String unitId) {
  return ref.watch(moveOutServiceProvider).getSettlements(groundId, unitId);
}
