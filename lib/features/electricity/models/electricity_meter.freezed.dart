// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'electricity_meter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ElectricityMeter {

 String get id; String get groundId; String get unitId; String get meterNumber; double get initialReading; double get currentReading; double get weeklyThreshold; bool get isActive; DateTime? get lastReadingDate; DateTime get createdAt; DateTime get updatedAt; String get updatedBy; int get schemaVersion;
/// Create a copy of ElectricityMeter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ElectricityMeterCopyWith<ElectricityMeter> get copyWith => _$ElectricityMeterCopyWithImpl<ElectricityMeter>(this as ElectricityMeter, _$identity);

  /// Serializes this ElectricityMeter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ElectricityMeter&&(identical(other.id, id) || other.id == id)&&(identical(other.groundId, groundId) || other.groundId == groundId)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.meterNumber, meterNumber) || other.meterNumber == meterNumber)&&(identical(other.initialReading, initialReading) || other.initialReading == initialReading)&&(identical(other.currentReading, currentReading) || other.currentReading == currentReading)&&(identical(other.weeklyThreshold, weeklyThreshold) || other.weeklyThreshold == weeklyThreshold)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastReadingDate, lastReadingDate) || other.lastReadingDate == lastReadingDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groundId,unitId,meterNumber,initialReading,currentReading,weeklyThreshold,isActive,lastReadingDate,createdAt,updatedAt,updatedBy,schemaVersion);

