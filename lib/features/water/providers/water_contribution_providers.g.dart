// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_contribution_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(waterContributionService)
final waterContributionServiceProvider = WaterContributionServiceProvider._();

final class WaterContributionServiceProvider
    extends
        $FunctionalProvider<
          WaterContributionService,
          WaterContributionService,
          WaterContributionService
        >
    with $Provider<WaterContributionService> {
  WaterContributionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'waterContributionServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$waterContributionServiceHash();

  @$internal
  @override
  $ProviderElement<WaterContributionService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WaterContributionService create(Ref ref) {
    return waterContributionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WaterContributionService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WaterContributionService>(value),
    );
  }
}

String _$waterContributionServiceHash() =>
    r'fb1d2b2aec08928e9bb1b7b2992433d3cbaa2eda';

@ProviderFor(currentMonthContributions)
final currentMonthContributionsProvider = CurrentMonthContributionsFamily._();

final class CurrentMonthContributionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RecurringRecord>>,
          List<RecurringRecord>,
          Stream<List<RecurringRecord>>
        >
    with
        $FutureModifier<List<RecurringRecord>>,
        $StreamProvider<List<RecurringRecord>> {
  CurrentMonthContributionsProvider._({
    required CurrentMonthContributionsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'currentMonthContributionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$currentMonthContributionsHash();

  @override
  String toString() {
    return r'currentMonthContributionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<RecurringRecord>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<RecurringRecord>> create(Ref ref) {
    final argument = this.argument as String;
    return currentMonthContributions(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentMonthContributionsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$currentMonthContributionsHash() =>
    r'f163e3280c9e9703578dbefa82e6fe23867aea77';

final class CurrentMonthContributionsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<RecurringRecord>>, String> {
  CurrentMonthContributionsFamily._()
    : super(
        retry: null,
        name: r'currentMonthContributionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CurrentMonthContributionsProvider call(String groundId) =>
      CurrentMonthContributionsProvider._(argument: groundId, from: this);

  @override
  String toString() => r'currentMonthContributionsProvider';
}

@ProviderFor(monthContributions)
final monthContributionsProvider = MonthContributionsFamily._();

final class MonthContributionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RecurringRecord>>,
          List<RecurringRecord>,
          Stream<List<RecurringRecord>>
        >
    with
        $FutureModifier<List<RecurringRecord>>,
        $StreamProvider<List<RecurringRecord>> {
  MonthContributionsProvider._({
    required MonthContributionsFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'monthContributionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$monthContributionsHash();

  @override
  String toString() {
    return r'monthContributionsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<RecurringRecord>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<RecurringRecord>> create(Ref ref) {
    final argument = this.argument as (String, String);
    return monthContributions(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthContributionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$monthContributionsHash() =>
    r'd470b8ed0565b3f8bdf5b7e89b614490f466f1c2';

final class MonthContributionsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<List<RecurringRecord>>,
          (String, String)
        > {
  MonthContributionsFamily._()
    : super(
        retry: null,
        name: r'monthContributionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MonthContributionsProvider call(String groundId, String period) =>
      MonthContributionsProvider._(argument: (groundId, period), from: this);

  @override
  String toString() => r'monthContributionsProvider';
}

@ProviderFor(surplusDeficit)
final surplusDeficitProvider = SurplusDeficitFamily._();

final class SurplusDeficitProvider
    extends
        $FunctionalProvider<
          AsyncValue<WaterSurplusDeficit>,
          WaterSurplusDeficit,
          FutureOr<WaterSurplusDeficit>
        >
    with
        $FutureModifier<WaterSurplusDeficit>,
        $FutureProvider<WaterSurplusDeficit> {
  SurplusDeficitProvider._({
    required SurplusDeficitFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'surplusDeficitProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$surplusDeficitHash();

  @override
  String toString() {
    return r'surplusDeficitProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<WaterSurplusDeficit> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WaterSurplusDeficit> create(Ref ref) {
    final argument = this.argument as (String, String);
    return surplusDeficit(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is SurplusDeficitProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$surplusDeficitHash() => r'f84cf33c1541bd18d500c562ededaeb3bc685b39';

final class SurplusDeficitFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<WaterSurplusDeficit>,
          (String, String)
        > {
  SurplusDeficitFamily._()
    : super(
        retry: null,
        name: r'surplusDeficitProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SurplusDeficitProvider call(String groundId, String period) =>
      SurplusDeficitProvider._(argument: (groundId, period), from: this);

  @override
  String toString() => r'surplusDeficitProvider';
}

@ProviderFor(defaultContributionAmount)
final defaultContributionAmountProvider = DefaultContributionAmountProvider._();

final class DefaultContributionAmountProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  DefaultContributionAmountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'defaultContributionAmountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$defaultContributionAmountHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return defaultContributionAmount(ref);
  }
}

String _$defaultContributionAmountHash() =>
    r'a9d89ffc1fab21dd77526ad385243eefb6f29a56';
