// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_score.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HealthScore {

 double get rentScore; double get billsScore; double get stockScore; double get overdueScore; double get budgetScore; bool get rentActive; bool get billsActive; bool get stockActive; bool get overdueActive; bool get budgetActive;
/// Create a copy of HealthScore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthScoreCopyWith<HealthScore> get copyWith => _$HealthScoreCopyWithImpl<HealthScore>(this as HealthScore, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthScore&&(identical(other.rentScore, rentScore) || other.rentScore == rentScore)&&(identical(other.billsScore, billsScore) || other.billsScore == billsScore)&&(identical(other.stockScore, stockScore) || other.stockScore == stockScore)&&(identical(other.overdueScore, overdueScore) || other.overdueScore == overdueScore)&&(identical(other.budgetScore, budgetScore) || other.budgetScore == budgetScore)&&(identical(other.rentActive, rentActive) || other.rentActive == rentActive)&&(identical(other.billsActive, billsActive) || other.billsActive == billsActive)&&(identical(other.stockActive, stockActive) || other.stockActive == stockActive)&&(identical(other.overdueActive, overdueActive) || other.overdueActive == overdueActive)&&(identical(other.budgetActive, budgetActive) || other.budgetActive == budgetActive));
}


@override
int get hashCode => Object.hash(runtimeType,rentScore,billsScore,stockScore,overdueScore,budgetScore,rentActive,billsActive,stockActive,overdueActive,budgetActive);

@override
String toString() {
  return 'HealthScore(rentScore: $rentScore, billsScore: $billsScore, stockScore: $stockScore, overdueScore: $overdueScore, budgetScore: $budgetScore, rentActive: $rentActive, billsActive: $billsActive, stockActive: $stockActive, overdueActive: $overdueActive, budgetActive: $budgetActive)';
}


}