@override
String toString() {
  return 'ElectricityMeter(id: $id, groundId: $groundId, unitId: $unitId, meterNumber: $meterNumber, initialReading: $initialReading, currentReading: $currentReading, weeklyThreshold: $weeklyThreshold, isActive: $isActive, lastReadingDate: $lastReadingDate, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class $ElectricityMeterCopyWith<$Res>  {
  factory $ElectricityMeterCopyWith(ElectricityMeter value, $Res Function(ElectricityMeter) _then) = _$ElectricityMeterCopyWithImpl;
@useResult
$Res call({
 String id, String groundId, String unitId, String meterNumber, double initialReading, double currentReading, double weeklyThreshold, bool isActive, DateTime? lastReadingDate, DateTime createdAt, DateTime updatedAt, String updatedBy, int schemaVersion
});




}
/// @nodoc
class _$ElectricityMeterCopyWithImpl<$Res>
    implements $ElectricityMeterCopyWith<$Res> {
  _$ElectricityMeterCopyWithImpl(this._self, this._then);

  final ElectricityMeter _self;
  final $Res Function(ElectricityMeter) _then;

/// Create a copy of ElectricityMeter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? groundId = null,Object? unitId = null,Object? meterNumber = null,Object? initialReading = null,Object? currentReading = null,Object? weeklyThreshold = null,Object? isActive = null,Object? lastReadingDate = freezed,Object? createdAt = null,Object? updatedAt = null,Object? updatedBy = null,Object? schemaVersion = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groundId: null == groundId ? _self.groundId : groundId // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,meterNumber: null == meterNumber ? _self.meterNumber : meterNumber // ignore: cast_nullable_to_non_nullable
as String,initialReading: null == initialReading ? _self.initialReading : initialReading // ignore: cast_nullable_to_non_nullable
as double,currentReading: null == currentReading ? _self.currentReading : currentReading // ignore: cast_nullable_to_non_nullable
as double,weeklyThreshold: null == weeklyThreshold ? _self.weeklyThreshold : weeklyThreshold // ignore: cast_nullable_to_non_nullable
as double,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastReadingDate: freezed == lastReadingDate ? _self.lastReadingDate : lastReadingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ElectricityMeter].
extension ElectricityMeterPatterns on ElectricityMeter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ElectricityMeter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ElectricityMeter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ElectricityMeter value)  $default,){
final _that = this;
switch (_that) {
case _ElectricityMeter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ElectricityMeter value)?  $default,){
final _that = this;
switch (_that) {
case _ElectricityMeter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String groundId,  String unitId,  String meterNumber,  double initialReading,  double currentReading,  double weeklyThreshold,  bool isActive,  DateTime? lastReadingDate,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ElectricityMeter() when $default != null:
return $default(_that.id,_that.groundId,_that.unitId,_that.meterNumber,_that.initialReading,_that.currentReading,_that.weeklyThreshold,_that.isActive,_that.lastReadingDate,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String groundId,  String unitId,  String meterNumber,  double initialReading,  double currentReading,  double weeklyThreshold,  bool isActive,  DateTime? lastReadingDate,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)  $default,) {final _that = this;
switch (_that) {
case _ElectricityMeter():
return $default(_that.id,_that.groundId,_that.unitId,_that.meterNumber,_that.initialReading,_that.currentReading,_that.weeklyThreshold,_that.isActive,_that.lastReadingDate,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String groundId,  String unitId,  String meterNumber,  double initialReading,  double currentReading,  double weeklyThreshold,  bool isActive,  DateTime? lastReadingDate,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)?  $default,) {final _that = this;
switch (_that) {
case _ElectricityMeter() when $default != null:
return $default(_that.id,_that.groundId,_that.unitId,_that.meterNumber,_that.initialReading,_that.currentReading,_that.weeklyThreshold,_that.isActive,_that.lastReadingDate,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ElectricityMeter extends ElectricityMeter {
  const _ElectricityMeter({required this.id, required this.groundId, required this.unitId, required this.meterNumber, this.initialReading = 0, this.currentReading = 0, this.weeklyThreshold = 0, this.isActive = true, this.lastReadingDate, required this.createdAt, required this.updatedAt, required this.updatedBy, this.schemaVersion = 1}): super._();
  factory _ElectricityMeter.fromJson(Map<String, dynamic> json) => _$ElectricityMeterFromJson(json);

@override final  String id;
@override final  String groundId;
@override final  String unitId;
@override final  String meterNumber;
@override@JsonKey() final  double initialReading;
@override@JsonKey() final  double currentReading;
@override@JsonKey() final  double weeklyThreshold;
@override@JsonKey() final  bool isActive;
@override final  DateTime? lastReadingDate;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String updatedBy;
@override@JsonKey() final  int schemaVersion;

/// Create a copy of ElectricityMeter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ElectricityMeterCopyWith<_ElectricityMeter> get copyWith => __$ElectricityMeterCopyWithImpl<_ElectricityMeter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ElectricityMeterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ElectricityMeter&&(identical(other.id, id) || other.id == id)&&(identical(other.groundId, groundId) || other.groundId == groundId)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.meterNumber, meterNumber) || other.meterNumber == meterNumber)&&(identical(other.initialReading, initialReading) || other.initialReading == initialReading)&&(identical(other.currentReading, currentReading) || other.currentReading == currentReading)&&(identical(other.weeklyThreshold, weeklyThreshold) || other.weeklyThreshold == weeklyThreshold)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastReadingDate, lastReadingDate) || other.lastReadingDate == lastReadingDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groundId,unitId,meterNumber,initialReading,currentReading,weeklyThreshold,isActive,lastReadingDate,createdAt,updatedAt,updatedBy,schemaVersion);

@override
String toString() {
  return 'ElectricityMeter(id: $id, groundId: $groundId, unitId: $unitId, meterNumber: $meterNumber, initialReading: $initialReading, currentReading: $currentReading, weeklyThreshold: $weeklyThreshold, isActive: $isActive, lastReadingDate: $lastReadingDate, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class _$ElectricityMeterCopyWith<$Res> implements $ElectricityMeterCopyWith<$Res> {
  factory _$ElectricityMeterCopyWith(_ElectricityMeter value, $Res Function(_ElectricityMeter) _then) = __$ElectricityMeterCopyWithImpl;
@override @useResult
$Res call({
 String id, String groundId, String unitId, String meterNumber, double initialReading, double currentReading, double weeklyThreshold, bool isActive, DateTime? lastReadingDate, DateTime createdAt, DateTime updatedAt, String updatedBy, int schemaVersion
});




}
/// @nodoc
class __$ElectricityMeterCopyWithImpl<$Res>
    implements _$ElectricityMeterCopyWith<$Res> {
  __$ElectricityMeterCopyWithImpl(this._self, this._then);

  final _ElectricityMeter _self;
  final $Res Function(_ElectricityMeter) _then;

/// Create a copy of ElectricityMeter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? groundId = null,Object? unitId = null,Object? meterNumber = null,Object? initialReading = null,Object? currentReading = null,Object? weeklyThreshold = null,Object? isActive = null,Object? lastReadingDate = freezed,Object? createdAt = null,Object? updatedAt = null,Object? updatedBy = null,Object? schemaVersion = null,}) {
  return _then(_ElectricityMeter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groundId: null == groundId ? _self.groundId : groundId // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,meterNumber: null == meterNumber ? _self.meterNumber : meterNumber // ignore: cast_nullable_to_non_nullable
as String,initialReading: null == initialReading ? _self.initialReading : initialReading // ignore: cast_nullable_to_non_nullable
as double,currentReading: null == currentReading ? _self.currentReading : currentReading // ignore: cast_nullable_to_non_nullable
as double,weeklyThreshold: null == weeklyThreshold ? _self.weeklyThreshold : weeklyThreshold // ignore: cast_nullable_to_non_nullable
as double,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastReadingDate: freezed == lastReadingDate ? _self.lastReadingDate : lastReadingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
