import 'package:hms/features/grounds/services/ground_service.dart';
import 'package:hms/features/water/models/water_bill.dart';
import 'package:hms/features/water/services/water_bill_service.dart';
import 'package:hms/features/water/services/water_contribution_service.dart';

class WaterSummaryService {
  WaterSummaryService(
    this._waterBillService,
    this._contributionService,
    this._groundService,
  );

  final WaterBillService _waterBillService;
  final WaterContributionService _contributionService;
  final GroundService _groundService;

  static String _currentPeriod() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  Future<List<String>> _resolveGroundIds(String? groundId) async {
    if (groundId != null) return [groundId];
    final grounds = await _groundService.getAllGrounds();
    return grounds.map((g) => g.id).toList();
  }

  Future<double> getCurrentMonthCost({String? groundId}) async {
    final period = _currentPeriod();
    final groundIds = await _resolveGroundIds(groundId);
    double total = 0.0;
    for (final gId in groundIds) {
      final bill = await _waterBillService.getBillForPeriod(gId, period);
      if (bill != null) total += bill.totalAmount;
    }
    return total;
  }

  Future<int> getUnpaidBillsCount({String? groundId}) async {
    final groundIds = await _resolveGroundIds(groundId);
    int count = 0;
    for (final gId in groundIds) {
      final bills = await _waterBillService.getAllBills(gId);
      count += bills.where((b) => !b.isPaid).length;
    }
    return count;
  }

  Future<List<WaterBill>> getBillsDueSoon({String? groundId}) async {
    final groundIds = await _resolveGroundIds(groundId);
    final result = <WaterBill>[];
    for (final gId in groundIds) {
      final bills = await _waterBillService.getAllBills(gId);
      result.addAll(bills.where((b) => b.isDueSoon));
    }
    return result;
  }

  Future<List<WaterBill>> getOverdueBills({String? groundId}) async {
    final groundIds = await _resolveGroundIds(groundId);
    final result = <WaterBill>[];
    for (final gId in groundIds) {
      final bills = await _waterBillService.getAllBills(gId);
      result.addAll(bills.where((b) => b.isOverdue));
    }
    return result;
  }

  Future<double> getCurrentMonthSurplusDeficit({String? groundId}) async {
    final period = _currentPeriod();
    final groundIds = await _resolveGroundIds(groundId);
    double total = 0.0;
    for (final gId in groundIds) {
      final sd = await _contributionService.calculateSurplusDeficit(
        groundId: gId,
        period: period,
      );
      total += sd.surplusDeficit;
    }
    return total;
  }

  Future<int> getUnpaidContributionsCount({String? groundId}) async {
    final groundIds = await _resolveGroundIds(groundId);
    int count = 0;
    for (final gId in groundIds) {
      final records = await _contributionService.getCurrentMonthRecords(gId);
      count += records.where((r) => !r.isPaid).length;
    }
    return count;
  }

  Future<double> getCurrentMonthContributionsCollected({
    String? groundId,
  }) async {
    final groundIds = await _resolveGroundIds(groundId);
    double total = 0.0;
    for (final gId in groundIds) {
      final records = await _contributionService.getCurrentMonthRecords(gId);
      total += records
          .where((r) => r.isPaid)
          .fold(0.0, (sum, r) => sum + r.amountPaid);
    }
    return total;
  }
}
