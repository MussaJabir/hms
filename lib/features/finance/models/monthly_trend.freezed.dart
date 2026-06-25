// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_trend.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MonthlyTrend {

 String get period; double get income; double get expenses;
/// Create a copy of MonthlyTrend
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyTrendCopyWith<MonthlyTrend> get copyWith => _$MonthlyTrendCopyWithImpl<MonthlyTrend>(this as MonthlyTrend, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyTrend&&(identical(other.period, period) || other.period == period)&&(identical(other.income, income) || other.income == income)&&(identical(other.expenses, expenses) || other.expenses == expenses));
}


@override
int get hashCode => Object.hash(runtimeType,period,income,expenses);

@override
String toString() {
  return 'MonthlyTrend(period: $period, income: $income, expenses: $expenses)';
}


}

/// @nodoc
abstract mixin class $MonthlyTrendCopyWith<$Res>  {
  factory $MonthlyTrendCopyWith(MonthlyTrend value, $Res Function(MonthlyTrend) _then) = _$MonthlyTrendCopyWithImpl;
@useResult
$Res call({
 String period, double income, double expenses
});




}
/// @nodoc
class _$MonthlyTrendCopyWithImpl<$Res>
    implements $MonthlyTrendCopyWith<$Res> {
  _$MonthlyTrendCopyWithImpl(this._self, this._then);

  final MonthlyTrend _self;
  final $Res Function(MonthlyTrend) _then;

/// Create a copy of MonthlyTrend
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? period = null,Object? income = null,Object? expenses = null,}) {
  return _then(_self.copyWith(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double,expenses: null == expenses ? _self.expenses : expenses // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyTrend].
extension MonthlyTrendPatterns on MonthlyTrend {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyTrend value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyTrend() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyTrend value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyTrend():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyTrend value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyTrend() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String period,  double income,  double expenses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyTrend() when $default != null:
return $default(_that.period,_that.income,_that.expenses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String period,  double income,  double expenses)  $default,) {final _that = this;
switch (_that) {
case _MonthlyTrend():
return $default(_that.period,_that.income,_that.expenses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String period,  double income,  double expenses)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyTrend() when $default != null:
return $default(_that.period,_that.income,_that.expenses);case _:
  return null;

}
}

}

/// @nodoc


class _MonthlyTrend extends MonthlyTrend {
  const _MonthlyTrend({required this.period, required this.income, required this.expenses}): super._();
  

@override final  String period;
@override final  double income;
@override final  double expenses;

/// Create a copy of MonthlyTrend
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyTrendCopyWith<_MonthlyTrend> get copyWith => __$MonthlyTrendCopyWithImpl<_MonthlyTrend>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyTrend&&(identical(other.period, period) || other.period == period)&&(identical(other.income, income) || other.income == income)&&(identical(other.expenses, expenses) || other.expenses == expenses));
}


@override
int get hashCode => Object.hash(runtimeType,period,income,expenses);

@override
String toString() {
  return 'MonthlyTrend(period: $period, income: $income, expenses: $expenses)';
}


}

/// @nodoc
abstract mixin class _$MonthlyTrendCopyWith<$Res> implements $MonthlyTrendCopyWith<$Res> {
  factory _$MonthlyTrendCopyWith(_MonthlyTrend value, $Res Function(_MonthlyTrend) _then) = __$MonthlyTrendCopyWithImpl;
@override @useResult
$Res call({
 String period, double income, double expenses
});




}
/// @nodoc
class __$MonthlyTrendCopyWithImpl<$Res>
    implements _$MonthlyTrendCopyWith<$Res> {
  __$MonthlyTrendCopyWithImpl(this._self, this._then);

  final _MonthlyTrend _self;
  final $Res Function(_MonthlyTrend) _then;

/// Create a copy of MonthlyTrend
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? period = null,Object? income = null,Object? expenses = null,}) {
  return _then(_MonthlyTrend(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double,expenses: null == expenses ? _self.expenses : expenses // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
