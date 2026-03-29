import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/utils/time_ago.dart';
import 'package:intl/intl.dart';

void main() {
  group('timeAgo', () {
    test('returns "Just now" for less than 1 minute ago', () {
      final dt = DateTime.now().subtract(const Duration(seconds: 30));
      expect(timeAgo(dt), 'Just now');
    });

    test('returns "X min ago" for 1 minute ago', () {
      final dt = DateTime.now().subtract(const Duration(minutes: 1));
      expect(timeAgo(dt), '1 min ago');
    });

    test('returns "X min ago" for 45 minutes ago', () {
      final dt = DateTime.now().subtract(const Duration(minutes: 45));
      expect(timeAgo(dt), '45 min ago');
    });

    test('returns "X min ago" for 59 minutes ago', () {
      final dt = DateTime.now().subtract(const Duration(minutes: 59));
      expect(timeAgo(dt), '59 min ago');
    });

    test('returns "1 hour ago" for exactly 1 hour ago', () {
      final dt = DateTime.now().subtract(const Duration(hours: 1));
      expect(timeAgo(dt), '1 hour ago');
    });

    test('returns "X hours ago" for 3 hours ago', () {
      final dt = DateTime.now().subtract(const Duration(hours: 3));
      expect(timeAgo(dt), '3 hours ago');
    });

    test('returns "X hours ago" for 23 hours ago', () {
      final dt = DateTime.now().subtract(const Duration(hours: 23));
      expect(timeAgo(dt), '23 hours ago');
    });

    test('returns "Yesterday" for 24 hours ago', () {
      final dt = DateTime.now().subtract(const Duration(hours: 24));
      expect(timeAgo(dt), 'Yesterday');
    });

    test('returns "Yesterday" for 47 hours ago', () {
      final dt = DateTime.now().subtract(const Duration(hours: 47));
      expect(timeAgo(dt), 'Yesterday');
    });

    test('returns "X days ago" for 2 days ago', () {
      final dt = DateTime.now().subtract(const Duration(days: 2));
      expect(timeAgo(dt), '2 days ago');
    });

    test('returns "X days ago" for 6 days ago', () {
      final dt = DateTime.now().subtract(const Duration(days: 6));
      expect(timeAgo(dt), '6 days ago');
    });

    test('returns "dd/MM/yyyy" format for exactly 7 days ago', () {
      final dt = DateTime.now().subtract(const Duration(days: 7));
      expect(timeAgo(dt), DateFormat('dd/MM/yyyy').format(dt));
    });

    test('returns "dd/MM/yyyy" format for 30 days ago', () {
      final dt = DateTime.now().subtract(const Duration(days: 30));
      expect(timeAgo(dt), DateFormat('dd/MM/yyyy').format(dt));
    });
  });
}
