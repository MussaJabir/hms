import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hms/core/widgets/alert_severity.dart';

part 'dashboard_alert.freezed.dart';

/// In-memory computed alert. Not persisted in Firestore.
@freezed
abstract class DashboardAlert with _$DashboardAlert {
  const factory DashboardAlert({
    required String id,
    required String title,
    required String message,
    required AlertSeverity severity,
    required IconData icon,
    required String module,
    required DateTime createdAt,
    String? targetRoute,
    String? targetId,
    String? actionLabel,
  }) = _DashboardAlert;
}
