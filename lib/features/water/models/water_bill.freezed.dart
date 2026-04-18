// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'water_bill.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WaterBill {

 String get id; String get groundId; String get billingPeriod; double get previousMeterReading; double get currentMeterReading; double get totalAmount; DateTime get dueDate; String get status; DateTime? get paidDate; String? get paymentMethod; String? get rawSmsText; String get notes; DateTime get createdAt; DateTime get updatedAt; String get updatedBy; int get schemaVersion;
/// Create a copy of WaterBill
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WaterBillCopyWith<WaterBill> get copyWith => _$WaterBillCopyWithImpl<WaterBill>(this as WaterBill, _$identity);

  /// Serializes this WaterBill to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WaterBill&&(identical(other.id, id) || other.id == id)&&(identical(other.groundId, groundId) || other.groundId == groundId)&&(identical(other.billingPeriod, billingPeriod) || other.billingPeriod == billingPeriod)&&(identical(other.previousMeterReading, previousMeterReading) || other.previousMeterReading == previousMeterReading)&&(identical(other.currentMeterReading, currentMeterReading) || other.currentMeterReading == currentMeterReading)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.paidDate, paidDate) || other.paidDate == paidDate)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.rawSmsText, rawSmsText) || other.rawSmsText == rawSmsText)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groundId,billingPeriod,previousMeterReading,currentMeterReading,totalAmount,dueDate,status,paidDate,paymentMethod,rawSmsText,notes,createdAt,updatedAt,updatedBy,schemaVersion);

