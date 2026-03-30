// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'first_time_setup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firstTimeSetupService)
final firstTimeSetupServiceProvider = FirstTimeSetupServiceProvider._();

final class FirstTimeSetupServiceProvider
    extends
        $FunctionalProvider<
          FirstTimeSetupService,
          FirstTimeSetupService,
          FirstTimeSetupService
        >
    with $Provider<FirstTimeSetupService> {
  FirstTimeSetupServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firstTimeSetupServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firstTimeSetupServiceHash();

  @$internal
  @override
  $ProviderElement<FirstTimeSetupService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirstTimeSetupService create(Ref ref) {
    return firstTimeSetupService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirstTimeSetupService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirstTimeSetupService>(value),
    );
  }
}

String _$firstTimeSetupServiceHash() =>
    r'ea22f90b8ea12eb463939ea22dfd70b7eeaf65bb';

@ProviderFor(isFirstTimeSetup)
final isFirstTimeSetupProvider = IsFirstTimeSetupProvider._();

final class IsFirstTimeSetupProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  IsFirstTimeSetupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isFirstTimeSetupProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isFirstTimeSetupHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return isFirstTimeSetup(ref);
  }
}

String _$isFirstTimeSetupHash() => r'36e00f0d4d21b09da7f4422fd5c7b5442725d072';
