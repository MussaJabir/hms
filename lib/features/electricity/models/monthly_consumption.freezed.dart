// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_consumption.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MonthlyConsumption {

 String get period;// "2026-03"
 double get unitsConsumed; double get estimatedCost;
/// Create a copy of MonthlyConsumption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyConsumptionCopyWith<MonthlyConsumption> get copyWith => _$MonthlyConsumptionCopyWithImpl<MonthlyConsumption>(this as MonthlyConsumption, _$identity);

  /// Serializes this MonthlyConsumption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyConsumption&&(identical(other.period, period) || other.period == period)&&(identical(other.unitsConsumed, unitsConsumed) || other.unitsConsumed == unitsConsumed)&&(identical(other.estimatedCost, estimatedCost) || other.estimatedCost == estimatedCost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,period,unitsConsumed,estimatedCost);

@override
String toString() {
  return 'MonthlyConsumption(period: $period, unitsConsumed: $unitsConsumed, estimatedCost: $estimatedCost)';
}


}

/// @nodoc
abstract mixin class $MonthlyConsumptionCopyWith<$Res>  {
  factory $MonthlyConsumptionCopyWith(MonthlyConsumption value, $Res Function(MonthlyConsumption) _then) = _$MonthlyConsumptionCopyWithImpl;
@useResult
$Res call({
 String period, double unitsConsumed, double estimatedCost
});




}
/// @nodoc
class _$MonthlyConsumptionCopyWithImpl<$Res>
    implements $MonthlyConsumptionCopyWith<$Res> {
  _$MonthlyConsumptionCopyWithImpl(this._self, this._then);

  final MonthlyConsumption _self;
  final $Res Function(MonthlyConsumption) _then;

/// Create a copy of MonthlyConsumption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? period = null,Object? unitsConsumed = null,Object? estimatedCost = null,}) {
  return _then(_self.copyWith(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,unitsConsumed: null == unitsConsumed ? _self.unitsConsumed : unitsConsumed // ignore: cast_nullable_to_non_nullable
as double,estimatedCost: null == estimatedCost ? _self.estimatedCost : estimatedCost // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyConsumption].
extension MonthlyConsumptionPatterns on MonthlyConsumption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyConsumption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyConsumption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyConsumption value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyConsumption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyConsumption value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyConsumption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String period,  double unitsConsumed,  double estimatedCost)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyConsumption() when $default != null:
return $default(_that.period,_that.unitsConsumed,_that.estimatedCost);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String period,  double unitsConsumed,  double estimatedCost)  $default,) {final _that = this;
switch (_that) {
case _MonthlyConsumption():
return $default(_that.period,_that.unitsConsumed,_that.estimatedCost);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String period,  double unitsConsumed,  double estimatedCost)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyConsumption() when $default != null:
return $default(_that.period,_that.unitsConsumed,_that.estimatedCost);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonthlyConsumption implements MonthlyConsumption {
  const _MonthlyConsumption({required this.period, required this.unitsConsumed, required this.estimatedCost});
  factory _MonthlyConsumption.fromJson(Map<String, dynamic> json) => _$MonthlyConsumptionFromJson(json);

@override final  String period;
// "2026-03"
@override final  double unitsConsumed;
@override final  double estimatedCost;

/// Create a copy of MonthlyConsumption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyConsumptionCopyWith<_MonthlyConsumption> get copyWith => __$MonthlyConsumptionCopyWithImpl<_MonthlyConsumption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthlyConsumptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyConsumption&&(identical(other.period, period) || other.period == period)&&(identical(other.unitsConsumed, unitsConsumed) || other.unitsConsumed == unitsConsumed)&&(identical(other.estimatedCost, estimatedCost) || other.estimatedCost == estimatedCost));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,period,unitsConsumed,estimatedCost);

@override
String toString() {
  return 'MonthlyConsumption(period: $period, unitsConsumed: $unitsConsumed, estimatedCost: $estimatedCost)';
}


}

/// @nodoc
abstract mixin class _$MonthlyConsumptionCopyWith<$Res> implements $MonthlyConsumptionCopyWith<$Res> {
  factory _$MonthlyConsumptionCopyWith(_MonthlyConsumption value, $Res Function(_MonthlyConsumption) _then) = __$MonthlyConsumptionCopyWithImpl;
@override @useResult
$Res call({
 String period, double unitsConsumed, double estimatedCost
});




}
/// @nodoc
class __$MonthlyConsumptionCopyWithImpl<$Res>
    implements _$MonthlyConsumptionCopyWith<$Res> {
  __$MonthlyConsumptionCopyWithImpl(this._self, this._then);

  final _MonthlyConsumption _self;
  final $Res Function(_MonthlyConsumption) _then;

/// Create a copy of MonthlyConsumption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? period = null,Object? unitsConsumed = null,Object? estimatedCost = null,}) {
  return _then(_MonthlyConsumption(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,unitsConsumed: null == unitsConsumed ? _self.unitsConsumed : unitsConsumed // ignore: cast_nullable_to_non_nullable
as double,estimatedCost: null == estimatedCost ? _self.estimatedCost : estimatedCost // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
