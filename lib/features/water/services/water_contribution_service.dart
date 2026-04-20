import 'package:hms/core/models/recurring_config.dart';
import 'package:hms/core/models/recurring_record.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/features/water/models/water_surplus_deficit.dart';
import 'package:hms/features/water/services/water_bill_service.dart';

class WaterContributionService {
  WaterContributionService(
    this._firestoreService,
    this._recurringTransactionService,
    this._waterBillService,
    this._activityLogService,
  );

  final FirestoreService _firestoreService;
  final RecurringTransactionService _recurringTransactionService;
  final WaterBillService _waterBillService;
  final ActivityLogService _activityLogService;

  static const String _configCollection = 'app_config';
  static const String _configDocId = 'water_contribution_config';
  static const double _fallbackDefaultAmount = 5000.0;

  static String _contributionPath(String groundId, String unitId) =>
      'grounds/$groundId/rental_units/$unitId/water_contributions';

  // ---------------------------------------------------------------------------
  // Contribution config lifecycle
  // ---------------------------------------------------------------------------

  Future<String> setupContribution({
    required String groundId,
    required String unitId,
    required String tenantId,
    required String tenantName,
    required String unitName,
    required double monthlyAmount,
    required String userId,
  }) async {
    final now = DateTime.now();
    final config = RecurringConfig(
      id: 'water_$tenantId',
      type: 'water_contribution',
      collectionPath: _contributionPath(groundId, unitId),
      linkedEntityId: tenantId,
      linkedEntityName: '$tenantName — $unitName',
      amount: monthlyAmount,
      frequency: 'monthly',
      dayOfMonth: 5,
      isActive: true,
      createdAt: now,
      updatedAt: now,
      updatedBy: userId,
    );

    await _recurringTransactionService.createConfig(
      config: config,
      userId: userId,
    );

    await _activityLogService.log(
      userId: userId,
      action: 'create',
      module: 'water',
      description:
          'Set up water contribution for "$tenantName" — TZS ${monthlyAmount.toStringAsFixed(0)}/month',
      documentId: config.id,
      collectionPath: RecurringTransactionService.configCollection,
    );

    return config.id;
  }

  Future<void> updateAmount({
    required String tenantId,
    required double newAmount,
    required String userId,
  }) async {
    await _recurringTransactionService.updateConfig(
      configId: 'water_$tenantId',
      updates: {'amount': newAmount},
      userId: userId,
    );
  }

  Future<void> deactivateForTenant({
    required String tenantId,
    required String userId,
  }) async {
    await _recurringTransactionService.deactivateConfig(
      configId: 'water_$tenantId',
      userId: userId,
    );
  }

  // ---------------------------------------------------------------------------
  // Queries
  // ---------------------------------------------------------------------------

  Future<List<RecurringConfig>> getActiveConfigs(String groundId) async {
    return _recurringTransactionService.getActiveConfigs(
      type: 'water_contribution',
    );
  }

  Future<List<RecurringRecord>> getCurrentMonthRecords(String groundId) async {
    final now = DateTime.now();
    final period = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    return _recurringTransactionService.getRecordsForPeriod(
      type: 'water_contribution',
      period: period,
    );
  }

  Stream<List<RecurringRecord>> streamCurrentMonthRecords(String groundId) {
    final now = DateTime.now();
    final period = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    return _recurringTransactionService.streamRecordsForPeriod(
      type: 'water_contribution',
      period: period,
    );
  }

  Stream<List<RecurringRecord>> streamMonthRecords(
    String groundId,
    String period,
  ) {
    return _recurringTransactionService.streamRecordsForPeriod(
      type: 'water_contribution',
      period: period,
    );
  }

  Future<List<RecurringRecord>> getMonthRecords(
    String groundId,
    String period,
  ) {
    return _recurringTransactionService.getRecordsForPeriod(
      type: 'water_contribution',
      period: period,
    );
  }

  /// Mark a contribution record as paid.
  /// [configId] is the RecurringConfig id, e.g. "water_{tenantId}".
  /// The service resolves the collectionPath from the stored config.
  Future<void> markPaid({
    required String recordId,
    required String configId,
    required double amount,
    required String paymentMethod,
    required String userId,
  }) async {
    final configs = await _firestoreService.query(
      collectionPath: RecurringTransactionService.configCollection,
      field: 'id',
      isEqualTo: configId,
    );
    if (configs.isEmpty) {
      throw StateError('No config found for $configId');
    }
    final collectionPath = configs.first['collectionPath'] as String? ?? '';

    await _recurringTransactionService.updateRecordPayment(
      collectionPath: collectionPath,
      recordId: recordId,
      status: 'paid',
      amountPaid: amount,
      paymentMethod: paymentMethod,
      userId: userId,
    );
  }

  // ---------------------------------------------------------------------------
  // Surplus / deficit
  // ---------------------------------------------------------------------------

  Future<WaterSurplusDeficit> calculateSurplusDeficit({
    required String groundId,
    required String period,
  }) async {
    final records = await getMonthRecords(groundId, period);
    final bill = await _waterBillService.getBillForPeriod(groundId, period);

    final totalCollected = records
        .where((r) => r.isPaid)
        .fold(0.0, (sum, r) => sum + r.amountPaid);
    final actualBillAmount = bill?.totalAmount ?? 0.0;
    final paidTenants = records.where((r) => r.isPaid).length;

    return WaterSurplusDeficit(
      period: period,
      groundId: groundId,
      totalCollected: totalCollected,
      actualBillAmount: actualBillAmount,
      totalTenants: records.length,
      paidTenants: paidTenants,
    );
  }

  // ---------------------------------------------------------------------------
  // Default amount (app_config)
  // ---------------------------------------------------------------------------

  Future<double> getDefaultAmount() async {
    final doc = await _firestoreService.get(
      collectionPath: _configCollection,
      documentId: _configDocId,
    );
    if (doc == null) return _fallbackDefaultAmount;
    final value = doc['defaultAmount'];
    if (value is num) return value.toDouble();
    return _fallbackDefaultAmount;
  }

  Future<void> setDefaultAmount({
    required double amount,
    required String userId,
  }) async {
    await _firestoreService.set(
      collectionPath: _configCollection,
      documentId: _configDocId,
      data: {'defaultAmount': amount},
      userId: userId,
    );

    await _activityLogService.log(
      userId: userId,
      action: 'update',
      module: 'water',
      description:
          'Updated default water contribution to TZS ${amount.toStringAsFixed(0)}',
      documentId: _configDocId,
      collectionPath: _configCollection,
    );
  }
}
