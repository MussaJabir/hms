// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_ground_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CurrentGround)
final currentGroundProvider = CurrentGroundProvider._();

final class CurrentGroundProvider
    extends $NotifierProvider<CurrentGround, GroundFilter> {
  CurrentGroundProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentGroundProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentGroundHash();

  @$internal
  @override
  CurrentGround create() => CurrentGround();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GroundFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GroundFilter>(value),
    );
  }
}

String _$currentGroundHash() => r'4f70bd506b2e35ea817ea13dae9ea1bbd52a1cee';

abstract class _$CurrentGround extends $Notifier<GroundFilter> {
  GroundFilter build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<GroundFilter, GroundFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GroundFilter, GroundFilter>,
              GroundFilter,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
