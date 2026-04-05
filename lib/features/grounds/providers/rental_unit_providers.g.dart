// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rental_unit_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(rentalUnitService)
final rentalUnitServiceProvider = RentalUnitServiceProvider._();

final class RentalUnitServiceProvider
    extends
        $FunctionalProvider<
          RentalUnitService,
          RentalUnitService,
          RentalUnitService
        >
    with $Provider<RentalUnitService> {
  RentalUnitServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rentalUnitServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rentalUnitServiceHash();

  @$internal
  @override
  $ProviderElement<RentalUnitService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RentalUnitService create(Ref ref) {
    return rentalUnitService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RentalUnitService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RentalUnitService>(value),
    );
  }
}

String _$rentalUnitServiceHash() => r'6afca34e1043d06a5371a5e56a22809330dbbcbe';

@ProviderFor(allUnits)
final allUnitsProvider = AllUnitsFamily._();

final class AllUnitsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RentalUnit>>,
          List<RentalUnit>,
          Stream<List<RentalUnit>>
        >
    with $FutureModifier<List<RentalUnit>>, $StreamProvider<List<RentalUnit>> {
  AllUnitsProvider._({
    required AllUnitsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'allUnitsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$allUnitsHash();

  @override
  String toString() {
    return r'allUnitsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<RentalUnit>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<RentalUnit>> create(Ref ref) {
    final argument = this.argument as String;
    return allUnits(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AllUnitsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$allUnitsHash() => r'c4253c9cd72d4de274c67ee107fa6ad30d9f16b4';

final class AllUnitsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<RentalUnit>>, String> {
  AllUnitsFamily._()
    : super(
        retry: null,
        name: r'allUnitsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AllUnitsProvider call(String groundId) =>
      AllUnitsProvider._(argument: groundId, from: this);

  @override
  String toString() => r'allUnitsProvider';
}

@ProviderFor(unitById)
final unitByIdProvider = UnitByIdFamily._();

final class UnitByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<RentalUnit?>,
          RentalUnit?,
          Stream<RentalUnit?>
        >
    with $FutureModifier<RentalUnit?>, $StreamProvider<RentalUnit?> {
  UnitByIdProvider._({
    required UnitByIdFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'unitByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$unitByIdHash();

  @override
  String toString() {
    return r'unitByIdProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $StreamProviderElement<RentalUnit?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<RentalUnit?> create(Ref ref) {
    final argument = this.argument as (String, String);
    return unitById(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is UnitByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unitByIdHash() => r'db6b41fb72635f48d27ee69bff07fa17de966ac1';

final class UnitByIdFamily extends $Family
    with $FunctionalFamilyOverride<Stream<RentalUnit?>, (String, String)> {
  UnitByIdFamily._()
    : super(
        retry: null,
        name: r'unitByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UnitByIdProvider call(String groundId, String unitId) =>
      UnitByIdProvider._(argument: (groundId, unitId), from: this);

  @override
  String toString() => r'unitByIdProvider';
}

@ProviderFor(unitCount)
final unitCountProvider = UnitCountFamily._();

final class UnitCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  UnitCountProvider._({
    required UnitCountFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'unitCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$unitCountHash();

  @override
  String toString() {
    return r'unitCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    final argument = this.argument as String;
    return unitCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is UnitCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$unitCountHash() => r'f1fa972de48086a773d2110f2a714736ab26bc88';

final class UnitCountFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, String> {
  UnitCountFamily._()
    : super(
        retry: null,
        name: r'unitCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UnitCountProvider call(String groundId) =>
      UnitCountProvider._(argument: groundId, from: this);

  @override
  String toString() => r'unitCountProvider';
}

@ProviderFor(vacantUnits)
final vacantUnitsProvider = VacantUnitsFamily._();

final class VacantUnitsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RentalUnit>>,
          List<RentalUnit>,
          FutureOr<List<RentalUnit>>
        >
    with $FutureModifier<List<RentalUnit>>, $FutureProvider<List<RentalUnit>> {
  VacantUnitsProvider._({
    required VacantUnitsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'vacantUnitsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$vacantUnitsHash();

  @override
  String toString() {
    return r'vacantUnitsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<RentalUnit>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RentalUnit>> create(Ref ref) {
    final argument = this.argument as String;
    return vacantUnits(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is VacantUnitsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$vacantUnitsHash() => r'2edce4f7a7e045d57e175cfed029a5bb0c5b3dc7';

final class VacantUnitsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<RentalUnit>>, String> {
  VacantUnitsFamily._()
    : super(
        retry: null,
        name: r'vacantUnitsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  VacantUnitsProvider call(String groundId) =>
      VacantUnitsProvider._(argument: groundId, from: this);

  @override
  String toString() => r'vacantUnitsProvider';
}
