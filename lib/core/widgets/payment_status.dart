enum PaymentStatus {
  paid('Paid', 'paid'),
  partial('Partial', 'partial'),
  pending('Pending', 'pending'),
  overdue('Overdue', 'overdue'),
  unpaid('Unpaid', 'unpaid'),
  vacant('Vacant', 'vacant'),
  active('Active', 'active'),
  inactive('Inactive', 'inactive'),
  low('Low Stock', 'low'),
  adequate('Adequate', 'adequate'),
  high('High', 'high');

  final String label;
  final String value;

  const PaymentStatus(this.label, this.value);

  /// Create from a string value (e.g., from Firestore). Falls back to [pending].
  static PaymentStatus fromString(String value) {
    return PaymentStatus.values.firstWhere(
      (s) => s.value == value,
      orElse: () => PaymentStatus.pending,
    );
  }
}
