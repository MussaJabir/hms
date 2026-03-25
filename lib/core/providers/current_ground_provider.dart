import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_ground_provider.g.dart';

@riverpod
class CurrentGround extends _$CurrentGround {
  @override
  String? build() => null;

  void selectGround(String groundId) => state = groundId;

  void clearSelection() => state = null;

  void selectAll() => state = 'all';
}
