// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meter_reading.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MeterReading {

 String get id; String get groundId; String get unitId; String get meterId; double get reading; double get previousReading; double get unitsConsumed; DateTime get readingDate; bool get isMeterReset; String get notes; DateTime get createdAt; DateTime get updatedAt; String get updatedBy; int get schemaVersion;
/// Create a copy of MeterReading
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeterReadingCopyWith<MeterReading> get copyWith => _$MeterReadingCopyWithImpl<MeterReading>(this as MeterReading, _$identity);

  /// Serializes this MeterReading to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeterReading&&(identical(other.id, id) || other.id == id)&&(identical(other.groundId, groundId) || other.groundId == groundId)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.meterId, meterId) || other.meterId == meterId)&&(identical(other.reading, reading) || other.reading == reading)&&(identical(other.previousReading, previousReading) || other.previousReading == previousReading)&&(identical(other.unitsConsumed, unitsConsumed) || other.unitsConsumed == unitsConsumed)&&(identical(other.readingDate, readingDate) || other.readingDate == readingDate)&&(identical(other.isMeterReset, isMeterReset) || other.isMeterReset == isMeterReset)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groundId,unitId,meterId,reading,previousReading,unitsConsumed,readingDate,isMeterReset,notes,createdAt,updatedAt,updatedBy,schemaVersion);

