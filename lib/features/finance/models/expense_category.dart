import 'package:flutter/material.dart';

/// The set of expense categories tracked by the Finance module. The [value] is
/// the string persisted to Firestore; [label] and [icon] are presentation only.
enum ExpenseCategory {
  utilities('Utilities', 'utilities', Icons.electrical_services_outlined),
  maintenance('Maintenance', 'maintenance', Icons.build_outlined),
  groceries('Groceries', 'groceries', Icons.shopping_cart_outlined),
  school('School & Education', 'school', Icons.school_outlined),
  transport('Transport', 'transport', Icons.directions_bus_outlined),
  health('Health & Medical', 'health', Icons.local_hospital_outlined),
  food('Food & Dining', 'food', Icons.restaurant_outlined),
  clothing('Clothing', 'clothing', Icons.checkroom_outlined),
  airtime('Airtime & Data', 'airtime', Icons.phone_android_outlined),
  household('Household Items', 'household', Icons.home_outlined),
  entertainment('Entertainment', 'entertainment', Icons.movie_outlined),
  savings('Savings & Investment', 'savings', Icons.savings_outlined),
  debt('Debt & Loans', 'debt', Icons.account_balance_outlined),
  uncategorized(
    'Other / Uncategorized',
    'uncategorized',
    Icons.more_horiz_outlined,
  );

  const ExpenseCategory(this.label, this.value, this.icon);

  final String label;
  final String value;
  final IconData icon;

  /// Maps a persisted category value back to its enum, defaulting to
  /// [uncategorized] for unknown values.
  static ExpenseCategory fromString(String value) {
    return ExpenseCategory.values.firstWhere(
      (c) => c.value == value,
      orElse: () => ExpenseCategory.uncategorized,
    );
  }
}
