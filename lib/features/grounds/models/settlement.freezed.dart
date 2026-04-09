// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settlement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Settlement {

 String get id; String get groundId; String get unitId; String get tenantId; String get tenantName; DateTime get moveOutDate; double get outstandingRent; double get outstandingWater; double get otherCharges; String get notes; String get status;// "settled", "pending", "waived"
 DateTime get createdAt; DateTime get updatedAt; String get updatedBy; int get schemaVersion;
/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettlementCopyWith<Settlement> get copyWith => _$SettlementCopyWithImpl<Settlement>(this as Settlement, _$identity);

  /// Serializes this Settlement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Settlement&&(identical(other.id, id) || other.id == id)&&(identical(other.groundId, groundId) || other.groundId == groundId)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.tenantName, tenantName) || other.tenantName == tenantName)&&(identical(other.moveOutDate, moveOutDate) || other.moveOutDate == moveOutDate)&&(identical(other.outstandingRent, outstandingRent) || other.outstandingRent == outstandingRent)&&(identical(other.outstandingWater, outstandingWater) || other.outstandingWater == outstandingWater)&&(identical(other.otherCharges, otherCharges) || other.otherCharges == otherCharges)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groundId,unitId,tenantId,tenantName,moveOutDate,outstandingRent,outstandingWater,otherCharges,notes,status,createdAt,updatedAt,updatedBy,schemaVersion);

