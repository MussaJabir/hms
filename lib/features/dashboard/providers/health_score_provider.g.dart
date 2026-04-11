// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_score_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(healthScoreService)
final healthScoreServiceProvider = HealthScoreServiceProvider._();

final class HealthScoreServiceProvider
    extends
        $FunctionalProvider<
          HealthScoreService,
          HealthScoreService,
          HealthScoreService
        >
    with $Provider<HealthScoreService> {
  HealthScoreServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'healthScoreServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$healthScoreServiceHash();

  @$internal
  @override
  $ProviderElement<HealthScoreService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HealthScoreService create(Ref ref) {
    return healthScoreService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HealthScoreService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HealthScoreService>(value),
    );
  }
}

String _$healthScoreServiceHash() =>
    r'4c97369c268a377fede6f8d9d47e2dc7019b9751';

/// Health score computed with real rent data.
///
/// Watches [currentMonthCollectionRateProvider] (async) and falls back to 0
/// while the data is loading or on error, so the card always renders.

@ProviderFor(healthScore)
final healthScoreProvider = HealthScoreProvider._();

/// Health score computed with real rent data.
///
/// Watches [currentMonthCollectionRateProvider] (async) and falls back to 0
/// while the data is loading or on error, so the card always renders.

final class HealthScoreProvider
    extends $FunctionalProvider<HealthScore, HealthScore, HealthScore>
    with $Provider<HealthScore> {
  /// Health score computed with real rent data.
  ///
  /// Watches [currentMonthCollectionRateProvider] (async) and falls back to 0
  /// while the data is loading or on error, so the card always renders.
  HealthScoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'healthScoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$healthScoreHash();

  @$internal
  @override
  $ProviderElement<HealthScore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HealthScore create(Ref ref) {
    return healthScore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HealthScore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HealthScore>(value),
    );
  }
}

String _$healthScoreHash() => r'6af8e775298e65e5327dca1b113671116c8b9a7c';
