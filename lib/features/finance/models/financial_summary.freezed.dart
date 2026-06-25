// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'financial_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FinancialSummary {

 String get period; double get totalIncome; double get totalExpenses; double get rentIncome; double get otherIncome; Map<String, double> get incomeBySource; Map<String, double> get expensesByCategory; double get budgetComplianceScore; int get budgetsOnTrack; int get budgetsOverLimit;
/// Create a copy of FinancialSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FinancialSummaryCopyWith<FinancialSummary> get copyWith => _$FinancialSummaryCopyWithImpl<FinancialSummary>(this as FinancialSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FinancialSummary&&(identical(other.period, period) || other.period == period)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpenses, totalExpenses) || other.totalExpenses == totalExpenses)&&(identical(other.rentIncome, rentIncome) || other.rentIncome == rentIncome)&&(identical(other.otherIncome, otherIncome) || other.otherIncome == otherIncome)&&const DeepCollectionEquality().equals(other.incomeBySource, incomeBySource)&&const DeepCollectionEquality().equals(other.expensesByCategory, expensesByCategory)&&(identical(other.budgetComplianceScore, budgetComplianceScore) || other.budgetComplianceScore == budgetComplianceScore)&&(identical(other.budgetsOnTrack, budgetsOnTrack) || other.budgetsOnTrack == budgetsOnTrack)&&(identical(other.budgetsOverLimit, budgetsOverLimit) || other.budgetsOverLimit == budgetsOverLimit));
}


@override
int get hashCode => Object.hash(runtimeType,period,totalIncome,totalExpenses,rentIncome,otherIncome,const DeepCollectionEquality().hash(incomeBySource),const DeepCollectionEquality().hash(expensesByCategory),budgetComplianceScore,budgetsOnTrack,budgetsOverLimit);

@override
String toString() {
  return 'FinancialSummary(period: $period, totalIncome: $totalIncome, totalExpenses: $totalExpenses, rentIncome: $rentIncome, otherIncome: $otherIncome, incomeBySource: $incomeBySource, expensesByCategory: $expensesByCategory, budgetComplianceScore: $budgetComplianceScore, budgetsOnTrack: $budgetsOnTrack, budgetsOverLimit: $budgetsOverLimit)';
}


}

