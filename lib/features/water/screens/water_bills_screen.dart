import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:hms/core/theme/app_spacing.dart';
import 'package:hms/core/utils/currency_formatter.dart';
import 'package:hms/core/widgets/widgets.dart';
import 'package:hms/features/grounds/providers/ground_providers.dart';
import 'package:hms/features/water/models/water_bill.dart';
import 'package:hms/features/water/providers/water_bill_providers.dart';

class WaterBillsScreen extends ConsumerWidget {
  const WaterBillsScreen({super.key, required this.groundId});

  final String groundId;

  String _formatPeriod(String period) {
    try {
      final date = DateFormat('yyyy-MM').parse(period);
      return DateFormat('MMMM yyyy').format(date);
    } catch (_) {
      return period;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groundAsync = ref.watch(groundByIdProvider(groundId));
    final billsAsync = ref.watch(waterBillsProvider(groundId));
    final latestAsync = ref.watch(latestBillProvider(groundId));
    final avgAsync = ref.watch(averageMonthlyBillProvider(groundId));
    final unpaidAsync = ref.watch(unpaidBillsProvider(groundId));

    final groundName = groundAsync.asData?.value?.name ?? 'Ground';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Water Bills'),
            Text(groundName, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Bill',
            onPressed: () => context.push('/grounds/$groundId/water/add'),
          ),
          IconButton(
            icon: const Icon(Icons.history_outlined),
            tooltip: 'History',
            onPressed: () => context.push('/grounds/$groundId/water/history'),
          ),
        ],
      ),
      body: billsAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.screenPadding),
          child: ShimmerList(itemCount: 5),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e', style: const TextStyle(color: Colors.red)),
        ),
        data: (bills) {
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  AppSpacing.screenPadding,
                  AppSpacing.screenPadding,
                  AppSpacing.sm,
                ),
                sliver: SliverToBoxAdapter(
                  child: _SummarySection(
                    latestAsync: latestAsync,
                    avgAsync: avgAsync,
                    unpaidAsync: unpaidAsync,
                  ),
                ),
              ),
              if (bills.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.screenPadding),
                      child: EmptyStatePresets.noWaterBills(
                        onAdd: () =>
                            context.push('/grounds/$groundId/water/add'),
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    0,
                    AppSpacing.screenPadding,
                    AppSpacing.screenPadding,
                  ),
                  sliver: SliverList.separated(
                    itemCount: bills.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final bill = bills[index];
                      return AppCard(
                        leadingIcon: Icons.water_drop_outlined,
                        leadingIconColor: Colors.blue,
                        title: _formatPeriod(bill.billingPeriod),
                        subtitle: _buildSubtitle(bill),
                        trailing: StatusBadge(
                          status: PaymentStatus.fromString(bill.status),
                        ),
                        trailingText: formatTZS(bill.totalAmount),
                        showChevron: true,
                        onTap: () => context.push(
                          '/grounds/$groundId/water/${bill.id}',
                          extra: bill,
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  String _buildSubtitle(WaterBill bill) {
    final due = 'Due: ${DateFormat('dd/MM/yyyy').format(bill.dueDate)}';
    return bill.hasSmsData ? '$due · (SMS)' : due;
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({
    required this.latestAsync,
    required this.avgAsync,
    required this.unpaidAsync,
  });

  final AsyncValue<WaterBill?> latestAsync;
  final AsyncValue<double> avgAsync;
  final AsyncValue<List<WaterBill>> unpaidAsync;

  @override
  Widget build(BuildContext context) {
    final latestBill = latestAsync.asData?.value;
    final avg = avgAsync.asData?.value ?? 0.0;
    final unpaidCount = unpaidAsync.asData?.value.length ?? 0;

    return Row(
      children: [
        Expanded(
          child: SummaryTile(
            label: 'Latest Bill',
            value: latestBill != null
                ? formatTZS(latestBill.totalAmount)
                : 'No bills',
            icon: Icons.water_drop_outlined,
            iconColor: Colors.blue,
            compact: true,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: SummaryTile(
            label: 'Avg Monthly',
            value: formatTZS(avg),
            icon: Icons.trending_flat_outlined,
            iconColor: Colors.teal,
            compact: true,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: SummaryTile(
            label: 'Unpaid',
            value: '$unpaidCount',
            icon: Icons.warning_amber_outlined,
            iconColor: unpaidCount > 0 ? Colors.red : Colors.green,
            valueColor: unpaidCount > 0 ? Colors.red : null,
            compact: true,
          ),
        ),
      ],
    );
  }
}
