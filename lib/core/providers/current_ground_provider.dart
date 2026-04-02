import 'package:hms/features/grounds/models/ground_filter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_ground_provider.g.dart';

@riverpod
class CurrentGround extends _$CurrentGround {
  @override
  GroundFilter build() => GroundFilter.all;

  void select(GroundFilter filter) => state = filter;
}
