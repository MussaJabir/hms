import 'package:freezed_annotation/freezed_annotation.dart';

part 'communication_log.freezed.dart';
part 'communication_log.g.dart';

@freezed
abstract class CommunicationLog with _$CommunicationLog {
  const factory CommunicationLog({
    required String id,
    required String tenantId,
    required String note,
    required DateTime createdAt,
    required String createdBy,
    @Default(1) int schemaVersion,
  }) = _CommunicationLog;

  factory CommunicationLog.fromJson(Map<String, dynamic> json) =>
      _$CommunicationLogFromJson(json);
}
