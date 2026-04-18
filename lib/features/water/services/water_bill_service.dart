import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/water/models/water_bill.dart';

class WaterBillService {
  WaterBillService(
    this._firestoreService,
    this._activityLogService, {
    FirebaseFirestore? firestore,
  }) : _db = firestore ?? FirebaseFirestore.instance;

  final FirestoreService _firestoreService;
  final ActivityLogService _activityLogService;
  final FirebaseFirestore _db;

  static String _col(String groundId) => 'grounds/$groundId/water_bills';

  // ---------------------------------------------------------------------------
  // Write
  // ---------------------------------------------------------------------------

  Future<String> createBill({
    required String groundId,
    required WaterBill bill,
    required String userId,
  }) async {
    final id = await _firestoreService.create(
      collectionPath: _col(groundId),
      data: _toMap(bill),
      userId: userId,
    );

    await _activityLogService.log(
      userId: userId,
      action: 'create',
      module: 'water',
      description: 'Created water bill for period ${bill.billingPeriod}',
      documentId: id,
      collectionPath: _col(groundId),
    );

    return id;
  }

  Future<void> updateBill({
    required String groundId,
    required String billId,
    required Map<String, dynamic> updates,
    required String userId,
  }) async {
    await _firestoreService.update(
      collectionPath: _col(groundId),
      documentId: billId,
      data: updates,
      userId: userId,
    );

    await _activityLogService.log(
      userId: userId,
      action: 'update',
      module: 'water',
      description: 'Updated water bill $billId',
      documentId: billId,
      collectionPath: _col(groundId),
    );
  }

  Future<void> markPaid({
    required String groundId,
    required String billId,
    required String paymentMethod,
    required String userId,
  }) async {
    await _firestoreService.update(
      collectionPath: _col(groundId),
      documentId: billId,
      data: {
        'status': 'paid',
        'paidDate': DateTime.now().toIso8601String(),
        'paymentMethod': paymentMethod,
      },
      userId: userId,
    );

    await _activityLogService.log(
      userId: userId,
      action: 'update',
      module: 'water',
      description: 'Marked water bill $billId as paid via $paymentMethod',
      documentId: billId,
      collectionPath: _col(groundId),
    );
  }

  Future<void> deleteBill({
    required String groundId,
    required String billId,
    required String userId,
  }) async {
    await _firestoreService.delete(
      collectionPath: _col(groundId),
      documentId: billId,
    );

    await _activityLogService.log(
      userId: userId,
      action: 'delete',
      module: 'water',
      description: 'Deleted water bill $billId',
      documentId: billId,
      collectionPath: _col(groundId),
    );
  }

  // ---------------------------------------------------------------------------
  // Read
  // ---------------------------------------------------------------------------

  Future<WaterBill?> getBill(String groundId, String billId) async {
    final doc = await _firestoreService.get(
      collectionPath: _col(groundId),
      documentId: billId,
    );
    if (doc == null) return null;
    return WaterBill.fromJson(doc);
  }

  Future<List<WaterBill>> getAllBills(String groundId, {int? limit}) async {
    final docs = await _firestoreService.getAll(
      collectionPath: _col(groundId),
      orderBy: 'billingPeriod',
      descending: true,
      limit: limit,
    );
    return docs.map(WaterBill.fromJson).toList();
  }

  Stream<List<WaterBill>> streamBills(String groundId) {
    return _firestoreService
        .stream(
          collectionPath: _col(groundId),
          orderBy: 'billingPeriod',
          descending: true,
        )
        .map((docs) => docs.map(WaterBill.fromJson).toList());
  }

  Future<WaterBill?> getLatestBill(String groundId) async {
    final bills = await getAllBills(groundId, limit: 1);
    return bills.isEmpty ? null : bills.first;
  }

  Future<WaterBill?> getBillForPeriod(String groundId, String period) async {
    final docs = await _firestoreService.query(
      collectionPath: _col(groundId),
      field: 'billingPeriod',
      isEqualTo: period,
    );
    if (docs.isEmpty) return null;
    return WaterBill.fromJson(docs.first);
  }

  Future<List<WaterBill>> getUnpaidBills(String groundId) async {
    final allBills = await getAllBills(groundId);
    return allBills.where((b) => !b.isPaid).toList();
  }

  /// Marks all globally unpaid bills past their due date as overdue.
  Future<int> markOverdueBills({required String userId}) async {
    final now = DateTime.now();
    final snapshot = await _db
        .collectionGroup('water_bills')
        .where('status', isEqualTo: 'unpaid')
        .get();

    int count = 0;
    for (final doc in snapshot.docs) {
      final bill = WaterBill.fromJson({...doc.data(), 'id': doc.id});
      if (bill.dueDate.isBefore(now)) {
        await doc.reference.update({
          'status': 'overdue',
          'updatedAt': DateTime.now().toIso8601String(),
          'updatedBy': userId,
        });
        count++;
      }
    }
    return count;
  }

  Future<double> getAverageMonthlyBill(String groundId) async {
    final bills = await getAllBills(groundId);
    if (bills.isEmpty) return 0.0;
    final total = bills.fold(0.0, (acc, b) => acc + b.totalAmount);
    return total / bills.length;
  }

  Future<Map<String, double>> getYearlyComparison(String groundId) async {
    final bills = await getAllBills(groundId);
    final Map<String, double> yearlyTotals = {};
    for (final bill in bills) {
      final year = bill.billingPeriod.substring(0, 4);
      yearlyTotals[year] = (yearlyTotals[year] ?? 0.0) + bill.totalAmount;
    }
    return yearlyTotals;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _toMap(WaterBill bill) => {
    'groundId': bill.groundId,
    'billingPeriod': bill.billingPeriod,
    'previousMeterReading': bill.previousMeterReading,
    'currentMeterReading': bill.currentMeterReading,
    'totalAmount': bill.totalAmount,
    'dueDate': bill.dueDate.toIso8601String(),
    'status': bill.status,
    if (bill.paidDate != null) 'paidDate': bill.paidDate!.toIso8601String(),
    if (bill.paymentMethod != null) 'paymentMethod': bill.paymentMethod,
    if (bill.rawSmsText != null) 'rawSmsText': bill.rawSmsText,
    'notes': bill.notes,
  };
}
