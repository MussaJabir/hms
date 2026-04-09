// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_ground_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds the currently selected ground ID, or null when "All" is selected.

@ProviderFor(CurrentGround)
final currentGroundProvider = CurrentGroundProvider._();

/// Holds the currently selected ground ID, or null when "All" is selected.
final class CurrentGroundProvider
    extends $NotifierProvider<CurrentGround, String?> {
  /// Holds the currently selected ground ID, or null when "All" is selected.
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

String _$currentGroundHash() => r'21d2ddee49c07cc161b70af1793f8c93510e0876';

/// Holds the currently selected ground ID, or null when "All" is selected.

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
