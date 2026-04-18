import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/water/models/water_bill.dart';
import 'package:hms/features/water/providers/water_bill_providers.dart';

class WaterBillHistoryScreen extends ConsumerWidget {
  const WaterBillHistoryScreen({super.key, required this.groundId});

  final String groundId;

  String _formatPeriod(String period) {
    try {
      return DateFormat('MMM yyyy').format(DateFormat('yyyy-MM').parse(period));
    } catch (_) {
      return period;
    }
  }

  Map<String, List<WaterBill>> _groupByYear(List<WaterBill> bills) {
    final Map<String, List<WaterBill>> grouped = {};
    for (final bill in bills) {
      final year = bill.billingPeriod.substring(0, 4);
      grouped.putIfAbsent(year, () => []).add(bill);
    }
    return Map.fromEntries(
      grouped.entries.toList()..sort((a, b) => b.key.compareTo(a.key)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billsAsync = ref.watch(waterBillsProvider(groundId));
    final avgAsync = ref.watch(averageMonthlyBillProvider(groundId));

    return Scaffold(
      appBar: AppBar(title: const Text('Bill History')),
      body: billsAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: ShimmerList(itemCount: 6),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
        ),
        data: (bills) {
          if (bills.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: EmptyStatePresets.noWaterBills(),
              ),
            );
          }

          final avg = avgAsync.asData?.value ?? 0.0;
          final grouped = _groupByYear(bills);
          final years = grouped.keys.toList();

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              // Average card
              SummaryTile(
                label: 'Average Monthly Bill',
                value: formatTZS(avg),
                icon: Icons.water_drop_outlined,
                iconColor: Colors.blue,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Year sections
              for (final year in years) ...[
                _YearSection(
                  year: year,
                  bills: grouped[year]!,
                  formatPeriod: _formatPeriod,
                  showComparison: years.length > 1,
                  allBills: bills,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _YearSection extends StatelessWidget {
  const _YearSection({
    required this.year,
    required this.bills,
    required this.formatPeriod,
    required this.showComparison,
    required this.allBills,
  });

  final String year;
  final List<WaterBill> bills;
  final String Function(String) formatPeriod;
  final bool showComparison;
  final List<WaterBill> allBills;

  double _yearTotal(String y) => allBills
      .where((b) => b.billingPeriod.startsWith(y))
      .fold(0.0, (sum, b) => sum + b.totalAmount);

  @override
  Widget build(BuildContext context) {
    final yearTotal = _yearTotal(year);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              year,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(formatTZS(yearTotal), style: theme.textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ...bills.map(
          (bill) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    formatPeriod(bill.billingPeriod),
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                StatusBadge(
                  status: PaymentStatus.fromString(bill.status),
                  small: true,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  formatTZS(bill.totalAmount),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
