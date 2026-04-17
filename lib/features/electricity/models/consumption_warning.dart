import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hms/core/widgets/alert_severity.dart';

part 'consumption_warning.freezed.dart';

/// In-memory computed consumption warning. Not persisted in Firestore.
@freezed
abstract class ConsumptionWarning with _$ConsumptionWarning {
  const ConsumptionWarning._();

  const factory ConsumptionWarning({
    required String groundId,
    required String unitId,
    required String unitName,
    required String meterId,
    required String meterNumber,
    String? tenantName,
    required double threshold,
    required double actualConsumption,
    required DateTime readingDate,
    required AlertSeverity severity,
  }) = _ConsumptionWarning;

  double get unitsOverThreshold => actualConsumption - threshold;

  double get percentOverThreshold =>
      threshold > 0 ? ((actualConsumption - threshold) / threshold * 100) : 0;
}
