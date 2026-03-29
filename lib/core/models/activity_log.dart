import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_log.freezed.dart';
part 'activity_log.g.dart';

@freezed
abstract class ActivityLog with _$ActivityLog {
  const factory ActivityLog({
    required String id,
    required String userId,
    required String action, // e.g., "created", "updated", "deleted"
    required String module, // e.g., "rent", "electricity", "inventory"
    required String
    description, // human-readable: "Marked rent paid for Room 3"
    String? documentId, // the ID of the affected document
    String? collectionPath, // the collection of the affected document
    required DateTime createdAt,
    @Default(1) int schemaVersion,
  }) = _ActivityLog;

  factory ActivityLog.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogFromJson(json);
}
