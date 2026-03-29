// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_migration_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dataMigrationService)
final dataMigrationServiceProvider = DataMigrationServiceProvider._();

final class DataMigrationServiceProvider
    extends
        $FunctionalProvider<
          DataMigrationService,
          DataMigrationService,
          DataMigrationService
        >
    with $Provider<DataMigrationService> {
  DataMigrationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dataMigrationServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dataMigrationServiceHash();

  @$internal
  @override
  $ProviderElement<DataMigrationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DataMigrationService create(Ref ref) {
    return dataMigrationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DataMigrationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DataMigrationService>(value),
    );
  }
}

String _$dataMigrationServiceHash() =>
    r'bd9df23c05ae5efcc1356545eef8f7734d6cb3e1';
