// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(consumptionAlertService)
final consumptionAlertServiceProvider = ConsumptionAlertServiceProvider._();

final class ConsumptionAlertServiceProvider
    extends
        $FunctionalProvider<
          ConsumptionAlertService,
          ConsumptionAlertService,
          ConsumptionAlertService
        >
    with $Provider<ConsumptionAlertService> {
  ConsumptionAlertServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'consumptionAlertServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$consumptionAlertServiceHash();

  @$internal
  @override
  $ProviderElement<ConsumptionAlertService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConsumptionAlertService create(Ref ref) {
    return consumptionAlertService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConsumptionAlertService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConsumptionAlertService>(value),
    );
  }
}

String _$consumptionAlertServiceHash() =>
    r'02daecd1a5af3a45722abf027c1b671a98103091';

@ProviderFor(electricityNotificationService)
final electricityNotificationServiceProvider =
    ElectricityNotificationServiceProvider._();

final class ElectricityNotificationServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<ElectricityNotificationService>,
          ElectricityNotificationService,
          FutureOr<ElectricityNotificationService>
        >
    with
        $FutureModifier<ElectricityNotificationService>,
        $FutureProvider<ElectricityNotificationService> {
  ElectricityNotificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'electricityNotificationServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$electricityNotificationServiceHash();

  @$internal
  @override
  $FutureProviderElement<ElectricityNotificationService> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ElectricityNotificationService> create(Ref ref) {
    return electricityNotificationService(ref);
  }
}

String _$electricityNotificationServiceHash() =>
    r'29ddb879f9cbe72bb05d1375fa8bc6125d593654';

/// Returns all active consumption warnings, filtered by the currently selected
/// ground when one is selected.

@ProviderFor(activeWarnings)
final activeWarningsProvider = ActiveWarningsProvider._();

/// Returns all active consumption warnings, filtered by the currently selected
/// ground when one is selected.

final class ActiveWarningsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ConsumptionWarning>>,
          List<ConsumptionWarning>,
          FutureOr<List<ConsumptionWarning>>
        >
    with
        $FutureModifier<List<ConsumptionWarning>>,
        $FutureProvider<List<ConsumptionWarning>> {
  /// Returns all active consumption warnings, filtered by the currently selected
  /// ground when one is selected.
  ActiveWarningsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeWarningsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeWarningsHash();

  @$internal
  @override
  $FutureProviderElement<List<ConsumptionWarning>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ConsumptionWarning>> create(Ref ref) {
    return activeWarnings(ref);
  }
}

String _$activeWarningsHash() => r'70f360bb925d055f91c94af0e636fd1e9b410c3a';

/// Returns how many units the latest reading for a specific meter is over
/// its threshold (0 when under or when no threshold is set).

@ProviderFor(overThreshold)
final overThresholdProvider = OverThresholdFamily._();

/// Returns how many units the latest reading for a specific meter is over
/// its threshold (0 when under or when no threshold is set).

final class OverThresholdProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  /// Returns how many units the latest reading for a specific meter is over
  /// its threshold (0 when under or when no threshold is set).
  OverThresholdProvider._({
    required OverThresholdFamily super.from,
    required (String, String, String) super.argument,
  }) : super(
         retry: null,
         name: r'overThresholdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$overThresholdHash();

  @override
  String toString() {
    return r'overThresholdProvider'
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
    return overThreshold(ref, argument.$1, argument.$2, argument.$3);
  }

  @override
  bool operator ==(Object other) {
    return other is OverThresholdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$overThresholdHash() => r'bf50d5d396187fe359b7cb82213cae6ad9d56a7b';

/// Returns how many units the latest reading for a specific meter is over
/// its threshold (0 when under or when no threshold is set).

final class OverThresholdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<double>, (String, String, String)> {
  OverThresholdFamily._()
    : super(
        retry: null,
        name: r'overThresholdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Returns how many units the latest reading for a specific meter is over
  /// its threshold (0 when under or when no threshold is set).

  OverThresholdProvider call(String groundId, String unitId, String meterId) =>
      OverThresholdProvider._(
        argument: (groundId, unitId, meterId),
        from: this,
      );

  @override
  String toString() => r'overThresholdProvider';
}
