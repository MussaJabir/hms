import 'package:flutter_test/flutter_test.dart';
import 'package:hms/features/finance/models/financial_summary.dart';
import 'package:hms/features/finance/models/ground_financial_summary.dart';
import 'package:hms/features/finance/models/monthly_trend.dart';

FinancialSummary _summary({double income = 0, double expenses = 0}) {
  return FinancialSummary(
    period: '2026-06',
    totalIncome: income,
    totalExpenses: expenses,
    rentIncome: 0,
    otherIncome: 0,
    incomeBySource: const {},
    expensesByCategory: const {},
    budgetComplianceScore: 100,
    budgetsOnTrack: 0,
    budgetsOverLimit: 0,
  );
}

void main() {
  group('FinancialSummary', () {
    test('netPosition = income - expenses', () {
      expect(_summary(income: 800000, expenses: 500000).netPosition, 300000);
      expect(_summary(income: 300000, expenses: 500000).netPosition, -200000);
    });

    test('isPositive is true when income >= expenses', () {
      expect(_summary(income: 500000, expenses: 400000).isPositive, isTrue);
      expect(_summary(income: 400000, expenses: 400000).isPositive, isTrue);
      expect(_summary(income: 300000, expenses: 400000).isPositive, isFalse);
    });

    test('savingsRate is net as a percentage of income', () {
      expect(_summary(income: 1000000, expenses: 750000).savingsRate, 25);
      // Guards against divide-by-zero.
      expect(_summary(income: 0, expenses: 500000).savingsRate, 0);
    });
  });

  group('GroundFinancialSummary', () {
    GroundFinancialSummary g(double income, double expenses) =>
        GroundFinancialSummary(
          groundId: 'g-1',
          groundName: 'Main',
          income: income,
          expenses: expenses,
        );

    test('netPosition and isPositive per ground', () {
      expect(g(600000, 350000).netPosition, 250000);
      expect(g(600000, 350000).isPositive, isTrue);
      expect(g(200000, 350000).netPosition, -150000);
      expect(g(200000, 350000).isPositive, isFalse);
    });
  });

  group('MonthlyTrend', () {
    test('netPosition per month', () {
      const trend = MonthlyTrend(
        period: '2026-06',
        income: 700000,
        expenses: 450000,
      );
      expect(trend.netPosition, 250000);
    });
  });
}
