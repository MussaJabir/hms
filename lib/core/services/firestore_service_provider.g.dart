// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firestoreService)
final firestoreServiceProvider = FirestoreServiceProvider._();

final class FirestoreServiceProvider
    extends
        $FunctionalProvider<
          FirestoreService,
          FirestoreService,
          FirestoreService
        >
    with $Provider<FirestoreService> {
  FirestoreServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firestoreServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firestoreServiceHash();

  @$internal
  @override
  $ProviderElement<FirestoreService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FirestoreService create(Ref ref) {
    return firestoreService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirestoreService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirestoreService>(value),
    );
  }
}

String _$firestoreServiceHash() => r'ab6a4068fcce40bd3123cf65d2f4d942f392e605';
