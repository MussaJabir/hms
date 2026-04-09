// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rent_config_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(rentConfigService)
final rentConfigServiceProvider = RentConfigServiceProvider._();

final class RentConfigServiceProvider
    extends
        $FunctionalProvider<
          RentConfigService,
          RentConfigService,
          RentConfigService
        >
    with $Provider<RentConfigService> {
  RentConfigServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rentConfigServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rentConfigServiceHash();

  @$internal
  @override
  $ProviderElement<RentConfigService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RentConfigService create(Ref ref) {
    return rentConfigService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RentConfigService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RentConfigService>(value),
    );
  }
}

String _$rentConfigServiceHash() => r'cb977cc95314713b1d477b763c8583311f7c0e2e';

@ProviderFor(activeRentConfigs)
final activeRentConfigsProvider = ActiveRentConfigsProvider._();

final class ActiveRentConfigsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RecurringConfig>>,
          List<RecurringConfig>,
          FutureOr<List<RecurringConfig>>
        >
    with
        $FutureModifier<List<RecurringConfig>>,
        $FutureProvider<List<RecurringConfig>> {
  ActiveRentConfigsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeRentConfigsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeRentConfigsHash();

  @$internal
  @override
  $FutureProviderElement<List<RecurringConfig>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RecurringConfig>> create(Ref ref) {
    return activeRentConfigs(ref);
  }
}

String _$activeRentConfigsHash() => r'359412db86ab3c413376f03b1d54c92397776db3';

@ProviderFor(rentConfigForTenant)
final rentConfigForTenantProvider = RentConfigForTenantFamily._();

final class RentConfigForTenantProvider
    extends
        $FunctionalProvider<
          AsyncValue<RecurringConfig?>,
          RecurringConfig?,
          FutureOr<RecurringConfig?>
        >
    with $FutureModifier<RecurringConfig?>, $FutureProvider<RecurringConfig?> {
  RentConfigForTenantProvider._({
    required RentConfigForTenantFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'rentConfigForTenantProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rentConfigForTenantHash();

  @override
  String toString() {
    return r'rentConfigForTenantProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<RecurringConfig?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RecurringConfig?> create(Ref ref) {
    final argument = this.argument as String;
    return rentConfigForTenant(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RentConfigForTenantProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rentConfigForTenantHash() =>
    r'1c1b5e0098e2ac522d36dc4d5a35f7b0e200c42a';

final class RentConfigForTenantFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<RecurringConfig?>, String> {
  RentConfigForTenantFamily._()
    : super(
        retry: null,
        name: r'rentConfigForTenantProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RentConfigForTenantProvider call(String tenantId) =>
      RentConfigForTenantProvider._(argument: tenantId, from: this);

  @override
  String toString() => r'rentConfigForTenantProvider';
}
