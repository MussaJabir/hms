// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scheduled_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduledNotification {

 String get id; String get type;// NotificationType.id value
 String get title; String get body; DateTime get scheduledAt; DateTime get createdAt; DateTime get updatedAt; String get updatedBy; bool get isRead; bool get isDismissed; String? get targetRoute;// GoRouter route for deep navigation e.g., "/rent"
 String? get targetId;// optional entity ID for deep navigation
 int get schemaVersion;
/// Create a copy of ScheduledNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduledNotificationCopyWith<ScheduledNotification> get copyWith => _$ScheduledNotificationCopyWithImpl<ScheduledNotification>(this as ScheduledNotification, _$identity);

  /// Serializes this ScheduledNotification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduledNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.isDismissed, isDismissed) || other.isDismissed == isDismissed)&&(identical(other.targetRoute, targetRoute) || other.targetRoute == targetRoute)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,body,scheduledAt,createdAt,updatedAt,updatedBy,isRead,isDismissed,targetRoute,targetId,schemaVersion);

@override
String toString() {
  return 'ScheduledNotification(id: $id, type: $type, title: $title, body: $body, scheduledAt: $scheduledAt, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy, isRead: $isRead, isDismissed: $isDismissed, targetRoute: $targetRoute, targetId: $targetId, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class $ScheduledNotificationCopyWith<$Res>  {
  factory $ScheduledNotificationCopyWith(ScheduledNotification value, $Res Function(ScheduledNotification) _then) = _$ScheduledNotificationCopyWithImpl;
@useResult
$Res call({
 String id, String type, String title, String body, DateTime scheduledAt, DateTime createdAt, DateTime updatedAt, String updatedBy, bool isRead, bool isDismissed, String? targetRoute, String? targetId, int schemaVersion
});




}
/// @nodoc
class _$ScheduledNotificationCopyWithImpl<$Res>
    implements $ScheduledNotificationCopyWith<$Res> {
  _$ScheduledNotificationCopyWithImpl(this._self, this._then);

  final ScheduledNotification _self;
  final $Res Function(ScheduledNotification) _then;

/// Create a copy of ScheduledNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? title = null,Object? body = null,Object? scheduledAt = null,Object? createdAt = null,Object? updatedAt = null,Object? updatedBy = null,Object? isRead = null,Object? isDismissed = null,Object? targetRoute = freezed,Object? targetId = freezed,Object? schemaVersion = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,isDismissed: null == isDismissed ? _self.isDismissed : isDismissed // ignore: cast_nullable_to_non_nullable
as bool,targetRoute: freezed == targetRoute ? _self.targetRoute : targetRoute // ignore: cast_nullable_to_non_nullable
as String?,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduledNotification].
extension ScheduledNotificationPatterns on ScheduledNotification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduledNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduledNotification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduledNotification value)  $default,){
final _that = this;
switch (_that) {
case _ScheduledNotification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduledNotification value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduledNotification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String title,  String body,  DateTime scheduledAt,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  bool isRead,  bool isDismissed,  String? targetRoute,  String? targetId,  int schemaVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduledNotification() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.body,_that.scheduledAt,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.isRead,_that.isDismissed,_that.targetRoute,_that.targetId,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String title,  String body,  DateTime scheduledAt,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  bool isRead,  bool isDismissed,  String? targetRoute,  String? targetId,  int schemaVersion)  $default,) {final _that = this;
switch (_that) {
case _ScheduledNotification():
return $default(_that.id,_that.type,_that.title,_that.body,_that.scheduledAt,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.isRead,_that.isDismissed,_that.targetRoute,_that.targetId,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String title,  String body,  DateTime scheduledAt,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  bool isRead,  bool isDismissed,  String? targetRoute,  String? targetId,  int schemaVersion)?  $default,) {final _that = this;
switch (_that) {
case _ScheduledNotification() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.body,_that.scheduledAt,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.isRead,_that.isDismissed,_that.targetRoute,_that.targetId,_that.schemaVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduledNotification extends ScheduledNotification {
  const _ScheduledNotification({required this.id, required this.type, required this.title, required this.body, required this.scheduledAt, required this.createdAt, required this.updatedAt, required this.updatedBy, this.isRead = false, this.isDismissed = false, this.targetRoute, this.targetId, this.schemaVersion = 1}): super._();
  factory _ScheduledNotification.fromJson(Map<String, dynamic> json) => _$ScheduledNotificationFromJson(json);

@override final  String id;
@override final  String type;
// NotificationType.id value
@override final  String title;
@override final  String body;
@override final  DateTime scheduledAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String updatedBy;
@override@JsonKey() final  bool isRead;
@override@JsonKey() final  bool isDismissed;
@override final  String? targetRoute;
// GoRouter route for deep navigation e.g., "/rent"
@override final  String? targetId;
// optional entity ID for deep navigation
@override@JsonKey() final  int schemaVersion;

/// Create a copy of ScheduledNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduledNotificationCopyWith<_ScheduledNotification> get copyWith => __$ScheduledNotificationCopyWithImpl<_ScheduledNotification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduledNotificationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduledNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.isDismissed, isDismissed) || other.isDismissed == isDismissed)&&(identical(other.targetRoute, targetRoute) || other.targetRoute == targetRoute)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,body,scheduledAt,createdAt,updatedAt,updatedBy,isRead,isDismissed,targetRoute,targetId,schemaVersion);

@override
String toString() {
  return 'ScheduledNotification(id: $id, type: $type, title: $title, body: $body, scheduledAt: $scheduledAt, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy, isRead: $isRead, isDismissed: $isDismissed, targetRoute: $targetRoute, targetId: $targetId, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class _$ScheduledNotificationCopyWith<$Res> implements $ScheduledNotificationCopyWith<$Res> {
  factory _$ScheduledNotificationCopyWith(_ScheduledNotification value, $Res Function(_ScheduledNotification) _then) = __$ScheduledNotificationCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String title, String body, DateTime scheduledAt, DateTime createdAt, DateTime updatedAt, String updatedBy, bool isRead, bool isDismissed, String? targetRoute, String? targetId, int schemaVersion
});




}
/// @nodoc
class __$ScheduledNotificationCopyWithImpl<$Res>
    implements _$ScheduledNotificationCopyWith<$Res> {
  __$ScheduledNotificationCopyWithImpl(this._self, this._then);

  final _ScheduledNotification _self;
  final $Res Function(_ScheduledNotification) _then;

/// Create a copy of ScheduledNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? title = null,Object? body = null,Object? scheduledAt = null,Object? createdAt = null,Object? updatedAt = null,Object? updatedBy = null,Object? isRead = null,Object? isDismissed = null,Object? targetRoute = freezed,Object? targetId = freezed,Object? schemaVersion = null,}) {
  return _then(_ScheduledNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,scheduledAt: null == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,isDismissed: null == isDismissed ? _self.isDismissed : isDismissed // ignore: cast_nullable_to_non_nullable
as bool,targetRoute: freezed == targetRoute ? _self.targetRoute : targetRoute // ignore: cast_nullable_to_non_nullable
as String?,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
