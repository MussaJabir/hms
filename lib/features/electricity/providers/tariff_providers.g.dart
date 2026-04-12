// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tariff_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tariffService)
final tariffServiceProvider = TariffServiceProvider._();

final class TariffServiceProvider
    extends $FunctionalProvider<TariffService, TariffService, TariffService>
    with $Provider<TariffService> {
  TariffServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tariffServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tariffServiceHash();

  @$internal
  @override
  $ProviderElement<TariffService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TariffService create(Ref ref) {
    return tariffService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TariffService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TariffService>(value),
    );
  }
}

String _$tariffServiceHash() => r'1256129e5ef23fb21340e9d48678990e2883d491';

/// Streams the current TANESCO tariff tiers in real time.
/// Emits an empty list when no configuration has been saved yet.

@ProviderFor(currentTariffs)
final currentTariffsProvider = CurrentTariffsProvider._();

/// Streams the current TANESCO tariff tiers in real time.
/// Emits an empty list when no configuration has been saved yet.

final class CurrentTariffsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TanescoTier>>,
          List<TanescoTier>,
          Stream<List<TanescoTier>>
        >
    with
        $FutureModifier<List<TanescoTier>>,
        $StreamProvider<List<TanescoTier>> {
  /// Streams the current TANESCO tariff tiers in real time.
  /// Emits an empty list when no configuration has been saved yet.
  CurrentTariffsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentTariffsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentTariffsHash();

  @$internal
  @override
  $StreamProviderElement<List<TanescoTier>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TanescoTier>> create(Ref ref) {
    return currentTariffs(ref);
  }
}

String _$currentTariffsHash() => r'4c32280c98d0ded0a61e4d2e6dcc5cdd4d1626ca';

/// Calculates the estimated electricity cost for [unitsConsumed].

@ProviderFor(calculateCost)
final calculateCostProvider = CalculateCostFamily._();

/// Calculates the estimated electricity cost for [unitsConsumed].

final class CalculateCostProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  /// Calculates the estimated electricity cost for [unitsConsumed].
  CalculateCostProvider._({
    required CalculateCostFamily super.from,
    required double super.argument,
  }) : super(
         retry: null,
         name: r'calculateCostProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$calculateCostHash();

  @override
  String toString() {
    return r'calculateCostProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    final argument = this.argument as double;
    return calculateCost(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CalculateCostProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$calculateCostHash() => r'3f47211b19d7f88bfc0ac25233b014081e663742';

/// Calculates the estimated electricity cost for [unitsConsumed].

final class CalculateCostFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<double>, double> {
  CalculateCostFamily._()
    : super(
        retry: null,
        name: r'calculateCostProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Calculates the estimated electricity cost for [unitsConsumed].

  CalculateCostProvider call(double unitsConsumed) =>
      CalculateCostProvider._(argument: unitsConsumed, from: this);

  @override
  String toString() => r'calculateCostProvider';
}
