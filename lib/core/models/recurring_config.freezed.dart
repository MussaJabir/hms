// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecurringConfig {

 String get id; String get type;// "rent", "water_contribution", "school_fee", "transport_fee", "budget_reset"
 String get collectionPath;// where to write generated records
 String get linkedEntityId;// tenant ID, child ID, or budget category ID
 String get linkedEntityName;// human-readable: "Room 3 - John", "Ahmad - School Fees"
 double get amount;// recurring amount in TZS
 String get frequency;// "monthly" or "termly"
 int get dayOfMonth;// day of month to generate (1-28)
 bool get isActive;// deactivated when tenant moves out
 DateTime get createdAt; DateTime get updatedAt; String get updatedBy; int get schemaVersion;
/// Create a copy of RecurringConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringConfigCopyWith<RecurringConfig> get copyWith => _$RecurringConfigCopyWithImpl<RecurringConfig>(this as RecurringConfig, _$identity);

  /// Serializes this RecurringConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.collectionPath, collectionPath) || other.collectionPath == collectionPath)&&(identical(other.linkedEntityId, linkedEntityId) || other.linkedEntityId == linkedEntityId)&&(identical(other.linkedEntityName, linkedEntityName) || other.linkedEntityName == linkedEntityName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.dayOfMonth, dayOfMonth) || other.dayOfMonth == dayOfMonth)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,collectionPath,linkedEntityId,linkedEntityName,amount,frequency,dayOfMonth,isActive,createdAt,updatedAt,updatedBy,schemaVersion);

