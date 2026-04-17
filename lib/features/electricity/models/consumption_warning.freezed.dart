// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consumption_warning.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConsumptionWarning {

 String get groundId; String get unitId; String get unitName; String get meterId; String get meterNumber; String? get tenantName; double get threshold; double get actualConsumption; DateTime get readingDate; AlertSeverity get severity;
/// Create a copy of ConsumptionWarning
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsumptionWarningCopyWith<ConsumptionWarning> get copyWith => _$ConsumptionWarningCopyWithImpl<ConsumptionWarning>(this as ConsumptionWarning, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsumptionWarning&&(identical(other.groundId, groundId) || other.groundId == groundId)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.unitName, unitName) || other.unitName == unitName)&&(identical(other.meterId, meterId) || other.meterId == meterId)&&(identical(other.meterNumber, meterNumber) || other.meterNumber == meterNumber)&&(identical(other.tenantName, tenantName) || other.tenantName == tenantName)&&(identical(other.threshold, threshold) || other.threshold == threshold)&&(identical(other.actualConsumption, actualConsumption) || other.actualConsumption == actualConsumption)&&(identical(other.readingDate, readingDate) || other.readingDate == readingDate)&&(identical(other.severity, severity) || other.severity == severity));
}


@override
int get hashCode => Object.hash(runtimeType,groundId,unitId,unitName,meterId,meterNumber,tenantName,threshold,actualConsumption,readingDate,severity);

@override
String toString() {
  return 'ConsumptionWarning(groundId: $groundId, unitId: $unitId, unitName: $unitName, meterId: $meterId, meterNumber: $meterNumber, tenantName: $tenantName, threshold: $threshold, actualConsumption: $actualConsumption, readingDate: $readingDate, severity: $severity)';
}


}

/// @nodoc
abstract mixin class $ConsumptionWarningCopyWith<$Res>  {
  factory $ConsumptionWarningCopyWith(ConsumptionWarning value, $Res Function(ConsumptionWarning) _then) = _$ConsumptionWarningCopyWithImpl;
@useResult
$Res call({
 String groundId, String unitId, String unitName, String meterId, String meterNumber, String? tenantName, double threshold, double actualConsumption, DateTime readingDate, AlertSeverity severity
});




}
/// @nodoc
class _$ConsumptionWarningCopyWithImpl<$Res>
    implements $ConsumptionWarningCopyWith<$Res> {
  _$ConsumptionWarningCopyWithImpl(this._self, this._then);

  final ConsumptionWarning _self;
  final $Res Function(ConsumptionWarning) _then;

/// Create a copy of ConsumptionWarning
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? groundId = null,Object? unitId = null,Object? unitName = null,Object? meterId = null,Object? meterNumber = null,Object? tenantName = freezed,Object? threshold = null,Object? actualConsumption = null,Object? readingDate = null,Object? severity = null,}) {
  return _then(_self.copyWith(
groundId: null == groundId ? _self.groundId : groundId // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,unitName: null == unitName ? _self.unitName : unitName // ignore: cast_nullable_to_non_nullable
as String,meterId: null == meterId ? _self.meterId : meterId // ignore: cast_nullable_to_non_nullable
as String,meterNumber: null == meterNumber ? _self.meterNumber : meterNumber // ignore: cast_nullable_to_non_nullable
as String,tenantName: freezed == tenantName ? _self.tenantName : tenantName // ignore: cast_nullable_to_non_nullable
as String?,threshold: null == threshold ? _self.threshold : threshold // ignore: cast_nullable_to_non_nullable
as double,actualConsumption: null == actualConsumption ? _self.actualConsumption : actualConsumption // ignore: cast_nullable_to_non_nullable
as double,readingDate: null == readingDate ? _self.readingDate : readingDate // ignore: cast_nullable_to_non_nullable
as DateTime,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as AlertSeverity,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsumptionWarning].
extension ConsumptionWarningPatterns on ConsumptionWarning {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsumptionWarning value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsumptionWarning() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsumptionWarning value)  $default,){
final _that = this;
switch (_that) {
case _ConsumptionWarning():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsumptionWarning value)?  $default,){
final _that = this;
switch (_that) {
case _ConsumptionWarning() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String groundId,  String unitId,  String unitName,  String meterId,  String meterNumber,  String? tenantName,  double threshold,  double actualConsumption,  DateTime readingDate,  AlertSeverity severity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsumptionWarning() when $default != null:
return $default(_that.groundId,_that.unitId,_that.unitName,_that.meterId,_that.meterNumber,_that.tenantName,_that.threshold,_that.actualConsumption,_that.readingDate,_that.severity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String groundId,  String unitId,  String unitName,  String meterId,  String meterNumber,  String? tenantName,  double threshold,  double actualConsumption,  DateTime readingDate,  AlertSeverity severity)  $default,) {final _that = this;
switch (_that) {
case _ConsumptionWarning():
return $default(_that.groundId,_that.unitId,_that.unitName,_that.meterId,_that.meterNumber,_that.tenantName,_that.threshold,_that.actualConsumption,_that.readingDate,_that.severity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String groundId,  String unitId,  String unitName,  String meterId,  String meterNumber,  String? tenantName,  double threshold,  double actualConsumption,  DateTime readingDate,  AlertSeverity severity)?  $default,) {final _that = this;
switch (_that) {
case _ConsumptionWarning() when $default != null:
return $default(_that.groundId,_that.unitId,_that.unitName,_that.meterId,_that.meterNumber,_that.tenantName,_that.threshold,_that.actualConsumption,_that.readingDate,_that.severity);case _:
  return null;

}
}

}

/// @nodoc


class _ConsumptionWarning extends ConsumptionWarning {
  const _ConsumptionWarning({required this.groundId, required this.unitId, required this.unitName, required this.meterId, required this.meterNumber, this.tenantName, required this.threshold, required this.actualConsumption, required this.readingDate, required this.severity}): super._();
  

@override final  String groundId;
@override final  String unitId;
@override final  String unitName;
@override final  String meterId;
@override final  String meterNumber;
@override final  String? tenantName;
@override final  double threshold;
@override final  double actualConsumption;
@override final  DateTime readingDate;
@override final  AlertSeverity severity;

/// Create a copy of ConsumptionWarning
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsumptionWarningCopyWith<_ConsumptionWarning> get copyWith => __$ConsumptionWarningCopyWithImpl<_ConsumptionWarning>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsumptionWarning&&(identical(other.groundId, groundId) || other.groundId == groundId)&&(identical(other.unitId, unitId) || other.unitId == unitId)&&(identical(other.unitName, unitName) || other.unitName == unitName)&&(identical(other.meterId, meterId) || other.meterId == meterId)&&(identical(other.meterNumber, meterNumber) || other.meterNumber == meterNumber)&&(identical(other.tenantName, tenantName) || other.tenantName == tenantName)&&(identical(other.threshold, threshold) || other.threshold == threshold)&&(identical(other.actualConsumption, actualConsumption) || other.actualConsumption == actualConsumption)&&(identical(other.readingDate, readingDate) || other.readingDate == readingDate)&&(identical(other.severity, severity) || other.severity == severity));
}


@override
int get hashCode => Object.hash(runtimeType,groundId,unitId,unitName,meterId,meterNumber,tenantName,threshold,actualConsumption,readingDate,severity);

@override
String toString() {
  return 'ConsumptionWarning(groundId: $groundId, unitId: $unitId, unitName: $unitName, meterId: $meterId, meterNumber: $meterNumber, tenantName: $tenantName, threshold: $threshold, actualConsumption: $actualConsumption, readingDate: $readingDate, severity: $severity)';
}


}