/// @nodoc
abstract mixin class $FinancialSummaryCopyWith<$Res>  {
  factory $FinancialSummaryCopyWith(FinancialSummary value, $Res Function(FinancialSummary) _then) = _$FinancialSummaryCopyWithImpl;
@useResult
$Res call({
 String period, double totalIncome, double totalExpenses, double rentIncome, double otherIncome, Map<String, double> incomeBySource, Map<String, double> expensesByCategory, double budgetComplianceScore, int budgetsOnTrack, int budgetsOverLimit
});




}
/// @nodoc
class _$FinancialSummaryCopyWithImpl<$Res>
    implements $FinancialSummaryCopyWith<$Res> {
  _$FinancialSummaryCopyWithImpl(this._self, this._then);

  final FinancialSummary _self;
  final $Res Function(FinancialSummary) _then;

/// Create a copy of FinancialSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? period = null,Object? totalIncome = null,Object? totalExpenses = null,Object? rentIncome = null,Object? otherIncome = null,Object? incomeBySource = null,Object? expensesByCategory = null,Object? budgetComplianceScore = null,Object? budgetsOnTrack = null,Object? budgetsOverLimit = null,}) {
  return _then(_self.copyWith(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpenses: null == totalExpenses ? _self.totalExpenses : totalExpenses // ignore: cast_nullable_to_non_nullable
as double,rentIncome: null == rentIncome ? _self.rentIncome : rentIncome // ignore: cast_nullable_to_non_nullable
as double,otherIncome: null == otherIncome ? _self.otherIncome : otherIncome // ignore: cast_nullable_to_non_nullable
as double,incomeBySource: null == incomeBySource ? _self.incomeBySource : incomeBySource // ignore: cast_nullable_to_non_nullable
as Map<String, double>,expensesByCategory: null == expensesByCategory ? _self.expensesByCategory : expensesByCategory // ignore: cast_nullable_to_non_nullable
as Map<String, double>,budgetComplianceScore: null == budgetComplianceScore ? _self.budgetComplianceScore : budgetComplianceScore // ignore: cast_nullable_to_non_nullable
as double,budgetsOnTrack: null == budgetsOnTrack ? _self.budgetsOnTrack : budgetsOnTrack // ignore: cast_nullable_to_non_nullable
as int,budgetsOverLimit: null == budgetsOverLimit ? _self.budgetsOverLimit : budgetsOverLimit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FinancialSummary].
extension FinancialSummaryPatterns on FinancialSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FinancialSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FinancialSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FinancialSummary value)  $default,){
final _that = this;
switch (_that) {
case _FinancialSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FinancialSummary value)?  $default,){
final _that = this;
switch (_that) {
case _FinancialSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String period,  double totalIncome,  double totalExpenses,  double rentIncome,  double otherIncome,  Map<String, double> incomeBySource,  Map<String, double> expensesByCategory,  double budgetComplianceScore,  int budgetsOnTrack,  int budgetsOverLimit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FinancialSummary() when $default != null:
return $default(_that.period,_that.totalIncome,_that.totalExpenses,_that.rentIncome,_that.otherIncome,_that.incomeBySource,_that.expensesByCategory,_that.budgetComplianceScore,_that.budgetsOnTrack,_that.budgetsOverLimit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String period,  double totalIncome,  double totalExpenses,  double rentIncome,  double otherIncome,  Map<String, double> incomeBySource,  Map<String, double> expensesByCategory,  double budgetComplianceScore,  int budgetsOnTrack,  int budgetsOverLimit)  $default,) {final _that = this;
switch (_that) {
case _FinancialSummary():
return $default(_that.period,_that.totalIncome,_that.totalExpenses,_that.rentIncome,_that.otherIncome,_that.incomeBySource,_that.expensesByCategory,_that.budgetComplianceScore,_that.budgetsOnTrack,_that.budgetsOverLimit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String period,  double totalIncome,  double totalExpenses,  double rentIncome,  double otherIncome,  Map<String, double> incomeBySource,  Map<String, double> expensesByCategory,  double budgetComplianceScore,  int budgetsOnTrack,  int budgetsOverLimit)?  $default,) {final _that = this;
switch (_that) {
case _FinancialSummary() when $default != null:
return $default(_that.period,_that.totalIncome,_that.totalExpenses,_that.rentIncome,_that.otherIncome,_that.incomeBySource,_that.expensesByCategory,_that.budgetComplianceScore,_that.budgetsOnTrack,_that.budgetsOverLimit);case _:
  return null;

}
}

}

/// @nodoc


class _FinancialSummary extends FinancialSummary {
  const _FinancialSummary({required this.period, required this.totalIncome, required this.totalExpenses, required this.rentIncome, required this.otherIncome, required final  Map<String, double> incomeBySource, required final  Map<String, double> expensesByCategory, required this.budgetComplianceScore, required this.budgetsOnTrack, required this.budgetsOverLimit}): _incomeBySource = incomeBySource,_expensesByCategory = expensesByCategory,super._();
  

@override final  String period;
@override final  double totalIncome;
@override final  double totalExpenses;
@override final  double rentIncome;
@override final  double otherIncome;
 final  Map<String, double> _incomeBySource;
@override Map<String, double> get incomeBySource {
  if (_incomeBySource is EqualUnmodifiableMapView) return _incomeBySource;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_incomeBySource);
}

 final  Map<String, double> _expensesByCategory;
@override Map<String, double> get expensesByCategory {
  if (_expensesByCategory is EqualUnmodifiableMapView) return _expensesByCategory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_expensesByCategory);
}

@override final  double budgetComplianceScore;
@override final  int budgetsOnTrack;
@override final  int budgetsOverLimit;

