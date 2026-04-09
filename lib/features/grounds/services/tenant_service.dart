import 'package:hms/core/models/recurring_config.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/features/grounds/models/communication_log.dart';
import 'package:hms/features/grounds/models/tenant.dart';
import 'package:hms/features/grounds/services/rental_unit_service.dart';

class TenantService {
  TenantService(
    this._firestore,
    this._activityLog,
    this._rentalUnitService,
    this._recurringTransactionService,
  );

  final FirestoreService _firestore;
  final ActivityLogService _activityLog;
  final RentalUnitService _rentalUnitService;
  final RecurringTransactionService _recurringTransactionService;

  static String _tenantCol(String groundId, String unitId) =>
      'grounds/$groundId/rental_units/$unitId/tenants';

  static String _logCol(String groundId, String unitId, String tenantId) =>
      'grounds/$groundId/rental_units/$unitId/tenants/$tenantId/communication_logs';

  static String _unitCol(String groundId) => 'grounds/$groundId/rental_units';

  // ---------------------------------------------------------------------------
  // Tenant CRUD
  // ---------------------------------------------------------------------------

  Future<String> createTenant(
    String groundId,
    String unitId,
    Tenant tenant,
    String userId,
  ) async {
    final id = await _firestore.create(
      collectionPath: _tenantCol(groundId, unitId),
      data: {
        'groundId': groundId,
        'unitId': unitId,
        'fullName': tenant.fullName,
        'phoneNumber': tenant.phoneNumber,
        if (tenant.nationalId != null) 'nationalId': tenant.nationalId,
        'moveInDate': tenant.moveInDate.toIso8601String(),
        if (tenant.leaseEndDate != null)
          'leaseEndDate': tenant.leaseEndDate!.toIso8601String(),
        'notes': tenant.notes,
      },
      userId: userId,
    );

    // Mark unit as occupied
    await _firestore.update(
      collectionPath: _unitCol(groundId),
      documentId: unitId,
      data: {'status': 'occupied'},
      userId: userId,
    );

    // Create recurring rent config for this tenant
    await _createRentConfig(
      groundId: groundId,
      unitId: unitId,
      tenantId: id,
      tenantName: tenant.fullName,
      userId: userId,
    );

    await _activityLog.log(
      userId: userId,
      action: 'create',
      module: 'tenants',
      description: 'Added tenant "${tenant.fullName}" to unit $unitId',
      documentId: id,
      collectionPath: _tenantCol(groundId, unitId),
    );
    return id;
  }

  Future<void> _createRentConfig({
    required String groundId,
    required String unitId,
    required String tenantId,
    required String tenantName,
    required String userId,
  }) async {
    final unit = await _rentalUnitService.getUnit(groundId, unitId);
    final rentAmount = unit?.rentAmount ?? 0.0;
    final unitName = unit?.name ?? unitId;

    final now = DateTime.now();
    final config = RecurringConfig(
      id: 'rent_$tenantId',
      type: 'rent',
      collectionPath: 'grounds/$groundId/rental_units/$unitId/rent_payments',
      linkedEntityId: tenantId,
      linkedEntityName: '$tenantName — $unitName',
      amount: rentAmount,
      frequency: 'monthly',
      dayOfMonth: 1,
      isActive: true,
      createdAt: now,
      updatedAt: now,
      updatedBy: userId,
    );

    await _recurringTransactionService.createConfig(
      config: config,
      userId: userId,
    );
  }

  Future<void> updateTenant(
    String groundId,
    String unitId,
    String tenantId,
    Map<String, dynamic> updates,
    String userId,
  ) async {
    await _firestore.update(
      collectionPath: _tenantCol(groundId, unitId),
      documentId: tenantId,
      data: updates,
      userId: userId,
    );
    await _activityLog.log(
      userId: userId,
      action: 'update',
      module: 'tenants',
      description: 'Updated tenant $tenantId in unit $unitId',
      documentId: tenantId,
      collectionPath: _tenantCol(groundId, unitId),
    );
  }

  /// Super Admin only — caller is responsible for role check.
  Future<void> deleteTenant(
    String groundId,
    String unitId,
    String tenantId,
    String userId,
  ) async {
    await _firestore.delete(
      collectionPath: _tenantCol(groundId, unitId),
      documentId: tenantId,
    );
    await _activityLog.log(
      userId: userId,
      action: 'delete',
      module: 'tenants',
      description: 'Deleted tenant $tenantId from unit $unitId',
      documentId: tenantId,
      collectionPath: _tenantCol(groundId, unitId),
    );
  }

  Future<Tenant?> getTenant(
    String groundId,
    String unitId,
    String tenantId,
  ) async {
    final data = await _firestore.get(
      collectionPath: _tenantCol(groundId, unitId),
      documentId: tenantId,
    );
    if (data == null) return null;
    return Tenant.fromJson(_normalize(data));
  }

  /// Returns the most recently created tenant for a unit (the active one).
  Future<Tenant?> getCurrentTenant(String groundId, String unitId) async {
    final results = await _firestore.getAll(
      collectionPath: _tenantCol(groundId, unitId),
      orderBy: 'createdAt',
      descending: true,
      limit: 1,
    );
    if (results.isEmpty) return null;
    return Tenant.fromJson(_normalize(results.first));
  }

  Stream<Tenant?> streamCurrentTenant(String groundId, String unitId) {
    return _firestore
        .stream(
          collectionPath: _tenantCol(groundId, unitId),
          orderBy: 'createdAt',
          descending: true,
        )
        .map((list) {
          if (list.isEmpty) return null;
          return Tenant.fromJson(_normalize(list.first));
        });
  }

  // ---------------------------------------------------------------------------
  // Communication log
  // ---------------------------------------------------------------------------

  Future<void> addCommunicationLog(
    String groundId,
    String unitId,
    String tenantId,
    String note,
    String userId,
  ) async {
    await _firestore.create(
      collectionPath: _logCol(groundId, unitId, tenantId),
      data: {'tenantId': tenantId, 'note': note, 'createdBy': userId},
      userId: userId,
    );
  }

  Future<List<CommunicationLog>> getCommunicationLogs(
    String groundId,
    String unitId,
    String tenantId,
  ) async {
    final results = await _firestore.getAll(
      collectionPath: _logCol(groundId, unitId, tenantId),
      orderBy: 'createdAt',
      descending: true,
    );
    return results
        .map((d) => CommunicationLog.fromJson(_normalize(d)))
        .toList();
  }

  Stream<List<CommunicationLog>> streamCommunicationLogs(
    String groundId,
    String unitId,
    String tenantId,
  ) {
    return _firestore
        .stream(
          collectionPath: _logCol(groundId, unitId, tenantId),
          orderBy: 'createdAt',
          descending: true,
        )
        .map(
          (list) => list
              .map((d) => CommunicationLog.fromJson(_normalize(d)))
              .toList(),
        );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

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