/// @nodoc
abstract mixin class _$ConsumptionWarningCopyWith<$Res> implements $ConsumptionWarningCopyWith<$Res> {
  factory _$ConsumptionWarningCopyWith(_ConsumptionWarning value, $Res Function(_ConsumptionWarning) _then) = __$ConsumptionWarningCopyWithImpl;
@override @useResult
$Res call({
 String groundId, String unitId, String unitName, String meterId, String meterNumber, String? tenantName, double threshold, double actualConsumption, DateTime readingDate, AlertSeverity severity
});




}
/// @nodoc
class __$ConsumptionWarningCopyWithImpl<$Res>
    implements _$ConsumptionWarningCopyWith<$Res> {
  __$ConsumptionWarningCopyWithImpl(this._self, this._then);

  final _ConsumptionWarning _self;
  final $Res Function(_ConsumptionWarning) _then;

/// Create a copy of ConsumptionWarning
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? groundId = null,Object? unitId = null,Object? unitName = null,Object? meterId = null,Object? meterNumber = null,Object? tenantName = freezed,Object? threshold = null,Object? actualConsumption = null,Object? readingDate = null,Object? severity = null,}) {
  return _then(_ConsumptionWarning(
groundId: null == groundId ? _self.groundId : groundId // ignore: cast_nullable_to_non_nullable
as String,unitId: null == unitId ? _self.unitId : unitId // ignore: cast_nullable_to_non_nullable
as String,unitName: null == unitName ? _self.unitName : unitName // ignore: cast_nullable_to_non_nullable
as String,meterId: null == meterId ? _self.meterId : meterId // ignore: cast_nullable_to_non_nullable
as String,meterNumber: null == meterNumber ? _self.meterNumber : meterNumber // ignore: cast_nullable_to_non_nullable
as String,tenantName: freezed == tenantName ? _self.tenantName : tenantName // ignore: cast_nullable_to_non_nullable
as String?,threshold: null == threshold ? _self.threshold : threshold // ignore: cast_nullable_to_non_nullable
as double,actualConsumption: null == actualConsumption ? _self.actualConsumption : actualConsumption // ignore: cast_nullable_to_non_nullable
as double,readingDate: null == readingDate ? _self.readingDate : readingDate // ignore: cast_nullable_to_non_nullable
as DateTime,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as AlertSeverity,
  ));
}


}

// dart format on
