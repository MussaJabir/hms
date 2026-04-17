// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(alertGeneratorService)
final alertGeneratorServiceProvider = AlertGeneratorServiceProvider._();

final class AlertGeneratorServiceProvider
    extends
        $FunctionalProvider<
          AlertGeneratorService,
          AlertGeneratorService,
          AlertGeneratorService
        >
    with $Provider<AlertGeneratorService> {
  AlertGeneratorServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alertGeneratorServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alertGeneratorServiceHash();

  @$internal
  @override
  $ProviderElement<AlertGeneratorService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AlertGeneratorService create(Ref ref) {
    return alertGeneratorService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlertGeneratorService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlertGeneratorService>(value),
    );
  }
}

String _$alertGeneratorServiceHash() =>
    r'da1bf6e3caa15270b4786561d9927b3575e08cc0';

/// Async provider — returns real alerts from all module generators.
/// Re-runs when the selected ground changes.

@ProviderFor(alerts)
final alertsProvider = AlertsProvider._();

/// Async provider — returns real alerts from all module generators.
/// Re-runs when the selected ground changes.

final class AlertsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DashboardAlert>>,
          List<DashboardAlert>,
          FutureOr<List<DashboardAlert>>
        >
    with
        $FutureModifier<List<DashboardAlert>>,
        $FutureProvider<List<DashboardAlert>> {
  /// Async provider — returns real alerts from all module generators.
  /// Re-runs when the selected ground changes.
  AlertsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'alertsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$alertsHash();

  @$internal
  @override
  $FutureProviderElement<List<DashboardAlert>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DashboardAlert>> create(Ref ref) {
    return alerts(ref);
  }
}

String _$alertsHash() => r'b2b409ab517365ef8d5251a48bb6bd0906565182';
