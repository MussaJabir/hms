import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/widgets/widgets.dart';

void main() {
  group('widgets.dart barrel export', () {
    test('AppCard is exported', () {
      expect(AppCard, isNotNull);
    });

    test('AppCardShimmer is exported', () {
      expect(AppCardShimmer, isNotNull);
    });

    test('AlertCard is exported', () {
      expect(AlertCard, isNotNull);
    });

    test('AlertSeverity is exported', () {
      expect(AlertSeverity.values, isNotEmpty);
    });

    test('SummaryTile is exported', () {
      expect(SummaryTile, isNotNull);
    });

    test('StatusBadge is exported', () {
      expect(StatusBadge, isNotNull);
    });

    test('PaymentStatus is exported', () {
      expect(PaymentStatus.values, isNotEmpty);
    });

    test('EmptyState is exported', () {
      expect(EmptyState, isNotNull);
    });

    test('EmptyStatePresets is exported', () {
      expect(EmptyStatePresets, isNotNull);
    });

    test('ShimmerList is exported', () {
      expect(ShimmerList, isNotNull);
    });

    test('OfflineBanner is exported', () {
      expect(OfflineBanner, isNotNull);
    });

    test('ConnectionStatus is exported', () {
      expect(ConnectionStatus, isNotNull);
    });

    test('HmsTextField is exported', () {
      expect(HmsTextField, isNotNull);
    });

    test('HmsCurrencyField is exported', () {
      expect(HmsCurrencyField, isNotNull);
    });
  });
}
