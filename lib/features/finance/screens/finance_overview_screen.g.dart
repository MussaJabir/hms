// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_overview_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FinanceOverviewPeriod)
final financeOverviewPeriodProvider = FinanceOverviewPeriodProvider._();

final class FinanceOverviewPeriodProvider
    extends $NotifierProvider<FinanceOverviewPeriod, DateTime> {
  FinanceOverviewPeriodProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'financeOverviewPeriodProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$financeOverviewPeriodHash();

  @$internal
  @override
  FinanceOverviewPeriod create() => FinanceOverviewPeriod();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$financeOverviewPeriodHash() =>
    r'fc414b5ac808af5f5b08e71216b58897e5eb434a';

abstract class _$FinanceOverviewPeriod extends $Notifier<DateTime> {
  DateTime build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DateTime, DateTime>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DateTime, DateTime>,
              DateTime,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(financeSummaryForPeriod)
final financeSummaryForPeriodProvider = FinanceSummaryForPeriodFamily._();

final class FinanceSummaryForPeriodProvider
    extends
        $FunctionalProvider<
          AsyncValue<FinancialSummary>,
          FinancialSummary,
          FutureOr<FinancialSummary>
        >
    with $FutureModifier<FinancialSummary>, $FutureProvider<FinancialSummary> {
  FinanceSummaryForPeriodProvider._({
    required FinanceSummaryForPeriodFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'financeSummaryForPeriodProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$financeSummaryForPeriodHash();

  @override
  String toString() {
    return r'financeSummaryForPeriodProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<FinancialSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FinancialSummary> create(Ref ref) {
    final argument = this.argument as String;
    return financeSummaryForPeriod(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FinanceSummaryForPeriodProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$financeSummaryForPeriodHash() =>
    r'4209071f1d4fa1b7ffc5e79847452e7b096330d6';

final class FinanceSummaryForPeriodFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<FinancialSummary>, String> {
  FinanceSummaryForPeriodFamily._()
    : super(
        retry: null,
        name: r'financeSummaryForPeriodProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FinanceSummaryForPeriodProvider call(String period) =>
      FinanceSummaryForPeriodProvider._(argument: period, from: this);

  @override
  String toString() => r'financeSummaryForPeriodProvider';
}

@ProviderFor(financeIncomeForPeriod)
final financeIncomeForPeriodProvider = FinanceIncomeForPeriodFamily._();

final class FinanceIncomeForPeriodProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Income>>,
          List<Income>,
          Stream<List<Income>>
        >
    with $FutureModifier<List<Income>>, $StreamProvider<List<Income>> {
  FinanceIncomeForPeriodProvider._({
    required FinanceIncomeForPeriodFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'financeIncomeForPeriodProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$financeIncomeForPeriodHash();

  @override
  String toString() {
    return r'financeIncomeForPeriodProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Income>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Income>> create(Ref ref) {
    final argument = this.argument as String;
    return financeIncomeForPeriod(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FinanceIncomeForPeriodProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$financeIncomeForPeriodHash() =>
    r'4691489cc2e066ee9999ef0b59e355c79eefc442';

final class FinanceIncomeForPeriodFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Income>>, String> {
  FinanceIncomeForPeriodFamily._()
    : super(
        retry: null,
        name: r'financeIncomeForPeriodProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FinanceIncomeForPeriodProvider call(String period) =>
      FinanceIncomeForPeriodProvider._(argument: period, from: this);

  @override
  String toString() => r'financeIncomeForPeriodProvider';
}

@ProviderFor(financeExpensesForPeriod)
final financeExpensesForPeriodProvider = FinanceExpensesForPeriodFamily._();

final class FinanceExpensesForPeriodProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Expense>>,
          List<Expense>,
          Stream<List<Expense>>
        >
    with $FutureModifier<List<Expense>>, $StreamProvider<List<Expense>> {
  FinanceExpensesForPeriodProvider._({
    required FinanceExpensesForPeriodFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'financeExpensesForPeriodProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$financeExpensesForPeriodHash();

  @override
  String toString() {
    return r'financeExpensesForPeriodProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Expense>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Expense>> create(Ref ref) {
    final argument = this.argument as String;
    return financeExpensesForPeriod(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FinanceExpensesForPeriodProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$financeExpensesForPeriodHash() =>
    r'4032555070aff697cc455c2cc1121c18b20f80e2';

final class FinanceExpensesForPeriodFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Expense>>, String> {
  FinanceExpensesForPeriodFamily._()
    : super(
        retry: null,
        name: r'financeExpensesForPeriodProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FinanceExpensesForPeriodProvider call(String period) =>
      FinanceExpensesForPeriodProvider._(argument: period, from: this);

  @override
  String toString() => r'financeExpensesForPeriodProvider';
}

@ProviderFor(financeBudgetsForPeriod)
final financeBudgetsForPeriodProvider = FinanceBudgetsForPeriodFamily._();

final class FinanceBudgetsForPeriodProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Budget>>,
          List<Budget>,
          Stream<List<Budget>>
        >
    with $FutureModifier<List<Budget>>, $StreamProvider<List<Budget>> {
  FinanceBudgetsForPeriodProvider._({
    required FinanceBudgetsForPeriodFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'financeBudgetsForPeriodProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$financeBudgetsForPeriodHash();

  @override
  String toString() {
    return r'financeBudgetsForPeriodProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Budget>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Budget>> create(Ref ref) {
    final argument = this.argument as String;
    return financeBudgetsForPeriod(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FinanceBudgetsForPeriodProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$financeBudgetsForPeriodHash() =>
    r'ee1068441ef1ad81b6ae9888522e81693244a0b2';

final class FinanceBudgetsForPeriodFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Budget>>, String> {
  FinanceBudgetsForPeriodFamily._()
    : super(
        retry: null,
        name: r'financeBudgetsForPeriodProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FinanceBudgetsForPeriodProvider call(String period) =>
      FinanceBudgetsForPeriodProvider._(argument: period, from: this);

  @override
  String toString() => r'financeBudgetsForPeriodProvider';
}
