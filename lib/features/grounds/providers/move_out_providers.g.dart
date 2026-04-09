// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'move_out_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(moveOutService)
final moveOutServiceProvider = MoveOutServiceProvider._();

final class MoveOutServiceProvider
    extends $FunctionalProvider<MoveOutService, MoveOutService, MoveOutService>
    with $Provider<MoveOutService> {
  MoveOutServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'moveOutServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$moveOutServiceHash();

  @$internal
  @override
  $ProviderElement<MoveOutService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MoveOutService create(Ref ref) {
    return moveOutService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MoveOutService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MoveOutService>(value),
    );
  }
}

String _$moveOutServiceHash() => r'ec82c662196c126c6a7eab8b96007bc49fdedcfb';

@ProviderFor(settlements)
final settlementsProvider = SettlementsFamily._();

final class SettlementsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Settlement>>,
          List<Settlement>,
          FutureOr<List<Settlement>>
        >
    with $FutureModifier<List<Settlement>>, $FutureProvider<List<Settlement>> {
  SettlementsProvider._({
    required SettlementsFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'settlementsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$settlementsHash();

  @override
  String toString() {
    return r'settlementsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Settlement>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Settlement>> create(Ref ref) {
    final argument = this.argument as (String, String);
    return settlements(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is SettlementsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$settlementsHash() => r'1d0775c70ce7d82c7bff668f0602532cdd894b18';

final class SettlementsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Settlement>>,
          (String, String)
        > {
  SettlementsFamily._()
    : super(
        retry: null,
        name: r'settlementsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SettlementsProvider call(String groundId, String unitId) =>
      SettlementsProvider._(argument: (groundId, unitId), from: this);

  @override
  String toString() => r'settlementsProvider';
}
