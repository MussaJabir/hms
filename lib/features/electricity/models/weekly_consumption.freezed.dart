// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_consumption.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeeklyConsumption {

 DateTime get weekStart; double get unitsConsumed; double get estimatedCost;
/// Create a copy of WeeklyConsumption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklyConsumptionCopyWith<WeeklyConsumption> get copyWith => _$WeeklyConsumptionCopyWithImpl<WeeklyConsumption>(this as WeeklyConsumption, _$identity);

  /// Serializes this WeeklyConsumption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklyConsumption&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&(identical(other.unitsConsumed, unitsConsumed) || other.unitsConsumed == unitsConsumed)&&(identical(other.estimatedCost, estimatedCost) || other.estimatedCost == estimatedCost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,weekStart,unitsConsumed,estimatedCost);

@override
String toString() {
  return 'WeeklyConsumption(weekStart: $weekStart, unitsConsumed: $unitsConsumed, estimatedCost: $estimatedCost)';
}


}

/// @nodoc
abstract mixin class $WeeklyConsumptionCopyWith<$Res>  {
  factory $WeeklyConsumptionCopyWith(WeeklyConsumption value, $Res Function(WeeklyConsumption) _then) = _$WeeklyConsumptionCopyWithImpl;
@useResult
$Res call({
 DateTime weekStart, double unitsConsumed, double estimatedCost
});




}
/// @nodoc
class _$WeeklyConsumptionCopyWithImpl<$Res>
    implements $WeeklyConsumptionCopyWith<$Res> {
  _$WeeklyConsumptionCopyWithImpl(this._self, this._then);

  final WeeklyConsumption _self;
  final $Res Function(WeeklyConsumption) _then;

/// Create a copy of WeeklyConsumption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekStart = null,Object? unitsConsumed = null,Object? estimatedCost = null,}) {
  return _then(_self.copyWith(
weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as DateTime,unitsConsumed: null == unitsConsumed ? _self.unitsConsumed : unitsConsumed // ignore: cast_nullable_to_non_nullable
as double,estimatedCost: null == estimatedCost ? _self.estimatedCost : estimatedCost // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [WeeklyConsumption].
extension WeeklyConsumptionPatterns on WeeklyConsumption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklyConsumption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklyConsumption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklyConsumption value)  $default,){
final _that = this;
switch (_that) {
case _WeeklyConsumption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklyConsumption value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklyConsumption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime weekStart,  double unitsConsumed,  double estimatedCost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeeklyConsumption() when $default != null:
return $default(_that.weekStart,_that.unitsConsumed,_that.estimatedCost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime weekStart,  double unitsConsumed,  double estimatedCost)  $default,) {final _that = this;
switch (_that) {
case _WeeklyConsumption():
return $default(_that.weekStart,_that.unitsConsumed,_that.estimatedCost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime weekStart,  double unitsConsumed,  double estimatedCost)?  $default,) {final _that = this;
switch (_that) {
case _WeeklyConsumption() when $default != null:
return $default(_that.weekStart,_that.unitsConsumed,_that.estimatedCost);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeeklyConsumption implements WeeklyConsumption {
  const _WeeklyConsumption({required this.weekStart, required this.unitsConsumed, required this.estimatedCost});
  factory _WeeklyConsumption.fromJson(Map<String, dynamic> json) => _$WeeklyConsumptionFromJson(json);

@override final  DateTime weekStart;
@override final  double unitsConsumed;
@override final  double estimatedCost;

/// Create a copy of WeeklyConsumption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklyConsumptionCopyWith<_WeeklyConsumption> get copyWith => __$WeeklyConsumptionCopyWithImpl<_WeeklyConsumption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeeklyConsumptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklyConsumption&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&(identical(other.unitsConsumed, unitsConsumed) || other.unitsConsumed == unitsConsumed)&&(identical(other.estimatedCost, estimatedCost) || other.estimatedCost == estimatedCost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,weekStart,unitsConsumed,estimatedCost);

@override
String toString() {
  return 'WeeklyConsumption(weekStart: $weekStart, unitsConsumed: $unitsConsumed, estimatedCost: $estimatedCost)';
}


}

/// @nodoc
abstract mixin class _$WeeklyConsumptionCopyWith<$Res> implements $WeeklyConsumptionCopyWith<$Res> {
  factory _$WeeklyConsumptionCopyWith(_WeeklyConsumption value, $Res Function(_WeeklyConsumption) _then) = __$WeeklyConsumptionCopyWithImpl;
@override @useResult
$Res call({
 DateTime weekStart, double unitsConsumed, double estimatedCost
});




}
/// @nodoc
class __$WeeklyConsumptionCopyWithImpl<$Res>
    implements _$WeeklyConsumptionCopyWith<$Res> {
  __$WeeklyConsumptionCopyWithImpl(this._self, this._then);

  final _WeeklyConsumption _self;
  final $Res Function(_WeeklyConsumption) _then;

/// Create a copy of WeeklyConsumption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekStart = null,Object? unitsConsumed = null,Object? estimatedCost = null,}) {
  return _then(_WeeklyConsumption(
weekStart: null == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as DateTime,unitsConsumed: null == unitsConsumed ? _self.unitsConsumed : unitsConsumed // ignore: cast_nullable_to_non_nullable
as double,estimatedCost: null == estimatedCost ? _self.estimatedCost : estimatedCost // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
