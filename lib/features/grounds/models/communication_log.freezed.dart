// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'communication_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommunicationLog {

 String get id; String get tenantId; String get note; DateTime get createdAt; String get createdBy; int get schemaVersion;
/// Create a copy of CommunicationLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommunicationLogCopyWith<CommunicationLog> get copyWith => _$CommunicationLogCopyWithImpl<CommunicationLog>(this as CommunicationLog, _$identity);

  /// Serializes this CommunicationLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommunicationLog&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tenantId,note,createdAt,createdBy,schemaVersion);

@override
String toString() {
  return 'CommunicationLog(id: $id, tenantId: $tenantId, note: $note, createdAt: $createdAt, createdBy: $createdBy, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class $CommunicationLogCopyWith<$Res>  {
  factory $CommunicationLogCopyWith(CommunicationLog value, $Res Function(CommunicationLog) _then) = _$CommunicationLogCopyWithImpl;
@useResult
$Res call({
 String id, String tenantId, String note, DateTime createdAt, String createdBy, int schemaVersion
});




}
/// @nodoc
class _$CommunicationLogCopyWithImpl<$Res>
    implements $CommunicationLogCopyWith<$Res> {
  _$CommunicationLogCopyWithImpl(this._self, this._then);

  final CommunicationLog _self;
  final $Res Function(CommunicationLog) _then;

/// Create a copy of CommunicationLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tenantId = null,Object? note = null,Object? createdAt = null,Object? createdBy = null,Object? schemaVersion = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CommunicationLog].
extension CommunicationLogPatterns on CommunicationLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommunicationLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommunicationLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommunicationLog value)  $default,){
final _that = this;
switch (_that) {
case _CommunicationLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommunicationLog value)?  $default,){
final _that = this;
switch (_that) {
case _CommunicationLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String tenantId,  String note,  DateTime createdAt,  String createdBy,  int schemaVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommunicationLog() when $default != null:
return $default(_that.id,_that.tenantId,_that.note,_that.createdAt,_that.createdBy,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String tenantId,  String note,  DateTime createdAt,  String createdBy,  int schemaVersion)  $default,) {final _that = this;
switch (_that) {
case _CommunicationLog():
return $default(_that.id,_that.tenantId,_that.note,_that.createdAt,_that.createdBy,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String tenantId,  String note,  DateTime createdAt,  String createdBy,  int schemaVersion)?  $default,) {final _that = this;
switch (_that) {
case _CommunicationLog() when $default != null:
return $default(_that.id,_that.tenantId,_that.note,_that.createdAt,_that.createdBy,_that.schemaVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CommunicationLog implements CommunicationLog {
  const _CommunicationLog({required this.id, required this.tenantId, required this.note, required this.createdAt, required this.createdBy, this.schemaVersion = 1});
  factory _CommunicationLog.fromJson(Map<String, dynamic> json) => _$CommunicationLogFromJson(json);

@override final  String id;
@override final  String tenantId;
@override final  String note;
@override final  DateTime createdAt;
@override final  String createdBy;
@override@JsonKey() final  int schemaVersion;

/// Create a copy of CommunicationLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommunicationLogCopyWith<_CommunicationLog> get copyWith => __$CommunicationLogCopyWithImpl<_CommunicationLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CommunicationLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommunicationLog&&(identical(other.id, id) || other.id == id)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,tenantId,note,createdAt,createdBy,schemaVersion);

@override
String toString() {
  return 'CommunicationLog(id: $id, tenantId: $tenantId, note: $note, createdAt: $createdAt, createdBy: $createdBy, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class _$CommunicationLogCopyWith<$Res> implements $CommunicationLogCopyWith<$Res> {
  factory _$CommunicationLogCopyWith(_CommunicationLog value, $Res Function(_CommunicationLog) _then) = __$CommunicationLogCopyWithImpl;
@override @useResult
$Res call({
 String id, String tenantId, String note, DateTime createdAt, String createdBy, int schemaVersion
});




}
/// @nodoc
class __$CommunicationLogCopyWithImpl<$Res>
    implements _$CommunicationLogCopyWith<$Res> {
  __$CommunicationLogCopyWithImpl(this._self, this._then);

  final _CommunicationLog _self;
  final $Res Function(_CommunicationLog) _then;

/// Create a copy of CommunicationLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tenantId = null,Object? note = null,Object? createdAt = null,Object? createdBy = null,Object? schemaVersion = null,}) {
  return _then(_CommunicationLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
