import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/utils/validators.dart';

void main() {
  group('Validators.required', () {
    test('null returns error', () {
      expect(Validators.required(null), isNotNull);
    });

    test('empty string returns error', () {
      expect(Validators.required(''), isNotNull);
    });

    test('whitespace-only returns error', () {
      expect(Validators.required('   '), isNotNull);
    });

    test('valid string returns null', () {
      expect(Validators.required('John'), isNull);
    });
  });

  group('Validators.email', () {
    test('valid email returns null', () {
      expect(Validators.email('test@example.com'), isNull);
    });

    test('missing @ returns error', () {
      expect(Validators.email('testexample.com'), isNotNull);
    });

    test('empty returns error', () {
      expect(Validators.email(''), isNotNull);
    });

    test('null returns error', () {
      expect(Validators.email(null), isNotNull);
    });
  });

  group('Validators.phone', () {
    test('"0712345678" returns null', () {
      expect(Validators.phone('0712345678'), isNull);
    });

    test('"0612345678" (06 prefix) returns null', () {
      expect(Validators.phone('0612345678'), isNull);
    });

    test('"1234" (too short) returns error', () {
      expect(Validators.phone('1234'), isNotNull);
    });

    test('"0812345678" (invalid prefix) returns error', () {
      expect(Validators.phone('0812345678'), isNotNull);
    });

    test('null returns error', () {
      expect(Validators.phone(null), isNotNull);
    });
  });

  group('Validators.nationalId', () {
    test('20-character string returns null', () {
      expect(Validators.nationalId('12345678901234567890'), isNull);
    });

    test('shorter than 20 chars returns error', () {
      expect(Validators.nationalId('1234567890'), isNotNull);
    });

    test('longer than 20 chars returns error', () {
      expect(Validators.nationalId('123456789012345678901'), isNotNull);
    });

    test('null returns error', () {
      expect(Validators.nationalId(null), isNotNull);
    });
  });

  group('Validators.positiveAmount', () {
    test('"150000" returns null', () {
      expect(Validators.positiveAmount('150000'), isNull);
    });

    test('"150,000" (formatted) returns null', () {
      expect(Validators.positiveAmount('150,000'), isNull);
    });

    test('"0" returns error', () {
      expect(Validators.positiveAmount('0'), isNotNull);
    });

    test('"-5" returns error', () {
      expect(Validators.positiveAmount('-5'), isNotNull);
    });

    test('"abc" returns error', () {
      expect(Validators.positiveAmount('abc'), isNotNull);
    });

    test('null returns error', () {
      expect(Validators.positiveAmount(null), isNotNull);
    });
  });

  group('Validators.meterReading', () {
    test('"100" with previous 50 returns null', () {
      expect(Validators.meterReading('100', previousReading: 50), isNull);
    });

    test('"50" equal to previous 50 returns null', () {
      expect(Validators.meterReading('50', previousReading: 50), isNull);
    });

    test('"30" with previous 50 returns error', () {
      expect(Validators.meterReading('30', previousReading: 50), isNotNull);
    });

    test('"100" with null previous returns null', () {
      expect(Validators.meterReading('100'), isNull);
    });

    test('null value returns error', () {
      expect(Validators.meterReading(null), isNotNull);
    });

    test('non-numeric returns error', () {
      expect(Validators.meterReading('abc'), isNotNull);
    });
  });

  group('Validators.password', () {
    test('"12345678" (8 chars) returns null', () {
      expect(Validators.password('12345678'), isNull);
    });

    test('"1234" (4 chars) returns error', () {
      expect(Validators.password('1234'), isNotNull);
    });

    test('null returns error', () {
      expect(Validators.password(null), isNotNull);
    });
  });

  group('Validators.dateNotInPast', () {
    test('tomorrow returns null', () {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      expect(Validators.dateNotInPast(tomorrow), isNull);
    });

    test('today returns null', () {
      final today = DateTime.now();
      expect(Validators.dateNotInPast(today), isNull);
    });

    test('yesterday returns error', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(Validators.dateNotInPast(yesterday), isNotNull);
    });

    test('null returns error', () {
      expect(Validators.dateNotInPast(null), isNotNull);
    });
  });

  group('Validators.dateAfter', () {
    test('value after reference date returns null', () {
      final ref = DateTime(2026, 1, 1);
      final value = DateTime(2026, 6, 1);
      expect(Validators.dateAfter(value, ref), isNull);
    });

    test('value equal to reference date returns error', () {
      final ref = DateTime(2026, 1, 1);
      expect(Validators.dateAfter(ref, ref), isNotNull);
    });

    test('value before reference date returns error', () {
      final ref = DateTime(2026, 6, 1);
      final value = DateTime(2026, 1, 1);
      expect(Validators.dateAfter(value, ref), isNotNull);
    });

    test('null value returns error', () {
      expect(Validators.dateAfter(null, DateTime(2026, 1, 1)), isNotNull);
    });

    test('null afterDate always returns null', () {
      expect(Validators.dateAfter(DateTime(2026, 1, 1), null), isNull);
    });
  });
}
