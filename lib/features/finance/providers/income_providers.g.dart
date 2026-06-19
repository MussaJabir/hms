// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(incomeService)
final incomeServiceProvider = IncomeServiceProvider._();

final class IncomeServiceProvider
    extends $FunctionalProvider<IncomeService, IncomeService, IncomeService>
    with $Provider<IncomeService> {
  IncomeServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'incomeServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$incomeServiceHash();

  @$internal
  @override
  $ProviderElement<IncomeService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IncomeService create(Ref ref) {
    return incomeService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IncomeService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IncomeService>(value),
    );
  }
}

String _$incomeServiceHash() => r'bae70d888ec1b1444f834d56174f25d5978d00fd';

/// Streams every income entry, newest first.

@ProviderFor(allIncome)
final allIncomeProvider = AllIncomeProvider._();

/// Streams every income entry, newest first.

final class AllIncomeProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Income>>,
          List<Income>,
          Stream<List<Income>>
        >
    with $FutureModifier<List<Income>>, $StreamProvider<List<Income>> {
  /// Streams every income entry, newest first.
  AllIncomeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allIncomeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allIncomeHash();

  @$internal
  @override
  $StreamProviderElement<List<Income>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Income>> create(Ref ref) {
    return allIncome(ref);
  }
}

String _$allIncomeHash() => r'9b66e677e7768f5942ed40f620061df1449d5f6f';

/// Streams income for the current calendar month.

@ProviderFor(currentMonthIncome)
final currentMonthIncomeProvider = CurrentMonthIncomeProvider._();

/// Streams income for the current calendar month.

final class CurrentMonthIncomeProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Income>>,
          List<Income>,
          Stream<List<Income>>
        >
    with $FutureModifier<List<Income>>, $StreamProvider<List<Income>> {
  /// Streams income for the current calendar month.
  CurrentMonthIncomeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentMonthIncomeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentMonthIncomeHash();

  @$internal
  @override
  $StreamProviderElement<List<Income>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Income>> create(Ref ref) {
    return currentMonthIncome(ref);
  }
}

String _$currentMonthIncomeHash() =>
    r'0a1a628a79c62815b830d54dac15588323360f2c';

/// Total income for the current month, scoped to the selected ground.

@ProviderFor(currentMonthIncomeTotal)
final currentMonthIncomeTotalProvider = CurrentMonthIncomeTotalProvider._();

/// Total income for the current month, scoped to the selected ground.

final class CurrentMonthIncomeTotalProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  /// Total income for the current month, scoped to the selected ground.
  CurrentMonthIncomeTotalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentMonthIncomeTotalProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentMonthIncomeTotalHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return currentMonthIncomeTotal(ref);
  }
}

String _$currentMonthIncomeTotalHash() =>
    r'8811ee41a7489e0a43ce124bf1b1bade382f16bf';

/// Income grouped by source value for a given "yyyy-MM" period.

@ProviderFor(incomeBySource)
final incomeBySourceProvider = IncomeBySourceFamily._();

/// Income grouped by source value for a given "yyyy-MM" period.

final class IncomeBySourceProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, double>>,
          Map<String, double>,
          FutureOr<Map<String, double>>
        >
    with
        $FutureModifier<Map<String, double>>,
        $FutureProvider<Map<String, double>> {
  /// Income grouped by source value for a given "yyyy-MM" period.
  IncomeBySourceProvider._({
    required IncomeBySourceFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'incomeBySourceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$incomeBySourceHash();

  @override
  String toString() {
    return r'incomeBySourceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, double>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, double>> create(Ref ref) {
    final argument = this.argument as String;
    return incomeBySource(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IncomeBySourceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$incomeBySourceHash() => r'c7322ae23e07ac93c30962d83ee863612000b013';

/// Income grouped by source value for a given "yyyy-MM" period.

final class IncomeBySourceFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Map<String, double>>, String> {
  IncomeBySourceFamily._()
    : super(
        retry: null,
        name: r'incomeBySourceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Income grouped by source value for a given "yyyy-MM" period.

  IncomeBySourceProvider call(String period) =>
      IncomeBySourceProvider._(argument: period, from: this);

  @override
  String toString() => r'incomeBySourceProvider';
}
