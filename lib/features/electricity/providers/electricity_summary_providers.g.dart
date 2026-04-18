// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'electricity_summary_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(electricitySummaryService)
final electricitySummaryServiceProvider = ElectricitySummaryServiceProvider._();

final class ElectricitySummaryServiceProvider
    extends
        $FunctionalProvider<
          ElectricitySummaryService,
          ElectricitySummaryService,
          ElectricitySummaryService
        >
    with $Provider<ElectricitySummaryService> {
  ElectricitySummaryServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'electricitySummaryServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$electricitySummaryServiceHash();

  @$internal
  @override
  $ProviderElement<ElectricitySummaryService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ElectricitySummaryService create(Ref ref) {
    return electricitySummaryService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ElectricitySummaryService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ElectricitySummaryService>(value),
    );
  }
}

String _$electricitySummaryServiceHash() =>
    r'94423646fa51609c793c4718ca87aab4154dbaeb';

@ProviderFor(currentWeekUnits)
final currentWeekUnitsProvider = CurrentWeekUnitsProvider._();

final class CurrentWeekUnitsProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  CurrentWeekUnitsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentWeekUnitsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentWeekUnitsHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return currentWeekUnits(ref);
  }
}

String _$currentWeekUnitsHash() => r'0fba9a6e2af238645e6abb342892e0fe08209191';

@ProviderFor(currentMonthUnits)
final currentMonthUnitsProvider = CurrentMonthUnitsProvider._();

final class CurrentMonthUnitsProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  CurrentMonthUnitsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentMonthUnitsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentMonthUnitsHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return currentMonthUnits(ref);
  }
}

String _$currentMonthUnitsHash() => r'4948fd1d77e451216ab90f16de396e6545088dfe';

@ProviderFor(currentWeekCost)
final currentWeekCostProvider = CurrentWeekCostProvider._();

final class CurrentWeekCostProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  CurrentWeekCostProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentWeekCostProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentWeekCostHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return currentWeekCost(ref);
  }
}

String _$currentWeekCostHash() => r'eadb373d445317184be3f3b4aa63c191c99e741d';

@ProviderFor(currentMonthCost)
final currentMonthCostProvider = CurrentMonthCostProvider._();

final class CurrentMonthCostProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  CurrentMonthCostProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentMonthCostProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentMonthCostHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return currentMonthCost(ref);
  }
}

String _$currentMonthCostHash() => r'18fc6a557a5dc634b328d7bdde537c59e8045f42';

@ProviderFor(activeMetersCount)
final activeMetersCountProvider = ActiveMetersCountProvider._();

final class ActiveMetersCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  ActiveMetersCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeMetersCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeMetersCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return activeMetersCount(ref);
  }
}

String _$activeMetersCountHash() => r'eb14a6b50f631af99616f48f6ffbc2c10186e3fb';

@ProviderFor(electricityPendingReadingsCount)
final electricityPendingReadingsCountProvider =
    ElectricityPendingReadingsCountProvider._();

final class ElectricityPendingReadingsCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  ElectricityPendingReadingsCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'electricityPendingReadingsCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$electricityPendingReadingsCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return electricityPendingReadingsCount(ref);
  }
}

String _$electricityPendingReadingsCountHash() =>
    r'9549f4370312e26f82990baa00161324ae205f86';

@ProviderFor(electricityWarningCount)
final electricityWarningCountProvider = ElectricityWarningCountProvider._();

final class ElectricityWarningCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  ElectricityWarningCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'electricityWarningCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$electricityWarningCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return electricityWarningCount(ref);
  }
}

String _$electricityWarningCountHash() =>
    r'ade2172f81c5c496d760127bbd6d0126188e226f';

@ProviderFor(weekOverWeekTrend)
final weekOverWeekTrendProvider = WeekOverWeekTrendProvider._();

final class WeekOverWeekTrendProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  WeekOverWeekTrendProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weekOverWeekTrendProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weekOverWeekTrendHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return weekOverWeekTrend(ref);
  }
}

String _$weekOverWeekTrendHash() => r'2b8cd2873579f968e5d2cdee17f77e80f3df6c7f';
