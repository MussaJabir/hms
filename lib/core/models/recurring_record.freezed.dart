// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecurringRecord {

 String get id; String get configId;// links back to the RecurringConfig that generated it
 String get type;// "rent", "water_contribution", "school_fee", etc.
 String get linkedEntityId; String get linkedEntityName; double get amount;// expected amount
 String get period;// "2026-03" format (year-month)
 String get status;// "pending", "paid", "partial", "overdue"
 double get amountPaid;// how much has been paid so far
 DateTime? get paidDate;// when it was marked paid
 String? get paymentMethod;// "cash", "mobile_money", "bank_transfer"
 String? get notes; DateTime get dueDate; DateTime get createdAt; DateTime get updatedAt; String get updatedBy; int get schemaVersion;
/// Create a copy of RecurringRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringRecordCopyWith<RecurringRecord> get copyWith => _$RecurringRecordCopyWithImpl<RecurringRecord>(this as RecurringRecord, _$identity);

  /// Serializes this RecurringRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.configId, configId) || other.configId == configId)&&(identical(other.type, type) || other.type == type)&&(identical(other.linkedEntityId, linkedEntityId) || other.linkedEntityId == linkedEntityId)&&(identical(other.linkedEntityName, linkedEntityName) || other.linkedEntityName == linkedEntityName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.period, period) || other.period == period)&&(identical(other.status, status) || other.status == status)&&(identical(other.amountPaid, amountPaid) || other.amountPaid == amountPaid)&&(identical(other.paidDate, paidDate) || other.paidDate == paidDate)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,configId,type,linkedEntityId,linkedEntityName,amount,period,status,amountPaid,paidDate,paymentMethod,notes,dueDate,createdAt,updatedAt,updatedBy,schemaVersion);

