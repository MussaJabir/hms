// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water_summary_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(waterSummaryService)
final waterSummaryServiceProvider = WaterSummaryServiceProvider._();

final class WaterSummaryServiceProvider
    extends
        $FunctionalProvider<
          WaterSummaryService,
          WaterSummaryService,
          WaterSummaryService
        >
    with $Provider<WaterSummaryService> {
  WaterSummaryServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'waterSummaryServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$waterSummaryServiceHash();

  @$internal
  @override
  $ProviderElement<WaterSummaryService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WaterSummaryService create(Ref ref) {
    return waterSummaryService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WaterSummaryService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WaterSummaryService>(value),
    );
  }
}

String _$waterSummaryServiceHash() =>
    r'63daa2e827678edc14925e6cbf7cd78f0ba20e47';

@ProviderFor(waterNotificationService)
final waterNotificationServiceProvider = WaterNotificationServiceProvider._();

final class WaterNotificationServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<WaterNotificationService>,
          WaterNotificationService,
          FutureOr<WaterNotificationService>
        >
    with
        $FutureModifier<WaterNotificationService>,
        $FutureProvider<WaterNotificationService> {
  WaterNotificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'waterNotificationServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$waterNotificationServiceHash();

  @$internal
  @override
  $FutureProviderElement<WaterNotificationService> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WaterNotificationService> create(Ref ref) {
    return waterNotificationService(ref);
  }
}

String _$waterNotificationServiceHash() =>
    r'7125c6e102d69c41d3cc18b99b77b5115c9f6702';

@ProviderFor(currentMonthWaterCost)
final currentMonthWaterCostProvider = CurrentMonthWaterCostProvider._();

final class CurrentMonthWaterCostProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  CurrentMonthWaterCostProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentMonthWaterCostProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentMonthWaterCostHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return currentMonthWaterCost(ref);
  }
}

String _$currentMonthWaterCostHash() =>
    r'9d0f7418b1f922b32684d137839030067562dc2c';

@ProviderFor(unpaidWaterBillsCount)
final unpaidWaterBillsCountProvider = UnpaidWaterBillsCountProvider._();

final class UnpaidWaterBillsCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  UnpaidWaterBillsCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unpaidWaterBillsCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unpaidWaterBillsCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return unpaidWaterBillsCount(ref);
  }
}

String _$unpaidWaterBillsCountHash() =>
    r'77d0cc37bc5af3a67baeb20c845a1f2807f095ed';

@ProviderFor(billsDueSoon)
final billsDueSoonProvider = BillsDueSoonProvider._();

final class BillsDueSoonProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WaterBill>>,
          List<WaterBill>,
          FutureOr<List<WaterBill>>
        >
    with $FutureModifier<List<WaterBill>>, $FutureProvider<List<WaterBill>> {
  BillsDueSoonProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'billsDueSoonProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$billsDueSoonHash();

  @$internal
  @override
  $FutureProviderElement<List<WaterBill>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WaterBill>> create(Ref ref) {
    return billsDueSoon(ref);
  }
}

String _$billsDueSoonHash() => r'2df5e60aeade2a6bda925ff6e36c1d5303d12d84';

@ProviderFor(overdueWaterBills)
final overdueWaterBillsProvider = OverdueWaterBillsProvider._();

final class OverdueWaterBillsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WaterBill>>,
          List<WaterBill>,
          FutureOr<List<WaterBill>>
        >
    with $FutureModifier<List<WaterBill>>, $FutureProvider<List<WaterBill>> {
  OverdueWaterBillsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overdueWaterBillsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overdueWaterBillsHash();

  @$internal
  @override
  $FutureProviderElement<List<WaterBill>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WaterBill>> create(Ref ref) {
    return overdueWaterBills(ref);
  }
}

String _$overdueWaterBillsHash() => r'ccf3637487107bee158fa91437a6e70f4b2df08d';

@ProviderFor(currentMonthWaterSurplusDeficit)
final currentMonthWaterSurplusDeficitProvider =
    CurrentMonthWaterSurplusDeficitProvider._();

final class CurrentMonthWaterSurplusDeficitProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  CurrentMonthWaterSurplusDeficitProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentMonthWaterSurplusDeficitProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentMonthWaterSurplusDeficitHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return currentMonthWaterSurplusDeficit(ref);
  }
}

String _$currentMonthWaterSurplusDeficitHash() =>
    r'86e572f28504fc70b0de101b4d055f77e09b0de9';

@ProviderFor(unpaidContributionsCount)
final unpaidContributionsCountProvider = UnpaidContributionsCountProvider._();

final class UnpaidContributionsCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  UnpaidContributionsCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unpaidContributionsCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unpaidContributionsCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return unpaidContributionsCount(ref);
  }
}

String _$unpaidContributionsCountHash() =>
    r'b0bb6e7fc02370f26373307ff1a2866dbb45934d';
