// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReminderConfig {

 String get id; bool get enabled; int get dayOfWeek;// 1=Monday, 7=Sunday
 int get hour;// 24-hour format
 int get minute; DateTime get updatedAt; String get updatedBy; int get schemaVersion;
/// Create a copy of ReminderConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderConfigCopyWith<ReminderConfig> get copyWith => _$ReminderConfigCopyWithImpl<ReminderConfig>(this as ReminderConfig, _$identity);

  /// Serializes this ReminderConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,enabled,dayOfWeek,hour,minute,updatedAt,updatedBy,schemaVersion);

@override
String toString() {
  return 'ReminderConfig(id: $id, enabled: $enabled, dayOfWeek: $dayOfWeek, hour: $hour, minute: $minute, updatedAt: $updatedAt, updatedBy: $updatedBy, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class $ReminderConfigCopyWith<$Res>  {
  factory $ReminderConfigCopyWith(ReminderConfig value, $Res Function(ReminderConfig) _then) = _$ReminderConfigCopyWithImpl;
@useResult
$Res call({
 String id, bool enabled, int dayOfWeek, int hour, int minute, DateTime updatedAt, String updatedBy, int schemaVersion
});




}
/// @nodoc
class _$ReminderConfigCopyWithImpl<$Res>
    implements $ReminderConfigCopyWith<$Res> {
  _$ReminderConfigCopyWithImpl(this._self, this._then);

  final ReminderConfig _self;
  final $Res Function(ReminderConfig) _then;

/// Create a copy of ReminderConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? enabled = null,Object? dayOfWeek = null,Object? hour = null,Object? minute = null,Object? updatedAt = null,Object? updatedBy = null,Object? schemaVersion = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int,hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReminderConfig].
extension ReminderConfigPatterns on ReminderConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReminderConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReminderConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReminderConfig value)  $default,){
final _that = this;
switch (_that) {
case _ReminderConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReminderConfig value)?  $default,){
final _that = this;
switch (_that) {
case _ReminderConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  bool enabled,  int dayOfWeek,  int hour,  int minute,  DateTime updatedAt,  String updatedBy,  int schemaVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReminderConfig() when $default != null:
return $default(_that.id,_that.enabled,_that.dayOfWeek,_that.hour,_that.minute,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  bool enabled,  int dayOfWeek,  int hour,  int minute,  DateTime updatedAt,  String updatedBy,  int schemaVersion)  $default,) {final _that = this;
switch (_that) {
case _ReminderConfig():
return $default(_that.id,_that.enabled,_that.dayOfWeek,_that.hour,_that.minute,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  bool enabled,  int dayOfWeek,  int hour,  int minute,  DateTime updatedAt,  String updatedBy,  int schemaVersion)?  $default,) {final _that = this;
switch (_that) {
case _ReminderConfig() when $default != null:
return $default(_that.id,_that.enabled,_that.dayOfWeek,_that.hour,_that.minute,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReminderConfig extends ReminderConfig {
  const _ReminderConfig({required this.id, this.enabled = true, this.dayOfWeek = 7, this.hour = 18, this.minute = 0, required this.updatedAt, required this.updatedBy, this.schemaVersion = 1}): super._();
  factory _ReminderConfig.fromJson(Map<String, dynamic> json) => _$ReminderConfigFromJson(json);

@override final  String id;
@override@JsonKey() final  bool enabled;
@override@JsonKey() final  int dayOfWeek;
// 1=Monday, 7=Sunday
@override@JsonKey() final  int hour;
// 24-hour format
@override@JsonKey() final  int minute;
@override final  DateTime updatedAt;
@override final  String updatedBy;
@override@JsonKey() final  int schemaVersion;

/// Create a copy of ReminderConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderConfigCopyWith<_ReminderConfig> get copyWith => __$ReminderConfigCopyWithImpl<_ReminderConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReminderConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReminderConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,enabled,dayOfWeek,hour,minute,updatedAt,updatedBy,schemaVersion);

@override
String toString() {
  return 'ReminderConfig(id: $id, enabled: $enabled, dayOfWeek: $dayOfWeek, hour: $hour, minute: $minute, updatedAt: $updatedAt, updatedBy: $updatedBy, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class _$ReminderConfigCopyWith<$Res> implements $ReminderConfigCopyWith<$Res> {
  factory _$ReminderConfigCopyWith(_ReminderConfig value, $Res Function(_ReminderConfig) _then) = __$ReminderConfigCopyWithImpl;
@override @useResult
$Res call({
 String id, bool enabled, int dayOfWeek, int hour, int minute, DateTime updatedAt, String updatedBy, int schemaVersion
});




}
/// @nodoc
class __$ReminderConfigCopyWithImpl<$Res>
    implements _$ReminderConfigCopyWith<$Res> {
  __$ReminderConfigCopyWithImpl(this._self, this._then);

  final _ReminderConfig _self;
  final $Res Function(_ReminderConfig) _then;

/// Create a copy of ReminderConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? enabled = null,Object? dayOfWeek = null,Object? hour = null,Object? minute = null,Object? updatedAt = null,Object? updatedBy = null,Object? schemaVersion = null,}) {
  return _then(_ReminderConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,dayOfWeek: null == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as int,hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
