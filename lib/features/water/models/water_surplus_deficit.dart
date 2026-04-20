import 'package:freezed_annotation/freezed_annotation.dart';

part 'water_surplus_deficit.freezed.dart';

@freezed
abstract class WaterSurplusDeficit with _$WaterSurplusDeficit {
  const WaterSurplusDeficit._();

  const factory WaterSurplusDeficit({
    required String period,
    required String groundId,
    required double totalCollected,
    required double actualBillAmount,
    required int totalTenants,
    required int paidTenants,
  }) = _WaterSurplusDeficit;

  double get surplusDeficit => totalCollected - actualBillAmount;
  bool get isSurplus => surplusDeficit >= 0;
  bool get isDeficit => surplusDeficit < 0;
  double get collectionRate =>
      totalTenants > 0 ? (paidTenants / totalTenants * 100) : 0;
}