@override
String toString() {
  return 'Settlement(id: $id, groundId: $groundId, unitId: $unitId, tenantId: $tenantId, tenantName: $tenantName, moveOutDate: $moveOutDate, outstandingRent: $outstandingRent, outstandingWater: $outstandingWater, otherCharges: $otherCharges, notes: $notes, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class $SettlementCopyWith<$Res>  {
  factory $SettlementCopyWith(Settlement value, $Res Function(Settlement) _then) = _$SettlementCopyWithImpl;
@useResult
$Res call({
 String id, String groundId, String unitId, String tenantId, String tenantName, DateTime moveOutDate, double outstandingRent, double outstandingWater, double otherCharges, String notes, String status, DateTime createdAt, DateTime updatedAt, String updatedBy, int schemaVersion
});




}
/// @nodoc
class _$SettlementCopyWithImpl<$Res>
    implements $SettlementCopyWith<$Res> {
  _$SettlementCopyWithImpl(this._self, this._then);

  final Settlement _self;
  final $Res Function(Settlement) _then;

/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? groundId = null,Object? unitId = null,Object? tenantId = null,Object? tenantName = null,Object? moveOutDate = null,Object? outstandingRent = null,Object? outstandingWater = null,Object? otherCharges = null,Object? notes = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,Object? updatedBy = null,Object? schemaVersion = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groundId: null == groundId ? _self.groundId : groundId // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,tenantName: null == tenantName ? _self.tenantName : tenantName // ignore: cast_nullable_to_non_nullable
as String,moveOutDate: null == moveOutDate ? _self.moveOutDate : moveOutDate // ignore: cast_nullable_to_non_nullable
as DateTime,outstandingRent: null == outstandingRent ? _self.outstandingRent : outstandingRent // ignore: cast_nullable_to_non_nullable
as double,outstandingWater: null == outstandingWater ? _self.outstandingWater : outstandingWater // ignore: cast_nullable_to_non_nullable
as double,otherCharges: null == otherCharges ? _self.otherCharges : otherCharges // ignore: cast_nullable_to_non_nullable
as double,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Settlement].
extension SettlementPatterns on Settlement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Settlement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Settlement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Settlement value)  $default,){
final _that = this;
switch (_that) {
case _Settlement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Settlement value)?  $default,){
final _that = this;
switch (_that) {
case _Settlement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String groundId,  String unitId,  String tenantId,  String tenantName,  DateTime moveOutDate,  double outstandingRent,  double outstandingWater,  double otherCharges,  String notes,  String status,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Settlement() when $default != null:
return $default(_that.id,_that.groundId,_that.unitId,_that.tenantId,_that.tenantName,_that.moveOutDate,_that.outstandingRent,_that.outstandingWater,_that.otherCharges,_that.notes,_that.status,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String groundId,  String unitId,  String tenantId,  String tenantName,  DateTime moveOutDate,  double outstandingRent,  double outstandingWater,  double otherCharges,  String notes,  String status,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)  $default,) {final _that = this;
switch (_that) {
case _Settlement():
return $default(_that.id,_that.groundId,_that.unitId,_that.tenantId,_that.tenantName,_that.moveOutDate,_that.outstandingRent,_that.outstandingWater,_that.otherCharges,_that.notes,_that.status,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String groundId,  String unitId,  String tenantId,  String tenantName,  DateTime moveOutDate,  double outstandingRent,  double outstandingWater,  double otherCharges,  String notes,  String status,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)?  $default,) {final _that = this;
switch (_that) {
case _Settlement() when $default != null:
return $default(_that.id,_that.groundId,_that.unitId,_that.tenantId,_that.tenantName,_that.moveOutDate,_that.outstandingRent,_that.outstandingWater,_that.otherCharges,_that.notes,_that.status,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Settlement extends Settlement {
  const _Settlement({required this.id, required this.groundId, required this.unitId, required this.tenantId, required this.tenantName, required this.moveOutDate, this.outstandingRent = 0, this.outstandingWater = 0, this.otherCharges = 0, this.notes = '', required this.status, required this.createdAt, required this.updatedAt, required this.updatedBy, this.schemaVersion = 1}): super._();
  factory _Settlement.fromJson(Map<String, dynamic> json) => _$SettlementFromJson(json);

@override final  String id;
@override final  String groundId;
@override final  String unitId;
@override final  String tenantId;
@override final  String tenantName;
@override final  DateTime moveOutDate;
@override@JsonKey() final  double outstandingRent;
@override@JsonKey() final  double outstandingWater;
@override@JsonKey() final  double otherCharges;
@override@JsonKey() final  String notes;
@override final  String status;
// "settled", "pending", "waived"
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String updatedBy;
@override@JsonKey() final  int schemaVersion;

/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettlementCopyWith<_Settlement> get copyWith => __$SettlementCopyWithImpl<_Settlement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettlementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Settlement&&(identical(other.id, id) || other.id == id)&&(identical(other.groundId, groundId) || other.groundId == groundId)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.tenantId, tenantId) || other.tenantId == tenantId)&&(identical(other.tenantName, tenantName) || other.tenantName == tenantName)&&(identical(other.moveOutDate, moveOutDate) || other.moveOutDate == moveOutDate)&&(identical(other.outstandingRent, outstandingRent) || other.outstandingRent == outstandingRent)&&(identical(other.outstandingWater, outstandingWater) || other.outstandingWater == outstandingWater)&&(identical(other.otherCharges, otherCharges) || other.otherCharges == otherCharges)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groundId,unitId,tenantId,tenantName,moveOutDate,outstandingRent,outstandingWater,otherCharges,notes,status,createdAt,updatedAt,updatedBy,schemaVersion);

@override
String toString() {
  return 'Settlement(id: $id, groundId: $groundId, unitId: $unitId, tenantId: $tenantId, tenantName: $tenantName, moveOutDate: $moveOutDate, outstandingRent: $outstandingRent, outstandingWater: $outstandingWater, otherCharges: $otherCharges, notes: $notes, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class _$SettlementCopyWith<$Res> implements $SettlementCopyWith<$Res> {
  factory _$SettlementCopyWith(_Settlement value, $Res Function(_Settlement) _then) = __$SettlementCopyWithImpl;
@override @useResult
$Res call({
 String id, String groundId, String unitId, String tenantId, String tenantName, DateTime moveOutDate, double outstandingRent, double outstandingWater, double otherCharges, String notes, String status, DateTime createdAt, DateTime updatedAt, String updatedBy, int schemaVersion
});




}
/// @nodoc
class __$SettlementCopyWithImpl<$Res>
    implements _$SettlementCopyWith<$Res> {
  __$SettlementCopyWithImpl(this._self, this._then);

  final _Settlement _self;
  final $Res Function(_Settlement) _then;

/// Create a copy of Settlement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? groundId = null,Object? unitId = null,Object? tenantId = null,Object? tenantName = null,Object? moveOutDate = null,Object? outstandingRent = null,Object? outstandingWater = null,Object? otherCharges = null,Object? notes = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,Object? updatedBy = null,Object? schemaVersion = null,}) {
  return _then(_Settlement(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groundId: null == groundId ? _self.groundId : groundId // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,tenantId: null == tenantId ? _self.tenantId : tenantId // ignore: cast_nullable_to_non_nullable
as String,tenantName: null == tenantName ? _self.tenantName : tenantName // ignore: cast_nullable_to_non_nullable
as String,moveOutDate: null == moveOutDate ? _self.moveOutDate : moveOutDate // ignore: cast_nullable_to_non_nullable
as DateTime,outstandingRent: null == outstandingRent ? _self.outstandingRent : outstandingRent // ignore: cast_nullable_to_non_nullable
as double,outstandingWater: null == outstandingWater ? _self.outstandingWater : outstandingWater // ignore: cast_nullable_to_non_nullable
as double,otherCharges: null == otherCharges ? _self.otherCharges : otherCharges // ignore: cast_nullable_to_non_nullable
as double,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
