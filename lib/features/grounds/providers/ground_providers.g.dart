// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ground_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(groundService)
final groundServiceProvider = GroundServiceProvider._();

final class GroundServiceProvider
    extends $FunctionalProvider<GroundService, GroundService, GroundService>
    with $Provider<GroundService> {
  GroundServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'groundServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$groundServiceHash();

  @$internal
  @override
  $ProviderElement<GroundService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GroundService create(Ref ref) {
    return groundService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GroundService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GroundService>(value),
    );
  }
}

String _$groundServiceHash() => r'e0afeba6c859a310a2cccfd4ec27a3b56500ee00';

@ProviderFor(allGrounds)
final allGroundsProvider = AllGroundsProvider._();

final class AllGroundsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Ground>>,
          List<Ground>,
          Stream<List<Ground>>
        >
    with $FutureModifier<List<Ground>>, $StreamProvider<List<Ground>> {
  AllGroundsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allGroundsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allGroundsHash();

  @$internal
  @override
  $StreamProviderElement<List<Ground>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Ground>> create(Ref ref) {
    return allGrounds(ref);
  }
}

String _$allGroundsHash() => r'535b4eada563ef3dc6d5ad6094958bd6177d5bf8';

@ProviderFor(groundById)
final groundByIdProvider = GroundByIdFamily._();

final class GroundByIdProvider
    extends $FunctionalProvider<AsyncValue<Ground?>, Ground?, Stream<Ground?>>
    with $FutureModifier<Ground?>, $StreamProvider<Ground?> {
  GroundByIdProvider._({
    required GroundByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'groundByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$groundByIdHash();

  @override
  String toString() {
    return r'groundByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Ground?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Ground?> create(Ref ref) {
    final argument = this.argument as String;
    return groundById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GroundByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$groundByIdHash() => r'cc8fe541329e20f2ddb41ef72ed2713009604974';

final class GroundByIdFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Ground?>, String> {
  GroundByIdFamily._()
    : super(
        retry: null,
        name: r'groundByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GroundByIdProvider call(String groundId) =>
      GroundByIdProvider._(argument: groundId, from: this);

  @override
  String toString() => r'groundByIdProvider';
}
