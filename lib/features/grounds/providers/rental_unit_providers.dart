import 'package:hms/core/services/services.dart';
import 'package:hms/features/grounds/models/rental_unit.dart';
import 'package:hms/features/grounds/services/rental_unit_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rental_unit_providers.g.dart';

@riverpod
RentalUnitService rentalUnitService(Ref ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  final activityLog = ref.watch(activityLogServiceProvider);
  return RentalUnitService(firestore, activityLog);
}

@riverpod
Stream<List<RentalUnit>> allUnits(Ref ref, String groundId) {
  return ref.watch(rentalUnitServiceProvider).streamAllUnits(groundId);
}

@riverpod
Stream<RentalUnit?> unitById(Ref ref, String groundId, String unitId) {
  return ref
      .watch(rentalUnitServiceProvider)
      .streamAllUnits(groundId)
      .map((units) => units.where((u) => u.id == unitId).firstOrNull);
}

@riverpod
Future<int> unitCount(Ref ref, String groundId) {
  return ref.watch(rentalUnitServiceProvider).getUnitCount(groundId);
}

@riverpod
Future<List<RentalUnit>> vacantUnits(Ref ref, String groundId) {
  return ref.watch(rentalUnitServiceProvider).getVacantUnits(groundId);
}