@override
String toString() {
  return 'WaterBill(id: $id, groundId: $groundId, billingPeriod: $billingPeriod, previousMeterReading: $previousMeterReading, currentMeterReading: $currentMeterReading, totalAmount: $totalAmount, dueDate: $dueDate, status: $status, paidDate: $paidDate, paymentMethod: $paymentMethod, rawSmsText: $rawSmsText, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class $WaterBillCopyWith<$Res>  {
  factory $WaterBillCopyWith(WaterBill value, $Res Function(WaterBill) _then) = _$WaterBillCopyWithImpl;
@useResult
$Res call({
 String id, String groundId, String billingPeriod, double previousMeterReading, double currentMeterReading, double totalAmount, DateTime dueDate, String status, DateTime? paidDate, String? paymentMethod, String? rawSmsText, String notes, DateTime createdAt, DateTime updatedAt, String updatedBy, int schemaVersion
});




}
/// @nodoc
class _$WaterBillCopyWithImpl<$Res>
    implements $WaterBillCopyWith<$Res> {
  _$WaterBillCopyWithImpl(this._self, this._then);

  final WaterBill _self;
  final $Res Function(WaterBill) _then;

/// Create a copy of WaterBill
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? groundId = null,Object? billingPeriod = null,Object? previousMeterReading = null,Object? currentMeterReading = null,Object? totalAmount = null,Object? dueDate = null,Object? status = null,Object? paidDate = freezed,Object? paymentMethod = freezed,Object? rawSmsText = freezed,Object? notes = null,Object? createdAt = null,Object? updatedAt = null,Object? updatedBy = null,Object? schemaVersion = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groundId: null == groundId ? _self.groundId : groundId // ignore: cast_nullable_to_non_nullable
as String,billingPeriod: null == billingPeriod ? _self.billingPeriod : billingPeriod // ignore: cast_nullable_to_non_nullable
as String,previousMeterReading: null == previousMeterReading ? _self.previousMeterReading : previousMeterReading // ignore: cast_nullable_to_non_nullable
as double,currentMeterReading: null == currentMeterReading ? _self.currentMeterReading : currentMeterReading // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,paidDate: freezed == paidDate ? _self.paidDate : paidDate // ignore: cast_nullable_to_non_nullable
as DateTime?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,rawSmsText: freezed == rawSmsText ? _self.rawSmsText : rawSmsText // ignore: cast_nullable_to_non_nullable
as String?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WaterBill].
extension WaterBillPatterns on WaterBill {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WaterBill value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WaterBill() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WaterBill value)  $default,){
final _that = this;
switch (_that) {
case _WaterBill():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WaterBill value)?  $default,){
final _that = this;
switch (_that) {
case _WaterBill() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String groundId,  String billingPeriod,  double previousMeterReading,  double currentMeterReading,  double totalAmount,  DateTime dueDate,  String status,  DateTime? paidDate,  String? paymentMethod,  String? rawSmsText,  String notes,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WaterBill() when $default != null:
return $default(_that.id,_that.groundId,_that.billingPeriod,_that.previousMeterReading,_that.currentMeterReading,_that.totalAmount,_that.dueDate,_that.status,_that.paidDate,_that.paymentMethod,_that.rawSmsText,_that.notes,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String groundId,  String billingPeriod,  double previousMeterReading,  double currentMeterReading,  double totalAmount,  DateTime dueDate,  String status,  DateTime? paidDate,  String? paymentMethod,  String? rawSmsText,  String notes,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)  $default,) {final _that = this;
switch (_that) {
case _WaterBill():
return $default(_that.id,_that.groundId,_that.billingPeriod,_that.previousMeterReading,_that.currentMeterReading,_that.totalAmount,_that.dueDate,_that.status,_that.paidDate,_that.paymentMethod,_that.rawSmsText,_that.notes,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String groundId,  String billingPeriod,  double previousMeterReading,  double currentMeterReading,  double totalAmount,  DateTime dueDate,  String status,  DateTime? paidDate,  String? paymentMethod,  String? rawSmsText,  String notes,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)?  $default,) {final _that = this;
switch (_that) {
case _WaterBill() when $default != null:
return $default(_that.id,_that.groundId,_that.billingPeriod,_that.previousMeterReading,_that.currentMeterReading,_that.totalAmount,_that.dueDate,_that.status,_that.paidDate,_that.paymentMethod,_that.rawSmsText,_that.notes,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WaterBill extends WaterBill {
  const _WaterBill({required this.id, required this.groundId, required this.billingPeriod, required this.previousMeterReading, required this.currentMeterReading, required this.totalAmount, required this.dueDate, required this.status, this.paidDate, this.paymentMethod, this.rawSmsText, this.notes = '', required this.createdAt, required this.updatedAt, required this.updatedBy, this.schemaVersion = 1}): super._();
  factory _WaterBill.fromJson(Map<String, dynamic> json) => _$WaterBillFromJson(json);

@override final  String id;
@override final  String groundId;
@override final  String billingPeriod;
@override final  double previousMeterReading;
@override final  double currentMeterReading;
@override final  double totalAmount;
@override final  DateTime dueDate;
@override final  String status;
@override final  DateTime? paidDate;
@override final  String? paymentMethod;
@override final  String? rawSmsText;
@override@JsonKey() final  String notes;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String updatedBy;
@override@JsonKey() final  int schemaVersion;

/// Create a copy of WaterBill
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WaterBillCopyWith<_WaterBill> get copyWith => __$WaterBillCopyWithImpl<_WaterBill>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WaterBillToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WaterBill&&(identical(other.id, id) || other.id == id)&&(identical(other.groundId, groundId) || other.groundId == groundId)&&(identical(other.billingPeriod, billingPeriod) || other.billingPeriod == billingPeriod)&&(identical(other.previousMeterReading, previousMeterReading) || other.previousMeterReading == previousMeterReading)&&(identical(other.currentMeterReading, currentMeterReading) || other.currentMeterReading == currentMeterReading)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.paidDate, paidDate) || other.paidDate == paidDate)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.rawSmsText, rawSmsText) || other.rawSmsText == rawSmsText)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,groundId,billingPeriod,previousMeterReading,currentMeterReading,totalAmount,dueDate,status,paidDate,paymentMethod,rawSmsText,notes,createdAt,updatedAt,updatedBy,schemaVersion);

@override
String toString() {
  return 'WaterBill(id: $id, groundId: $groundId, billingPeriod: $billingPeriod, previousMeterReading: $previousMeterReading, currentMeterReading: $currentMeterReading, totalAmount: $totalAmount, dueDate: $dueDate, status: $status, paidDate: $paidDate, paymentMethod: $paymentMethod, rawSmsText: $rawSmsText, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class _$WaterBillCopyWith<$Res> implements $WaterBillCopyWith<$Res> {
  factory _$WaterBillCopyWith(_WaterBill value, $Res Function(_WaterBill) _then) = __$WaterBillCopyWithImpl;
@override @useResult
$Res call({
 String id, String groundId, String billingPeriod, double previousMeterReading, double currentMeterReading, double totalAmount, DateTime dueDate, String status, DateTime? paidDate, String? paymentMethod, String? rawSmsText, String notes, DateTime createdAt, DateTime updatedAt, String updatedBy, int schemaVersion
});




}
/// @nodoc
class __$WaterBillCopyWithImpl<$Res>
    implements _$WaterBillCopyWith<$Res> {
  __$WaterBillCopyWithImpl(this._self, this._then);

  final _WaterBill _self;
  final $Res Function(_WaterBill) _then;

/// Create a copy of WaterBill
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? groundId = null,Object? billingPeriod = null,Object? previousMeterReading = null,Object? currentMeterReading = null,Object? totalAmount = null,Object? dueDate = null,Object? status = null,Object? paidDate = freezed,Object? paymentMethod = freezed,Object? rawSmsText = freezed,Object? notes = null,Object? createdAt = null,Object? updatedAt = null,Object? updatedBy = null,Object? schemaVersion = null,}) {
  return _then(_WaterBill(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,groundId: null == groundId ? _self.groundId : groundId // ignore: cast_nullable_to_non_nullable
as String,billingPeriod: null == billingPeriod ? _self.billingPeriod : billingPeriod // ignore: cast_nullable_to_non_nullable
as String,previousMeterReading: null == previousMeterReading ? _self.previousMeterReading : previousMeterReading // ignore: cast_nullable_to_non_nullable
as double,currentMeterReading: null == currentMeterReading ? _self.currentMeterReading : currentMeterReading // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,paidDate: freezed == paidDate ? _self.paidDate : paidDate // ignore: cast_nullable_to_non_nullable
as DateTime?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,rawSmsText: freezed == rawSmsText ? _self.rawSmsText : rawSmsText // ignore: cast_nullable_to_non_nullable
as String?,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
