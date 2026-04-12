// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(consumptionAnalyticsService)
final consumptionAnalyticsServiceProvider =
    ConsumptionAnalyticsServiceProvider._();

final class ConsumptionAnalyticsServiceProvider
    extends
        $FunctionalProvider<
          ConsumptionAnalyticsService,
          ConsumptionAnalyticsService,
          ConsumptionAnalyticsService
        >
    with $Provider<ConsumptionAnalyticsService> {
  ConsumptionAnalyticsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'consumptionAnalyticsServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$consumptionAnalyticsServiceHash();

  @$internal
  @override
  $ProviderElement<ConsumptionAnalyticsService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConsumptionAnalyticsService create(Ref ref) {
    return consumptionAnalyticsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConsumptionAnalyticsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConsumptionAnalyticsService>(value),
    );
  }
}

String _$consumptionAnalyticsServiceHash() =>
    r'e0c741248e901a641b4910493b8d0cb05cb9dce1';

/// Weekly consumption buckets for a meter over the last 12 weeks.

@ProviderFor(weeklyConsumption)
final weeklyConsumptionProvider = WeeklyConsumptionFamily._();

/// Weekly consumption buckets for a meter over the last 12 weeks.

final class WeeklyConsumptionProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WeeklyConsumption>>,
          List<WeeklyConsumption>,
          FutureOr<List<WeeklyConsumption>>
        >
    with
        $FutureModifier<List<WeeklyConsumption>>,
        $FutureProvider<List<WeeklyConsumption>> {
  /// Weekly consumption buckets for a meter over the last 12 weeks.
  WeeklyConsumptionProvider._({
    required WeeklyConsumptionFamily super.from,
    required (String, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'weeklyConsumptionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$weeklyConsumptionHash();

  @override
  String toString() {
    return r'weeklyConsumptionProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<WeeklyConsumption>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WeeklyConsumption>> create(Ref ref) {
    final argument = this.argument as (String, String, String);
    return weeklyConsumption(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is WeeklyConsumptionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$weeklyConsumptionHash() => r'05969efb96c36fb8c31a793f2b2f05ccc5e69f88';

/// Weekly consumption buckets for a meter over the last 12 weeks.

final class WeeklyConsumptionFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<WeeklyConsumption>>,
          (String, String, String)
        > {
  WeeklyConsumptionFamily._()
    : super(
        retry: null,
        name: r'weeklyConsumptionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Weekly consumption buckets for a meter over the last 12 weeks.

  WeeklyConsumptionProvider call(
    String groundId,
    String unitId,
    String meterId,
  ) => WeeklyConsumptionProvider._(
    argument: (groundId, unitId, meterId),
    from: this,
  );

  @override
  String toString() => r'weeklyConsumptionProvider';
}

/// Monthly consumption buckets for a meter over the last 6 months.

@ProviderFor(monthlyConsumption)
final monthlyConsumptionProvider = MonthlyConsumptionFamily._();

/// Monthly consumption buckets for a meter over the last 6 months.

final class MonthlyConsumptionProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MonthlyConsumption>>,
          List<MonthlyConsumption>,
          FutureOr<List<MonthlyConsumption>>
        >
    with
        $FutureModifier<List<MonthlyConsumption>>,
        $FutureProvider<List<MonthlyConsumption>> {
  /// Monthly consumption buckets for a meter over the last 6 months.
  MonthlyConsumptionProvider._({
    required MonthlyConsumptionFamily super.from,
    required (String, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'monthlyConsumptionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$monthlyConsumptionHash();

  @override
  String toString() {
    return r'monthlyConsumptionProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<MonthlyConsumption>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MonthlyConsumption>> create(Ref ref) {
    final argument = this.argument as (String, String, String);
    return monthlyConsumption(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyConsumptionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$monthlyConsumptionHash() =>
    r'd8744469824ba3364037c9eb2da6b0fef1be00d2';

/// Monthly consumption buckets for a meter over the last 6 months.

final class MonthlyConsumptionFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<MonthlyConsumption>>,
          (String, String, String)
        > {
  MonthlyConsumptionFamily._()
    : super(
        retry: null,
        name: r'monthlyConsumptionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Monthly consumption buckets for a meter over the last 6 months.

  MonthlyConsumptionProvider call(
    String groundId,
    String unitId,
    String meterId,
  ) => MonthlyConsumptionProvider._(
    argument: (groundId, unitId, meterId),
    from: this,
  );

  @override
  String toString() => r'monthlyConsumptionProvider';
}

/// Average weekly consumption (units) over the last 12 weeks.

@ProviderFor(averageConsumption)
final averageConsumptionProvider = AverageConsumptionFamily._();

/// Average weekly consumption (units) over the last 12 weeks.

final class AverageConsumptionProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  /// Average weekly consumption (units) over the last 12 weeks.
  AverageConsumptionProvider._({
    required AverageConsumptionFamily super.from,
    required (String, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'averageConsumptionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$averageConsumptionHash();

  @override
  String toString() {
    return r'averageConsumptionProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    final argument = this.argument as (String, String, String);
    return averageConsumption(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is AverageConsumptionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$averageConsumptionHash() =>
    r'91d7335ec3acee1d03f1eaa505c30bf324b3ba6f';

/// Average weekly consumption (units) over the last 12 weeks.

final class AverageConsumptionFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<double>, (String, String, String)> {
  AverageConsumptionFamily._()
    : super(
        retry: null,
        name: r'averageConsumptionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Average weekly consumption (units) over the last 12 weeks.

  AverageConsumptionProvider call(
    String groundId,
    String unitId,
    String meterId,
  ) => AverageConsumptionProvider._(
    argument: (groundId, unitId, meterId),
    from: this,
  );

  @override
  String toString() => r'averageConsumptionProvider';
}

/// Consumption across all units in a ground for a date range.

@ProviderFor(groundConsumption)
final groundConsumptionProvider = GroundConsumptionFamily._();

/// Consumption across all units in a ground for a date range.

final class GroundConsumptionProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<UnitConsumption>>,
          List<UnitConsumption>,
          FutureOr<List<UnitConsumption>>
        >
    with
        $FutureModifier<List<UnitConsumption>>,
        $FutureProvider<List<UnitConsumption>> {
  /// Consumption across all units in a ground for a date range.
  GroundConsumptionProvider._({
    required GroundConsumptionFamily super.from,
    required (String, DateTime, DateTime) super.argument,
  }) : super(
         retry: null,
         name: r'groundConsumptionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$groundConsumptionHash();

  @override
  String toString() {
    return r'groundConsumptionProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<UnitConsumption>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<UnitConsumption>> create(Ref ref) {
    final argument = this.argument as (String, DateTime, DateTime);
    return groundConsumption(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is GroundConsumptionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$groundConsumptionHash() => r'8d57f5f18e8563bc4d2e87230f7246c9ddf73b8f';

/// Consumption across all units in a ground for a date range.

final class GroundConsumptionFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<UnitConsumption>>,
          (String, DateTime, DateTime)
        > {
  GroundConsumptionFamily._()
    : super(
        retry: null,
        name: r'groundConsumptionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Consumption across all units in a ground for a date range.

  GroundConsumptionProvider call(
    String groundId,
    DateTime start,
    DateTime end,
  ) =>
      GroundConsumptionProvider._(argument: (groundId, start, end), from: this);

  @override
  String toString() => r'groundConsumptionProvider';
}