@override
String toString() {
  return 'RecurringConfig(id: $id, type: $type, collectionPath: $collectionPath, linkedEntityId: $linkedEntityId, linkedEntityName: $linkedEntityName, amount: $amount, frequency: $frequency, dayOfMonth: $dayOfMonth, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class $RecurringConfigCopyWith<$Res>  {
  factory $RecurringConfigCopyWith(RecurringConfig value, $Res Function(RecurringConfig) _then) = _$RecurringConfigCopyWithImpl;
@useResult
$Res call({
 String id, String type, String collectionPath, String linkedEntityId, String linkedEntityName, double amount, String frequency, int dayOfMonth, bool isActive, DateTime createdAt, DateTime updatedAt, String updatedBy, int schemaVersion
});




}
/// @nodoc
class _$RecurringConfigCopyWithImpl<$Res>
    implements $RecurringConfigCopyWith<$Res> {
  _$RecurringConfigCopyWithImpl(this._self, this._then);

  final RecurringConfig _self;
  final $Res Function(RecurringConfig) _then;

/// Create a copy of RecurringConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? collectionPath = null,Object? linkedEntityId = null,Object? linkedEntityName = null,Object? amount = null,Object? frequency = null,Object? dayOfMonth = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,Object? updatedBy = null,Object? schemaVersion = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,collectionPath: null == collectionPath ? _self.collectionPath : collectionPath // ignore: cast_nullable_to_non_nullable
as String,linkedEntityId: null == linkedEntityId ? _self.linkedEntityId : linkedEntityId // ignore: cast_nullable_to_non_nullable
as String,linkedEntityName: null == linkedEntityName ? _self.linkedEntityName : linkedEntityName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as String,dayOfMonth: null == dayOfMonth ? _self.dayOfMonth : dayOfMonth // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RecurringConfig].
extension RecurringConfigPatterns on RecurringConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringConfig value)  $default,){
final _that = this;
switch (_that) {
case _RecurringConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringConfig value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String collectionPath,  String linkedEntityId,  String linkedEntityName,  double amount,  String frequency,  int dayOfMonth,  bool isActive,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurringConfig() when $default != null:
return $default(_that.id,_that.type,_that.collectionPath,_that.linkedEntityId,_that.linkedEntityName,_that.amount,_that.frequency,_that.dayOfMonth,_that.isActive,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String collectionPath,  String linkedEntityId,  String linkedEntityName,  double amount,  String frequency,  int dayOfMonth,  bool isActive,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)  $default,) {final _that = this;
switch (_that) {
case _RecurringConfig():
return $default(_that.id,_that.type,_that.collectionPath,_that.linkedEntityId,_that.linkedEntityName,_that.amount,_that.frequency,_that.dayOfMonth,_that.isActive,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String collectionPath,  String linkedEntityId,  String linkedEntityName,  double amount,  String frequency,  int dayOfMonth,  bool isActive,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)?  $default,) {final _that = this;
switch (_that) {
case _RecurringConfig() when $default != null:
return $default(_that.id,_that.type,_that.collectionPath,_that.linkedEntityId,_that.linkedEntityName,_that.amount,_that.frequency,_that.dayOfMonth,_that.isActive,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecurringConfig implements RecurringConfig {
  const _RecurringConfig({required this.id, required this.type, required this.collectionPath, required this.linkedEntityId, required this.linkedEntityName, required this.amount, required this.frequency, this.dayOfMonth = 1, this.isActive = true, required this.createdAt, required this.updatedAt, required this.updatedBy, this.schemaVersion = 1});
  factory _RecurringConfig.fromJson(Map<String, dynamic> json) => _$RecurringConfigFromJson(json);

@override final  String id;
@override final  String type;
// "rent", "water_contribution", "school_fee", "transport_fee", "budget_reset"
@override final  String collectionPath;
// where to write generated records
@override final  String linkedEntityId;
// tenant ID, child ID, or budget category ID
@override final  String linkedEntityName;
// human-readable: "Room 3 - John", "Ahmad - School Fees"
@override final  double amount;
// recurring amount in TZS
@override final  String frequency;
// "monthly" or "termly"
@override@JsonKey() final  int dayOfMonth;
// day of month to generate (1-28)
@override@JsonKey() final  bool isActive;
// deactivated when tenant moves out
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String updatedBy;
@override@JsonKey() final  int schemaVersion;

/// Create a copy of RecurringConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringConfigCopyWith<_RecurringConfig> get copyWith => __$RecurringConfigCopyWithImpl<_RecurringConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecurringConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.collectionPath, collectionPath) || other.collectionPath == collectionPath)&&(identical(other.linkedEntityId, linkedEntityId) || other.linkedEntityId == linkedEntityId)&&(identical(other.linkedEntityName, linkedEntityName) || other.linkedEntityName == linkedEntityName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.dayOfMonth, dayOfMonth) || other.dayOfMonth == dayOfMonth)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,collectionPath,linkedEntityId,linkedEntityName,amount,frequency,dayOfMonth,isActive,createdAt,updatedAt,updatedBy,schemaVersion);

@override
String toString() {
  return 'RecurringConfig(id: $id, type: $type, collectionPath: $collectionPath, linkedEntityId: $linkedEntityId, linkedEntityName: $linkedEntityName, amount: $amount, frequency: $frequency, dayOfMonth: $dayOfMonth, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class _$RecurringConfigCopyWith<$Res> implements $RecurringConfigCopyWith<$Res> {
  factory _$RecurringConfigCopyWith(_RecurringConfig value, $Res Function(_RecurringConfig) _then) = __$RecurringConfigCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String collectionPath, String linkedEntityId, String linkedEntityName, double amount, String frequency, int dayOfMonth, bool isActive, DateTime createdAt, DateTime updatedAt, String updatedBy, int schemaVersion
});




}
/// @nodoc
class __$RecurringConfigCopyWithImpl<$Res>
    implements _$RecurringConfigCopyWith<$Res> {
  __$RecurringConfigCopyWithImpl(this._self, this._then);

  final _RecurringConfig _self;
  final $Res Function(_RecurringConfig) _then;

/// Create a copy of RecurringConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? collectionPath = null,Object? linkedEntityId = null,Object? linkedEntityName = null,Object? amount = null,Object? frequency = null,Object? dayOfMonth = null,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,Object? updatedBy = null,Object? schemaVersion = null,}) {
  return _then(_RecurringConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,collectionPath: null == collectionPath ? _self.collectionPath : collectionPath // ignore: cast_nullable_to_non_nullable
as String,linkedEntityId: null == linkedEntityId ? _self.linkedEntityId : linkedEntityId // ignore: cast_nullable_to_non_nullable
as String,linkedEntityName: null == linkedEntityName ? _self.linkedEntityName : linkedEntityName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as String,dayOfMonth: null == dayOfMonth ? _self.dayOfMonth : dayOfMonth // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
