// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_summary_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(financialSummaryService)
final financialSummaryServiceProvider = FinancialSummaryServiceProvider._();

final class FinancialSummaryServiceProvider
    extends
        $FunctionalProvider<
          FinancialSummaryService,
          FinancialSummaryService,
          FinancialSummaryService
        >
    with $Provider<FinancialSummaryService> {
  FinancialSummaryServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'financialSummaryServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$financialSummaryServiceHash();

  @$internal
  @override
  $ProviderElement<FinancialSummaryService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FinancialSummaryService create(Ref ref) {
    return financialSummaryService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FinancialSummaryService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FinancialSummaryService>(value),
    );
  }
}

String _$financialSummaryServiceHash() =>
    r'6ff2f7502fc65d17e27116dd426b43d49d9840f3';

/// Full financial summary for the current month, scoped to the selected ground.

@ProviderFor(currentMonthSummary)
final currentMonthSummaryProvider = CurrentMonthSummaryProvider._();

/// Full financial summary for the current month, scoped to the selected ground.

final class CurrentMonthSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<FinancialSummary>,
          FinancialSummary,
          FutureOr<FinancialSummary>
        >
    with $FutureModifier<FinancialSummary>, $FutureProvider<FinancialSummary> {
  /// Full financial summary for the current month, scoped to the selected ground.
  CurrentMonthSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentMonthSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentMonthSummaryHash();

  @$internal
  @override
  $FutureProviderElement<FinancialSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FinancialSummary> create(Ref ref) {
    return currentMonthSummary(ref);
  }
}

String _$currentMonthSummaryHash() =>
    r'13b7d885acd8ad535d11bdc2a558db9daf770eef';

/// Per-ground income vs expenses comparison for a given "yyyy-MM" period.

@ProviderFor(perGroundComparison)
final perGroundComparisonProvider = PerGroundComparisonFamily._();

/// Per-ground income vs expenses comparison for a given "yyyy-MM" period.

final class PerGroundComparisonProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GroundFinancialSummary>>,
          List<GroundFinancialSummary>,
          FutureOr<List<GroundFinancialSummary>>
        >
    with
        $FutureModifier<List<GroundFinancialSummary>>,
        $FutureProvider<List<GroundFinancialSummary>> {
  /// Per-ground income vs expenses comparison for a given "yyyy-MM" period.
  PerGroundComparisonProvider._({
    required PerGroundComparisonFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'perGroundComparisonProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$perGroundComparisonHash();

  @override
  String toString() {
    return r'perGroundComparisonProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<GroundFinancialSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GroundFinancialSummary>> create(Ref ref) {
    final argument = this.argument as String;
    return perGroundComparison(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PerGroundComparisonProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$perGroundComparisonHash() =>
    r'02c483857ed9e74e131bd11c501b1c877745857a';

/// Per-ground income vs expenses comparison for a given "yyyy-MM" period.

final class PerGroundComparisonFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<GroundFinancialSummary>>,
          String
        > {
  PerGroundComparisonFamily._()
    : super(
        retry: null,
        name: r'perGroundComparisonProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Per-ground income vs expenses comparison for a given "yyyy-MM" period.

  PerGroundComparisonProvider call(String period) =>
      PerGroundComparisonProvider._(argument: period, from: this);

  @override
  String toString() => r'perGroundComparisonProvider';
}

/// Income/expense trend for the last 6 months.

@ProviderFor(monthlyTrends)
final monthlyTrendsProvider = MonthlyTrendsProvider._();

/// Income/expense trend for the last 6 months.

final class MonthlyTrendsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MonthlyTrend>>,
          List<MonthlyTrend>,
          FutureOr<List<MonthlyTrend>>
        >
    with
        $FutureModifier<List<MonthlyTrend>>,
        $FutureProvider<List<MonthlyTrend>> {
  /// Income/expense trend for the last 6 months.
  MonthlyTrendsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monthlyTrendsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monthlyTrendsHash();

  @$internal
  @override
  $FutureProviderElement<List<MonthlyTrend>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MonthlyTrend>> create(Ref ref) {
    return monthlyTrends(ref);
  }
}

String _$monthlyTrendsHash() => r'7570b4c777db37eafc752f1f11ea895094a2100c';

/// Net position for a "yyyy-MM" period, scoped to a ground when [groundId] is
/// non-null.

@ProviderFor(netPosition)
final netPositionProvider = NetPositionFamily._();

/// Net position for a "yyyy-MM" period, scoped to a ground when [groundId] is
/// non-null.

final class NetPositionProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  /// Net position for a "yyyy-MM" period, scoped to a ground when [groundId] is
  /// non-null.
  NetPositionProvider._({
    required NetPositionFamily super.from,
    required (String, {String? groundId}) super.argument,
  }) : super(
         retry: null,
         name: r'netPositionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$netPositionHash();

  @override
  String toString() {
    return r'netPositionProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    final argument = this.argument as (String, {String? groundId});
    return netPosition(ref, argument.$1, groundId: argument.groundId);
  }

  @override
  bool operator ==(Object other) {
    return other is NetPositionProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$netPositionHash() => r'2b201889f9e639a18465e2b9d78c3218a3fa934e';

/// Net position for a "yyyy-MM" period, scoped to a ground when [groundId] is
/// non-null.

final class NetPositionFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<double>,
          (String, {String? groundId})
        > {
  NetPositionFamily._()
    : super(
        retry: null,
        name: r'netPositionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Net position for a "yyyy-MM" period, scoped to a ground when [groundId] is
  /// non-null.

  NetPositionProvider call(String period, {String? groundId}) =>
      NetPositionProvider._(argument: (period, groundId: groundId), from: this);

  @override
  String toString() => r'netPositionProvider';
}
