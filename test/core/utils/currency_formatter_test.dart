import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/utils/currency_formatter.dart';

void main() {
  group('formatTZS', () {
    test('formats 1,250,000 with full format', () {
      expect(formatTZS(1250000), 'TZS 1,250,000');
    });

    test('formats 1,250,000 with short format', () {
      expect(formatTZS(1250000, short: true), 'TZS 1.25M');
    });

    test('formats 50,000 with full format', () {
      expect(formatTZS(50000), 'TZS 50,000');
    });

    test('formats 50,000 with short format', () {
      expect(formatTZS(50000, short: true), 'TZS 50K');
    });

    test('formats 0', () {
      expect(formatTZS(0), 'TZS 0');
    });

    test('rounds 1500.50 to nearest integer', () {
      expect(formatTZS(1500.50), 'TZS 1,501');
    });

    test('formats 999 with full format', () {
      expect(formatTZS(999), 'TZS 999');
    });

    test('formats negative amount -50,000', () {
      expect(formatTZS(-50000), 'TZS -50,000');
    });

    test('formats exactly 1,000,000 short', () {
      expect(formatTZS(1000000, short: true), 'TZS 1M');
    });

    test('formats exactly 1,000 short', () {
      expect(formatTZS(1000, short: true), 'TZS 1K');
    });
  });

  group('formatNumber', () {
    test('formats 1,250,000 with full format', () {
      expect(formatNumber(1250000), '1,250,000');
    });

    test('formats 50,000 short', () {
      expect(formatNumber(50000, short: true), '50K');
    });

    test('formats 0', () {
      expect(formatNumber(0), '0');
    });

    test('formats negative amount short', () {
      expect(formatNumber(-50000, short: true), '-50K');
    });
  });
}
