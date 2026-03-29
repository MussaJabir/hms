import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'activity_log_service_provider.g.dart';

@riverpod
ActivityLogService activityLogService(Ref ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  return ActivityLogService(firestore);
}