/// Create a copy of FinancialSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FinancialSummaryCopyWith<_FinancialSummary> get copyWith => __$FinancialSummaryCopyWithImpl<_FinancialSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FinancialSummary&&(identical(other.period, period) || other.period == period)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpenses, totalExpenses) || other.totalExpenses == totalExpenses)&&(identical(other.rentIncome, rentIncome) || other.rentIncome == rentIncome)&&(identical(other.otherIncome, otherIncome) || other.otherIncome == otherIncome)&&const DeepCollectionEquality().equals(other._incomeBySource, _incomeBySource)&&const DeepCollectionEquality().equals(other._expensesByCategory, _expensesByCategory)&&(identical(other.budgetComplianceScore, budgetComplianceScore) || other.budgetComplianceScore == budgetComplianceScore)&&(identical(other.budgetsOnTrack, budgetsOnTrack) || other.budgetsOnTrack == budgetsOnTrack)&&(identical(other.budgetsOverLimit, budgetsOverLimit) || other.budgetsOverLimit == budgetsOverLimit));
}


@override
int get hashCode => Object.hash(runtimeType,period,totalIncome,totalExpenses,rentIncome,otherIncome,const DeepCollectionEquality().hash(_incomeBySource),const DeepCollectionEquality().hash(_expensesByCategory),budgetComplianceScore,budgetsOnTrack,budgetsOverLimit);

@override
String toString() {
  return 'FinancialSummary(period: $period, totalIncome: $totalIncome, totalExpenses: $totalExpenses, rentIncome: $rentIncome, otherIncome: $otherIncome, incomeBySource: $incomeBySource, expensesByCategory: $expensesByCategory, budgetComplianceScore: $budgetComplianceScore, budgetsOnTrack: $budgetsOnTrack, budgetsOverLimit: $budgetsOverLimit)';
}


}

/// @nodoc
abstract mixin class _$FinancialSummaryCopyWith<$Res> implements $FinancialSummaryCopyWith<$Res> {
  factory _$FinancialSummaryCopyWith(_FinancialSummary value, $Res Function(_FinancialSummary) _then) = __$FinancialSummaryCopyWithImpl;
@override @useResult
$Res call({
 String period, double totalIncome, double totalExpenses, double rentIncome, double otherIncome, Map<String, double> incomeBySource, Map<String, double> expensesByCategory, double budgetComplianceScore, int budgetsOnTrack, int budgetsOverLimit
});




}
/// @nodoc
class __$FinancialSummaryCopyWithImpl<$Res>
    implements _$FinancialSummaryCopyWith<$Res> {
  __$FinancialSummaryCopyWithImpl(this._self, this._then);

  final _FinancialSummary _self;
  final $Res Function(_FinancialSummary) _then;

/// Create a copy of FinancialSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? period = null,Object? totalIncome = null,Object? totalExpenses = null,Object? rentIncome = null,Object? otherIncome = null,Object? incomeBySource = null,Object? expensesByCategory = null,Object? budgetComplianceScore = null,Object? budgetsOnTrack = null,Object? budgetsOverLimit = null,}) {
  return _then(_FinancialSummary(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpenses: null == totalExpenses ? _self.totalExpenses : totalExpenses // ignore: cast_nullable_to_non_nullable
as double,rentIncome: null == rentIncome ? _self.rentIncome : rentIncome // ignore: cast_nullable_to_non_nullable
as double,otherIncome: null == otherIncome ? _self.otherIncome : otherIncome // ignore: cast_nullable_to_non_nullable
as double,incomeBySource: null == incomeBySource ? _self._incomeBySource : incomeBySource // ignore: cast_nullable_to_non_nullable
as Map<String, double>,expensesByCategory: null == expensesByCategory ? _self._expensesByCategory : expensesByCategory // ignore: cast_nullable_to_non_nullable
as Map<String, double>,budgetComplianceScore: null == budgetComplianceScore ? _self.budgetComplianceScore : budgetComplianceScore // ignore: cast_nullable_to_non_nullable
as double,budgetsOnTrack: null == budgetsOnTrack ? _self.budgetsOnTrack : budgetsOnTrack // ignore: cast_nullable_to_non_nullable
as int,budgetsOverLimit: null == budgetsOverLimit ? _self.budgetsOverLimit : budgetsOverLimit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
