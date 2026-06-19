import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense.freezed.dart';
part 'expense.g.dart';

/// A single expense entry. Expenses can be entered manually (groceries,
/// maintenance, transport, etc.) or created automatically from another module
/// (a water bill, a school fee), in which case [isAutoLinked] is true and the
/// entry is read-only from the Finance module — manage it from its source.
@freezed
abstract class Expense with _$Expense {
  const Expense._();

  const factory Expense({
    required String id,
    required String category, // from ExpenseCategory enum value
    required String description, // "Plumber fixed kitchen sink"
    required double amount,
    required DateTime date,
    String? groundId, // which ground if property-related (null = household)
    String? module, // "rent"/"electricity"/"water"/"inventory"/"children"
    String? linkedDocumentId, // if auto-linked from another module
    @Default(false) bool isAutoLinked, // true if created by another module
    @Default('') String notes,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String updatedBy,
    @Default(1) int schemaVersion,
  }) = _Expense;

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);

  bool get isUncategorized =>
      category == 'other' || category == 'uncategorized';
  bool get hasGround => groundId != null && groundId!.isNotEmpty;
}
