// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BudgetPeriod)
final budgetPeriodProvider = BudgetPeriodProvider._();

final class BudgetPeriodProvider
    extends $NotifierProvider<BudgetPeriod, DateTime> {
  BudgetPeriodProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetPeriodProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetPeriodHash();

  @$internal
  @override
  BudgetPeriod create() => BudgetPeriod();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$budgetPeriodHash() => r'5a4f825f4e5fe7bedd17abfcd3e583cab178b26d';

abstract class _$BudgetPeriod extends $Notifier<DateTime> {
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

@ProviderFor(budgetsForPeriod)
final budgetsForPeriodProvider = BudgetsForPeriodFamily._();

final class BudgetsForPeriodProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Budget>>,
          List<Budget>,
          Stream<List<Budget>>
        >
    with $FutureModifier<List<Budget>>, $StreamProvider<List<Budget>> {
  BudgetsForPeriodProvider._({
    required BudgetsForPeriodFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'budgetsForPeriodProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$budgetsForPeriodHash();

  @override
  String toString() {
    return r'budgetsForPeriodProvider'
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
    return budgetsForPeriod(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BudgetsForPeriodProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$budgetsForPeriodHash() => r'279e6e73cdf6ee5fa752d3057a0b15596fe311c8';

final class BudgetsForPeriodFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Budget>>, String> {
  BudgetsForPeriodFamily._()
    : super(
        retry: null,
        name: r'budgetsForPeriodProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BudgetsForPeriodProvider call(String period) =>
      BudgetsForPeriodProvider._(argument: period, from: this);

  @override
  String toString() => r'budgetsForPeriodProvider';
}
