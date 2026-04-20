// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'water_surplus_deficit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WaterSurplusDeficit {

 String get period; String get groundId; double get totalCollected; double get actualBillAmount; int get totalTenants; int get paidTenants;
/// Create a copy of WaterSurplusDeficit
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WaterSurplusDeficitCopyWith<WaterSurplusDeficit> get copyWith => _$WaterSurplusDeficitCopyWithImpl<WaterSurplusDeficit>(this as WaterSurplusDeficit, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WaterSurplusDeficit&&(identical(other.period, period) || other.period == period)&&(identical(other.groundId, groundId) || other.groundId == groundId)&&(identical(other.totalCollected, totalCollected) || other.totalCollected == totalCollected)&&(identical(other.actualBillAmount, actualBillAmount) || other.actualBillAmount == actualBillAmount)&&(identical(other.totalTenants, totalTenants) || other.totalTenants == totalTenants)&&(identical(other.paidTenants, paidTenants) || other.paidTenants == paidTenants));
}


@override
int get hashCode => Object.hash(runtimeType,period,groundId,totalCollected,actualBillAmount,totalTenants,paidTenants);

@override
String toString() {
  return 'WaterSurplusDeficit(period: $period, groundId: $groundId, totalCollected: $totalCollected, actualBillAmount: $actualBillAmount, totalTenants: $totalTenants, paidTenants: $paidTenants)';
}


}

/// @nodoc
abstract mixin class $WaterSurplusDeficitCopyWith<$Res>  {
  factory $WaterSurplusDeficitCopyWith(WaterSurplusDeficit value, $Res Function(WaterSurplusDeficit) _then) = _$WaterSurplusDeficitCopyWithImpl;
@useResult
$Res call({
 String period, String groundId, double totalCollected, double actualBillAmount, int totalTenants, int paidTenants
});




}
/// @nodoc
class _$WaterSurplusDeficitCopyWithImpl<$Res>
    implements $WaterSurplusDeficitCopyWith<$Res> {
  _$WaterSurplusDeficitCopyWithImpl(this._self, this._then);

  final WaterSurplusDeficit _self;
  final $Res Function(WaterSurplusDeficit) _then;

/// Create a copy of WaterSurplusDeficit
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? period = null,Object? groundId = null,Object? totalCollected = null,Object? actualBillAmount = null,Object? totalTenants = null,Object? paidTenants = null,}) {
  return _then(_self.copyWith(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,groundId: null == groundId ? _self.groundId : groundId // ignore: cast_nullable_to_non_nullable
as String,totalCollected: null == totalCollected ? _self.totalCollected : totalCollected // ignore: cast_nullable_to_non_nullable
as double,actualBillAmount: null == actualBillAmount ? _self.actualBillAmount : actualBillAmount // ignore: cast_nullable_to_non_nullable
as double,totalTenants: null == totalTenants ? _self.totalTenants : totalTenants // ignore: cast_nullable_to_non_nullable
as int,paidTenants: null == paidTenants ? _self.paidTenants : paidTenants // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WaterSurplusDeficit].
extension WaterSurplusDeficitPatterns on WaterSurplusDeficit {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WaterSurplusDeficit value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WaterSurplusDeficit() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WaterSurplusDeficit value)  $default,){
final _that = this;
switch (_that) {
case _WaterSurplusDeficit():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WaterSurplusDeficit value)?  $default,){
final _that = this;
switch (_that) {
case _WaterSurplusDeficit() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String period,  String groundId,  double totalCollected,  double actualBillAmount,  int totalTenants,  int paidTenants)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WaterSurplusDeficit() when $default != null:
return $default(_that.period,_that.groundId,_that.totalCollected,_that.actualBillAmount,_that.totalTenants,_that.paidTenants);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String period,  String groundId,  double totalCollected,  double actualBillAmount,  int totalTenants,  int paidTenants)  $default,) {final _that = this;
switch (_that) {
case _WaterSurplusDeficit():
return $default(_that.period,_that.groundId,_that.totalCollected,_that.actualBillAmount,_that.totalTenants,_that.paidTenants);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String period,  String groundId,  double totalCollected,  double actualBillAmount,  int totalTenants,  int paidTenants)?  $default,) {final _that = this;
switch (_that) {
case _WaterSurplusDeficit() when $default != null:
return $default(_that.period,_that.groundId,_that.totalCollected,_that.actualBillAmount,_that.totalTenants,_that.paidTenants);case _:
  return null;

}
}

}

