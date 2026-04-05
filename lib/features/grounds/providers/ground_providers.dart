import 'package:hms/core/models/ground.dart';
import 'package:hms/core/services/services.dart';
import 'package:hms/features/grounds/services/ground_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ground_providers.g.dart';

@riverpod
GroundService groundService(Ref ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  final activityLog = ref.watch(activityLogServiceProvider);
  return GroundService(firestore, activityLog);
}

@riverpod
Stream<List<Ground>> allGrounds(Ref ref) {
  return ref.watch(groundServiceProvider).streamAllGrounds();
}

@riverpod
Stream<Ground?> groundById(Ref ref, String groundId) {
  return ref.watch(groundServiceProvider).streamGround(groundId);
}
