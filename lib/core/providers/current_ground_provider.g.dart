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
    extends $NotifierProvider<CurrentGround, String?> {
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
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$currentGroundHash() => r'4ae22f26a22ff0257a0fedf356137ef90dfa4546';

abstract class _$CurrentGround extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
