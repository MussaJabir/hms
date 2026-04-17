import 'package:hms/core/services/services.dart';
import 'package:hms/features/electricity/models/reminder_config.dart';
import 'package:hms/features/electricity/providers/meter_providers.dart';
import 'package:hms/features/electricity/services/meter_reminder_service.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';
import 'package:hms/features/grounds/providers/rental_unit_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reminder_providers.g.dart';

@riverpod
Future<MeterReminderService> meterReminderService(Ref ref) async {
  final notificationService = await ref.watch(
    notificationServiceProvider.future,
  );
  return MeterReminderService(
    ref.watch(firestoreServiceProvider),
    notificationService,
    ref.watch(groundServiceProvider),
    ref.watch(rentalUnitServiceProvider),
    ref.watch(meterServiceProvider),
    ref.watch(activityLogServiceProvider),
  );
}

@riverpod
Future<ReminderConfig> reminderConfig(Ref ref) async {
  final svc = await ref.watch(meterReminderServiceProvider.future);
  return svc.getConfig();
}

@riverpod
Future<int> pendingReadingsCount(Ref ref) async {
  final svc = await ref.watch(meterReminderServiceProvider.future);
  return svc.getPendingReadingsCount();
}