@override
String toString() {
  return 'RecurringRecord(id: $id, configId: $configId, type: $type, linkedEntityId: $linkedEntityId, linkedEntityName: $linkedEntityName, amount: $amount, period: $period, status: $status, amountPaid: $amountPaid, paidDate: $paidDate, paymentMethod: $paymentMethod, notes: $notes, dueDate: $dueDate, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class $RecurringRecordCopyWith<$Res>  {
  factory $RecurringRecordCopyWith(RecurringRecord value, $Res Function(RecurringRecord) _then) = _$RecurringRecordCopyWithImpl;
@useResult
$Res call({
 String id, String configId, String type, String linkedEntityId, String linkedEntityName, double amount, String period, String status, double amountPaid, DateTime? paidDate, String? paymentMethod, String? notes, DateTime dueDate, DateTime createdAt, DateTime updatedAt, String updatedBy, int schemaVersion
});




}
/// @nodoc
class _$RecurringRecordCopyWithImpl<$Res>
    implements $RecurringRecordCopyWith<$Res> {
  _$RecurringRecordCopyWithImpl(this._self, this._then);

  final RecurringRecord _self;
  final $Res Function(RecurringRecord) _then;

/// Create a copy of RecurringRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? configId = null,Object? type = null,Object? linkedEntityId = null,Object? linkedEntityName = null,Object? amount = null,Object? period = null,Object? status = null,Object? amountPaid = null,Object? paidDate = freezed,Object? paymentMethod = freezed,Object? notes = freezed,Object? dueDate = null,Object? createdAt = null,Object? updatedAt = null,Object? updatedBy = null,Object? schemaVersion = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,configId: null == configId ? _self.configId : configId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,linkedEntityId: null == linkedEntityId ? _self.linkedEntityId : linkedEntityId // ignore: cast_nullable_to_non_nullable
as String,linkedEntityName: null == linkedEntityName ? _self.linkedEntityName : linkedEntityName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,amountPaid: null == amountPaid ? _self.amountPaid : amountPaid // ignore: cast_nullable_to_non_nullable
as double,paidDate: freezed == paidDate ? _self.paidDate : paidDate // ignore: cast_nullable_to_non_nullable
as DateTime?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RecurringRecord].
extension RecurringRecordPatterns on RecurringRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringRecord value)  $default,){
final _that = this;
switch (_that) {
case _RecurringRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringRecord value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String configId,  String type,  String linkedEntityId,  String linkedEntityName,  double amount,  String period,  String status,  double amountPaid,  DateTime? paidDate,  String? paymentMethod,  String? notes,  DateTime dueDate,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurringRecord() when $default != null:
return $default(_that.id,_that.configId,_that.type,_that.linkedEntityId,_that.linkedEntityName,_that.amount,_that.period,_that.status,_that.amountPaid,_that.paidDate,_that.paymentMethod,_that.notes,_that.dueDate,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String configId,  String type,  String linkedEntityId,  String linkedEntityName,  double amount,  String period,  String status,  double amountPaid,  DateTime? paidDate,  String? paymentMethod,  String? notes,  DateTime dueDate,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)  $default,) {final _that = this;
switch (_that) {
case _RecurringRecord():
return $default(_that.id,_that.configId,_that.type,_that.linkedEntityId,_that.linkedEntityName,_that.amount,_that.period,_that.status,_that.amountPaid,_that.paidDate,_that.paymentMethod,_that.notes,_that.dueDate,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String configId,  String type,  String linkedEntityId,  String linkedEntityName,  double amount,  String period,  String status,  double amountPaid,  DateTime? paidDate,  String? paymentMethod,  String? notes,  DateTime dueDate,  DateTime createdAt,  DateTime updatedAt,  String updatedBy,  int schemaVersion)?  $default,) {final _that = this;
switch (_that) {
case _RecurringRecord() when $default != null:
return $default(_that.id,_that.configId,_that.type,_that.linkedEntityId,_that.linkedEntityName,_that.amount,_that.period,_that.status,_that.amountPaid,_that.paidDate,_that.paymentMethod,_that.notes,_that.dueDate,_that.createdAt,_that.updatedAt,_that.updatedBy,_that.schemaVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecurringRecord extends RecurringRecord {
  const _RecurringRecord({required this.id, required this.configId, required this.type, required this.linkedEntityId, required this.linkedEntityName, required this.amount, required this.period, required this.status, this.amountPaid = 0, this.paidDate, this.paymentMethod, this.notes, required this.dueDate, required this.createdAt, required this.updatedAt, required this.updatedBy, this.schemaVersion = 1}): super._();
  factory _RecurringRecord.fromJson(Map<String, dynamic> json) => _$RecurringRecordFromJson(json);

@override final  String id;
@override final  String configId;
// links back to the RecurringConfig that generated it
@override final  String type;
// "rent", "water_contribution", "school_fee", etc.
@override final  String linkedEntityId;
@override final  String linkedEntityName;
@override final  double amount;
// expected amount
@override final  String period;
// "2026-03" format (year-month)
@override final  String status;
// "pending", "paid", "partial", "overdue"
@override@JsonKey() final  double amountPaid;
// how much has been paid so far
@override final  DateTime? paidDate;
// when it was marked paid
@override final  String? paymentMethod;
// "cash", "mobile_money", "bank_transfer"
@override final  String? notes;
@override final  DateTime dueDate;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String updatedBy;
@override@JsonKey() final  int schemaVersion;

/// Create a copy of RecurringRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringRecordCopyWith<_RecurringRecord> get copyWith => __$RecurringRecordCopyWithImpl<_RecurringRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecurringRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.configId, configId) || other.configId == configId)&&(identical(other.type, type) || other.type == type)&&(identical(other.linkedEntityId, linkedEntityId) || other.linkedEntityId == linkedEntityId)&&(identical(other.linkedEntityName, linkedEntityName) || other.linkedEntityName == linkedEntityName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.period, period) || other.period == period)&&(identical(other.status, status) || other.status == status)&&(identical(other.amountPaid, amountPaid) || other.amountPaid == amountPaid)&&(identical(other.paidDate, paidDate) || other.paidDate == paidDate)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedBy, updatedBy) || other.updatedBy == updatedBy)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,configId,type,linkedEntityId,linkedEntityName,amount,period,status,amountPaid,paidDate,paymentMethod,notes,dueDate,createdAt,updatedAt,updatedBy,schemaVersion);

@override
String toString() {
  return 'RecurringRecord(id: $id, configId: $configId, type: $type, linkedEntityId: $linkedEntityId, linkedEntityName: $linkedEntityName, amount: $amount, period: $period, status: $status, amountPaid: $amountPaid, paidDate: $paidDate, paymentMethod: $paymentMethod, notes: $notes, dueDate: $dueDate, createdAt: $createdAt, updatedAt: $updatedAt, updatedBy: $updatedBy, schemaVersion: $schemaVersion)';
}


}

/// @nodoc
abstract mixin class _$RecurringRecordCopyWith<$Res> implements $RecurringRecordCopyWith<$Res> {
  factory _$RecurringRecordCopyWith(_RecurringRecord value, $Res Function(_RecurringRecord) _then) = __$RecurringRecordCopyWithImpl;
@override @useResult
$Res call({
 String id, String configId, String type, String linkedEntityId, String linkedEntityName, double amount, String period, String status, double amountPaid, DateTime? paidDate, String? paymentMethod, String? notes, DateTime dueDate, DateTime createdAt, DateTime updatedAt, String updatedBy, int schemaVersion
});




}
/// @nodoc
class __$RecurringRecordCopyWithImpl<$Res>
    implements _$RecurringRecordCopyWith<$Res> {
  __$RecurringRecordCopyWithImpl(this._self, this._then);

  final _RecurringRecord _self;
  final $Res Function(_RecurringRecord) _then;

/// Create a copy of RecurringRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? configId = null,Object? type = null,Object? linkedEntityId = null,Object? linkedEntityName = null,Object? amount = null,Object? period = null,Object? status = null,Object? amountPaid = null,Object? paidDate = freezed,Object? paymentMethod = freezed,Object? notes = freezed,Object? dueDate = null,Object? createdAt = null,Object? updatedAt = null,Object? updatedBy = null,Object? schemaVersion = null,}) {
  return _then(_RecurringRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,configId: null == configId ? _self.configId : configId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,linkedEntityId: null == linkedEntityId ? _self.linkedEntityId : linkedEntityId // ignore: cast_nullable_to_non_nullable
as String,linkedEntityName: null == linkedEntityName ? _self.linkedEntityName : linkedEntityName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,amountPaid: null == amountPaid ? _self.amountPaid : amountPaid // ignore: cast_nullable_to_non_nullable
as double,paidDate: freezed == paidDate ? _self.paidDate : paidDate // ignore: cast_nullable_to_non_nullable
as DateTime?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedBy: null == updatedBy ? _self.updatedBy : updatedBy // ignore: cast_nullable_to_non_nullable
as String,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
