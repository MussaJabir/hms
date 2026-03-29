// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppConfig _$AppConfigFromJson(Map<String, dynamic> json) => _AppConfig(
  id: json['id'] as String,
  tanescoTiers:
      (json['tanescoTiers'] as List<dynamic>?)
          ?.map((e) => TanescoTier.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  defaultWaterContribution:
      (json['defaultWaterContribution'] as num?)?.toDouble() ?? 0,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  updatedBy: json['updatedBy'] as String,
  schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$AppConfigToJson(_AppConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tanescoTiers': instance.tanescoTiers.map((e) => e.toJson()).toList(),
      'defaultWaterContribution': instance.defaultWaterContribution,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'updatedBy': instance.updatedBy,
      'schemaVersion': instance.schemaVersion,
    };

_TanescoTier _$TanescoTierFromJson(Map<String, dynamic> json) => _TanescoTier(
  minUnits: (json['minUnits'] as num).toDouble(),
  maxUnits: (json['maxUnits'] as num).toDouble(),
  ratePerUnit: (json['ratePerUnit'] as num).toDouble(),
);

Map<String, dynamic> _$TanescoTierToJson(_TanescoTier instance) =>
    <String, dynamic>{
      'minUnits': instance.minUnits,
      'maxUnits': instance.maxUnits,
      'ratePerUnit': instance.ratePerUnit,
    };
