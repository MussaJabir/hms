import 'package:hms/core/models/recurring_record.dart';
import 'package:hms/core/services/firestore_service.dart';

class RentHistoryService {
  RentHistoryService(this._firestoreService);

  final FirestoreService _firestoreService;

  String _path(String groundId, String unitId) =>
      'grounds/$groundId/rental_units/$unitId/rent_payments';

  RecurringRecord _fromMap(Map<String, dynamic> map) =>
      RecurringRecord.fromJson(_normalize(map));

  /// Normalises Firestore Timestamps to ISO-8601 strings for json_serializable.
  Map<String, dynamic> _normalize(Map<String, dynamic> map) {
    return map.map((key, value) {
      if (value is DateTime) return MapEntry(key, value.toIso8601String());
      if (value != null && value.runtimeType.toString() == 'Timestamp') {
        return MapEntry(key, (value as dynamic).toDate().toIso8601String());
      }
      return MapEntry(key, value);
    });
  }

  /// Returns all rent records for a tenant across all months, newest first.
  Future<List<RecurringRecord>> getTenantHistory({
    required String groundId,
    required String unitId,
    required String tenantId,
  }) async {
    final results = await _firestoreService.query(
      collectionPath: _path(groundId, unitId),
      field: 'linkedEntityId',
      isEqualTo: tenantId,
    );
    final records = results.map(_fromMap).toList();
    // Sort newest period first in memory (avoids requiring a Firestore composite index)
    records.sort((a, b) => b.period.compareTo(a.period));
    return records;
  }

  /// Streams tenant payment history in real-time, newest first.
  Stream<List<RecurringRecord>> streamTenantHistory({
    required String groundId,
    required String unitId,
    required String tenantId,
  }) {
    return _firestoreService
        .stream(collectionPath: _path(groundId, unitId))
        .map((list) {
          final records = list
              .map(_fromMap)
              .where((r) => r.linkedEntityId == tenantId)
              .toList();
          records.sort((a, b) => b.period.compareTo(a.period));
          return records;
        });
  }

  /// Total amount paid by the tenant across all time.
  Future<double> getTotalPaidByTenant({
    required String groundId,
    required String unitId,
    required String tenantId,
  }) async {
    final records = await getTenantHistory(
      groundId: groundId,
      unitId: unitId,
      tenantId: tenantId,
    );
    return records.fold<double>(0.0, (sum, r) => sum + r.amountPaid);
  }

  /// Number of months where the tenant has fully paid.
  Future<int> getPaidMonthsCount({
    required String groundId,
    required String unitId,
    required String tenantId,
  }) async {
    final records = await getTenantHistory(
      groundId: groundId,
      unitId: unitId,
      tenantId: tenantId,
    );
    return records.where((r) => r.status == 'paid').length;
  }

  /// Number of months that are pending, partial, or overdue (not fully paid).
  Future<int> getOutstandingMonthsCount({
    required String groundId,
    required String unitId,
    required String tenantId,
  }) async {
    final records = await getTenantHistory(
      groundId: groundId,
      unitId: unitId,
      tenantId: tenantId,
    );
    return records.where((r) => r.status != 'paid').length;
  }
}
