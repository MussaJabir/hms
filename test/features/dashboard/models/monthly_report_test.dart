import 'package:flutter_test/flutter_test.dart';
import 'package:hms/features/dashboard/models/monthly_report.dart';

void main() {
  group('MonthlyReport.netPosition', () {
    test('calculates income minus expenses correctly', () {
      const report = MonthlyReport(
        period: '2026-03',
        totalIncome: 850000,
        totalExpenses: 620000,
      );
      expect(report.netPosition, 230000);
    });

    test('returns negative when expenses exceed income', () {
      const report = MonthlyReport(
        period: '2026-03',
        totalIncome: 400000,
        totalExpenses: 600000,
      );
      expect(report.netPosition, -200000);
    });

    test('returns 0 when income equals expenses', () {
      const report = MonthlyReport(
        period: '2026-03',
        totalIncome: 500000,
        totalExpenses: 500000,
      );
      expect(report.netPosition, 0);
    });
  });

  group('MonthlyReport.isPositive', () {
    test('returns true when income > expenses', () {
      const report = MonthlyReport(
        period: '2026-03',
        totalIncome: 850000,
        totalExpenses: 620000,
      );
      expect(report.isPositive, isTrue);
    });

    test('returns true when income equals expenses', () {
      const report = MonthlyReport(
        period: '2026-03',
        totalIncome: 500000,
        totalExpenses: 500000,
      );
      expect(report.isPositive, isTrue);
    });

    test('returns false when expenses exceed income', () {
      const report = MonthlyReport(
        period: '2026-03',
        totalIncome: 400000,
        totalExpenses: 600000,
      );
      expect(report.isPositive, isFalse);
    });
  });

  group('MonthlyReport.rentCollectionRate', () {
    test('calculates percentage correctly', () {
      const report = MonthlyReport(
        period: '2026-03',
        rentExpected: 750000,
        rentCollected: 600000,
      );
      expect(report.rentCollectionRate, closeTo(80.0, 0.001));
    });

    test('returns 0 when rentExpected is 0', () {
      const report = MonthlyReport(
        period: '2026-03',
        rentExpected: 0,
        rentCollected: 0,
      );
      expect(report.rentCollectionRate, 0);
    });

    test('returns 100 when all rent collected', () {
      const report = MonthlyReport(
        period: '2026-03',
        rentExpected: 750000,
        rentCollected: 750000,
      );
      expect(report.rentCollectionRate, closeTo(100.0, 0.001));
    });

    test('can exceed 100 if over-collected', () {
      const report = MonthlyReport(
        period: '2026-03',
        rentExpected: 500000,
        rentCollected: 600000,
      );
      expect(report.rentCollectionRate, closeTo(120.0, 0.001));
    });
  });
}
