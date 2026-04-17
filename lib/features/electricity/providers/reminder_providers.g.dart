// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(meterReminderService)
final meterReminderServiceProvider = MeterReminderServiceProvider._();

final class MeterReminderServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<MeterReminderService>,
          MeterReminderService,
          FutureOr<MeterReminderService>
        >
    with
        $FutureModifier<MeterReminderService>,
        $FutureProvider<MeterReminderService> {
  MeterReminderServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'meterReminderServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$meterReminderServiceHash();

  @$internal
  @override
  $FutureProviderElement<MeterReminderService> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MeterReminderService> create(Ref ref) {
    return meterReminderService(ref);
  }
}

String _$meterReminderServiceHash() =>
    r'a86f024159053e4fa66f3e32e6d00b41ba050152';

@ProviderFor(reminderConfig)
final reminderConfigProvider = ReminderConfigProvider._();

final class ReminderConfigProvider
    extends
        $FunctionalProvider<
          AsyncValue<ReminderConfig>,
          ReminderConfig,
          FutureOr<ReminderConfig>
        >
    with $FutureModifier<ReminderConfig>, $FutureProvider<ReminderConfig> {
  ReminderConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderConfigProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderConfigHash();

  @$internal
  @override
  $FutureProviderElement<ReminderConfig> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ReminderConfig> create(Ref ref) {
    return reminderConfig(ref);
  }
}

String _$reminderConfigHash() => r'408ad9755da66602d449ae5eba36e258c43fb599';

@ProviderFor(pendingReadingsCount)
final pendingReadingsCountProvider = PendingReadingsCountProvider._();

final class PendingReadingsCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  PendingReadingsCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingReadingsCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingReadingsCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return pendingReadingsCount(ref);
  }
}

String _$pendingReadingsCountHash() =>
    r'602a5eea8add9d7567dcbd47e76fcf63ccda2e12';
