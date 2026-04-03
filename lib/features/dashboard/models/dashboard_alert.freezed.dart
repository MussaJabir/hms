// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_alert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardAlert {

 String get id; String get title; String get message; AlertSeverity get severity; IconData get icon; String get module; DateTime get createdAt; String? get targetRoute; String? get targetId; String? get actionLabel;
/// Create a copy of DashboardAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardAlertCopyWith<DashboardAlert> get copyWith => _$DashboardAlertCopyWithImpl<DashboardAlert>(this as DashboardAlert, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.module, module) || other.module == module)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.targetRoute, targetRoute) || other.targetRoute == targetRoute)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.actionLabel, actionLabel) || other.actionLabel == actionLabel));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,message,severity,icon,module,createdAt,targetRoute,targetId,actionLabel);

@override
String toString() {
  return 'DashboardAlert(id: $id, title: $title, message: $message, severity: $severity, icon: $icon, module: $module, createdAt: $createdAt, targetRoute: $targetRoute, targetId: $targetId, actionLabel: $actionLabel)';
}


}

/// @nodoc
abstract mixin class $DashboardAlertCopyWith<$Res>  {
  factory $DashboardAlertCopyWith(DashboardAlert value, $Res Function(DashboardAlert) _then) = _$DashboardAlertCopyWithImpl;
@useResult
$Res call({
 String id, String title, String message, AlertSeverity severity, IconData icon, String module, DateTime createdAt, String? targetRoute, String? targetId, String? actionLabel
});




}
/// @nodoc
class _$DashboardAlertCopyWithImpl<$Res>
    implements $DashboardAlertCopyWith<$Res> {
  _$DashboardAlertCopyWithImpl(this._self, this._then);

  final DashboardAlert _self;
  final $Res Function(DashboardAlert) _then;

/// Create a copy of DashboardAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? message = null,Object? severity = null,Object? icon = null,Object? module = null,Object? createdAt = null,Object? targetRoute = freezed,Object? targetId = freezed,Object? actionLabel = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as AlertSeverity,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,targetRoute: freezed == targetRoute ? _self.targetRoute : targetRoute // ignore: cast_nullable_to_non_nullable
as String?,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,actionLabel: freezed == actionLabel ? _self.actionLabel : actionLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardAlert].
extension DashboardAlertPatterns on DashboardAlert {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardAlert() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardAlert value)  $default,){
final _that = this;
switch (_that) {
case _DashboardAlert():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardAlert value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardAlert() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String message,  AlertSeverity severity,  IconData icon,  String module,  DateTime createdAt,  String? targetRoute,  String? targetId,  String? actionLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardAlert() when $default != null:
return $default(_that.id,_that.title,_that.message,_that.severity,_that.icon,_that.module,_that.createdAt,_that.targetRoute,_that.targetId,_that.actionLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String message,  AlertSeverity severity,  IconData icon,  String module,  DateTime createdAt,  String? targetRoute,  String? targetId,  String? actionLabel)  $default,) {final _that = this;
switch (_that) {
case _DashboardAlert():
return $default(_that.id,_that.title,_that.message,_that.severity,_that.icon,_that.module,_that.createdAt,_that.targetRoute,_that.targetId,_that.actionLabel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String message,  AlertSeverity severity,  IconData icon,  String module,  DateTime createdAt,  String? targetRoute,  String? targetId,  String? actionLabel)?  $default,) {final _that = this;
switch (_that) {
case _DashboardAlert() when $default != null:
return $default(_that.id,_that.title,_that.message,_that.severity,_that.icon,_that.module,_that.createdAt,_that.targetRoute,_that.targetId,_that.actionLabel);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardAlert implements DashboardAlert {
  const _DashboardAlert({required this.id, required this.title, required this.message, required this.severity, required this.icon, required this.module, required this.createdAt, this.targetRoute, this.targetId, this.actionLabel});
  

@override final  String id;
@override final  String title;
@override final  String message;
@override final  AlertSeverity severity;
@override final  IconData icon;
@override final  String module;
@override final  DateTime createdAt;
@override final  String? targetRoute;
@override final  String? targetId;
@override final  String? actionLabel;

/// Create a copy of DashboardAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardAlertCopyWith<_DashboardAlert> get copyWith => __$DashboardAlertCopyWithImpl<_DashboardAlert>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.module, module) || other.module == module)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.targetRoute, targetRoute) || other.targetRoute == targetRoute)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.actionLabel, actionLabel) || other.actionLabel == actionLabel));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,message,severity,icon,module,createdAt,targetRoute,targetId,actionLabel);

@override
String toString() {
  return 'DashboardAlert(id: $id, title: $title, message: $message, severity: $severity, icon: $icon, module: $module, createdAt: $createdAt, targetRoute: $targetRoute, targetId: $targetId, actionLabel: $actionLabel)';
}


}

/// @nodoc
abstract mixin class _$DashboardAlertCopyWith<$Res> implements $DashboardAlertCopyWith<$Res> {
  factory _$DashboardAlertCopyWith(_DashboardAlert value, $Res Function(_DashboardAlert) _then) = __$DashboardAlertCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String message, AlertSeverity severity, IconData icon, String module, DateTime createdAt, String? targetRoute, String? targetId, String? actionLabel
});




}
/// @nodoc
class __$DashboardAlertCopyWithImpl<$Res>
    implements _$DashboardAlertCopyWith<$Res> {
  __$DashboardAlertCopyWithImpl(this._self, this._then);

  final _DashboardAlert _self;
  final $Res Function(_DashboardAlert) _then;

/// Create a copy of DashboardAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? message = null,Object? severity = null,Object? icon = null,Object? module = null,Object? createdAt = null,Object? targetRoute = freezed,Object? targetId = freezed,Object? actionLabel = freezed,}) {
  return _then(_DashboardAlert(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as AlertSeverity,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as IconData,module: null == module ? _self.module : module // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,targetRoute: freezed == targetRoute ? _self.targetRoute : targetRoute // ignore: cast_nullable_to_non_nullable
as String?,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,actionLabel: freezed == actionLabel ? _self.actionLabel : actionLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
