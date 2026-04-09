// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(alerts)
final alertsProvider = AlertsProvider._();

final class AlertsProvider
    extends
        $FunctionalProvider<
          List<DashboardAlert>,
          List<DashboardAlert>,
          List<DashboardAlert>
        >
    with $Provider<List<DashboardAlert>> {
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
  $ProviderElement<List<DashboardAlert>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<DashboardAlert> create(Ref ref) {
    return alerts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DashboardAlert> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DashboardAlert>>(value),
    );
  }
}

String _$alertsHash() => r'1d19585da59d41aa2aee9bf69fe0f883d5bc496c';
