// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MonthlyReport {

 String get period;// "2026-03" format
 double get totalIncome; double get totalExpenses; double get rentExpected; double get rentCollected; List<ExpenseCategory> get topExpenses; List<OverdueItem> get overdueItems; double get mainGroundIncome; double get mainGroundExpenses; double get minorGroundIncome; double get minorGroundExpenses; double get electricityUnits; double get electricityEstimatedCost; double get waterBillTotal; double get waterContributionsCollected; double get waterSurplusDeficit;
/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyReportCopyWith<MonthlyReport> get copyWith => _$MonthlyReportCopyWithImpl<MonthlyReport>(this as MonthlyReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyReport&&(identical(other.period, period) || other.period == period)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpenses, totalExpenses) || other.totalExpenses == totalExpenses)&&(identical(other.rentExpected, rentExpected) || other.rentExpected == rentExpected)&&(identical(other.rentCollected, rentCollected) || other.rentCollected == rentCollected)&&const DeepCollectionEquality().equals(other.topExpenses, topExpenses)&&const DeepCollectionEquality().equals(other.overdueItems, overdueItems)&&(identical(other.mainGroundIncome, mainGroundIncome) || other.mainGroundIncome == mainGroundIncome)&&(identical(other.mainGroundExpenses, mainGroundExpenses) || other.mainGroundExpenses == mainGroundExpenses)&&(identical(other.minorGroundIncome, minorGroundIncome) || other.minorGroundIncome == minorGroundIncome)&&(identical(other.minorGroundExpenses, minorGroundExpenses) || other.minorGroundExpenses == minorGroundExpenses)&&(identical(other.electricityUnits, electricityUnits) || other.electricityUnits == electricityUnits)&&(identical(other.electricityEstimatedCost, electricityEstimatedCost) || other.electricityEstimatedCost == electricityEstimatedCost)&&(identical(other.waterBillTotal, waterBillTotal) || other.waterBillTotal == waterBillTotal)&&(identical(other.waterContributionsCollected, waterContributionsCollected) || other.waterContributionsCollected == waterContributionsCollected)&&(identical(other.waterSurplusDeficit, waterSurplusDeficit) || other.waterSurplusDeficit == waterSurplusDeficit));
}


@override
int get hashCode => Object.hash(runtimeType,period,totalIncome,totalExpenses,rentExpected,rentCollected,const DeepCollectionEquality().hash(topExpenses),const DeepCollectionEquality().hash(overdueItems),mainGroundIncome,mainGroundExpenses,minorGroundIncome,minorGroundExpenses,electricityUnits,electricityEstimatedCost,waterBillTotal,waterContributionsCollected,waterSurplusDeficit);

@override
String toString() {
  return 'MonthlyReport(period: $period, totalIncome: $totalIncome, totalExpenses: $totalExpenses, rentExpected: $rentExpected, rentCollected: $rentCollected, topExpenses: $topExpenses, overdueItems: $overdueItems, mainGroundIncome: $mainGroundIncome, mainGroundExpenses: $mainGroundExpenses, minorGroundIncome: $minorGroundIncome, minorGroundExpenses: $minorGroundExpenses, electricityUnits: $electricityUnits, electricityEstimatedCost: $electricityEstimatedCost, waterBillTotal: $waterBillTotal, waterContributionsCollected: $waterContributionsCollected, waterSurplusDeficit: $waterSurplusDeficit)';
}


}

