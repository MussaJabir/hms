import 'package:flutter_test/flutter_test.dart';
import 'package:hms/features/electricity/models/reminder_config.dart';

void main() {
  final base = ReminderConfig(
    id: 'meter_reminder',
    updatedAt: DateTime(2026, 4, 17),
    updatedBy: 'user-1',
  );

  group('ReminderConfig.dayName', () {
    test('returns Monday for dayOfWeek 1', () {
      expect(base.copyWith(dayOfWeek: 1).dayName, 'Monday');
    });

    test('returns Sunday for dayOfWeek 7 (default)', () {
      expect(base.dayName, 'Sunday');
    });

    test('returns correct name for each day', () {
      const expected = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];
      for (var i = 1; i <= 7; i++) {
        expect(base.copyWith(dayOfWeek: i).dayName, expected[i - 1]);
      }
    });
  });

  group('ReminderConfig.timeFormatted', () {
    test('returns 18:00 for default (hour=18, minute=0)', () {
      expect(base.timeFormatted, '18:00');
    });

    test('pads single-digit hour and minute', () {
      expect(base.copyWith(hour: 6, minute: 5).timeFormatted, '06:05');
    });

    test('formats midnight as 00:00', () {
      expect(base.copyWith(hour: 0, minute: 0).timeFormatted, '00:00');
    });
  });
}