/// @nodoc


class _WaterSurplusDeficit extends WaterSurplusDeficit {
  const _WaterSurplusDeficit({required this.period, required this.groundId, required this.totalCollected, required this.actualBillAmount, required this.totalTenants, required this.paidTenants}): super._();
  

@override final  String period;
@override final  String groundId;
@override final  double totalCollected;
@override final  double actualBillAmount;
@override final  int totalTenants;
@override final  int paidTenants;

/// Create a copy of WaterSurplusDeficit
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WaterSurplusDeficitCopyWith<_WaterSurplusDeficit> get copyWith => __$WaterSurplusDeficitCopyWithImpl<_WaterSurplusDeficit>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WaterSurplusDeficit&&(identical(other.period, period) || other.period == period)&&(identical(other.groundId, groundId) || other.groundId == groundId)&&(identical(other.totalCollected, totalCollected) || other.totalCollected == totalCollected)&&(identical(other.actualBillAmount, actualBillAmount) || other.actualBillAmount == actualBillAmount)&&(identical(other.totalTenants, totalTenants) || other.totalTenants == totalTenants)&&(identical(other.paidTenants, paidTenants) || other.paidTenants == paidTenants));
}


@override
int get hashCode => Object.hash(runtimeType,period,groundId,totalCollected,actualBillAmount,totalTenants,paidTenants);

@override
String toString() {
  return 'WaterSurplusDeficit(period: $period, groundId: $groundId, totalCollected: $totalCollected, actualBillAmount: $actualBillAmount, totalTenants: $totalTenants, paidTenants: $paidTenants)';
}


}

/// @nodoc
abstract mixin class _$WaterSurplusDeficitCopyWith<$Res> implements $WaterSurplusDeficitCopyWith<$Res> {
  factory _$WaterSurplusDeficitCopyWith(_WaterSurplusDeficit value, $Res Function(_WaterSurplusDeficit) _then) = __$WaterSurplusDeficitCopyWithImpl;
@override @useResult
$Res call({
 String period, String groundId, double totalCollected, double actualBillAmount, int totalTenants, int paidTenants
});




}
/// @nodoc
class __$WaterSurplusDeficitCopyWithImpl<$Res>
    implements _$WaterSurplusDeficitCopyWith<$Res> {
  __$WaterSurplusDeficitCopyWithImpl(this._self, this._then);

  final _WaterSurplusDeficit _self;
  final $Res Function(_WaterSurplusDeficit) _then;

/// Create a copy of WaterSurplusDeficit
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? period = null,Object? groundId = null,Object? totalCollected = null,Object? actualBillAmount = null,Object? totalTenants = null,Object? paidTenants = null,}) {
  return _then(_WaterSurplusDeficit(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,groundId: null == groundId ? _self.groundId : groundId // ignore: cast_nullable_to_non_nullable
as String,totalCollected: null == totalCollected ? _self.totalCollected : totalCollected // ignore: cast_nullable_to_non_nullable
as double,actualBillAmount: null == actualBillAmount ? _self.actualBillAmount : actualBillAmount // ignore: cast_nullable_to_non_nullable
as double,totalTenants: null == totalTenants ? _self.totalTenants : totalTenants // ignore: cast_nullable_to_non_nullable
as int,paidTenants: null == paidTenants ? _self.paidTenants : paidTenants // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