/// @nodoc
abstract mixin class $MonthlyReportCopyWith<$Res>  {
  factory $MonthlyReportCopyWith(MonthlyReport value, $Res Function(MonthlyReport) _then) = _$MonthlyReportCopyWithImpl;
@useResult
$Res call({
 String period, double totalIncome, double totalExpenses, double rentExpected, double rentCollected, List<ExpenseCategory> topExpenses, List<OverdueItem> overdueItems, double mainGroundIncome, double mainGroundExpenses, double minorGroundIncome, double minorGroundExpenses, double electricityUnits, double electricityEstimatedCost, double waterBillTotal, double waterContributionsCollected, double waterSurplusDeficit
});




}
/// @nodoc
class _$MonthlyReportCopyWithImpl<$Res>
    implements $MonthlyReportCopyWith<$Res> {
  _$MonthlyReportCopyWithImpl(this._self, this._then);

  final MonthlyReport _self;
  final $Res Function(MonthlyReport) _then;

/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? period = null,Object? totalIncome = null,Object? totalExpenses = null,Object? rentExpected = null,Object? rentCollected = null,Object? topExpenses = null,Object? overdueItems = null,Object? mainGroundIncome = null,Object? mainGroundExpenses = null,Object? minorGroundIncome = null,Object? minorGroundExpenses = null,Object? electricityUnits = null,Object? electricityEstimatedCost = null,Object? waterBillTotal = null,Object? waterContributionsCollected = null,Object? waterSurplusDeficit = null,}) {
  return _then(_self.copyWith(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpenses: null == totalExpenses ? _self.totalExpenses : totalExpenses // ignore: cast_nullable_to_non_nullable
as double,rentExpected: null == rentExpected ? _self.rentExpected : rentExpected // ignore: cast_nullable_to_non_nullable
as double,rentCollected: null == rentCollected ? _self.rentCollected : rentCollected // ignore: cast_nullable_to_non_nullable
as double,topExpenses: null == topExpenses ? _self.topExpenses : topExpenses // ignore: cast_nullable_to_non_nullable
as List<ExpenseCategory>,overdueItems: null == overdueItems ? _self.overdueItems : overdueItems // ignore: cast_nullable_to_non_nullable
as List<OverdueItem>,mainGroundIncome: null == mainGroundIncome ? _self.mainGroundIncome : mainGroundIncome // ignore: cast_nullable_to_non_nullable
as double,mainGroundExpenses: null == mainGroundExpenses ? _self.mainGroundExpenses : mainGroundExpenses // ignore: cast_nullable_to_non_nullable
as double,minorGroundIncome: null == minorGroundIncome ? _self.minorGroundIncome : minorGroundIncome // ignore: cast_nullable_to_non_nullable
as double,minorGroundExpenses: null == minorGroundExpenses ? _self.minorGroundExpenses : minorGroundExpenses // ignore: cast_nullable_to_non_nullable
as double,electricityUnits: null == electricityUnits ? _self.electricityUnits : electricityUnits // ignore: cast_nullable_to_non_nullable
as double,electricityEstimatedCost: null == electricityEstimatedCost ? _self.electricityEstimatedCost : electricityEstimatedCost // ignore: cast_nullable_to_non_nullable
as double,waterBillTotal: null == waterBillTotal ? _self.waterBillTotal : waterBillTotal // ignore: cast_nullable_to_non_nullable
as double,waterContributionsCollected: null == waterContributionsCollected ? _self.waterContributionsCollected : waterContributionsCollected // ignore: cast_nullable_to_non_nullable
as double,waterSurplusDeficit: null == waterSurplusDeficit ? _self.waterSurplusDeficit : waterSurplusDeficit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyReport].
extension MonthlyReportPatterns on MonthlyReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyReport value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyReport value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String period,  double totalIncome,  double totalExpenses,  double rentExpected,  double rentCollected,  List<ExpenseCategory> topExpenses,  List<OverdueItem> overdueItems,  double mainGroundIncome,  double mainGroundExpenses,  double minorGroundIncome,  double minorGroundExpenses,  double electricityUnits,  double electricityEstimatedCost,  double waterBillTotal,  double waterContributionsCollected,  double waterSurplusDeficit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyReport() when $default != null:
return $default(_that.period,_that.totalIncome,_that.totalExpenses,_that.rentExpected,_that.rentCollected,_that.topExpenses,_that.overdueItems,_that.mainGroundIncome,_that.mainGroundExpenses,_that.minorGroundIncome,_that.minorGroundExpenses,_that.electricityUnits,_that.electricityEstimatedCost,_that.waterBillTotal,_that.waterContributionsCollected,_that.waterSurplusDeficit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String period,  double totalIncome,  double totalExpenses,  double rentExpected,  double rentCollected,  List<ExpenseCategory> topExpenses,  List<OverdueItem> overdueItems,  double mainGroundIncome,  double mainGroundExpenses,  double minorGroundIncome,  double minorGroundExpenses,  double electricityUnits,  double electricityEstimatedCost,  double waterBillTotal,  double waterContributionsCollected,  double waterSurplusDeficit)  $default,) {final _that = this;
switch (_that) {
case _MonthlyReport():
return $default(_that.period,_that.totalIncome,_that.totalExpenses,_that.rentExpected,_that.rentCollected,_that.topExpenses,_that.overdueItems,_that.mainGroundIncome,_that.mainGroundExpenses,_that.minorGroundIncome,_that.minorGroundExpenses,_that.electricityUnits,_that.electricityEstimatedCost,_that.waterBillTotal,_that.waterContributionsCollected,_that.waterSurplusDeficit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String period,  double totalIncome,  double totalExpenses,  double rentExpected,  double rentCollected,  List<ExpenseCategory> topExpenses,  List<OverdueItem> overdueItems,  double mainGroundIncome,  double mainGroundExpenses,  double minorGroundIncome,  double minorGroundExpenses,  double electricityUnits,  double electricityEstimatedCost,  double waterBillTotal,  double waterContributionsCollected,  double waterSurplusDeficit)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyReport() when $default != null:
return $default(_that.period,_that.totalIncome,_that.totalExpenses,_that.rentExpected,_that.rentCollected,_that.topExpenses,_that.overdueItems,_that.mainGroundIncome,_that.mainGroundExpenses,_that.minorGroundIncome,_that.minorGroundExpenses,_that.electricityUnits,_that.electricityEstimatedCost,_that.waterBillTotal,_that.waterContributionsCollected,_that.waterSurplusDeficit);case _:
  return null;

}
}

}

