// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rent_summary_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(rentSummaryService)
final rentSummaryServiceProvider = RentSummaryServiceProvider._();

final class RentSummaryServiceProvider
    extends
        $FunctionalProvider<
          RentSummaryService,
          RentSummaryService,
          RentSummaryService
        >
    with $Provider<RentSummaryService> {
  RentSummaryServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rentSummaryServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rentSummaryServiceHash();

  @$internal
  @override
  $ProviderElement<RentSummaryService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RentSummaryService create(Ref ref) {
    return rentSummaryService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RentSummaryService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RentSummaryService>(value),
    );
  }
}

String _$rentSummaryServiceHash() =>
    r'f5d09b1aadaafbbf8c4cfc694470d86f7bfd2694';

@ProviderFor(rentIncomeLinkService)
final rentIncomeLinkServiceProvider = RentIncomeLinkServiceProvider._();

final class RentIncomeLinkServiceProvider
    extends
        $FunctionalProvider<
          RentIncomeLinkService,
          RentIncomeLinkService,
          RentIncomeLinkService
        >
    with $Provider<RentIncomeLinkService> {
  RentIncomeLinkServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rentIncomeLinkServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rentIncomeLinkServiceHash();

  @$internal
  @override
  $ProviderElement<RentIncomeLinkService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RentIncomeLinkService create(Ref ref) {
    return rentIncomeLinkService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RentIncomeLinkService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RentIncomeLinkService>(value),
    );
  }
}

String _$rentIncomeLinkServiceHash() =>
    r'de53965d8f95beed1a8fadfae3365af4442ed03e';

/// Current month's total expected rent, filtered by selected ground.

@ProviderFor(currentMonthExpected)
final currentMonthExpectedProvider = CurrentMonthExpectedProvider._();

/// Current month's total expected rent, filtered by selected ground.

final class CurrentMonthExpectedProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  /// Current month's total expected rent, filtered by selected ground.
  CurrentMonthExpectedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentMonthExpectedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentMonthExpectedHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return currentMonthExpected(ref);
  }
}

String _$currentMonthExpectedHash() =>
    r'0d593f8c329bc2747f8362376f267094570f1cf3';

/// Current month's total collected rent, filtered by selected ground.

@ProviderFor(currentMonthCollected)
final currentMonthCollectedProvider = CurrentMonthCollectedProvider._();

/// Current month's total collected rent, filtered by selected ground.

final class CurrentMonthCollectedProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  /// Current month's total collected rent, filtered by selected ground.
  CurrentMonthCollectedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentMonthCollectedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentMonthCollectedHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return currentMonthCollected(ref);
  }
}

String _$currentMonthCollectedHash() =>
    r'5418db5baee09a120bea35612c9d1cb90b1b0001';

/// Current month's outstanding rent (expected – collected), filtered.

@ProviderFor(currentMonthOutstanding)
final currentMonthOutstandingProvider = CurrentMonthOutstandingProvider._();

/// Current month's outstanding rent (expected – collected), filtered.

final class CurrentMonthOutstandingProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  /// Current month's outstanding rent (expected – collected), filtered.
  CurrentMonthOutstandingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentMonthOutstandingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentMonthOutstandingHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return currentMonthOutstanding(ref);
  }
}

String _$currentMonthOutstandingHash() =>
    r'120b166181121fd7161191c37be70b34b69e479f';

/// Rent collection rate as a percentage (0–100), filtered by selected ground.

@ProviderFor(currentMonthCollectionRate)
final currentMonthCollectionRateProvider =
    CurrentMonthCollectionRateProvider._();

/// Rent collection rate as a percentage (0–100), filtered by selected ground.

final class CurrentMonthCollectionRateProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  /// Rent collection rate as a percentage (0–100), filtered by selected ground.
  CurrentMonthCollectionRateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentMonthCollectionRateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentMonthCollectionRateHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return currentMonthCollectionRate(ref);
  }
}

String _$currentMonthCollectionRateHash() =>
    r'fbda887f60f20e815e449e89dc1b023afe925946';

/// Count of overdue rent records for the current month, filtered.

@ProviderFor(overdueRentCount)
final overdueRentCountProvider = OverdueRentCountProvider._();

/// Count of overdue rent records for the current month, filtered.

final class OverdueRentCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Count of overdue rent records for the current month, filtered.
  OverdueRentCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overdueRentCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overdueRentCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return overdueRentCount(ref);
  }
}

String _$overdueRentCountHash() => r'd1bf67e72be2622e0e29bffaf7b5bc532812b0f8';

/// List of overdue rent records for the current month, filtered.

@ProviderFor(overdueRentRecords)
final overdueRentRecordsProvider = OverdueRentRecordsProvider._();

/// List of overdue rent records for the current month, filtered.

final class OverdueRentRecordsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RecurringRecord>>,
          List<RecurringRecord>,
          FutureOr<List<RecurringRecord>>
        >
    with
        $FutureModifier<List<RecurringRecord>>,
        $FutureProvider<List<RecurringRecord>> {
  /// List of overdue rent records for the current month, filtered.
  OverdueRentRecordsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overdueRentRecordsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overdueRentRecordsHash();

  @$internal
  @override
  $FutureProviderElement<List<RecurringRecord>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RecurringRecord>> create(Ref ref) {
    return overdueRentRecords(ref);
  }
}

String _$overdueRentRecordsHash() =>
    r'1732576c47549105e4020dba0f346b9396c4aeba';
