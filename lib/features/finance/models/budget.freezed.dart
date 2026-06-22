// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Budget {

 String get id; String get category;// matches ExpenseCategory value
 double get limitAmount;// monthly budget limit in TZS
 String get period;// "2026-03" format
 double get spentAmount;// current spend (calculated from expenses)
 DateTime get createdAt; DateTime get updatedAt; String get updatedBy; int get schemaVersion;
/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetCopyWith<Budget> get copyWith => _$BudgetCopyWithImpl<Budget>(this as Budget, _$identity);

  /// Serializes this Budget to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Budget&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.limitAmount, limitAmount) || other.limitAmount == limitAmount)&&(identical(other.period, period) || other.period == period)&&(identical(other.spentAmount, spentAmount) || other.spentAmount == spentAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,limitAmount,period,spentAmount,createdAt,updatedAt,updatedBy,schemaVersion);

@override
String toString() {
  return 'Budget(id: $id, category: $category, limitAmount: $limitAmount, period: $period, spentAmount: $spentAmount, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class $BudgetCopyWith<$Res>  {
  factory $BudgetCopyWith(Budget value, $Res Function(Budget) _then) = _$BudgetCopyWithImpl;
@useResult
$Res call({
 String id, String category, double limitAmount, String period, double spentAmount, DateTime createdAt, DateTime updatedAt, String updatedBy, int schemaVersion
});




}
/// @nodoc
class _$BudgetCopyWithImpl<$Res>
    implements $BudgetCopyWith<$Res> {
  _$BudgetCopyWithImpl(this._self, this._then);

  final Budget _self;
  final $Res Function(Budget) _then;

/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? category = null,Object? limitAmount = null,Object? period = null,Object? spentAmount = null,Object? createdAt = null,Object? updatedAt = null,Object? updatedBy = null,Object? schemaVersion = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,limitAmount: null == limitAmount ? _self.limitAmount : limitAmount // ignore: cast_nullable_to_non_nullable
as double,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,spentAmount: null == spentAmount ? _self.spentAmount : spentAmount // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Budget].
extension BudgetPatterns on Budget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Budget value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Budget() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Budget value)  $default,){
final _that = this;
switch (_that) {
case _Budget():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Budget value)?  $default,){
final _that = this;
switch (_that) {
case _Budget() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String category,  double limitAmount,  String period,  double spentAmount,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Budget() when $default != null:
return $default(_that.id,_that.category,_that.limitAmount,_that.period,_that.spentAmount,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String category,  double limitAmount,  String period,  double spentAmount,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)  $default,) {final _that = this;
switch (_that) {
case _Budget():
return $default(_that.id,_that.category,_that.limitAmount,_that.period,_that.spentAmount,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String category,  double limitAmount,  String period,  double spentAmount,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)?  $default,) {final _that = this;
switch (_that) {
case _Budget() when $default != null:
return $default(_that.id,_that.category,_that.limitAmount,_that.period,_that.spentAmount,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Budget extends Budget {
  const _Budget({required this.id, required this.category, required this.limitAmount, required this.period, this.spentAmount = 0, required this.createdAt, required this.updatedAt, required this.updatedBy, this.schemaVersion = 1}): super._();
  factory _Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);

@override final  String id;
@override final  String category;
// matches ExpenseCategory value
@override final  double limitAmount;
// monthly budget limit in TZS
@override final  String period;
// "2026-03" format
@override@JsonKey() final  double spentAmount;
// current spend (calculated from expenses)
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String updatedBy;
@override@JsonKey() final  int schemaVersion;

/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetCopyWith<_Budget> get copyWith => __$BudgetCopyWithImpl<_Budget>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BudgetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Budget&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.limitAmount, limitAmount) || other.limitAmount == limitAmount)&&(identical(other.period, period) || other.period == period)&&(identical(other.spentAmount, spentAmount) || other.spentAmount == spentAmount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,limitAmount,period,spentAmount,createdAt,updatedAt,updatedBy,schemaVersion);

@override
String toString() {
  return 'Budget(id: $id, category: $category, limitAmount: $limitAmount, period: $period, spentAmount: $spentAmount, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class _$BudgetCopyWith<$Res> implements $BudgetCopyWith<$Res> {
  factory _$BudgetCopyWith(_Budget value, $Res Function(_Budget) _then) = __$BudgetCopyWithImpl;
@override @useResult
$Res call({
 String id, String category, double limitAmount, String period, double spentAmount, DateTime createdAt, DateTime updatedAt, String updatedBy, int schemaVersion
});




}
/// @nodoc
class __$BudgetCopyWithImpl<$Res>
    implements _$BudgetCopyWith<$Res> {
  __$BudgetCopyWithImpl(this._self, this._then);

  final _Budget _self;
  final $Res Function(_Budget) _then;

/// Create a copy of Budget
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? category = null,Object? limitAmount = null,Object? period = null,Object? spentAmount = null,Object? createdAt = null,Object? updatedAt = null,Object? updatedBy = null,Object? schemaVersion = null,}) {
  return _then(_Budget(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,limitAmount: null == limitAmount ? _self.limitAmount : limitAmount // ignore: cast_nullable_to_non_nullable
as double,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,spentAmount: null == spentAmount ? _self.spentAmount : spentAmount // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
