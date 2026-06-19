// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'income.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Income {

 String get id; String get source;// "rent", "freelance", "business", "bodaboda"...
 String get description;// "Rent from John — Room 3"
 double get amount; DateTime get date; String? get groundId;// associated ground (null for non-property income)
 String? get linkedTenantId;// set when source is rent
 String? get linkedRentRecordId;// set when source is rent
 bool get isAutoLinked;// true if created from a rent payment
 String get notes; DateTime get createdAt; DateTime get updatedAt; String get updatedBy; int get schemaVersion;
/// Create a copy of Income
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IncomeCopyWith<Income> get copyWith => _$IncomeCopyWithImpl<Income>(this as Income, _$identity);

  /// Serializes this Income to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Income&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.groundId, groundId) || other.groundId == groundId)&&(identical(other.linkedTenantId, linkedTenantId) || other.linkedTenantId == linkedTenantId)&&(identical(other.linkedRentRecordId, linkedRentRecordId) || other.linkedRentRecordId == linkedRentRecordId)&&(identical(other.isAutoLinked, isAutoLinked) || other.isAutoLinked == isAutoLinked)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,source,description,amount,date,groundId,linkedTenantId,linkedRentRecordId,isAutoLinked,notes,createdAt,updatedAt,updatedBy,schemaVersion);

