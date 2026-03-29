import 'package:intl/intl.dart';

abstract class Validators {
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) return 'Invalid email address';
    return null;
  }

  static String? minLength(String? value, int length) {
    if (value == null || value.length < length) {
      return 'Must be at least $length characters';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final digits = value.trim();
    final phoneRegex = RegExp(r'^0[67]\d{8}$');
    if (!phoneRegex.hasMatch(digits)) {
      return 'Invalid phone number — use format 07XXXXXXXX';
    }
    return null;
  }

  static String? nationalId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'National ID is required';
    }
    if (value.trim().length != 20) {
      return 'National ID must be 20 characters';
    }
    return null;
  }

  static String? positiveAmount(String? value) {
    if (value == null || value.trim().isEmpty) return 'Amount is required';
    final raw = double.tryParse(value.replaceAll(',', ''));
    if (raw == null) return 'Amount must be a valid number';
    if (raw <= 0) return 'Amount must be greater than 0';
    return null;
  }

  static String? meterReading(String? value, {double? previousReading}) {
    if (value == null || value.trim().isEmpty) {
      return 'Meter reading is required';
    }
    final reading = double.tryParse(value.trim());
    if (reading == null) return 'Must be a valid number';
    if (previousReading != null && reading < previousReading) {
      final formatted = NumberFormat('#,##0.##').format(previousReading);
      return 'Reading must be greater than or equal to previous reading ($formatted)';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  static String? dateNotInPast(DateTime? value) {
    if (value == null) return 'Date is required';
    final today = DateTime.now();
    final startOfToday = DateTime(today.year, today.month, today.day);
    if (value.isBefore(startOfToday)) return 'Date cannot be in the past';
    return null;
  }

  static String? dateAfter(
    DateTime? value,
    DateTime? afterDate, {
    String fieldName = 'Date',
  }) {
    if (value == null) return '$fieldName is required';
    if (afterDate == null) return null;
    if (!value.isAfter(afterDate)) {
      final formatted = DateFormat('dd/MM/yyyy').format(afterDate);
      return '$fieldName must be after $formatted';
    }
    return null;
  }
}
