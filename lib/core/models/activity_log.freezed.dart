// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityLog {

 String get id; String get userId; String get action;// e.g., "created", "updated", "deleted"
 String get module;// e.g., "rent", "electricity", "inventory"
 String get description;// human-readable: "Marked rent paid for Room 3"
 String? get documentId;// the ID of the affected document
 String? get collectionPath;// the collection of the affected document
 DateTime get createdAt; int get schemaVersion;
/// Create a copy of ActivityLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityLogCopyWith<ActivityLog> get copyWith => _$ActivityLogCopyWithImpl<ActivityLog>(this as ActivityLog, _$identity);

  /// Serializes this ActivityLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityLog&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.action, action) || other.action == action)&&(identical(other.module, module) || other.module == module)&&(identical(other.description, description) || other.description == description)&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.collectionPath, collectionPath) || other.collectionPath == collectionPath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,action,module,description,documentId,collectionPath,createdAt,schemaVersion);

@override
String toString() {
  return 'ActivityLog(id: $id, userId: $userId, action: $action, module: $module, description: $description, documentId: $documentId, collectionPath: $collectionPath, createdAt: $createdAt, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class $ActivityLogCopyWith<$Res>  {
  factory $ActivityLogCopyWith(ActivityLog value, $Res Function(ActivityLog) _then) = _$ActivityLogCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String action, String module, String description, String? documentId, String? collectionPath, DateTime createdAt, int schemaVersion
});




}
/// @nodoc
class _$ActivityLogCopyWithImpl<$Res>
    implements $ActivityLogCopyWith<$Res> {
  _$ActivityLogCopyWithImpl(this._self, this._then);

  final ActivityLog _self;
  final $Res Function(ActivityLog) _then;

/// Create a copy of ActivityLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? action = null,Object? module = null,Object? description = null,Object? documentId = freezed,Object? collectionPath = freezed,Object? createdAt = null,Object? schemaVersion = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,documentId: freezed == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String?,collectionPath: freezed == collectionPath ? _self.collectionPath : collectionPath // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityLog].
extension ActivityLogPatterns on ActivityLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityLog value)  $default,){
final _that = this;
switch (_that) {
case _ActivityLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityLog value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String action,  String module,  String description,  String? documentId,  String? collectionPath,  DateTime createdAt,  int schemaVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityLog() when $default != null:
return $default(_that.id,_that.userId,_that.action,_that.module,_that.description,_that.documentId,_that.collectionPath,_that.createdAt,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String action,  String module,  String description,  String? documentId,  String? collectionPath,  DateTime createdAt,  int schemaVersion)  $default,) {final _that = this;
switch (_that) {
case _ActivityLog():
return $default(_that.id,_that.userId,_that.action,_that.module,_that.description,_that.documentId,_that.collectionPath,_that.createdAt,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String action,  String module,  String description,  String? documentId,  String? collectionPath,  DateTime createdAt,  int schemaVersion)?  $default,) {final _that = this;
switch (_that) {
case _ActivityLog() when $default != null:
return $default(_that.id,_that.userId,_that.action,_that.module,_that.description,_that.documentId,_that.collectionPath,_that.createdAt,_that.schemaVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityLog implements ActivityLog {
  const _ActivityLog({required this.id, required this.userId, required this.action, required this.module, required this.description, this.documentId, this.collectionPath, required this.createdAt, this.schemaVersion = 1});
  factory _ActivityLog.fromJson(Map<String, dynamic> json) => _$ActivityLogFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String action;
// e.g., "created", "updated", "deleted"
@override final  String module;
// e.g., "rent", "electricity", "inventory"
@override final  String description;
// human-readable: "Marked rent paid for Room 3"
@override final  String? documentId;
// the ID of the affected document
@override final  String? collectionPath;
// the collection of the affected document
@override final  DateTime createdAt;
@override@JsonKey() final  int schemaVersion;

/// Create a copy of ActivityLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityLogCopyWith<_ActivityLog> get copyWith => __$ActivityLogCopyWithImpl<_ActivityLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityLog&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.action, action) || other.action == action)&&(identical(other.module, module) || other.module == module)&&(identical(other.description, description) || other.description == description)&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.collectionPath, collectionPath) || other.collectionPath == collectionPath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,action,module,description,documentId,collectionPath,createdAt,schemaVersion);

@override
String toString() {
  return 'ActivityLog(id: $id, userId: $userId, action: $action, module: $module, description: $description, documentId: $documentId, collectionPath: $collectionPath, createdAt: $createdAt, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class _$ActivityLogCopyWith<$Res> implements $ActivityLogCopyWith<$Res> {
  factory _$ActivityLogCopyWith(_ActivityLog value, $Res Function(_ActivityLog) _then) = __$ActivityLogCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String action, String module, String description, String? documentId, String? collectionPath, DateTime createdAt, int schemaVersion
});




}
/// @nodoc
class __$ActivityLogCopyWithImpl<$Res>
    implements _$ActivityLogCopyWith<$Res> {
  __$ActivityLogCopyWithImpl(this._self, this._then);

  final _ActivityLog _self;
  final $Res Function(_ActivityLog) _then;

/// Create a copy of ActivityLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? action = null,Object? module = null,Object? description = null,Object? documentId = freezed,Object? collectionPath = freezed,Object? createdAt = null,Object? schemaVersion = null,}) {
  return _then(_ActivityLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,documentId: freezed == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String?,collectionPath: freezed == collectionPath ? _self.collectionPath : collectionPath // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
