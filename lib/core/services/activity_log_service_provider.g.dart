// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_log_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activityLogService)
final activityLogServiceProvider = ActivityLogServiceProvider._();

final class ActivityLogServiceProvider
    extends
        $FunctionalProvider<
          ActivityLogService,
          ActivityLogService,
          ActivityLogService
        >
    with $Provider<ActivityLogService> {
  ActivityLogServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityLogServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityLogServiceHash();

  @$internal
  @override
  $ProviderElement<ActivityLogService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ActivityLogService create(Ref ref) {
    return activityLogService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActivityLogService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActivityLogService>(value),
    );
  }
}

String _$activityLogServiceHash() =>
    r'a738652bc59a835ab21bb527f23e688c9657b602';
