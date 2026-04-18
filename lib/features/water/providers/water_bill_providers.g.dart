// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_bill_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(waterBillService)
final waterBillServiceProvider = WaterBillServiceProvider._();

final class WaterBillServiceProvider
    extends
        $FunctionalProvider<
          WaterBillService,
          WaterBillService,
          WaterBillService
        >
    with $Provider<WaterBillService> {
  WaterBillServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'waterBillServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$waterBillServiceHash();

  @$internal
  @override
  $ProviderElement<WaterBillService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WaterBillService create(Ref ref) {
    return waterBillService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WaterBillService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WaterBillService>(value),
    );
  }
}

String _$waterBillServiceHash() => r'813d9ab7b329f6dc60c96a5f3cea3a25a83f6b67';

@ProviderFor(waterBills)
final waterBillsProvider = WaterBillsFamily._();

final class WaterBillsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WaterBill>>,
          List<WaterBill>,
          Stream<List<WaterBill>>
        >
    with $FutureModifier<List<WaterBill>>, $StreamProvider<List<WaterBill>> {
  WaterBillsProvider._({
    required WaterBillsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'waterBillsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$waterBillsHash();

  @override
  String toString() {
    return r'waterBillsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<WaterBill>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<WaterBill>> create(Ref ref) {
    final argument = this.argument as String;
    return waterBills(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WaterBillsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$waterBillsHash() => r'0b8f1827ee4977f2e22e057dbf4a0250fa0f109e';

final class WaterBillsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<WaterBill>>, String> {
  WaterBillsFamily._()
    : super(
        retry: null,
        name: r'waterBillsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WaterBillsProvider call(String groundId) =>
      WaterBillsProvider._(argument: groundId, from: this);

  @override
  String toString() => r'waterBillsProvider';
}

@ProviderFor(latestBill)
final latestBillProvider = LatestBillFamily._();

final class LatestBillProvider
    extends
        $FunctionalProvider<
          AsyncValue<WaterBill?>,
          WaterBill?,
          FutureOr<WaterBill?>
        >
    with $FutureModifier<WaterBill?>, $FutureProvider<WaterBill?> {
  LatestBillProvider._({
    required LatestBillFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'latestBillProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$latestBillHash();

  @override
  String toString() {
    return r'latestBillProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<WaterBill?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<WaterBill?> create(Ref ref) {
    final argument = this.argument as String;
    return latestBill(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LatestBillProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$latestBillHash() => r'dcd00ce418b01a756918316989f4bec099425c73';

final class LatestBillFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<WaterBill?>, String> {
  LatestBillFamily._()
    : super(
        retry: null,
        name: r'latestBillProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LatestBillProvider call(String groundId) =>
      LatestBillProvider._(argument: groundId, from: this);

  @override
  String toString() => r'latestBillProvider';
}

@ProviderFor(unpaidBills)
final unpaidBillsProvider = UnpaidBillsFamily._();

final class UnpaidBillsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WaterBill>>,
          List<WaterBill>,
          FutureOr<List<WaterBill>>
        >
    with $FutureModifier<List<WaterBill>>, $FutureProvider<List<WaterBill>> {
  UnpaidBillsProvider._({
    required UnpaidBillsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'unpaidBillsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$unpaidBillsHash();

  @override
  String toString() {
    return r'unpaidBillsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<WaterBill>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WaterBill>> create(Ref ref) {
    final argument = this.argument as String;
    return unpaidBills(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UnpaidBillsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unpaidBillsHash() => r'd56b25246d81d532568f7169bf22e43dab73ad18';

final class UnpaidBillsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<WaterBill>>, String> {
  UnpaidBillsFamily._()
    : super(
        retry: null,
        name: r'unpaidBillsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UnpaidBillsProvider call(String groundId) =>
      UnpaidBillsProvider._(argument: groundId, from: this);

  @override
  String toString() => r'unpaidBillsProvider';
}

@ProviderFor(averageMonthlyBill)
final averageMonthlyBillProvider = AverageMonthlyBillFamily._();

final class AverageMonthlyBillProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  AverageMonthlyBillProvider._({
    required AverageMonthlyBillFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'averageMonthlyBillProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$averageMonthlyBillHash();

  @override
  String toString() {
    return r'averageMonthlyBillProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    final argument = this.argument as String;
    return averageMonthlyBill(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AverageMonthlyBillProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$averageMonthlyBillHash() =>
    r'd0ca6cc73dc4d67b5f4d0018b6ac54a3c27ebd4d';

final class AverageMonthlyBillFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<double>, String> {
  AverageMonthlyBillFamily._()
    : super(
        retry: null,
        name: r'averageMonthlyBillProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AverageMonthlyBillProvider call(String groundId) =>
      AverageMonthlyBillProvider._(argument: groundId, from: this);

  @override
  String toString() => r'averageMonthlyBillProvider';
}
