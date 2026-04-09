import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/features/grounds/models/settlement.dart';
import 'package:hms/features/grounds/services/rental_unit_service.dart';

class MoveOutService {
  MoveOutService(
    this._firestoreService,
    this._rentalUnitService,
    this._recurringTransactionService,
    this._activityLogService,
  );

  final FirestoreService _firestoreService;
  final RentalUnitService _rentalUnitService;
  final RecurringTransactionService _recurringTransactionService;
  final ActivityLogService _activityLogService;

  static String _settlementCol(String groundId, String unitId) =>
      'grounds/$groundId/rental_units/$unitId/settlements';

  /// Execute the full move-out flow:
  /// 1. Create a Settlement record
  /// 2. Deactivate all recurring configs linked to this tenant
  /// 3. Update the unit status to "vacant"
  /// 4. Log the action
  Future<String> processMoveOut({
    required String groundId,
    required String unitId,
    required String tenantId,
    required String tenantName,
    required DateTime moveOutDate,
    double outstandingRent = 0,
    double outstandingWater = 0,
    double otherCharges = 0,
    String notes = '',
    required String userId,
  }) async {
    final total = outstandingRent + outstandingWater + otherCharges;
    final status = total <= 0 ? 'settled' : 'pending';

    final settlementId = await _firestoreService.create(
      collectionPath: _settlementCol(groundId, unitId),
      data: {
        'groundId': groundId,
        'unitId': unitId,
        'tenantId': tenantId,
        'tenantName': tenantName,
        'moveOutDate': moveOutDate.toIso8601String(),
        'outstandingRent': outstandingRent,
        'outstandingWater': outstandingWater,
        'otherCharges': otherCharges,
        'notes': notes,
        'status': status,
      },
      userId: userId,
    );

    // Deactivate recurring configs linked to this tenant
    await _deactivateTenantConfigs(tenantId, userId);

    // Mark unit vacant
    await _rentalUnitService.updateUnit(groundId, unitId, {
      'status': 'vacant',
    }, userId);

    await _activityLogService.log(
      userId: userId,
      action: 'move_out',
      module: 'tenants',
      description:
          'Processed move-out for "$tenantName" from unit $unitId (settlement: $settlementId)',
      documentId: settlementId,
      collectionPath: _settlementCol(groundId, unitId),
    );

    return settlementId;
  }

  /// Mark a settlement as settled (balance paid).
  Future<void> markSettled({
    required String groundId,
    required String unitId,
    required String settlementId,
    required String userId,
  }) async {
    await _firestoreService.update(
      collectionPath: _settlementCol(groundId, unitId),
      documentId: settlementId,
      data: {'status': 'settled'},
      userId: userId,
    );
    await _activityLogService.log(
      userId: userId,
      action: 'update',
      module: 'settlements',
      description: 'Marked settlement $settlementId as settled',
      documentId: settlementId,
      collectionPath: _settlementCol(groundId, unitId),
    );
  }

  /// Waive the outstanding balance.
  Future<void> waiveBalance({
    required String groundId,
    required String unitId,
    required String settlementId,
    required String userId,
  }) async {
    await _firestoreService.update(
      collectionPath: _settlementCol(groundId, unitId),
      documentId: settlementId,
      data: {'status': 'waived'},
      userId: userId,
    );
    await _activityLogService.log(
      userId: userId,
      action: 'update',
      module: 'settlements',
      description: 'Waived balance on settlement $settlementId',
      documentId: settlementId,
      collectionPath: _settlementCol(groundId, unitId),
    );
  }

  /// Get settlement history for a unit.
  Future<List<Settlement>> getSettlements(
    String groundId,
    String unitId,
  ) async {
    final results = await _firestoreService.getAll(
      collectionPath: _settlementCol(groundId, unitId),
      orderBy: 'createdAt',
      descending: true,
    );
    return results.map((d) => Settlement.fromJson(_normalize(d))).toList();
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  Future<void> _deactivateTenantConfigs(String tenantId, String userId) async {
    final allConfigs = await _firestoreService.getAll(
      collectionPath: RecurringTransactionService.configCollection,
    );
    final tenantConfigs = allConfigs.where(
      (d) => d['linkedEntityId'] == tenantId && (d['isActive'] == true),
    );
    for (final config in tenantConfigs) {
      final configId = config['id'] as String? ?? '';
      if (configId.isEmpty) continue;
      await _recurringTransactionService.deactivateConfig(
        configId: configId,
        userId: userId,
      );
    }
  }

  Map<String, dynamic> _normalize(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is DateTime) return MapEntry(key, value.toIso8601String());
      if (value != null && value.runtimeType.toString() == 'Timestamp') {
        return MapEntry(key, (value as dynamic).toDate().toIso8601String());
      }
      return MapEntry(key, value);
    });
  }
}
