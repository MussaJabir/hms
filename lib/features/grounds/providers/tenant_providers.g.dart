// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tenant_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tenantService)
final tenantServiceProvider = TenantServiceProvider._();

final class TenantServiceProvider
    extends $FunctionalProvider<TenantService, TenantService, TenantService>
    with $Provider<TenantService> {
  TenantServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tenantServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tenantServiceHash();

  @$internal
  @override
  $ProviderElement<TenantService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TenantService create(Ref ref) {
    return tenantService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TenantService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TenantService>(value),
    );
  }
}

String _$tenantServiceHash() => r'db7085ed4b5a9a5ea2c3d0c0cb90a9dfc9ee1e9b';

@ProviderFor(currentTenant)
final currentTenantProvider = CurrentTenantFamily._();

final class CurrentTenantProvider
    extends $FunctionalProvider<AsyncValue<Tenant?>, Tenant?, Stream<Tenant?>>
    with $FutureModifier<Tenant?>, $StreamProvider<Tenant?> {
  CurrentTenantProvider._({
    required CurrentTenantFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'currentTenantProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$currentTenantHash();

  @override
  String toString() {
    return r'currentTenantProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<Tenant?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Tenant?> create(Ref ref) {
    final argument = this.argument as (String, String);
    return currentTenant(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentTenantProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$currentTenantHash() => r'87cb84282312d5719caa3a56891b50de24276cad';

final class CurrentTenantFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Tenant?>, (String, String)> {
  CurrentTenantFamily._()
    : super(
        retry: null,
        name: r'currentTenantProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CurrentTenantProvider call(String groundId, String unitId) =>
      CurrentTenantProvider._(argument: (groundId, unitId), from: this);

  @override
  String toString() => r'currentTenantProvider';
}

@ProviderFor(tenantById)
final tenantByIdProvider = TenantByIdFamily._();

final class TenantByIdProvider
    extends $FunctionalProvider<AsyncValue<Tenant?>, Tenant?, FutureOr<Tenant?>>
    with $FutureModifier<Tenant?>, $FutureProvider<Tenant?> {
  TenantByIdProvider._({
    required TenantByIdFamily super.from,
    required (String, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'tenantByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tenantByIdHash();

  @override
  String toString() {
    return r'tenantByIdProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Tenant?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Tenant?> create(Ref ref) {
    final argument = this.argument as (String, String, String);
    return tenantById(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is TenantByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tenantByIdHash() => r'f54119a8fb0ebc514769728ed5adc819ea87bcf5';

final class TenantByIdFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<Tenant?>, (String, String, String)> {
  TenantByIdFamily._()
    : super(
        retry: null,
        name: r'tenantByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TenantByIdProvider call(String groundId, String unitId, String tenantId) =>
      TenantByIdProvider._(argument: (groundId, unitId, tenantId), from: this);

  @override
  String toString() => r'tenantByIdProvider';
}