@override
String toString() {
  return 'MeterReading(id: $id, groundId: $groundId, unitId: $unitId, meterId: $meterId, reading: $reading, previousReading: $previousReading, unitsConsumed: $unitsConsumed, readingDate: $readingDate, isMeterReset: $isMeterReset, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class $MeterReadingCopyWith<$Res>  {
  factory $MeterReadingCopyWith(MeterReading value, $Res Function(MeterReading) _then) = _$MeterReadingCopyWithImpl;
@useResult
$Res call({
 String id, String groundId, String unitId, String meterId, double reading, double previousReading, double unitsConsumed, DateTime readingDate, bool isMeterReset, String notes, DateTime createdAt, DateTime updatedAt, String updatedBy, int schemaVersion
});




}
/// @nodoc
class _$MeterReadingCopyWithImpl<$Res>
    implements $MeterReadingCopyWith<$Res> {
  _$MeterReadingCopyWithImpl(this._self, this._then);

  final MeterReading _self;
  final $Res Function(MeterReading) _then;

/// Create a copy of MeterReading
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? groundId = null,Object? unitId = null,Object? meterId = null,Object? reading = null,Object? previousReading = null,Object? unitsConsumed = null,Object? readingDate = null,Object? isMeterReset = null,Object? notes = null,Object? createdAt = null,Object? updatedAt = null,Object? updatedBy = null,Object? schemaVersion = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groundId: null == groundId ? _self.groundId : groundId // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,meterId: null == meterId ? _self.meterId : meterId // ignore: cast_nullable_to_non_nullable
as String,reading: null == reading ? _self.reading : reading // ignore: cast_nullable_to_non_nullable
as double,previousReading: null == previousReading ? _self.previousReading : previousReading // ignore: cast_nullable_to_non_nullable
as double,unitsConsumed: null == unitsConsumed ? _self.unitsConsumed : unitsConsumed // ignore: cast_nullable_to_non_nullable
as double,readingDate: null == readingDate ? _self.readingDate : readingDate // ignore: cast_nullable_to_non_nullable
as DateTime,isMeterReset: null == isMeterReset ? _self.isMeterReset : isMeterReset // ignore: cast_nullable_to_non_nullable
as bool,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MeterReading].
extension MeterReadingPatterns on MeterReading {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeterReading value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeterReading() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeterReading value)  $default,){
final _that = this;
switch (_that) {
case _MeterReading():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeterReading value)?  $default,){
final _that = this;
switch (_that) {
case _MeterReading() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String groundId,  String unitId,  String meterId,  double reading,  double previousReading,  double unitsConsumed,  DateTime readingDate,  bool isMeterReset,  String notes,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeterReading() when $default != null:
return $default(_that.id,_that.groundId,_that.unitId,_that.meterId,_that.reading,_that.previousReading,_that.unitsConsumed,_that.readingDate,_that.isMeterReset,_that.notes,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String groundId,  String unitId,  String meterId,  double reading,  double previousReading,  double unitsConsumed,  DateTime readingDate,  bool isMeterReset,  String notes,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)  $default,) {final _that = this;
switch (_that) {
case _MeterReading():
return $default(_that.id,_that.groundId,_that.unitId,_that.meterId,_that.reading,_that.previousReading,_that.unitsConsumed,_that.readingDate,_that.isMeterReset,_that.notes,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String groundId,  String unitId,  String meterId,  double reading,  double previousReading,  double unitsConsumed,  DateTime readingDate,  bool isMeterReset,  String notes,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)?  $default,) {final _that = this;
switch (_that) {
case _MeterReading() when $default != null:
return $default(_that.id,_that.groundId,_that.unitId,_that.meterId,_that.reading,_that.previousReading,_that.unitsConsumed,_that.readingDate,_that.isMeterReset,_that.notes,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MeterReading extends MeterReading {
  const _MeterReading({required this.id, required this.groundId, required this.unitId, required this.meterId, required this.reading, required this.previousReading, required this.unitsConsumed, required this.readingDate, this.isMeterReset = false, this.notes = '', required this.createdAt, required this.updatedAt, required this.updatedBy, this.schemaVersion = 1}): super._();
  factory _MeterReading.fromJson(Map<String, dynamic> json) => _$MeterReadingFromJson(json);

@override final  String id;
@override final  String groundId;
@override final  String unitId;
@override final  String meterId;
@override final  double reading;
@override final  double previousReading;
@override final  double unitsConsumed;
@override final  DateTime readingDate;
@override@JsonKey() final  bool isMeterReset;
@override@JsonKey() final  String notes;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String updatedBy;
@override@JsonKey() final  int schemaVersion;

/// Create a copy of MeterReading
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeterReadingCopyWith<_MeterReading> get copyWith => __$MeterReadingCopyWithImpl<_MeterReading>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeterReadingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeterReading&&(identical(other.id, id) || other.id == id)&&(identical(other.groundId, groundId) || other.groundId == groundId)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.meterId, meterId) || other.meterId == meterId)&&(identical(other.reading, reading) || other.reading == reading)&&(identical(other.previousReading, previousReading) || other.previousReading == previousReading)&&(identical(other.unitsConsumed, unitsConsumed) || other.unitsConsumed == unitsConsumed)&&(identical(other.readingDate, readingDate) || other.readingDate == readingDate)&&(identical(other.isMeterReset, isMeterReset) || other.isMeterReset == isMeterReset)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groundId,unitId,meterId,reading,previousReading,unitsConsumed,readingDate,isMeterReset,notes,createdAt,updatedAt,updatedBy,schemaVersion);

@override
String toString() {
  return 'MeterReading(id: $id, groundId: $groundId, unitId: $unitId, meterId: $meterId, reading: $reading, previousReading: $previousReading, unitsConsumed: $unitsConsumed, readingDate: $readingDate, isMeterReset: $isMeterReset, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class _$MeterReadingCopyWith<$Res> implements $MeterReadingCopyWith<$Res> {
  factory _$MeterReadingCopyWith(_MeterReading value, $Res Function(_MeterReading) _then) = __$MeterReadingCopyWithImpl;
@override @useResult
$Res call({
 String id, String groundId, String unitId, String meterId, double reading, double previousReading, double unitsConsumed, DateTime readingDate, bool isMeterReset, String notes, DateTime createdAt, DateTime updatedAt, String updatedBy, int schemaVersion
});




}
/// @nodoc
class __$MeterReadingCopyWithImpl<$Res>
    implements _$MeterReadingCopyWith<$Res> {
  __$MeterReadingCopyWithImpl(this._self, this._then);

  final _MeterReading _self;
  final $Res Function(_MeterReading) _then;

/// Create a copy of MeterReading
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? groundId = null,Object? unitId = null,Object? meterId = null,Object? reading = null,Object? previousReading = null,Object? unitsConsumed = null,Object? readingDate = null,Object? isMeterReset = null,Object? notes = null,Object? createdAt = null,Object? updatedAt = null,Object? updatedBy = null,Object? schemaVersion = null,}) {
  return _then(_MeterReading(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groundId: null == groundId ? _self.groundId : groundId // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,meterId: null == meterId ? _self.meterId : meterId // ignore: cast_nullable_to_non_nullable
as String,reading: null == reading ? _self.reading : reading // ignore: cast_nullable_to_non_nullable
as double,previousReading: null == previousReading ? _self.previousReading : previousReading // ignore: cast_nullable_to_non_nullable
as double,unitsConsumed: null == unitsConsumed ? _self.unitsConsumed : unitsConsumed // ignore: cast_nullable_to_non_nullable
as double,readingDate: null == readingDate ? _self.readingDate : readingDate // ignore: cast_nullable_to_non_nullable
as DateTime,isMeterReset: null == isMeterReset ? _self.isMeterReset : isMeterReset // ignore: cast_nullable_to_non_nullable
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
