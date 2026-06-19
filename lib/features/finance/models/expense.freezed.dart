// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Expense {

 String get id; String get category;// from ExpenseCategory enum value
 String get description;// "Plumber fixed kitchen sink"
 double get amount; DateTime get date; String? get groundId;// which ground if property-related (null = household)
 String? get module;// "rent"/"electricity"/"water"/"inventory"/"children"
 String? get linkedDocumentId;// if auto-linked from another module
 bool get isAutoLinked;// true if created by another module
 String get notes; DateTime get createdAt; DateTime get updatedAt; String get updatedBy; int get schemaVersion;
/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseCopyWith<Expense> get copyWith => _$ExpenseCopyWithImpl<Expense>(this as Expense, _$identity);

  /// Serializes this Expense to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Expense&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.groundId, groundId) || other.groundId == groundId)&&(identical(other.module, module) || other.module == module)&&(identical(other.linkedDocumentId, linkedDocumentId) || other.linkedDocumentId == linkedDocumentId)&&(identical(other.isAutoLinked, isAutoLinked) || other.isAutoLinked == isAutoLinked)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,description,amount,date,groundId,module,linkedDocumentId,isAutoLinked,notes,createdAt,updatedAt,updatedBy,schemaVersion);

@override
String toString() {
  return 'Expense(id: $id, category: $category, description: $description, amount: $amount, date: $date, groundId: $groundId, module: $module, linkedDocumentId: $linkedDocumentId, isAutoLinked: $isAutoLinked, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class $ExpenseCopyWith<$Res>  {
  factory $ExpenseCopyWith(Expense value, $Res Function(Expense) _then) = _$ExpenseCopyWithImpl;
@useResult
$Res call({
 String id, String category, String description, double amount, DateTime date, String? groundId, String? module, String? linkedDocumentId, bool isAutoLinked, String notes, DateTime createdAt, DateTime updatedAt, String updatedBy, int schemaVersion
});




}
/// @nodoc
class _$ExpenseCopyWithImpl<$Res>
    implements $ExpenseCopyWith<$Res> {
  _$ExpenseCopyWithImpl(this._self, this._then);

  final Expense _self;
  final $Res Function(Expense) _then;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? category = null,Object? description = null,Object? amount = null,Object? date = null,Object? groundId = freezed,Object? module = freezed,Object? linkedDocumentId = freezed,Object? isAutoLinked = null,Object? notes = null,Object? createdAt = null,Object? updatedAt = null,Object? updatedBy = null,Object? schemaVersion = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,groundId: freezed == groundId ? _self.groundId : groundId // ignore: cast_nullable_to_non_nullable
as String?,module: freezed == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as String?,linkedDocumentId: freezed == linkedDocumentId ? _self.linkedDocumentId : linkedDocumentId // ignore: cast_nullable_to_non_nullable
as String?,isAutoLinked: null == isAutoLinked ? _self.isAutoLinked : isAutoLinked // ignore: cast_nullable_to_non_nullable
as bool,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Expense].
extension ExpensePatterns on Expense {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Expense value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Expense() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Expense value)  $default,){
final _that = this;
switch (_that) {
case _Expense():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Expense value)?  $default,){
final _that = this;
switch (_that) {
case _Expense() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String category,  String description,  double amount,  DateTime date,  String? groundId,  String? module,  String? linkedDocumentId,  bool isAutoLinked,  String notes,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that.id,_that.category,_that.description,_that.amount,_that.date,_that.groundId,_that.module,_that.linkedDocumentId,_that.isAutoLinked,_that.notes,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String category,  String description,  double amount,  DateTime date,  String? groundId,  String? module,  String? linkedDocumentId,  bool isAutoLinked,  String notes,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)  $default,) {final _that = this;
switch (_that) {
case _Expense():
return $default(_that.id,_that.category,_that.description,_that.amount,_that.date,_that.groundId,_that.module,_that.linkedDocumentId,_that.isAutoLinked,_that.notes,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String category,  String description,  double amount,  DateTime date,  String? groundId,  String? module,  String? linkedDocumentId,  bool isAutoLinked,  String notes,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)?  $default,) {final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that.id,_that.category,_that.description,_that.amount,_that.date,_that.groundId,_that.module,_that.linkedDocumentId,_that.isAutoLinked,_that.notes,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Expense extends Expense {
  const _Expense({required this.id, required this.category, required this.description, required this.amount, required this.date, this.groundId, this.module, this.linkedDocumentId, this.isAutoLinked = false, this.notes = '', required this.createdAt, required this.updatedAt, required this.updatedBy, this.schemaVersion = 1}): super._();
  factory _Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);

@override final  String id;
@override final  String category;
// from ExpenseCategory enum value
@override final  String description;
// "Plumber fixed kitchen sink"
@override final  double amount;
@override final  DateTime date;
@override final  String? groundId;
// which ground if property-related (null = household)
@override final  String? module;
// "rent"/"electricity"/"water"/"inventory"/"children"
@override final  String? linkedDocumentId;
// if auto-linked from another module
@override@JsonKey() final  bool isAutoLinked;
// true if created by another module
@override@JsonKey() final  String notes;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String updatedBy;
@override@JsonKey() final  int schemaVersion;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseCopyWith<_Expense> get copyWith => __$ExpenseCopyWithImpl<_Expense>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Expense&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.groundId, groundId) || other.groundId == groundId)&&(identical(other.module, module) || other.module == module)&&(identical(other.linkedDocumentId, linkedDocumentId) || other.linkedDocumentId == linkedDocumentId)&&(identical(other.isAutoLinked, isAutoLinked) || other.isAutoLinked == isAutoLinked)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,description,amount,date,groundId,module,linkedDocumentId,isAutoLinked,notes,createdAt,updatedAt,updatedBy,schemaVersion);

@override
String toString() {
  return 'Expense(id: $id, category: $category, description: $description, amount: $amount, date: $date, groundId: $groundId, module: $module, linkedDocumentId: $linkedDocumentId, isAutoLinked: $isAutoLinked, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class _$ExpenseCopyWith<$Res> implements $ExpenseCopyWith<$Res> {
  factory _$ExpenseCopyWith(_Expense value, $Res Function(_Expense) _then) = __$ExpenseCopyWithImpl;
@override @useResult
$Res call({
 String id, String category, String description, double amount, DateTime date, String? groundId, String? module, String? linkedDocumentId, bool isAutoLinked, String notes, DateTime createdAt, DateTime updatedAt, String updatedBy, int schemaVersion
});




}
/// @nodoc
class __$ExpenseCopyWithImpl<$Res>
    implements _$ExpenseCopyWith<$Res> {
  __$ExpenseCopyWithImpl(this._self, this._then);

  final _Expense _self;
  final $Res Function(_Expense) _then;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? category = null,Object? description = null,Object? amount = null,Object? date = null,Object? groundId = freezed,Object? module = freezed,Object? linkedDocumentId = freezed,Object? isAutoLinked = null,Object? notes = null,Object? createdAt = null,Object? updatedAt = null,Object? updatedBy = null,Object? schemaVersion = null,}) {
  return _then(_Expense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,groundId: freezed == groundId ? _self.groundId : groundId // ignore: cast_nullable_to_non_nullable
as String?,module: freezed == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as String?,linkedDocumentId: freezed == linkedDocumentId ? _self.linkedDocumentId : linkedDocumentId // ignore: cast_nullable_to_non_nullable
as String?,isAutoLinked: null == isAutoLinked ? _self.isAutoLinked : isAutoLinked // ignore: cast_nullable_to_non_nullable
as bool,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
