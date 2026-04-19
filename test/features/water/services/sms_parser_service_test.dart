import 'package:flutter_test/flutter_test.dart';
import 'package:hms/features/water/services/sms_parser_service.dart';

void main() {
  late SmsParserService parser;

  setUp(() => parser = SmsParserService());

  group('English format', () {
    test('full bill SMS extracts all fields', () {
      const sms =
          'Your water bill. Total: TZS 45,000. Due: 15/04/2026. Prev Reading: 1234. Current Reading: 1456.';
      final result = parser.parse(sms);

      expect(result.isSuccessful, isTrue);
      expect(result.billAmount, 45000);
      expect(result.dueDate, DateTime(2026, 4, 15));
      expect(result.previousMeterReading, 1234);
      expect(result.currentMeterReading, 1456);
    });

    test('DAWASCO bill with amount and due date', () {
      const sms = 'DAWASCO Bill Amount: 32000 Due Date: 20-03-2026';
      final result = parser.parse(sms);

      expect(result.isSuccessful, isTrue);
      expect(result.billAmount, 32000);
      expect(result.dueDate, DateTime(2026, 3, 20));
    });

    test('amount due only', () {
      const sms = 'Amount Due TZS 55,500';
      final result = parser.parse(sms);

      expect(result.isSuccessful, isTrue);
      expect(result.billAmount, 55500);
      expect(result.billingPeriod, isNull);
      expect(result.previousMeterReading, isNull);
      expect(result.currentMeterReading, isNull);
      expect(result.dueDate, isNull);
    });

    test('billing period month name', () {
      const sms = 'Billing Period: March 2026 Amount: TZS 20,000';
      final result = parser.parse(sms);

      expect(result.billingPeriod, '2026-03');
    });

    test('billing period numeric mm/yyyy', () {
      const sms = 'Period: 03/2026 Total: TZS 20,000';
      final result = parser.parse(sms);

      expect(result.billingPeriod, '2026-03');
    });
  });

  group('Swahili format', () {
    test('Kiasi and tarehe ya mwisho', () {
      const sms = 'Kiasi: TZS 45,000. Tarehe ya mwisho: 15/04/2026';
      final result = parser.parse(sms);

      expect(result.isSuccessful, isTrue);
      expect(result.billAmount, 45000);
      expect(result.dueDate, DateTime(2026, 4, 15));
    });

    test('Jumla ya bili with meter readings', () {
      const sms =
          'Jumla ya bili: Tsh 38,000. Usomaji uliopita: 500. Usomaji wa sasa: 550.';
      final result = parser.parse(sms);

      expect(result.isSuccessful, isTrue);
      expect(result.billAmount, 38000);
      expect(result.previousMeterReading, 500);
      expect(result.currentMeterReading, 550);
    });

    test('Swahili month name in period', () {
      const sms = 'Kipindi: Machi 2026 Kiasi: TZS 10,000';
      final result = parser.parse(sms);

      expect(result.billingPeriod, '2026-03');
    });
  });

  group('Edge cases', () {
    test('empty string returns unsuccessful', () {
      final result = parser.parse('');

      expect(result.isSuccessful, isFalse);
      expect(result.rawText, '');
    });

    test('random text with no numbers returns unsuccessful', () {
      final result = parser.parse('Hello there how are you doing today');

      expect(result.isSuccessful, isFalse);
    });

    test('text with only amount returns successful with fieldsFound=1', () {
      const sms = 'Total: TZS 15,000';
      final result = parser.parse(sms);

      expect(result.isSuccessful, isTrue);
      expect(result.fieldsFound, 1);
      expect(result.billAmount, 15000);
    });

    test('amount without commas', () {
      const sms = 'Amount: 45000';
      final result = parser.parse(sms);

      expect(result.billAmount, 45000);
    });

    test('amount with commas', () {
      const sms = 'Amount: 45,000';
      final result = parser.parse(sms);

      expect(result.billAmount, 45000);
    });

    test('Tsh prefix', () {
      const sms = 'Tsh 45,000 due this month';
      final result = parser.parse(sms);

      expect(result.billAmount, 45000);
    });

    test('TZS prefix', () {
      const sms = 'TZS 45,000 due this month';
      final result = parser.parse(sms);

      expect(result.billAmount, 45000);
    });

    test('date dd/MM/yyyy', () {
      const sms = 'Due: 15/04/2026';
      final result = parser.parse(sms);

      expect(result.dueDate, DateTime(2026, 4, 15));
    });

    test('date dd-MM-yyyy', () {
      const sms = 'Due Date: 15-04-2026';
      final result = parser.parse(sms);

      expect(result.dueDate, DateTime(2026, 4, 15));
    });

    test('fieldsFound counts only non-null fields', () {
      const sms = 'Total: TZS 10,000. Prev Reading: 100. Current Reading: 200.';
      final result = parser.parse(sms);

      expect(result.fieldsFound, 3);
    });

    test('rawText always stores original input', () {
      const sms = '  some text with spaces  ';
      final result = parser.parse(sms);

      expect(result.rawText, sms);
    });

    test('rawText preserved even on failed parse', () {
      const sms = 'no data here';
      final result = parser.parse(sms);

      expect(result.rawText, sms);
      expect(result.isSuccessful, isFalse);
    });
  });
}
