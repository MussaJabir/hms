// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppConfig {

 String get id; List<TanescoTier> get tanescoTiers; double get defaultWaterContribution; DateTime get updatedAt; String get updatedBy; int get schemaVersion;
/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppConfigCopyWith<AppConfig> get copyWith => _$AppConfigCopyWithImpl<AppConfig>(this as AppConfig, _$identity);

  /// Serializes this AppConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppConfig&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.tanescoTiers, tanescoTiers)&&(identical(other.defaultWaterContribution, defaultWaterContribution) || other.defaultWaterContribution == defaultWaterContribution)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(tanescoTiers),defaultWaterContribution,updatedAt,updatedBy,schemaVersion);

@override
String toString() {
  return 'AppConfig(id: $id, tanescoTiers: $tanescoTiers, defaultWaterContribution: $defaultWaterContribution, updatedAt: $updatedAt, updatedBy: $updatedBy, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class $AppConfigCopyWith<$Res>  {
  factory $AppConfigCopyWith(AppConfig value, $Res Function(AppConfig) _then) = _$AppConfigCopyWithImpl;
@useResult
$Res call({
 String id, List<TanescoTier> tanescoTiers, double defaultWaterContribution, DateTime updatedAt, String updatedBy, int schemaVersion
});




}
/// @nodoc
class _$AppConfigCopyWithImpl<$Res>
    implements $AppConfigCopyWith<$Res> {
  _$AppConfigCopyWithImpl(this._self, this._then);

  final AppConfig _self;
  final $Res Function(AppConfig) _then;

/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tanescoTiers = null,Object? defaultWaterContribution = null,Object? updatedAt = null,Object? updatedBy = null,Object? schemaVersion = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tanescoTiers: null == tanescoTiers ? _self.tanescoTiers : tanescoTiers // ignore: cast_nullable_to_non_nullable
as List<TanescoTier>,defaultWaterContribution: null == defaultWaterContribution ? _self.defaultWaterContribution : defaultWaterContribution // ignore: cast_nullable_to_non_nullable
as double,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AppConfig].
extension AppConfigPatterns on AppConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppConfig value)  $default,){
final _that = this;
switch (_that) {
case _AppConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppConfig value)?  $default,){
final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  List<TanescoTier> tanescoTiers,  double defaultWaterContribution,  DateTime updatedAt,  String updatedBy,  int schemaVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
return $default(_that.id,_that.tanescoTiers,_that.defaultWaterContribution,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  List<TanescoTier> tanescoTiers,  double defaultWaterContribution,  DateTime updatedAt,  String updatedBy,  int schemaVersion)  $default,) {final _that = this;
switch (_that) {
case _AppConfig():
return $default(_that.id,_that.tanescoTiers,_that.defaultWaterContribution,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  List<TanescoTier> tanescoTiers,  double defaultWaterContribution,  DateTime updatedAt,  String updatedBy,  int schemaVersion)?  $default,) {final _that = this;
switch (_that) {
case _AppConfig() when $default != null:
return $default(_that.id,_that.tanescoTiers,_that.defaultWaterContribution,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppConfig implements AppConfig {
  const _AppConfig({required this.id, final  List<TanescoTier> tanescoTiers = const [], this.defaultWaterContribution = 0, required this.updatedAt, required this.updatedBy, this.schemaVersion = 1}): _tanescoTiers = tanescoTiers;
  factory _AppConfig.fromJson(Map<String, dynamic> json) => _$AppConfigFromJson(json);

@override final  String id;
 final  List<TanescoTier> _tanescoTiers;
@override@JsonKey() List<TanescoTier> get tanescoTiers {
  if (_tanescoTiers is EqualUnmodifiableListView) return _tanescoTiers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tanescoTiers);
}

@override@JsonKey() final  double defaultWaterContribution;
@override final  DateTime updatedAt;
@override final  String updatedBy;
@override@JsonKey() final  int schemaVersion;

/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppConfigCopyWith<_AppConfig> get copyWith => __$AppConfigCopyWithImpl<_AppConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppConfig&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._tanescoTiers, _tanescoTiers)&&(identical(other.defaultWaterContribution, defaultWaterContribution) || other.defaultWaterContribution == defaultWaterContribution)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_tanescoTiers),defaultWaterContribution,updatedAt,updatedBy,schemaVersion);

@override
String toString() {
  return 'AppConfig(id: $id, tanescoTiers: $tanescoTiers, defaultWaterContribution: $defaultWaterContribution, updatedAt: $updatedAt, updatedBy: $updatedBy, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class _$AppConfigCopyWith<$Res> implements $AppConfigCopyWith<$Res> {
  factory _$AppConfigCopyWith(_AppConfig value, $Res Function(_AppConfig) _then) = __$AppConfigCopyWithImpl;
@override @useResult
$Res call({
 String id, List<TanescoTier> tanescoTiers, double defaultWaterContribution, DateTime updatedAt, String updatedBy, int schemaVersion
});




}
/// @nodoc
class __$AppConfigCopyWithImpl<$Res>
    implements _$AppConfigCopyWith<$Res> {
  __$AppConfigCopyWithImpl(this._self, this._then);

  final _AppConfig _self;
  final $Res Function(_AppConfig) _then;

/// Create a copy of AppConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tanescoTiers = null,Object? defaultWaterContribution = null,Object? updatedAt = null,Object? updatedBy = null,Object? schemaVersion = null,}) {
  return _then(_AppConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tanescoTiers: null == tanescoTiers ? _self._tanescoTiers : tanescoTiers // ignore: cast_nullable_to_non_nullable
as List<TanescoTier>,defaultWaterContribution: null == defaultWaterContribution ? _self.defaultWaterContribution : defaultWaterContribution // ignore: cast_nullable_to_non_nullable
as double,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TanescoTier {

 double get minUnits; double get maxUnits; double get ratePerUnit;
/// Create a copy of TanescoTier
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TanescoTierCopyWith<TanescoTier> get copyWith => _$TanescoTierCopyWithImpl<TanescoTier>(this as TanescoTier, _$identity);

  /// Serializes this TanescoTier to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TanescoTier&&(identical(other.minUnits, minUnits) || other.minUnits == minUnits)&&(identical(other.maxUnits, maxUnits) || other.maxUnits == maxUnits)&&(identical(other.ratePerUnit, ratePerUnit) || other.ratePerUnit == ratePerUnit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,minUnits,maxUnits,ratePerUnit);

@override
String toString() {
  return 'TanescoTier(minUnits: $minUnits, maxUnits: $maxUnits, ratePerUnit: $ratePerUnit)';
}


}

/// @nodoc
abstract mixin class $TanescoTierCopyWith<$Res>  {
  factory $TanescoTierCopyWith(TanescoTier value, $Res Function(TanescoTier) _then) = _$TanescoTierCopyWithImpl;
@useResult
$Res call({
 double minUnits, double maxUnits, double ratePerUnit
});




}
/// @nodoc
class _$TanescoTierCopyWithImpl<$Res>
    implements $TanescoTierCopyWith<$Res> {
  _$TanescoTierCopyWithImpl(this._self, this._then);

  final TanescoTier _self;
  final $Res Function(TanescoTier) _then;

/// Create a copy of TanescoTier
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? minUnits = null,Object? maxUnits = null,Object? ratePerUnit = null,}) {
  return _then(_self.copyWith(
minUnits: null == minUnits ? _self.minUnits : minUnits // ignore: cast_nullable_to_non_nullable
as double,maxUnits: null == maxUnits ? _self.maxUnits : maxUnits // ignore: cast_nullable_to_non_nullable
as double,ratePerUnit: null == ratePerUnit ? _self.ratePerUnit : ratePerUnit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TanescoTier].
extension TanescoTierPatterns on TanescoTier {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TanescoTier value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TanescoTier() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TanescoTier value)  $default,){
final _that = this;
switch (_that) {
case _TanescoTier():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TanescoTier value)?  $default,){
final _that = this;
switch (_that) {
case _TanescoTier() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double minUnits,  double maxUnits,  double ratePerUnit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TanescoTier() when $default != null:
return $default(_that.minUnits,_that.maxUnits,_that.ratePerUnit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double minUnits,  double maxUnits,  double ratePerUnit)  $default,) {final _that = this;
switch (_that) {
case _TanescoTier():
return $default(_that.minUnits,_that.maxUnits,_that.ratePerUnit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double minUnits,  double maxUnits,  double ratePerUnit)?  $default,) {final _that = this;
switch (_that) {
case _TanescoTier() when $default != null:
return $default(_that.minUnits,_that.maxUnits,_that.ratePerUnit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TanescoTier implements TanescoTier {
  const _TanescoTier({required this.minUnits, required this.maxUnits, required this.ratePerUnit});
  factory _TanescoTier.fromJson(Map<String, dynamic> json) => _$TanescoTierFromJson(json);

@override final  double minUnits;
@override final  double maxUnits;
@override final  double ratePerUnit;

/// Create a copy of TanescoTier
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TanescoTierCopyWith<_TanescoTier> get copyWith => __$TanescoTierCopyWithImpl<_TanescoTier>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TanescoTierToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TanescoTier&&(identical(other.minUnits, minUnits) || other.minUnits == minUnits)&&(identical(other.maxUnits, maxUnits) || other.maxUnits == maxUnits)&&(identical(other.ratePerUnit, ratePerUnit) || other.ratePerUnit == ratePerUnit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,minUnits,maxUnits,ratePerUnit);

@override
String toString() {
  return 'TanescoTier(minUnits: $minUnits, maxUnits: $maxUnits, ratePerUnit: $ratePerUnit)';
}


}

/// @nodoc
abstract mixin class _$TanescoTierCopyWith<$Res> implements $TanescoTierCopyWith<$Res> {
  factory _$TanescoTierCopyWith(_TanescoTier value, $Res Function(_TanescoTier) _then) = __$TanescoTierCopyWithImpl;
@override @useResult
$Res call({
 double minUnits, double maxUnits, double ratePerUnit
});




}
/// @nodoc
class __$TanescoTierCopyWithImpl<$Res>
    implements _$TanescoTierCopyWith<$Res> {
  __$TanescoTierCopyWithImpl(this._self, this._then);

  final _TanescoTier _self;
  final $Res Function(_TanescoTier) _then;

/// Create a copy of TanescoTier
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? minUnits = null,Object? maxUnits = null,Object? ratePerUnit = null,}) {
  return _then(_TanescoTier(
minUnits: null == minUnits ? _self.minUnits : minUnits // ignore: cast_nullable_to_non_nullable
as double,maxUnits: null == maxUnits ? _self.maxUnits : maxUnits // ignore: cast_nullable_to_non_nullable
as double,ratePerUnit: null == ratePerUnit ? _self.ratePerUnit : ratePerUnit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
