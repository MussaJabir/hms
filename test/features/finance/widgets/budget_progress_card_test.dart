import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/theme/app_colors.dart';
import 'package:hms/features/finance/models/budget.dart';
import 'package:hms/features/finance/widgets/budget_progress_card.dart';

Budget _budget({double limit = 100000, double spent = 0}) {
  final now = DateTime(2026, 3, 1);
  return Budget(
    id: '2026-03_groceries',
    category: 'groceries',
    limitAmount: limit,
    period: '2026-03',
    spentAmount: spent,
    createdAt: now,
    updatedAt: now,
    updatedBy: 'user-1',
  );
}

Widget _wrap(Budget budget) {
  return MaterialApp(
    theme: ThemeData(splashFactory: NoSplash.splashFactory),
    home: Scaffold(body: BudgetProgressCard(budget: budget)),
  );
}

void main() {
  group('BudgetProgressCard', () {
    testWidgets('renders a progress bar and the percentage', (tester) async {
      await tester.pumpWidget(_wrap(_budget(limit: 100000, spent: 50000)));
      await tester.pump();

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text('50%'), findsOneWidget);
    });

    testWidgets('shows remaining text when under budget', (tester) async {
      await tester.pumpWidget(_wrap(_budget(limit: 100000, spent: 40000)));
      await tester.pump();

      expect(find.textContaining('left'), findsOneWidget);
    });

    testWidgets('shows over text when over budget', (tester) async {
      await tester.pumpWidget(_wrap(_budget(limit: 100000, spent: 130000)));
      await tester.pump();

      expect(find.textContaining('over'), findsOneWidget);
    });

    test('statusColor is green / amber / red by spend', () {
      expect(
        BudgetProgressCard.statusColor(_budget(limit: 100000, spent: 10000)),
        AppColors.success,
      );
      expect(
        BudgetProgressCard.statusColor(_budget(limit: 100000, spent: 85000)),
        AppColors.warning,
      );
      expect(
        BudgetProgressCard.statusColor(_budget(limit: 100000, spent: 120000)),
        AppColors.error,
      );
    });
  });
}
