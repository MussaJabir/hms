// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_list_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ExpenseListPeriod)
final expenseListPeriodProvider = ExpenseListPeriodProvider._();

final class ExpenseListPeriodProvider
    extends $NotifierProvider<ExpenseListPeriod, DateTime> {
  ExpenseListPeriodProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseListPeriodProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseListPeriodHash();

  @$internal
  @override
  ExpenseListPeriod create() => ExpenseListPeriod();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$expenseListPeriodHash() => r'6244b217cff8bc1b9b946929e679195a5e624a59';

abstract class _$ExpenseListPeriod extends $Notifier<DateTime> {
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

@ProviderFor(expensesForPeriod)
final expensesForPeriodProvider = ExpensesForPeriodFamily._();

final class ExpensesForPeriodProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Expense>>,
          List<Expense>,
          Stream<List<Expense>>
        >
    with $FutureModifier<List<Expense>>, $StreamProvider<List<Expense>> {
  ExpensesForPeriodProvider._({
    required ExpensesForPeriodFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'expensesForPeriodProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$expensesForPeriodHash();

  @override
  String toString() {
    return r'expensesForPeriodProvider'
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
    return expensesForPeriod(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpensesForPeriodProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$expensesForPeriodHash() => r'ea5f1e7c74651ad092bd370ac0381dd58cf96fcb';

final class ExpensesForPeriodFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Expense>>, String> {
  ExpensesForPeriodFamily._()
    : super(
        retry: null,
        name: r'expensesForPeriodProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ExpensesForPeriodProvider call(String period) =>
      ExpensesForPeriodProvider._(argument: period, from: this);

  @override
  String toString() => r'expensesForPeriodProvider';
}
