import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hms/core/theme/app_colors.dart';

part 'health_score.freezed.dart';

@freezed
abstract class HealthScore with _$HealthScore {
  const HealthScore._();

  const factory HealthScore({
    @Default(0) double rentScore,
    @Default(0) double billsScore,
    @Default(0) double stockScore,
    @Default(0) double overdueScore,
    @Default(0) double budgetScore,
    @Default(false) bool rentActive,
    @Default(false) bool billsActive,
    @Default(false) bool stockActive,
    @Default(false) bool overdueActive,
    @Default(false) bool budgetActive,
  }) = _HealthScore;

  static const double _rentWeight = 0.35;
  static const double _billsWeight = 0.20;
  static const double _stockWeight = 0.15;
  static const double _overdueWeight = 0.15;
  static const double _budgetWeight = 0.15;

  /// Weighted total score, redistributing weight from inactive modules.
  /// Returns 0 if no modules are active.
  double get totalScore {
    final activeWeights = <double>[];
    final activeScores = <double>[];

    if (rentActive) {
      activeWeights.add(_rentWeight);
      activeScores.add(rentScore);
    }
    if (billsActive) {
      activeWeights.add(_billsWeight);
      activeScores.add(billsScore);
    }
    if (stockActive) {
      activeWeights.add(_stockWeight);
      activeScores.add(stockScore);
    }
    if (overdueActive) {
      activeWeights.add(_overdueWeight);
      activeScores.add(overdueScore);
    }
    if (budgetActive) {
      activeWeights.add(_budgetWeight);
      activeScores.add(budgetScore);
    }

    if (activeWeights.isEmpty) return 0;

    final totalWeight = activeWeights.fold(0.0, (a, b) => a + b);
    double weighted = 0;
    for (var i = 0; i < activeWeights.length; i++) {
      weighted += (activeWeights[i] / totalWeight) * activeScores[i];
    }
    return weighted.clamp(0, 100);
  }

  /// Human-readable label based on score range.
  String get label {
    final score = totalScore;
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Needs Attention';
  }

  /// Color matching score range.
  Color get color {
    final score = totalScore;
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.primary;
    if (score >= 40) return AppColors.warning;
    return AppColors.error;
  }
}

/// Metadata for a single factor shown in the breakdown dialog.
class HealthScoreFactor {
  const HealthScoreFactor({
    required this.name,
    required this.weight,
    required this.score,
    required this.isActive,
  });

  final String name;
  final double weight; // 0.0–1.0
  final double score; // 0–100
  final bool isActive;
}