/// @nodoc
abstract mixin class $HealthScoreCopyWith<$Res>  {
  factory $HealthScoreCopyWith(HealthScore value, $Res Function(HealthScore) _then) = _$HealthScoreCopyWithImpl;
@useResult
$Res call({
 double rentScore, double billsScore, double stockScore, double overdueScore, double budgetScore, bool rentActive, bool billsActive, bool stockActive, bool overdueActive, bool budgetActive
});




}
/// @nodoc
class _$HealthScoreCopyWithImpl<$Res>
    implements $HealthScoreCopyWith<$Res> {
  _$HealthScoreCopyWithImpl(this._self, this._then);

  final HealthScore _self;
  final $Res Function(HealthScore) _then;

/// Create a copy of HealthScore
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rentScore = null,Object? billsScore = null,Object? stockScore = null,Object? overdueScore = null,Object? budgetScore = null,Object? rentActive = null,Object? billsActive = null,Object? stockActive = null,Object? overdueActive = null,Object? budgetActive = null,}) {
  return _then(_self.copyWith(
rentScore: null == rentScore ? _self.rentScore : rentScore // ignore: cast_nullable_to_non_nullable
as double,billsScore: null == billsScore ? _self.billsScore : billsScore // ignore: cast_nullable_to_non_nullable
as double,stockScore: null == stockScore ? _self.stockScore : stockScore // ignore: cast_nullable_to_non_nullable
as double,overdueScore: null == overdueScore ? _self.overdueScore : overdueScore // ignore: cast_nullable_to_non_nullable
as double,budgetScore: null == budgetScore ? _self.budgetScore : budgetScore // ignore: cast_nullable_to_non_nullable
as double,rentActive: null == rentActive ? _self.rentActive : rentActive // ignore: cast_nullable_to_non_nullable
as bool,billsActive: null == billsActive ? _self.billsActive : billsActive // ignore: cast_nullable_to_non_nullable
as bool,stockActive: null == stockActive ? _self.stockActive : stockActive // ignore: cast_nullable_to_non_nullable
as bool,overdueActive: null == overdueActive ? _self.overdueActive : overdueActive // ignore: cast_nullable_to_non_nullable
as bool,budgetActive: null == budgetActive ? _self.budgetActive : budgetActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthScore].
extension HealthScorePatterns on HealthScore {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthScore value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthScore() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthScore value)  $default,){
final _that = this;
switch (_that) {
case _HealthScore():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthScore value)?  $default,){
final _that = this;
switch (_that) {
case _HealthScore() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double rentScore,  double billsScore,  double stockScore,  double overdueScore,  double budgetScore,  bool rentActive,  bool billsActive,  bool stockActive,  bool overdueActive,  bool budgetActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthScore() when $default != null:
return $default(_that.rentScore,_that.billsScore,_that.stockScore,_that.overdueScore,_that.budgetScore,_that.rentActive,_that.billsActive,_that.stockActive,_that.overdueActive,_that.budgetActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double rentScore,  double billsScore,  double stockScore,  double overdueScore,  double budgetScore,  bool rentActive,  bool billsActive,  bool stockActive,  bool overdueActive,  bool budgetActive)  $default,) {final _that = this;
switch (_that) {
case _HealthScore():
return $default(_that.rentScore,_that.billsScore,_that.stockScore,_that.overdueScore,_that.budgetScore,_that.rentActive,_that.billsActive,_that.stockActive,_that.overdueActive,_that.budgetActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double rentScore,  double billsScore,  double stockScore,  double overdueScore,  double budgetScore,  bool rentActive,  bool billsActive,  bool stockActive,  bool overdueActive,  bool budgetActive)?  $default,) {final _that = this;
switch (_that) {
case _HealthScore() when $default != null:
return $default(_that.rentScore,_that.billsScore,_that.stockScore,_that.overdueScore,_that.budgetScore,_that.rentActive,_that.billsActive,_that.stockActive,_that.overdueActive,_that.budgetActive);case _:
  return null;

}
}

}

/// @nodoc


class _HealthScore extends HealthScore {
  const _HealthScore({this.rentScore = 0, this.billsScore = 0, this.stockScore = 0, this.overdueScore = 0, this.budgetScore = 0, this.rentActive = false, this.billsActive = false, this.stockActive = false, this.overdueActive = false, this.budgetActive = false}): super._();
  

@override@JsonKey() final  double rentScore;
@override@JsonKey() final  double billsScore;
@override@JsonKey() final  double stockScore;
@override@JsonKey() final  double overdueScore;
@override@JsonKey() final  double budgetScore;
@override@JsonKey() final  bool rentActive;
@override@JsonKey() final  bool billsActive;
@override@JsonKey() final  bool stockActive;
@override@JsonKey() final  bool overdueActive;
@override@JsonKey() final  bool budgetActive;

/// Create a copy of HealthScore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthScoreCopyWith<_HealthScore> get copyWith => __$HealthScoreCopyWithImpl<_HealthScore>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthScore&&(identical(other.rentScore, rentScore) || other.rentScore == rentScore)&&(identical(other.billsScore, billsScore) || other.billsScore == billsScore)&&(identical(other.stockScore, stockScore) || other.stockScore == stockScore)&&(identical(other.overdueScore, overdueScore) || other.overdueScore == overdueScore)&&(identical(other.budgetScore, budgetScore) || other.budgetScore == budgetScore)&&(identical(other.rentActive, rentActive) || other.rentActive == rentActive)&&(identical(other.billsActive, billsActive) || other.billsActive == billsActive)&&(identical(other.stockActive, stockActive) || other.stockActive == stockActive)&&(identical(other.overdueActive, overdueActive) || other.overdueActive == overdueActive)&&(identical(other.budgetActive, budgetActive) || other.budgetActive == budgetActive));
}


@override
int get hashCode => Object.hash(runtimeType,rentScore,billsScore,stockScore,overdueScore,budgetScore,rentActive,billsActive,stockActive,overdueActive,budgetActive);

@override
String toString() {
  return 'HealthScore(rentScore: $rentScore, billsScore: $billsScore, stockScore: $stockScore, overdueScore: $overdueScore, budgetScore: $budgetScore, rentActive: $rentActive, billsActive: $billsActive, stockActive: $stockActive, overdueActive: $overdueActive, budgetActive: $budgetActive)';
}


}

/// @nodoc
abstract mixin class _$HealthScoreCopyWith<$Res> implements $HealthScoreCopyWith<$Res> {
  factory _$HealthScoreCopyWith(_HealthScore value, $Res Function(_HealthScore) _then) = __$HealthScoreCopyWithImpl;
@override @useResult
$Res call({
 double rentScore, double billsScore, double stockScore, double overdueScore, double budgetScore, bool rentActive, bool billsActive, bool stockActive, bool overdueActive, bool budgetActive
});




}
/// @nodoc
class __$HealthScoreCopyWithImpl<$Res>
    implements _$HealthScoreCopyWith<$Res> {
  __$HealthScoreCopyWithImpl(this._self, this._then);

  final _HealthScore _self;
  final $Res Function(_HealthScore) _then;

/// Create a copy of HealthScore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rentScore = null,Object? billsScore = null,Object? stockScore = null,Object? overdueScore = null,Object? budgetScore = null,Object? rentActive = null,Object? billsActive = null,Object? stockActive = null,Object? overdueActive = null,Object? budgetActive = null,}) {
  return _then(_HealthScore(
rentScore: null == rentScore ? _self.rentScore : rentScore // ignore: cast_nullable_to_non_nullable
as double,billsScore: null == billsScore ? _self.billsScore : billsScore // ignore: cast_nullable_to_non_nullable
as double,stockScore: null == stockScore ? _self.stockScore : stockScore // ignore: cast_nullable_to_non_nullable
as double,overdueScore: null == overdueScore ? _self.overdueScore : overdueScore // ignore: cast_nullable_to_non_nullable
as double,budgetScore: null == budgetScore ? _self.budgetScore : budgetScore // ignore: cast_nullable_to_non_nullable
as double,rentActive: null == rentActive ? _self.rentActive : rentActive // ignore: cast_nullable_to_non_nullable
as bool,billsActive: null == billsActive ? _self.billsActive : billsActive // ignore: cast_nullable_to_non_nullable
as bool,stockActive: null == stockActive ? _self.stockActive : stockActive // ignore: cast_nullable_to_non_nullable
as bool,overdueActive: null == overdueActive ? _self.overdueActive : overdueActive // ignore: cast_nullable_to_non_nullable
as bool,budgetActive: null == budgetActive ? _self.budgetActive : budgetActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
