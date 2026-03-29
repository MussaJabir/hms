import 'package:hms/core/services/firestore_service_provider.dart';
import 'package:hms/core/services/notification_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_service_provider.g.dart';

@riverpod
Future<NotificationService> notificationService(Ref ref) async {
  final firestore = ref.watch(firestoreServiceProvider);
  final service = NotificationService(firestore);
  await service.initialize();
  return service;
}
