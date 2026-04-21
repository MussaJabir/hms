import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/features/water/providers/water_summary_providers.dart';

// ---------------------------------------------------------------------------
// Minimal widget that renders water summary tile providers under test.
// ---------------------------------------------------------------------------

class _WaterTileData extends ConsumerWidget {
  const _WaterTileData();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cost = ref.watch(currentMonthWaterCostProvider).asData?.value ?? 0.0;
    final sd =
        ref.watch(currentMonthWaterSurplusDeficitProvider).asData?.value ?? 0.0;
    return Column(
      children: [
        Text('cost:${cost.toStringAsFixed(0)}'),
        Text('sd:${sd.toStringAsFixed(0)}'),
      ],
    );
  }
}

Widget _wrap({required double cost, required double sd}) {
  return ProviderScope(
    overrides: [
      currentMonthWaterCostProvider.overrideWith((ref) => Future.value(cost)),
      currentMonthWaterSurplusDeficitProvider.overrideWith(
        (ref) => Future.value(sd),
      ),
    ],
    child: const MaterialApp(home: Scaffold(body: _WaterTileData())),
  );
}

void main() {
  group('Dashboard water summary tile providers', () {
    testWidgets('shows cost value from provider', (tester) async {
      await tester.pumpWidget(_wrap(cost: 35000, sd: 5000));
      await tester.pumpAndSettle();
      expect(find.textContaining('cost:35000'), findsOneWidget);
    });

    testWidgets('shows surplus/deficit from provider', (tester) async {
      await tester.pumpWidget(_wrap(cost: 35000, sd: -3000));
      await tester.pumpAndSettle();
      expect(find.textContaining('sd:-3000'), findsOneWidget);
    });

    testWidgets('shows zero cost when no bills', (tester) async {
      await tester.pumpWidget(_wrap(cost: 0, sd: 0));
      await tester.pumpAndSettle();
      expect(find.textContaining('cost:0'), findsOneWidget);
    });
  });
}
