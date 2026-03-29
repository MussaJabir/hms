import 'package:hms/core/services/activity_log_service_provider.dart';
import 'package:hms/core/services/data_migration_service.dart';
import 'package:hms/core/services/firestore_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_migration_service_provider.g.dart';

@riverpod
DataMigrationService dataMigrationService(Ref ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  final activityLog = ref.watch(activityLogServiceProvider);
  return DataMigrationService(firestore, activityLog);
}
