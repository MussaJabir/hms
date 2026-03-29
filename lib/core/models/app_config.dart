import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config.freezed.dart';
part 'app_config.g.dart';

@freezed
abstract class AppConfig with _$AppConfig {
  const factory AppConfig({
    required String id,
    @Default([]) List<TanescoTier> tanescoTiers,
    @Default(0) double defaultWaterContribution,
    required DateTime updatedAt,
    required String updatedBy,
    @Default(1) int schemaVersion,
  }) = _AppConfig;

  factory AppConfig.fromJson(Map<String, dynamic> json) =>
      _$AppConfigFromJson(json);
}

@freezed
abstract class TanescoTier with _$TanescoTier {
  const factory TanescoTier({
    required double minUnits,
    required double maxUnits,
    required double ratePerUnit, // TZS per unit
  }) = _TanescoTier;

  factory TanescoTier.fromJson(Map<String, dynamic> json) =>
      _$TanescoTierFromJson(json);
}
