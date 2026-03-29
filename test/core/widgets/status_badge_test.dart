import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/theme/app_colors.dart';
import 'package:hms/core/widgets/payment_status.dart';
import 'package:hms/core/widgets/status_badge.dart';

Widget _wrap(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

/// Returns the background color of the StatusBadge's pill Container.
Color? _badgeBackgroundColor(WidgetTester tester) {
  final containers = tester
      .widgetList<Container>(find.byType(Container))
      .toList();
  for (final c in containers) {
    final deco = c.decoration;
    if (deco is BoxDecoration &&
        deco.borderRadius != null &&
        deco.color != null) {
      return deco.color;
    }
  }
  return null;
}

/// Returns the text color applied to the badge label.
Color? _badgeTextColor(WidgetTester tester, String label) {
  final text = tester.widget<Text>(find.text(label));
  return text.style?.color;
}

void main() {
  group('StatusBadge labels', () {
    for (final status in PaymentStatus.values) {
      testWidgets('renders correct label for ${status.name}', (tester) async {
        await tester.pumpWidget(_wrap(StatusBadge(status: status)));
        expect(find.text(status.label), findsOneWidget);
      });
    }
  });

  group('StatusBadge colors', () {
    testWidgets('paid status shows green coloring', (tester) async {
      await tester.pumpWidget(
        _wrap(const StatusBadge(status: PaymentStatus.paid)),
      );
      final bg = _badgeBackgroundColor(tester);
      final textColor = _badgeTextColor(tester, 'Paid');
      expect(bg, AppColors.success.withValues(alpha: 0.15));
      expect(textColor, AppColors.success);
    });

    testWidgets('overdue status shows red coloring', (tester) async {
      await tester.pumpWidget(
        _wrap(const StatusBadge(status: PaymentStatus.overdue)),
      );
      final bg = _badgeBackgroundColor(tester);
      final textColor = _badgeTextColor(tester, 'Overdue');
      expect(bg, AppColors.error.withValues(alpha: 0.15));
      expect(textColor, AppColors.error);
    });

    testWidgets('pending status shows blue coloring', (tester) async {
      await tester.pumpWidget(
        _wrap(const StatusBadge(status: PaymentStatus.pending)),
      );
      final bg = _badgeBackgroundColor(tester);
      final textColor = _badgeTextColor(tester, 'Pending');
      expect(bg, AppColors.primaryLight.withValues(alpha: 0.15));
      expect(textColor, AppColors.primaryLight);
    });

    testWidgets('partial status shows amber coloring', (tester) async {
      await tester.pumpWidget(
        _wrap(const StatusBadge(status: PaymentStatus.partial)),
      );
      final bg = _badgeBackgroundColor(tester);
      final textColor = _badgeTextColor(tester, 'Partial');
      expect(bg, AppColors.warning.withValues(alpha: 0.15));
      expect(textColor, AppColors.warning);
    });

    testWidgets('vacant status shows gray coloring', (tester) async {
      await tester.pumpWidget(
        _wrap(const StatusBadge(status: PaymentStatus.vacant)),
      );
      final bg = _badgeBackgroundColor(tester);
      final textColor = _badgeTextColor(tester, 'Vacant');
      expect(bg, AppColors.border.withValues(alpha: 0.30));
      expect(textColor, AppColors.textSecondary);
    });
  });

  group('StatusBadge small mode', () {
    testWidgets('small mode renders with bodySmall text style', (tester) async {
      await tester.pumpWidget(
        _wrap(const StatusBadge(status: PaymentStatus.paid, small: true)),
      );
      final text = tester.widget<Text>(find.text('Paid'));
      // bodySmall is fontSize 12
      expect(text.style?.fontSize, 12);
    });

    testWidgets('normal mode renders with labelLarge text style', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const StatusBadge(status: PaymentStatus.paid)),
      );
      final text = tester.widget<Text>(find.text('Paid'));
      // labelLarge is fontSize 14
      expect(text.style?.fontSize, 14);
    });
  });

  group('PaymentStatus.fromString', () {
    test('returns paid for "paid"', () {
      expect(PaymentStatus.fromString('paid'), PaymentStatus.paid);
    });

    test('returns overdue for "overdue"', () {
      expect(PaymentStatus.fromString('overdue'), PaymentStatus.overdue);
    });

    test('returns pending as fallback for unknown value', () {
      expect(PaymentStatus.fromString('unknown_value'), PaymentStatus.pending);
    });

    test('returns correct status for every defined value', () {
      for (final status in PaymentStatus.values) {
        expect(PaymentStatus.fromString(status.value), status);
      }
    });
  });
}
