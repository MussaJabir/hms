import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hms/core/models/notification_type.dart';
import 'package:hms/core/services/services.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/auth/providers/user_providers.dart';
import 'package:hms/features/electricity/models/reminder_config.dart';
import 'package:hms/features/electricity/providers/reminder_providers.dart';
import 'package:hms/features/electricity/services/meter_reminder_service.dart';

class MeterReminderSettingsScreen extends ConsumerStatefulWidget {
  const MeterReminderSettingsScreen({super.key});

  @override
  ConsumerState<MeterReminderSettingsScreen> createState() =>
      _MeterReminderSettingsScreenState();
}

class _MeterReminderSettingsScreenState
    extends ConsumerState<MeterReminderSettingsScreen> {
  bool? _enabled;
  int? _dayOfWeek;
  TimeOfDay? _time;
  bool _saving = false;
  bool _initialised = false;

  static const List<String> _dayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  void _initFromConfig(ReminderConfig config) {
    if (_initialised) return;
    _initialised = true;
    _enabled = config.enabled;
    _dayOfWeek = config.dayOfWeek;
    _time = TimeOfDay(hour: config.hour, minute: config.minute);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 18, minute: 0),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      setState(() => _time = picked);
    }
  }

  Future<void> _save(ReminderConfig current) async {
    final uid = ref.read(currentUserProfileProvider).asData?.value?.id;
    if (uid == null) return;

    setState(() => _saving = true);
    try {
      final svc = await ref.read(meterReminderServiceProvider.future);
      final resolvedTime =
          _time ?? TimeOfDay(hour: current.hour, minute: current.minute);
      final updated = current.copyWith(
        enabled: _enabled ?? current.enabled,
        dayOfWeek: _dayOfWeek ?? current.dayOfWeek,
        hour: resolvedTime.hour,
        minute: resolvedTime.minute,
        updatedAt: DateTime.now(),
        updatedBy: uid,
      );
      await svc.updateConfig(config: updated, userId: uid);
      await svc.scheduleReminder();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Reminder updated')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _testNotification() async {
    final uid = ref.read(currentUserProfileProvider).asData?.value?.id;
    if (uid == null) return;

    try {
      final svc = await ref.read(meterReminderServiceProvider.future);
      final pending = await svc.getPendingReadingsCount();
      final notifSvc = await ref.read(notificationServiceProvider.future);
      final body = pending > 0
          ? 'Time to check meters — $pending rooms pending'
          : "Time to record this week's meter readings";
      await notifSvc.showImmediateNotification(
        notificationId: MeterReminderService.notificationId,
        type: NotificationType.meterReading,
        title: 'Meter Reading Reminder (Test)',
        body: body,
        userId: uid,
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Test notification sent')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final configAsync = ref.watch(reminderConfigProvider);
    final pendingAsync = ref.watch(pendingReadingsCountProvider);
    final isSuperAdmin =
        ref.watch(currentUserProfileProvider).asData?.value?.isSuperAdmin ??
        false;

    return Scaffold(
      appBar: AppBar(title: const Text('Meter Reading Reminder')),
      body: configAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: ShimmerList(itemCount: 4),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
        ),
        data: (config) {
          _initFromConfig(config);
          final enabled = _enabled ?? config.enabled;
          final day = _dayOfWeek ?? config.dayOfWeek;
          final time =
              _time ?? TimeOfDay(hour: config.hour, minute: config.minute);
          final dayName = _dayNames[day - 1];
          final timeStr =
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
          final pending = pendingAsync.asData?.value;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Enable toggle ──────────────────────────────────────────
                AppCard(
                  title: 'Enable Reminder',
                  subtitle: enabled
                      ? 'Weekly reminder is active'
                      : 'Reminder is disabled',
                  trailing: Switch(
                    value: enabled,
                    onChanged: (v) => setState(() => _enabled = v),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // ── Day & time (grayed when disabled) ──────────────────────
                Opacity(
                  opacity: enabled ? 1.0 : 0.4,
                  child: AbsorbPointer(
                    absorbing: !enabled,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DropdownButtonFormField<int>(
                          initialValue: day,
                          decoration: const InputDecoration(
                            labelText: 'Day of Week',
                            border: OutlineInputBorder(),
                          ),
                          items: List.generate(7, (i) {
                            return DropdownMenuItem(
                              value: i + 1,
                              child: Text(_dayNames[i]),
                            );
                          }),
                          onChanged: (v) {
                            if (v != null) setState(() => _dayOfWeek = v);
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        InkWell(
                          onTap: _pickTime,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.borderRadius,
                          ),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Time',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.access_time),
                            ),
                            child: Text(timeStr),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── Preview ────────────────────────────────────────────────
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Preview',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          enabled
                              ? 'Next reminder: $dayName, $timeStr'
                              : 'Reminder disabled — no notifications scheduled',
                          style: theme.textTheme.bodyMedium,
                        ),
                        if (pending != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '$pending room${pending == 1 ? '' : 's'} currently have active meters',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // ── Save ───────────────────────────────────────────────────
                FilledButton(
                  onPressed: _saving ? null : () => _save(config),
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),

                // ── Test notification (Super Admin only) ───────────────────
                if (isSuperAdmin) ...[
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton.icon(
                    onPressed: _testNotification,
                    icon: const Icon(
                      Icons.notifications_active_outlined,
                      size: 18,
                    ),
                    label: const Text('Test Notification'),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
