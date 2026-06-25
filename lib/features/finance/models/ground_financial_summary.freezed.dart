// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ground_financial_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GroundFinancialSummary {

 String get groundId; String get groundName; double get income; double get expenses;
/// Create a copy of GroundFinancialSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroundFinancialSummaryCopyWith<GroundFinancialSummary> get copyWith => _$GroundFinancialSummaryCopyWithImpl<GroundFinancialSummary>(this as GroundFinancialSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroundFinancialSummary&&(identical(other.groundId, groundId) || other.groundId == groundId)&&(identical(other.groundName, groundName) || other.groundName == groundName)&&(identical(other.income, income) || other.income == income)&&(identical(other.expenses, expenses) || other.expenses == expenses));
}


@override
int get hashCode => Object.hash(runtimeType,groundId,groundName,income,expenses);

@override
String toString() {
  return 'GroundFinancialSummary(groundId: $groundId, groundName: $groundName, income: $income, expenses: $expenses)';
}


}

/// @nodoc
abstract mixin class $GroundFinancialSummaryCopyWith<$Res>  {
  factory $GroundFinancialSummaryCopyWith(GroundFinancialSummary value, $Res Function(GroundFinancialSummary) _then) = _$GroundFinancialSummaryCopyWithImpl;
@useResult
$Res call({
 String groundId, String groundName, double income, double expenses
});




}
/// @nodoc
class _$GroundFinancialSummaryCopyWithImpl<$Res>
    implements $GroundFinancialSummaryCopyWith<$Res> {
  _$GroundFinancialSummaryCopyWithImpl(this._self, this._then);

  final GroundFinancialSummary _self;
  final $Res Function(GroundFinancialSummary) _then;

/// Create a copy of GroundFinancialSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groundId = null,Object? groundName = null,Object? income = null,Object? expenses = null,}) {
  return _then(_self.copyWith(
groundId: null == groundId ? _self.groundId : groundId // ignore: cast_nullable_to_non_nullable
as String,groundName: null == groundName ? _self.groundName : groundName // ignore: cast_nullable_to_non_nullable
as String,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double,expenses: null == expenses ? _self.expenses : expenses // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [GroundFinancialSummary].
extension GroundFinancialSummaryPatterns on GroundFinancialSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroundFinancialSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroundFinancialSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroundFinancialSummary value)  $default,){
final _that = this;
switch (_that) {
case _GroundFinancialSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroundFinancialSummary value)?  $default,){
final _that = this;
switch (_that) {
case _GroundFinancialSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String groundId,  String groundName,  double income,  double expenses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroundFinancialSummary() when $default != null:
return $default(_that.groundId,_that.groundName,_that.income,_that.expenses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String groundId,  String groundName,  double income,  double expenses)  $default,) {final _that = this;
switch (_that) {
case _GroundFinancialSummary():
return $default(_that.groundId,_that.groundName,_that.income,_that.expenses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String groundId,  String groundName,  double income,  double expenses)?  $default,) {final _that = this;
switch (_that) {
case _GroundFinancialSummary() when $default != null:
return $default(_that.groundId,_that.groundName,_that.income,_that.expenses);case _:
  return null;

}
}

}

/// @nodoc


class _GroundFinancialSummary extends GroundFinancialSummary {
  const _GroundFinancialSummary({required this.groundId, required this.groundName, required this.income, required this.expenses}): super._();
  

@override final  String groundId;
@override final  String groundName;
@override final  double income;
@override final  double expenses;

/// Create a copy of GroundFinancialSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroundFinancialSummaryCopyWith<_GroundFinancialSummary> get copyWith => __$GroundFinancialSummaryCopyWithImpl<_GroundFinancialSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroundFinancialSummary&&(identical(other.groundId, groundId) || other.groundId == groundId)&&(identical(other.groundName, groundName) || other.groundName == groundName)&&(identical(other.income, income) || other.income == income)&&(identical(other.expenses, expenses) || other.expenses == expenses));
}


@override
int get hashCode => Object.hash(runtimeType,groundId,groundName,income,expenses);

@override
String toString() {
  return 'GroundFinancialSummary(groundId: $groundId, groundName: $groundName, income: $income, expenses: $expenses)';
}


}

/// @nodoc
abstract mixin class _$GroundFinancialSummaryCopyWith<$Res> implements $GroundFinancialSummaryCopyWith<$Res> {
  factory _$GroundFinancialSummaryCopyWith(_GroundFinancialSummary value, $Res Function(_GroundFinancialSummary) _then) = __$GroundFinancialSummaryCopyWithImpl;
@override @useResult
$Res call({
 String groundId, String groundName, double income, double expenses
});




}
/// @nodoc
class __$GroundFinancialSummaryCopyWithImpl<$Res>
    implements _$GroundFinancialSummaryCopyWith<$Res> {
  __$GroundFinancialSummaryCopyWithImpl(this._self, this._then);

  final _GroundFinancialSummary _self;
  final $Res Function(_GroundFinancialSummary) _then;

/// Create a copy of GroundFinancialSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groundId = null,Object? groundName = null,Object? income = null,Object? expenses = null,}) {
  return _then(_GroundFinancialSummary(
groundId: null == groundId ? _self.groundId : groundId // ignore: cast_nullable_to_non_nullable
as String,groundName: null == groundName ? _self.groundName : groundName // ignore: cast_nullable_to_non_nullable
as String,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double,expenses: null == expenses ? _self.expenses : expenses // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
