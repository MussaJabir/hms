import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/grounds/models/rental_unit.dart';

class RentalUnitService {
  RentalUnitService(this._firestore, this._activityLog);

  final FirestoreService _firestore;
  final ActivityLogService _activityLog;

  static String _col(String groundId) => 'grounds/$groundId/rental_units';

  // ---------------------------------------------------------------------------
  // Write operations
  // ---------------------------------------------------------------------------

  Future<String> createUnit(
    String groundId,
    RentalUnit unit,
    String userId,
  ) async {
    final id = await _firestore.create(
      collectionPath: _col(groundId),
      data: {
        'groundId': groundId,
        'name': unit.name,
        'rentAmount': unit.rentAmount,
        'status': unit.status,
        if (unit.meterId != null) 'meterId': unit.meterId,
      },
      userId: userId,
    );
    await _activityLog.log(
      userId: userId,
      action: 'create',
      module: 'rental_units',
      description: 'Added unit "${unit.name}" to ground $groundId',
      documentId: id,
      collectionPath: _col(groundId),
    );
    return id;
  }

  Future<void> updateUnit(
    String groundId,
    String unitId,
    Map<String, dynamic> updates,
    String userId,
  ) async {
    await _firestore.update(
      collectionPath: _col(groundId),
      documentId: unitId,
      data: updates,
      userId: userId,
    );
    await _activityLog.log(
      userId: userId,
      action: 'update',
      module: 'rental_units',
      description: 'Updated unit $unitId in ground $groundId',
      documentId: unitId,
      collectionPath: _col(groundId),
    );
  }

  /// Super Admin only — caller is responsible for role check.
  Future<void> deleteUnit(String groundId, String unitId, String userId) async {
    await _firestore.delete(collectionPath: _col(groundId), documentId: unitId);
    await _activityLog.log(
      userId: userId,
      action: 'delete',
      module: 'rental_units',
      description: 'Deleted unit $unitId from ground $groundId',
      documentId: unitId,
      collectionPath: _col(groundId),
    );
  }

  // ---------------------------------------------------------------------------
  // Read operations
  // ---------------------------------------------------------------------------

  Future<RentalUnit?> getUnit(String groundId, String unitId) async {
    final data = await _firestore.get(
      collectionPath: _col(groundId),
      documentId: unitId,
    );
    if (data == null) return null;
    return RentalUnit.fromJson(_normalize(data));
  }

  Future<List<RentalUnit>> getAllUnits(String groundId) async {
    final results = await _firestore.getAll(
      collectionPath: _col(groundId),
      orderBy: 'createdAt',
    );
    return results.map((d) => RentalUnit.fromJson(_normalize(d))).toList();
  }

  Stream<List<RentalUnit>> streamAllUnits(String groundId) {
    return _firestore
        .stream(collectionPath: _col(groundId), orderBy: 'createdAt')
        .map(
          (list) =>
              list.map((d) => RentalUnit.fromJson(_normalize(d))).toList(),
        );
  }

  Future<int> getUnitCount(String groundId) async {
    final units = await getAllUnits(groundId);
    return units.length;
  }

  Future<List<RentalUnit>> getVacantUnits(String groundId) async {
    final units = await getAllUnits(groundId);
    return units.where((u) => u.isVacant).toList();
  }

  Future<List<RentalUnit>> getOccupiedUnits(String groundId) async {
    final units = await getAllUnits(groundId);
    return units.where((u) => u.isOccupied).toList();
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
