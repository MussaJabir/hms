// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_list_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(IncomeListPeriod)
final incomeListPeriodProvider = IncomeListPeriodProvider._();

final class IncomeListPeriodProvider
    extends $NotifierProvider<IncomeListPeriod, DateTime> {
  IncomeListPeriodProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'incomeListPeriodProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$incomeListPeriodHash();

  @$internal
  @override
  IncomeListPeriod create() => IncomeListPeriod();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$incomeListPeriodHash() => r'07bf1d0c9d05f30ba48e87a1de36861b31564f56';

abstract class _$IncomeListPeriod extends $Notifier<DateTime> {
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

@ProviderFor(incomeForPeriod)
final incomeForPeriodProvider = IncomeForPeriodFamily._();

final class IncomeForPeriodProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Income>>,
          List<Income>,
          Stream<List<Income>>
        >
    with $FutureModifier<List<Income>>, $StreamProvider<List<Income>> {
  IncomeForPeriodProvider._({
    required IncomeForPeriodFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'incomeForPeriodProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$incomeForPeriodHash();

  @override
  String toString() {
    return r'incomeForPeriodProvider'
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
    return incomeForPeriod(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is IncomeForPeriodProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$incomeForPeriodHash() => r'ab4bc262bca4c66c1cdef1c0627498a1c15b0ec9';

final class IncomeForPeriodFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Income>>, String> {
  IncomeForPeriodFamily._()
    : super(
        retry: null,
        name: r'incomeForPeriodProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IncomeForPeriodProvider call(String period) =>
      IncomeForPeriodProvider._(argument: period, from: this);

  @override
  String toString() => r'incomeForPeriodProvider';
}
