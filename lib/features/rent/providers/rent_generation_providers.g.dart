// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rent_generation_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(rentGenerationService)
final rentGenerationServiceProvider = RentGenerationServiceProvider._();

final class RentGenerationServiceProvider
    extends
        $FunctionalProvider<
          RentGenerationService,
          RentGenerationService,
          RentGenerationService
        >
    with $Provider<RentGenerationService> {
  RentGenerationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rentGenerationServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rentGenerationServiceHash();

  @$internal
  @override
  $ProviderElement<RentGenerationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RentGenerationService create(Ref ref) {
    return rentGenerationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RentGenerationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RentGenerationService>(value),
    );
  }
}

String _$rentGenerationServiceHash() =>
    r'f7c9de2f67608d0990de929495c3e122a04f388e';

/// Returns true when at least one rent record exists for the current month.

@ProviderFor(isCurrentMonthGenerated)
final isCurrentMonthGeneratedProvider = IsCurrentMonthGeneratedProvider._();

/// Returns true when at least one rent record exists for the current month.

final class IsCurrentMonthGeneratedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Returns true when at least one rent record exists for the current month.
  IsCurrentMonthGeneratedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isCurrentMonthGeneratedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isCurrentMonthGeneratedHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return isCurrentMonthGenerated(ref);
  }
}

String _$isCurrentMonthGeneratedHash() =>
    r'a1bd23170e510f400eeeac3a183e55dcea3a9210';
