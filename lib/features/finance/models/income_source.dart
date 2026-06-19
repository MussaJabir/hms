import 'package:flutter/material.dart';

/// The set of income sources tracked by the Finance module. The [value] is the
/// string persisted to Firestore; [label] and [icon] are presentation only.
enum IncomeSource {
  rent('Rent', 'rent', Icons.payments_outlined),
  freelance('Freelance', 'freelance', Icons.computer_outlined),
  business('Business', 'business', Icons.store_outlined),
  bodaboda('Bodaboda', 'bodaboda', Icons.two_wheeler_outlined),
  salary('Salary', 'salary', Icons.account_balance_outlined),
  gift('Gift', 'gift', Icons.card_giftcard_outlined),
  other('Other', 'other', Icons.attach_money_outlined);

  const IncomeSource(this.label, this.value, this.icon);

  final String label;
  final String value;
  final IconData icon;

  /// Maps a persisted source value back to its enum, defaulting to [other].
  static IncomeSource fromString(String value) {
    return IncomeSource.values.firstWhere(
      (s) => s.value == value,
      orElse: () => IncomeSource.other,
    );
  }
}