/// @nodoc


class _MonthlyReport extends MonthlyReport {
  const _MonthlyReport({required this.period, this.totalIncome = 0, this.totalExpenses = 0, this.rentExpected = 0, this.rentCollected = 0, final  List<ExpenseCategory> topExpenses = const [], final  List<OverdueItem> overdueItems = const [], this.mainGroundIncome = 0, this.mainGroundExpenses = 0, this.minorGroundIncome = 0, this.minorGroundExpenses = 0, this.electricityUnits = 0, this.electricityEstimatedCost = 0, this.waterBillTotal = 0, this.waterContributionsCollected = 0, this.waterSurplusDeficit = 0}): _topExpenses = topExpenses,_overdueItems = overdueItems,super._();
  

@override final  String period;
// "2026-03" format
@override@JsonKey() final  double totalIncome;
@override@JsonKey() final  double totalExpenses;
@override@JsonKey() final  double rentExpected;
@override@JsonKey() final  double rentCollected;
 final  List<ExpenseCategory> _topExpenses;
@override@JsonKey() List<ExpenseCategory> get topExpenses {
  if (_topExpenses is EqualUnmodifiableListView) return _topExpenses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topExpenses);
}

 final  List<OverdueItem> _overdueItems;
@override@JsonKey() List<OverdueItem> get overdueItems {
  if (_overdueItems is EqualUnmodifiableListView) return _overdueItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_overdueItems);
}

@override@JsonKey() final  double mainGroundIncome;
@override@JsonKey() final  double mainGroundExpenses;
@override@JsonKey() final  double minorGroundIncome;
@override@JsonKey() final  double minorGroundExpenses;
@override@JsonKey() final  double electricityUnits;
@override@JsonKey() final  double electricityEstimatedCost;
@override@JsonKey() final  double waterBillTotal;
@override@JsonKey() final  double waterContributionsCollected;
@override@JsonKey() final  double waterSurplusDeficit;

/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyReportCopyWith<_MonthlyReport> get copyWith => __$MonthlyReportCopyWithImpl<_MonthlyReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyReport&&(identical(other.period, period) || other.period == period)&&(identical(other.totalIncome, totalIncome) || other.totalIncome == totalIncome)&&(identical(other.totalExpenses, totalExpenses) || other.totalExpenses == totalExpenses)&&(identical(other.rentExpected, rentExpected) || other.rentExpected == rentExpected)&&(identical(other.rentCollected, rentCollected) || other.rentCollected == rentCollected)&&const DeepCollectionEquality().equals(other._topExpenses, _topExpenses)&&const DeepCollectionEquality().equals(other._overdueItems, _overdueItems)&&(identical(other.mainGroundIncome, mainGroundIncome) || other.mainGroundIncome == mainGroundIncome)&&(identical(other.mainGroundExpenses, mainGroundExpenses) || other.mainGroundExpenses == mainGroundExpenses)&&(identical(other.minorGroundIncome, minorGroundIncome) || other.minorGroundIncome == minorGroundIncome)&&(identical(other.minorGroundExpenses, minorGroundExpenses) || other.minorGroundExpenses == minorGroundExpenses)&&(identical(other.electricityUnits, electricityUnits) || other.electricityUnits == electricityUnits)&&(identical(other.electricityEstimatedCost, electricityEstimatedCost) || other.electricityEstimatedCost == electricityEstimatedCost)&&(identical(other.waterBillTotal, waterBillTotal) || other.waterBillTotal == waterBillTotal)&&(identical(other.waterContributionsCollected, waterContributionsCollected) || other.waterContributionsCollected == waterContributionsCollected)&&(identical(other.waterSurplusDeficit, waterSurplusDeficit) || other.waterSurplusDeficit == waterSurplusDeficit));
}


