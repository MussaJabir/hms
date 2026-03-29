import 'package:intl/intl.dart';

final _fullFormat = NumberFormat('#,##0', 'en_US');

/// Format a number as TZS currency.
///
/// Examples:
///   formatTZS(1250000)              → "TZS 1,250,000"
///   formatTZS(1250000, short: true) → "TZS 1.25M"
///   formatTZS(50000)                → "TZS 50,000"
///   formatTZS(50000, short: true)   → "TZS 50K"
///   formatTZS(0)                    → "TZS 0"
///   formatTZS(1500.50)              → "TZS 1,501"
String formatTZS(double amount, {bool short = false}) {
  return 'TZS ${formatNumber(amount, short: short)}';
}

/// Format just the number without the "TZS" prefix.
///
/// Examples:
///   formatNumber(1250000)              → "1,250,000"
///   formatNumber(50000, short: true)   → "50K"
String formatNumber(double amount, {bool short = false}) {
  if (short) {
    return _shortFormat(amount);
  }
  return _fullFormat.format(amount.roundToDouble());
}

String _shortFormat(double amount) {
  final abs = amount.abs();
  final sign = amount < 0 ? '-' : '';

  if (abs >= 1000000) {
    final val = abs / 1000000;
    final formatted = val == val.truncateToDouble()
        ? val.toInt().toString()
        : val.toStringAsFixed(2);
    return '$sign${formatted}M';
  }
  if (abs >= 1000) {
    final val = abs / 1000;
    final formatted = val == val.truncateToDouble()
        ? val.toInt().toString()
        : val.toStringAsFixed(1);
    return '$sign${formatted}K';
  }
  return '$sign${_fullFormat.format(abs.roundToDouble())}';
}
