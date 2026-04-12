// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unit_consumption.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnitConsumption {

 String get unitId; String get unitName; String get tenantName; double get unitsConsumed; double get estimatedCost;
/// Create a copy of UnitConsumption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnitConsumptionCopyWith<UnitConsumption> get copyWith => _$UnitConsumptionCopyWithImpl<UnitConsumption>(this as UnitConsumption, _$identity);

  /// Serializes this UnitConsumption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnitConsumption&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.unitName, unitName) || other.unitName == unitName)&&(identical(other.tenantName, tenantName) || other.tenantName == tenantName)&&(identical(other.unitsConsumed, unitsConsumed) || other.unitsConsumed == unitsConsumed)&&(identical(other.estimatedCost, estimatedCost) || other.estimatedCost == estimatedCost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,unitId,unitName,tenantName,unitsConsumed,estimatedCost);

@override
String toString() {
  return 'UnitConsumption(unitId: $unitId, unitName: $unitName, tenantName: $tenantName, unitsConsumed: $unitsConsumed, estimatedCost: $estimatedCost)';
}


}

/// @nodoc
abstract mixin class $UnitConsumptionCopyWith<$Res>  {
  factory $UnitConsumptionCopyWith(UnitConsumption value, $Res Function(UnitConsumption) _then) = _$UnitConsumptionCopyWithImpl;
@useResult
$Res call({
 String unitId, String unitName, String tenantName, double unitsConsumed, double estimatedCost
});




}
/// @nodoc
class _$UnitConsumptionCopyWithImpl<$Res>
    implements $UnitConsumptionCopyWith<$Res> {
  _$UnitConsumptionCopyWithImpl(this._self, this._then);

  final UnitConsumption _self;
  final $Res Function(UnitConsumption) _then;

/// Create a copy of UnitConsumption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? unitId = null,Object? unitName = null,Object? tenantName = null,Object? unitsConsumed = null,Object? estimatedCost = null,}) {
  return _then(_self.copyWith(
unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,unitName: null == unitName ? _self.unitName : unitName // ignore: cast_nullable_to_non_nullable
as String,tenantName: null == tenantName ? _self.tenantName : tenantName // ignore: cast_nullable_to_non_nullable
as String,unitsConsumed: null == unitsConsumed ? _self.unitsConsumed : unitsConsumed // ignore: cast_nullable_to_non_nullable
as double,estimatedCost: null == estimatedCost ? _self.estimatedCost : estimatedCost // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [UnitConsumption].
extension UnitConsumptionPatterns on UnitConsumption {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnitConsumption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnitConsumption() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnitConsumption value)  $default,){
final _that = this;
switch (_that) {
case _UnitConsumption():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnitConsumption value)?  $default,){
final _that = this;
switch (_that) {
case _UnitConsumption() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String unitId,  String unitName,  String tenantName,  double unitsConsumed,  double estimatedCost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnitConsumption() when $default != null:
return $default(_that.unitId,_that.unitName,_that.tenantName,_that.unitsConsumed,_that.estimatedCost);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String unitId,  String unitName,  String tenantName,  double unitsConsumed,  double estimatedCost)  $default,) {final _that = this;
switch (_that) {
case _UnitConsumption():
return $default(_that.unitId,_that.unitName,_that.tenantName,_that.unitsConsumed,_that.estimatedCost);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String unitId,  String unitName,  String tenantName,  double unitsConsumed,  double estimatedCost)?  $default,) {final _that = this;
switch (_that) {
case _UnitConsumption() when $default != null:
return $default(_that.unitId,_that.unitName,_that.tenantName,_that.unitsConsumed,_that.estimatedCost);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UnitConsumption implements UnitConsumption {
  const _UnitConsumption({required this.unitId, required this.unitName, required this.tenantName, required this.unitsConsumed, required this.estimatedCost});
  factory _UnitConsumption.fromJson(Map<String, dynamic> json) => _$UnitConsumptionFromJson(json);

@override final  String unitId;
@override final  String unitName;
@override final  String tenantName;
@override final  double unitsConsumed;
@override final  double estimatedCost;

/// Create a copy of UnitConsumption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnitConsumptionCopyWith<_UnitConsumption> get copyWith => __$UnitConsumptionCopyWithImpl<_UnitConsumption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnitConsumptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnitConsumption&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.unitName, unitName) || other.unitName == unitName)&&(identical(other.tenantName, tenantName) || other.tenantName == tenantName)&&(identical(other.unitsConsumed, unitsConsumed) || other.unitsConsumed == unitsConsumed)&&(identical(other.estimatedCost, estimatedCost) || other.estimatedCost == estimatedCost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,unitId,unitName,tenantName,unitsConsumed,estimatedCost);

@override
String toString() {
  return 'UnitConsumption(unitId: $unitId, unitName: $unitName, tenantName: $tenantName, unitsConsumed: $unitsConsumed, estimatedCost: $estimatedCost)';
}


}

/// @nodoc
abstract mixin class _$UnitConsumptionCopyWith<$Res> implements $UnitConsumptionCopyWith<$Res> {
  factory _$UnitConsumptionCopyWith(_UnitConsumption value, $Res Function(_UnitConsumption) _then) = __$UnitConsumptionCopyWithImpl;
@override @useResult
$Res call({
 String unitId, String unitName, String tenantName, double unitsConsumed, double estimatedCost
});




}
/// @nodoc
class __$UnitConsumptionCopyWithImpl<$Res>
    implements _$UnitConsumptionCopyWith<$Res> {
  __$UnitConsumptionCopyWithImpl(this._self, this._then);

  final _UnitConsumption _self;
  final $Res Function(_UnitConsumption) _then;

/// Create a copy of UnitConsumption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? unitId = null,Object? unitName = null,Object? tenantName = null,Object? unitsConsumed = null,Object? estimatedCost = null,}) {
  return _then(_UnitConsumption(
unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,unitName: null == unitName ? _self.unitName : unitName // ignore: cast_nullable_to_non_nullable
as String,tenantName: null == tenantName ? _self.tenantName : tenantName // ignore: cast_nullable_to_non_nullable
as String,unitsConsumed: null == unitsConsumed ? _self.unitsConsumed : unitsConsumed // ignore: cast_nullable_to_non_nullable
as double,estimatedCost: null == estimatedCost ? _self.estimatedCost : estimatedCost // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
