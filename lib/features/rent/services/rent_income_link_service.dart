import 'package:hms/features/finance/models/income.dart';
import 'package:hms/features/finance/services/income_service.dart';

/// Creates an [Income] entry whenever a rent payment is recorded, so the
/// Finance module picks up rent as income automatically without duplicate
/// entry. The entry is flagged [Income.isAutoLinked] so Finance keeps it
/// read-only — it must be managed from the rent module.
class RentIncomeLinkService {
  RentIncomeLinkService(this._incomeService);

  final IncomeService _incomeService;

  Future<void> createIncomeFromRentPayment({
    required String groundId,
    required String tenantId,
    required String tenantName,
    required String unitName,
    required String rentRecordId,
    required double amount,
    required String userId,
  }) async {
    final now = DateTime.now();
    final income = Income(
      id: '',
      source: 'rent',
      description: 'Rent from $tenantName — $unitName',
      amount: amount,
      date: now,
      groundId: groundId,
      linkedTenantId: tenantId,
      linkedRentRecordId: rentRecordId,
      isAutoLinked: true,
      createdAt: now,
      updatedAt: now,
      updatedBy: userId,
    );

    await _incomeService.createIncome(income: income, userId: userId);
  }
}
