import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary palette
  static const Color primary = Color(0xFF1B4F72);
  static const Color primaryLight = Color(0xFF2E86C1);

  // Accent
  static const Color secondary = Color(0xFFE67E22);

  // Status
  static const Color success = Color(0xFF27AE60);
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);

  // Light theme surfaces
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);

  // Light theme text
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);

  // Light theme border
  static const Color border = Color(0xFFD5D8DC);

  // Dark theme surfaces
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);

  // Dark theme text
  static const Color darkTextPrimary = Color(0xFFECF0F1);
  static const Color darkTextSecondary = Color(0xFF95A5A6);

  // Dark theme border
  static const Color darkBorder = Color(0xFF2C3E50);
}
