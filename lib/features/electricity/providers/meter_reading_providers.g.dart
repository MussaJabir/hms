// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meter_reading_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(meterReadingService)
final meterReadingServiceProvider = MeterReadingServiceProvider._();

final class MeterReadingServiceProvider
    extends
        $FunctionalProvider<
          MeterReadingService,
          MeterReadingService,
          MeterReadingService
        >
    with $Provider<MeterReadingService> {
  MeterReadingServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'meterReadingServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$meterReadingServiceHash();

  @$internal
  @override
  $ProviderElement<MeterReadingService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MeterReadingService create(Ref ref) {
    return meterReadingService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeterReadingService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeterReadingService>(value),
    );
  }
}

String _$meterReadingServiceHash() =>
    r'5f34d85f9a3988c915d16615fc663afc6af5994b';

/// Fetches the latest reading for a meter.

@ProviderFor(latestReading)
final latestReadingProvider = LatestReadingFamily._();

/// Fetches the latest reading for a meter.

final class LatestReadingProvider
    extends
        $FunctionalProvider<
          AsyncValue<MeterReading?>,
          MeterReading?,
          FutureOr<MeterReading?>
        >
    with $FutureModifier<MeterReading?>, $FutureProvider<MeterReading?> {
  /// Fetches the latest reading for a meter.
  LatestReadingProvider._({
    required LatestReadingFamily super.from,
    required (String, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'latestReadingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$latestReadingHash();

  @override
  String toString() {
    return r'latestReadingProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<MeterReading?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MeterReading?> create(Ref ref) {
    final argument = this.argument as (String, String, String);
    return latestReading(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is LatestReadingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$latestReadingHash() => r'1aa13dd2da6e8b95eefb0ca3d1d4926fd309f03e';

/// Fetches the latest reading for a meter.

final class LatestReadingFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<MeterReading?>,
          (String, String, String)
        > {
  LatestReadingFamily._()
    : super(
        retry: null,
        name: r'latestReadingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches the latest reading for a meter.

  LatestReadingProvider call(String groundId, String unitId, String meterId) =>
      LatestReadingProvider._(
        argument: (groundId, unitId, meterId),
        from: this,
      );

  @override
  String toString() => r'latestReadingProvider';
}

/// Streams all readings for a meter, newest first.

@ProviderFor(readings)
final readingsProvider = ReadingsFamily._();

/// Streams all readings for a meter, newest first.

final class ReadingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MeterReading>>,
          List<MeterReading>,
          Stream<List<MeterReading>>
        >
    with
        $FutureModifier<List<MeterReading>>,
        $StreamProvider<List<MeterReading>> {
  /// Streams all readings for a meter, newest first.
  ReadingsProvider._({
    required ReadingsFamily super.from,
    required (String, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'readingsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$readingsHash();

  @override
  String toString() {
    return r'readingsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<List<MeterReading>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MeterReading>> create(Ref ref) {
    final argument = this.argument as (String, String, String);
    return readings(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is ReadingsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$readingsHash() => r'9feeaa5018ecf32b2e8e4e6b3a9171318e8b64ac';

/// Streams all readings for a meter, newest first.

final class ReadingsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<List<MeterReading>>,
          (String, String, String)
        > {
  ReadingsFamily._()
    : super(
        retry: null,
        name: r'readingsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Streams all readings for a meter, newest first.

  ReadingsProvider call(String groundId, String unitId, String meterId) =>
      ReadingsProvider._(argument: (groundId, unitId, meterId), from: this);

  @override
  String toString() => r'readingsProvider';
}