@override
String toString() {
  return 'Income(id: $id, source: $source, description: $description, amount: $amount, date: $date, groundId: $groundId, linkedTenantId: $linkedTenantId, linkedRentRecordId: $linkedRentRecordId, isAutoLinked: $isAutoLinked, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class $IncomeCopyWith<$Res>  {
  factory $IncomeCopyWith(Income value, $Res Function(Income) _then) = _$IncomeCopyWithImpl;
@useResult
$Res call({
 String id, String source, String description, double amount, DateTime date, String? groundId, String? linkedTenantId, String? linkedRentRecordId, bool isAutoLinked, String notes, DateTime createdAt, DateTime updatedAt, String updatedBy, int schemaVersion
});




}
/// @nodoc
class _$IncomeCopyWithImpl<$Res>
    implements $IncomeCopyWith<$Res> {
  _$IncomeCopyWithImpl(this._self, this._then);

  final Income _self;
  final $Res Function(Income) _then;

/// Create a copy of Income
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? source = null,Object? description = null,Object? amount = null,Object? date = null,Object? groundId = freezed,Object? linkedTenantId = freezed,Object? linkedRentRecordId = freezed,Object? isAutoLinked = null,Object? notes = null,Object? createdAt = null,Object? updatedAt = null,Object? updatedBy = null,Object? schemaVersion = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,groundId: freezed == groundId ? _self.groundId : groundId // ignore: cast_nullable_to_non_nullable
as String?,linkedTenantId: freezed == linkedTenantId ? _self.linkedTenantId : linkedTenantId // ignore: cast_nullable_to_non_nullable
as String?,linkedRentRecordId: freezed == linkedRentRecordId ? _self.linkedRentRecordId : linkedRentRecordId // ignore: cast_nullable_to_non_nullable
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


/// Adds pattern-matching-related methods to [Income].
extension IncomePatterns on Income {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Income value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Income() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Income value)  $default,){
final _that = this;
switch (_that) {
case _Income():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Income value)?  $default,){
final _that = this;
switch (_that) {
case _Income() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String source,  String description,  double amount,  DateTime date,  String? groundId,  String? linkedTenantId,  String? linkedRentRecordId,  bool isAutoLinked,  String notes,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Income() when $default != null:
return $default(_that.id,_that.source,_that.description,_that.amount,_that.date,_that.groundId,_that.linkedTenantId,_that.linkedRentRecordId,_that.isAutoLinked,_that.notes,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String source,  String description,  double amount,  DateTime date,  String? groundId,  String? linkedTenantId,  String? linkedRentRecordId,  bool isAutoLinked,  String notes,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)  $default,) {final _that = this;
switch (_that) {
case _Income():
return $default(_that.id,_that.source,_that.description,_that.amount,_that.date,_that.groundId,_that.linkedTenantId,_that.linkedRentRecordId,_that.isAutoLinked,_that.notes,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String source,  String description,  double amount,  DateTime date,  String? groundId,  String? linkedTenantId,  String? linkedRentRecordId,  bool isAutoLinked,  String notes,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)?  $default,) {final _that = this;
switch (_that) {
case _Income() when $default != null:
return $default(_that.id,_that.source,_that.description,_that.amount,_that.date,_that.groundId,_that.linkedTenantId,_that.linkedRentRecordId,_that.isAutoLinked,_that.notes,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Income extends Income {
  const _Income({required this.id, required this.source, required this.description, required this.amount, required this.date, this.groundId, this.linkedTenantId, this.linkedRentRecordId, this.isAutoLinked = false, this.notes = '', required this.createdAt, required this.updatedAt, required this.updatedBy, this.schemaVersion = 1}): super._();
  factory _Income.fromJson(Map<String, dynamic> json) => _$IncomeFromJson(json);

@override final  String id;
@override final  String source;
// "rent", "freelance", "business", "bodaboda"...
@override final  String description;
// "Rent from John — Room 3"
@override final  double amount;
@override final  DateTime date;
@override final  String? groundId;
// associated ground (null for non-property income)
@override final  String? linkedTenantId;
// set when source is rent
@override final  String? linkedRentRecordId;
// set when source is rent
@override@JsonKey() final  bool isAutoLinked;
// true if created from a rent payment
@override@JsonKey() final  String notes;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String updatedBy;
@override@JsonKey() final  int schemaVersion;

/// Create a copy of Income
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IncomeCopyWith<_Income> get copyWith => __$IncomeCopyWithImpl<_Income>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IncomeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Income&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.groundId, groundId) || other.groundId == groundId)&&(identical(other.linkedTenantId, linkedTenantId) || other.linkedTenantId == linkedTenantId)&&(identical(other.linkedRentRecordId, linkedRentRecordId) || other.linkedRentRecordId == linkedRentRecordId)&&(identical(other.isAutoLinked, isAutoLinked) || other.isAutoLinked == isAutoLinked)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,source,description,amount,date,groundId,linkedTenantId,linkedRentRecordId,isAutoLinked,notes,createdAt,updatedAt,updatedBy,schemaVersion);

@override
String toString() {
  return 'Income(id: $id, source: $source, description: $description, amount: $amount, date: $date, groundId: $groundId, linkedTenantId: $linkedTenantId, linkedRentRecordId: $linkedRentRecordId, isAutoLinked: $isAutoLinked, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class _$IncomeCopyWith<$Res> implements $IncomeCopyWith<$Res> {
  factory _$IncomeCopyWith(_Income value, $Res Function(_Income) _then) = __$IncomeCopyWithImpl;
@override @useResult
$Res call({
 String id, String source, String description, double amount, DateTime date, String? groundId, String? linkedTenantId, String? linkedRentRecordId, bool isAutoLinked, String notes, DateTime createdAt, DateTime updatedAt, String updatedBy, int schemaVersion
});




}
/// @nodoc
class __$IncomeCopyWithImpl<$Res>
    implements _$IncomeCopyWith<$Res> {
  __$IncomeCopyWithImpl(this._self, this._then);

  final _Income _self;
  final $Res Function(_Income) _then;

/// Create a copy of Income
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? source = null,Object? description = null,Object? amount = null,Object? date = null,Object? groundId = freezed,Object? linkedTenantId = freezed,Object? linkedRentRecordId = freezed,Object? isAutoLinked = null,Object? notes = null,Object? createdAt = null,Object? updatedAt = null,Object? updatedBy = null,Object? schemaVersion = null,}) {
  return _then(_Income(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,groundId: freezed == groundId ? _self.groundId : groundId // ignore: cast_nullable_to_non_nullable
as String?,linkedTenantId: freezed == linkedTenantId ? _self.linkedTenantId : linkedTenantId // ignore: cast_nullable_to_non_nullable
as String?,linkedRentRecordId: freezed == linkedRentRecordId ? _self.linkedRentRecordId : linkedRentRecordId // ignore: cast_nullable_to_non_nullable
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
