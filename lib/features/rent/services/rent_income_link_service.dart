import 'package:hms/core/services/firestore_service.dart';

/// Creates an income record in the top-level `incomes` collection whenever a
/// rent payment is recorded. This lets Phase 7 (Finance) pick up rent as
/// income automatically without duplicate entry.
class RentIncomeLinkService {
  RentIncomeLinkService(this._firestoreService);

  final FirestoreService _firestoreService;

  static const String _collection = 'incomes';

  Future<void> createIncomeFromRentPayment({
    required String groundId,
    required String tenantId,
    required String tenantName,
    required String unitName,
    required String rentRecordId,
    required double amount,
    required String userId,
  }) async {
    final today = DateTime.now();
    final dateStr =
        '${today.year}-'
        '${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';

    await _firestoreService.create(
      collectionPath: _collection,
      data: {
        'source': 'rent',
        'description': 'Rent from $tenantName — $unitName',
        'amount': amount,
        'date': dateStr,
        'groundId': groundId,
        'linkedTenantId': tenantId,
        'linkedRentRecordId': rentRecordId,
      },
      userId: userId,
    );
  }
}
