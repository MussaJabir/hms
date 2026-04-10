// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rent_history_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(rentHistoryService)
final rentHistoryServiceProvider = RentHistoryServiceProvider._();

final class RentHistoryServiceProvider
    extends
        $FunctionalProvider<
          RentHistoryService,
          RentHistoryService,
          RentHistoryService
        >
    with $Provider<RentHistoryService> {
  RentHistoryServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rentHistoryServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rentHistoryServiceHash();

  @$internal
  @override
  $ProviderElement<RentHistoryService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RentHistoryService create(Ref ref) {
    return rentHistoryService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RentHistoryService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RentHistoryService>(value),
    );
  }
}

String _$rentHistoryServiceHash() =>
    r'e015a3c77ef20a22d7892df478cb8bd41952e8f2';

/// Streams all payment records for a tenant in real-time.

@ProviderFor(tenantHistory)
final tenantHistoryProvider = TenantHistoryFamily._();

/// Streams all payment records for a tenant in real-time.

final class TenantHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RecurringRecord>>,
          List<RecurringRecord>,
          Stream<List<RecurringRecord>>
        >
    with
        $FutureModifier<List<RecurringRecord>>,
        $StreamProvider<List<RecurringRecord>> {
  /// Streams all payment records for a tenant in real-time.
  TenantHistoryProvider._({
    required TenantHistoryFamily super.from,
    required (String, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'tenantHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tenantHistoryHash();

  @override
  String toString() {
    return r'tenantHistoryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<RecurringRecord>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<RecurringRecord>> create(Ref ref) {
    final argument = this.argument as (String, String, String);
    return tenantHistory(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is TenantHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tenantHistoryHash() => r'2dba7b019024a809229e535671555d59c7941053';

/// Streams all payment records for a tenant in real-time.

final class TenantHistoryFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<List<RecurringRecord>>,
          (String, String, String)
        > {
  TenantHistoryFamily._()
    : super(
        retry: null,
        name: r'tenantHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Streams all payment records for a tenant in real-time.

  TenantHistoryProvider call(String groundId, String unitId, String tenantId) =>
      TenantHistoryProvider._(
        argument: (groundId, unitId, tenantId),
        from: this,
      );

  @override
  String toString() => r'tenantHistoryProvider';
}

/// Total amount paid by a tenant across all time.

@ProviderFor(tenantTotalPaid)
final tenantTotalPaidProvider = TenantTotalPaidFamily._();

/// Total amount paid by a tenant across all time.

final class TenantTotalPaidProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  /// Total amount paid by a tenant across all time.
  TenantTotalPaidProvider._({
    required TenantTotalPaidFamily super.from,
    required (String, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'tenantTotalPaidProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tenantTotalPaidHash();

  @override
  String toString() {
    return r'tenantTotalPaidProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    final argument = this.argument as (String, String, String);
    return tenantTotalPaid(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is TenantTotalPaidProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tenantTotalPaidHash() => r'ebeeb221b6c310378cb851ab4384a76b0f1a605e';

/// Total amount paid by a tenant across all time.

final class TenantTotalPaidFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<double>, (String, String, String)> {
  TenantTotalPaidFamily._()
    : super(
        retry: null,
        name: r'tenantTotalPaidProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Total amount paid by a tenant across all time.

  TenantTotalPaidProvider call(
    String groundId,
    String unitId,
    String tenantId,
  ) => TenantTotalPaidProvider._(
    argument: (groundId, unitId, tenantId),
    from: this,
  );

  @override
  String toString() => r'tenantTotalPaidProvider';
}

/// Number of fully paid months for a tenant.

@ProviderFor(tenantPaidMonths)
final tenantPaidMonthsProvider = TenantPaidMonthsFamily._();

/// Number of fully paid months for a tenant.

final class TenantPaidMonthsProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Number of fully paid months for a tenant.
  TenantPaidMonthsProvider._({
    required TenantPaidMonthsFamily super.from,
    required (String, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'tenantPaidMonthsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tenantPaidMonthsHash();

  @override
  String toString() {
    return r'tenantPaidMonthsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    final argument = this.argument as (String, String, String);
    return tenantPaidMonths(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is TenantPaidMonthsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tenantPaidMonthsHash() => r'9d07109d20e2b50ba75b07a8be349c079586fe4b';

/// Number of fully paid months for a tenant.

final class TenantPaidMonthsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, (String, String, String)> {
  TenantPaidMonthsFamily._()
    : super(
        retry: null,
        name: r'tenantPaidMonthsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Number of fully paid months for a tenant.

  TenantPaidMonthsProvider call(
    String groundId,
    String unitId,
    String tenantId,
  ) => TenantPaidMonthsProvider._(
    argument: (groundId, unitId, tenantId),
    from: this,
  );

  @override
  String toString() => r'tenantPaidMonthsProvider';
}

/// Number of unpaid / overdue months for a tenant.

@ProviderFor(tenantOutstandingMonths)
final tenantOutstandingMonthsProvider = TenantOutstandingMonthsFamily._();

/// Number of unpaid / overdue months for a tenant.

final class TenantOutstandingMonthsProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Number of unpaid / overdue months for a tenant.
  TenantOutstandingMonthsProvider._({
    required TenantOutstandingMonthsFamily super.from,
    required (String, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'tenantOutstandingMonthsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tenantOutstandingMonthsHash();

  @override
  String toString() {
    return r'tenantOutstandingMonthsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    final argument = this.argument as (String, String, String);
    return tenantOutstandingMonths(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is TenantOutstandingMonthsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tenantOutstandingMonthsHash() =>
    r'83fcf02e36184af77637de850bf696b47815cc59';

/// Number of unpaid / overdue months for a tenant.

final class TenantOutstandingMonthsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, (String, String, String)> {
  TenantOutstandingMonthsFamily._()
    : super(
        retry: null,
        name: r'tenantOutstandingMonthsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Number of unpaid / overdue months for a tenant.

  TenantOutstandingMonthsProvider call(
    String groundId,
    String unitId,
    String tenantId,
  ) => TenantOutstandingMonthsProvider._(
    argument: (groundId, unitId, tenantId),
    from: this,
  );

  @override
  String toString() => r'tenantOutstandingMonthsProvider';
}
