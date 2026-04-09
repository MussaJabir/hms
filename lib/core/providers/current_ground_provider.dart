import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_ground_provider.g.dart';

/// Holds the currently selected ground ID, or null when "All" is selected.
@riverpod
class CurrentGround extends _$CurrentGround {
  @override
  String? build() => null; // null = "All grounds"

  /// Select a specific ground by ID.
  void select(String? groundId) => state = groundId;
}
