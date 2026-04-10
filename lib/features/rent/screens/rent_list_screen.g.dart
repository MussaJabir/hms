// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rent_list_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RentListPeriod)
final rentListPeriodProvider = RentListPeriodProvider._();

final class RentListPeriodProvider
    extends $NotifierProvider<RentListPeriod, DateTime> {
  RentListPeriodProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rentListPeriodProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rentListPeriodHash();

  @$internal
  @override
  RentListPeriod create() => RentListPeriod();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$rentListPeriodHash() => r'5b1e5fc1a16c2fbc0480073db1df05319b5ed152';

abstract class _$RentListPeriod extends $Notifier<DateTime> {
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

@ProviderFor(rentRecordsForPeriod)
final rentRecordsForPeriodProvider = RentRecordsForPeriodFamily._();

final class RentRecordsForPeriodProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RecurringRecord>>,
          List<RecurringRecord>,
          FutureOr<List<RecurringRecord>>
        >
    with
        $FutureModifier<List<RecurringRecord>>,
        $FutureProvider<List<RecurringRecord>> {
  RentRecordsForPeriodProvider._({
    required RentRecordsForPeriodFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'rentRecordsForPeriodProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rentRecordsForPeriodHash();

  @override
  String toString() {
    return r'rentRecordsForPeriodProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<RecurringRecord>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RecurringRecord>> create(Ref ref) {
    final argument = this.argument as String;
    return rentRecordsForPeriod(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RentRecordsForPeriodProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rentRecordsForPeriodHash() =>
    r'76c8294d37775a233603224b0801a24b5ff44b8d';

final class RentRecordsForPeriodFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<RecurringRecord>>, String> {
  RentRecordsForPeriodFamily._()
    : super(
        retry: null,
        name: r'rentRecordsForPeriodProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RentRecordsForPeriodProvider call(String period) =>
      RentRecordsForPeriodProvider._(argument: period, from: this);

  @override
  String toString() => r'rentRecordsForPeriodProvider';
}

@ProviderFor(rentConfigPathMap)
final rentConfigPathMapProvider = RentConfigPathMapProvider._();

final class RentConfigPathMapProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, String>>,
          Map<String, String>,
          FutureOr<Map<String, String>>
        >
    with
        $FutureModifier<Map<String, String>>,
        $FutureProvider<Map<String, String>> {
  RentConfigPathMapProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rentConfigPathMapProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rentConfigPathMapHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, String>> create(Ref ref) {
    return rentConfigPathMap(ref);
  }
}

String _$rentConfigPathMapHash() => r'1beb763bfa3272e4967141a2b4fb5dd7ec8cb955';