@override
int get hashCode => Object.hash(runtimeType,period,totalIncome,totalExpenses,rentExpected,rentCollected,const DeepCollectionEquality().hash(_topExpenses),const DeepCollectionEquality().hash(_overdueItems),mainGroundIncome,mainGroundExpenses,minorGroundIncome,minorGroundExpenses,electricityUnits,electricityEstimatedCost,waterBillTotal,waterContributionsCollected,waterSurplusDeficit);

@override
String toString() {
  return 'MonthlyReport(period: $period, totalIncome: $totalIncome, totalExpenses: $totalExpenses, rentExpected: $rentExpected, rentCollected: $rentCollected, topExpenses: $topExpenses, overdueItems: $overdueItems, mainGroundIncome: $mainGroundIncome, mainGroundExpenses: $mainGroundExpenses, minorGroundIncome: $minorGroundIncome, minorGroundExpenses: $minorGroundExpenses, electricityUnits: $electricityUnits, electricityEstimatedCost: $electricityEstimatedCost, waterBillTotal: $waterBillTotal, waterContributionsCollected: $waterContributionsCollected, waterSurplusDeficit: $waterSurplusDeficit)';
}


}

/// @nodoc
abstract mixin class _$MonthlyReportCopyWith<$Res> implements $MonthlyReportCopyWith<$Res> {
  factory _$MonthlyReportCopyWith(_MonthlyReport value, $Res Function(_MonthlyReport) _then) = __$MonthlyReportCopyWithImpl;
@override @useResult
$Res call({
 String period, double totalIncome, double totalExpenses, double rentExpected, double rentCollected, List<ExpenseCategory> topExpenses, List<OverdueItem> overdueItems, double mainGroundIncome, double mainGroundExpenses, double minorGroundIncome, double minorGroundExpenses, double electricityUnits, double electricityEstimatedCost, double waterBillTotal, double waterContributionsCollected, double waterSurplusDeficit
});




}
/// @nodoc
class __$MonthlyReportCopyWithImpl<$Res>
    implements _$MonthlyReportCopyWith<$Res> {
  __$MonthlyReportCopyWithImpl(this._self, this._then);

  final _MonthlyReport _self;
  final $Res Function(_MonthlyReport) _then;

/// Create a copy of MonthlyReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? period = null,Object? totalIncome = null,Object? totalExpenses = null,Object? rentExpected = null,Object? rentCollected = null,Object? topExpenses = null,Object? overdueItems = null,Object? mainGroundIncome = null,Object? mainGroundExpenses = null,Object? minorGroundIncome = null,Object? minorGroundExpenses = null,Object? electricityUnits = null,Object? electricityEstimatedCost = null,Object? waterBillTotal = null,Object? waterContributionsCollected = null,Object? waterSurplusDeficit = null,}) {
  return _then(_MonthlyReport(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,totalIncome: null == totalIncome ? _self.totalIncome : totalIncome // ignore: cast_nullable_to_non_nullable
as double,totalExpenses: null == totalExpenses ? _self.totalExpenses : totalExpenses // ignore: cast_nullable_to_non_nullable
as double,rentExpected: null == rentExpected ? _self.rentExpected : rentExpected // ignore: cast_nullable_to_non_nullable
as double,rentCollected: null == rentCollected ? _self.rentCollected : rentCollected // ignore: cast_nullable_to_non_nullable
as double,topExpenses: null == topExpenses ? _self._topExpenses : topExpenses // ignore: cast_nullable_to_non_nullable
as List<ExpenseCategory>,overdueItems: null == overdueItems ? _self._overdueItems : overdueItems // ignore: cast_nullable_to_non_nullable
as List<OverdueItem>,mainGroundIncome: null == mainGroundIncome ? _self.mainGroundIncome : mainGroundIncome // ignore: cast_nullable_to_non_nullable
as double,mainGroundExpenses: null == mainGroundExpenses ? _self.mainGroundExpenses : mainGroundExpenses // ignore: cast_nullable_to_non_nullable
as double,minorGroundIncome: null == minorGroundIncome ? _self.minorGroundIncome : minorGroundIncome // ignore: cast_nullable_to_non_nullable
as double,minorGroundExpenses: null == minorGroundExpenses ? _self.minorGroundExpenses : minorGroundExpenses // ignore: cast_nullable_to_non_nullable
as double,electricityUnits: null == electricityUnits ? _self.electricityUnits : electricityUnits // ignore: cast_nullable_to_non_nullable
as double,electricityEstimatedCost: null == electricityEstimatedCost ? _self.electricityEstimatedCost : electricityEstimatedCost // ignore: cast_nullable_to_non_nullable
as double,waterBillTotal: null == waterBillTotal ? _self.waterBillTotal : waterBillTotal // ignore: cast_nullable_to_non_nullable
as double,waterContributionsCollected: null == waterContributionsCollected ? _self.waterContributionsCollected : waterContributionsCollected // ignore: cast_nullable_to_non_nullable
as double,waterSurplusDeficit: null == waterSurplusDeficit ? _self.waterSurplusDeficit : waterSurplusDeficit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$ExpenseCategory {

 String get name; double get amount;
/// Create a copy of ExpenseCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseCategoryCopyWith<ExpenseCategory> get copyWith => _$ExpenseCategoryCopyWithImpl<ExpenseCategory>(this as ExpenseCategory, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseCategory&&(identical(other.name, name) || other.name == name)&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,name,amount);

@override
String toString() {
  return 'ExpenseCategory(name: $name, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $ExpenseCategoryCopyWith<$Res>  {
  factory $ExpenseCategoryCopyWith(ExpenseCategory value, $Res Function(ExpenseCategory) _then) = _$ExpenseCategoryCopyWithImpl;
@useResult
$Res call({
 String name, double amount
});




}
/// @nodoc
class _$ExpenseCategoryCopyWithImpl<$Res>
    implements $ExpenseCategoryCopyWith<$Res> {
  _$ExpenseCategoryCopyWithImpl(this._self, this._then);

  final ExpenseCategory _self;
  final $Res Function(ExpenseCategory) _then;

/// Create a copy of ExpenseCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? amount = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpenseCategory].
extension ExpenseCategoryPatterns on ExpenseCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseCategory value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseCategory value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  double amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseCategory() when $default != null:
return $default(_that.name,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  double amount)  $default,) {final _that = this;
switch (_that) {
case _ExpenseCategory():
return $default(_that.name,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  double amount)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseCategory() when $default != null:
return $default(_that.name,_that.amount);case _:
  return null;

}
}

}

/// @nodoc


class _ExpenseCategory implements ExpenseCategory {
  const _ExpenseCategory({required this.name, required this.amount});
  

@override final  String name;
@override final  double amount;

/// Create a copy of ExpenseCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseCategoryCopyWith<_ExpenseCategory> get copyWith => __$ExpenseCategoryCopyWithImpl<_ExpenseCategory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseCategory&&(identical(other.name, name) || other.name == name)&&(identical(other.amount, amount) || other.amount == amount));
}


@override
int get hashCode => Object.hash(runtimeType,name,amount);

@override
String toString() {
  return 'ExpenseCategory(name: $name, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$ExpenseCategoryCopyWith<$Res> implements $ExpenseCategoryCopyWith<$Res> {
  factory _$ExpenseCategoryCopyWith(_ExpenseCategory value, $Res Function(_ExpenseCategory) _then) = __$ExpenseCategoryCopyWithImpl;
@override @useResult
$Res call({
 String name, double amount
});




}
/// @nodoc
class __$ExpenseCategoryCopyWithImpl<$Res>
    implements _$ExpenseCategoryCopyWith<$Res> {
  __$ExpenseCategoryCopyWithImpl(this._self, this._then);

  final _ExpenseCategory _self;
  final $Res Function(_ExpenseCategory) _then;

/// Create a copy of ExpenseCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? amount = null,}) {
  return _then(_ExpenseCategory(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$OverdueItem {

 String get title; String get module; int get daysOverdue;
/// Create a copy of OverdueItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OverdueItemCopyWith<OverdueItem> get copyWith => _$OverdueItemCopyWithImpl<OverdueItem>(this as OverdueItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OverdueItem&&(identical(other.title, title) || other.title == title)&&(identical(other.module, module) || other.module == module)&&(identical(other.daysOverdue, daysOverdue) || other.daysOverdue == daysOverdue));
}


@override
int get hashCode => Object.hash(runtimeType,title,module,daysOverdue);

@override
String toString() {
  return 'OverdueItem(title: $title, module: $module, daysOverdue: $daysOverdue)';
}


}

/// @nodoc
abstract mixin class $OverdueItemCopyWith<$Res>  {
  factory $OverdueItemCopyWith(OverdueItem value, $Res Function(OverdueItem) _then) = _$OverdueItemCopyWithImpl;
@useResult
$Res call({
 String title, String module, int daysOverdue
});




}
/// @nodoc
class _$OverdueItemCopyWithImpl<$Res>
    implements $OverdueItemCopyWith<$Res> {
  _$OverdueItemCopyWithImpl(this._self, this._then);

  final OverdueItem _self;
  final $Res Function(OverdueItem) _then;

/// Create a copy of OverdueItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? module = null,Object? daysOverdue = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as String,daysOverdue: null == daysOverdue ? _self.daysOverdue : daysOverdue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OverdueItem].
extension OverdueItemPatterns on OverdueItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OverdueItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OverdueItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OverdueItem value)  $default,){
final _that = this;
switch (_that) {
case _OverdueItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OverdueItem value)?  $default,){
final _that = this;
switch (_that) {
case _OverdueItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String module,  int daysOverdue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OverdueItem() when $default != null:
return $default(_that.title,_that.module,_that.daysOverdue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String module,  int daysOverdue)  $default,) {final _that = this;
switch (_that) {
case _OverdueItem():
return $default(_that.title,_that.module,_that.daysOverdue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String module,  int daysOverdue)?  $default,) {final _that = this;
switch (_that) {
case _OverdueItem() when $default != null:
return $default(_that.title,_that.module,_that.daysOverdue);case _:
  return null;

}
}

}

/// @nodoc


class _OverdueItem implements OverdueItem {
  const _OverdueItem({required this.title, required this.module, required this.daysOverdue});
  

@override final  String title;
@override final  String module;
@override final  int daysOverdue;

/// Create a copy of OverdueItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OverdueItemCopyWith<_OverdueItem> get copyWith => __$OverdueItemCopyWithImpl<_OverdueItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OverdueItem&&(identical(other.title, title) || other.title == title)&&(identical(other.module, module) || other.module == module)&&(identical(other.daysOverdue, daysOverdue) || other.daysOverdue == daysOverdue));
}


@override
int get hashCode => Object.hash(runtimeType,title,module,daysOverdue);

@override
String toString() {
  return 'OverdueItem(title: $title, module: $module, daysOverdue: $daysOverdue)';
}


}

/// @nodoc
abstract mixin class _$OverdueItemCopyWith<$Res> implements $OverdueItemCopyWith<$Res> {
  factory _$OverdueItemCopyWith(_OverdueItem value, $Res Function(_OverdueItem) _then) = __$OverdueItemCopyWithImpl;
@override @useResult
$Res call({
 String title, String module, int daysOverdue
});




}
/// @nodoc
class __$OverdueItemCopyWithImpl<$Res>
    implements _$OverdueItemCopyWith<$Res> {
  __$OverdueItemCopyWithImpl(this._self, this._then);

  final _OverdueItem _self;
  final $Res Function(_OverdueItem) _then;

/// Create a copy of OverdueItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? module = null,Object? daysOverdue = null,}) {
  return _then(_OverdueItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as String,daysOverdue: null == daysOverdue ? _self.daysOverdue : daysOverdue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
