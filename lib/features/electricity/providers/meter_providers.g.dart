// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meter_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(meterService)
final meterServiceProvider = MeterServiceProvider._();

final class MeterServiceProvider
    extends $FunctionalProvider<MeterService, MeterService, MeterService>
    with $Provider<MeterService> {
  MeterServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'meterServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$meterServiceHash();

  @$internal
  @override
  $ProviderElement<MeterService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MeterService create(Ref ref) {
    return meterService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeterService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeterService>(value),
    );
  }
}

String _$meterServiceHash() => r'5b40631a98e4deabccb88c45fb902b178024225f';

/// Streams the active meter for a unit in real time.

@ProviderFor(activeMeter)
final activeMeterProvider = ActiveMeterFamily._();

/// Streams the active meter for a unit in real time.

final class ActiveMeterProvider
    extends
        $FunctionalProvider<
          AsyncValue<ElectricityMeter?>,
          ElectricityMeter?,
          Stream<ElectricityMeter?>
        >
    with
        $FutureModifier<ElectricityMeter?>,
        $StreamProvider<ElectricityMeter?> {
  /// Streams the active meter for a unit in real time.
  ActiveMeterProvider._({
    required ActiveMeterFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'activeMeterProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activeMeterHash();

  @override
  String toString() {
    return r'activeMeterProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<ElectricityMeter?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<ElectricityMeter?> create(Ref ref) {
    final argument = this.argument as (String, String);
    return activeMeter(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveMeterProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activeMeterHash() => r'c5780cc98b36e43bece1c0680021cc0d9a176fd7';

/// Streams the active meter for a unit in real time.

final class ActiveMeterFamily extends $Family
    with
        $FunctionalFamilyOverride<Stream<ElectricityMeter?>, (String, String)> {
  ActiveMeterFamily._()
    : super(
        retry: null,
        name: r'activeMeterProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Streams the active meter for a unit in real time.

  ActiveMeterProvider call(String groundId, String unitId) =>
      ActiveMeterProvider._(argument: (groundId, unitId), from: this);

  @override
  String toString() => r'activeMeterProvider';
}

/// Fetches all meters (including inactive history) for a unit.

@ProviderFor(allMeters)
final allMetersProvider = AllMetersFamily._();

/// Fetches all meters (including inactive history) for a unit.

final class AllMetersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ElectricityMeter>>,
          List<ElectricityMeter>,
          FutureOr<List<ElectricityMeter>>
        >
    with
        $FutureModifier<List<ElectricityMeter>>,
        $FutureProvider<List<ElectricityMeter>> {
  /// Fetches all meters (including inactive history) for a unit.
  AllMetersProvider._({
    required AllMetersFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'allMetersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$allMetersHash();

  @override
  String toString() {
    return r'allMetersProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<ElectricityMeter>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ElectricityMeter>> create(Ref ref) {
    final argument = this.argument as (String, String);
    return allMeters(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is AllMetersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$allMetersHash() => r'5f6c5fb1654e9c4e678f74007e9acfed7856d0da';

/// Fetches all meters (including inactive history) for a unit.

final class AllMetersFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<ElectricityMeter>>,
          (String, String)
        > {
  AllMetersFamily._()
    : super(
        retry: null,
        name: r'allMetersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches all meters (including inactive history) for a unit.

  AllMetersProvider call(String groundId, String unitId) =>
      AllMetersProvider._(argument: (groundId, unitId), from: this);

  @override
  String toString() => r'allMetersProvider';
}
