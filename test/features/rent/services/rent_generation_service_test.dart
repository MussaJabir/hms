import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/core/services/recurring_transaction_service.dart';
import 'package:hms/features/rent/services/rent_generation_service.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late ActivityLogService activityLogService;
  late RecurringTransactionService recurringService;
  late RentGenerationService rentGenerationService;

  const userId = 'user-1';

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
    activityLogService = ActivityLogService(firestoreService);
    recurringService = RecurringTransactionService(
      firestoreService,
      activityLogService,
    );
    rentGenerationService = RentGenerationService(
      recurringService,
      activityLogService,
    );
  });

  Future<void> seedRentConfig({
    required String id,
    required String tenantId,
    required String collectionPath,
    double amount = 300000,
    bool isActive = true,
  }) async {
    await fakeFirestore.collection('recurring_configs').doc(id).set({
      'id': id,
      'type': 'rent',
      'linkedEntityId': tenantId,
      'linkedEntityName': 'John Doe — Room 1',
      'collectionPath': collectionPath,
      'amount': amount,
      'frequency': 'monthly',
      'dayOfMonth': 1,
      'isActive': isActive,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
      'updatedBy': userId,
      'schemaVersion': 1,
    });
  }

  group('RentGenerationService.getCurrentPeriod', () {
    test('returns YYYY-MM format for today', () {
      final period = rentGenerationService.getCurrentPeriod();
      final now = DateTime.now();
      final expected = '${now.year}-${now.month.toString().padLeft(2, '0')}';
      expect(period, equals(expected));
    });

    test('zero-pads single-digit months', () {
      // January would be "2026-01", not "2026-1"
      final period = rentGenerationService.getCurrentPeriod();
      expect(period, matches(RegExp(r'^\d{4}-\d{2}$')));
    });
  });

  group('RentGenerationService.generateCurrentMonth', () {
    test('calls RecurringTransactionService and returns rent count', () async {
      await seedRentConfig(
        id: 'rent_tenant-1',
        tenantId: 'tenant-1',
        collectionPath: 'grounds/g-1/rental_units/u-1/rent_payments',
      );

      final count = await rentGenerationService.generateCurrentMonth(
        userId: userId,
      );

      // One rent config seeded → should create 1 rent record
      expect(count, equals(1));
    });

    test('is idempotent — second call creates 0 records', () async {
      await seedRentConfig(
        id: 'rent_tenant-1',
        tenantId: 'tenant-1',
        collectionPath: 'grounds/g-1/rental_units/u-1/rent_payments',
      );

      await rentGenerationService.generateCurrentMonth(userId: userId);
      final secondCount = await rentGenerationService.generateCurrentMonth(
        userId: userId,
      );

      expect(secondCount, equals(0));
    });

    test('does not create records for inactive configs', () async {
      await seedRentConfig(
        id: 'rent_tenant-inactive',
        tenantId: 'tenant-inactive',
        collectionPath: 'grounds/g-1/rental_units/u-2/rent_payments',
        isActive: false,
      );

      final count = await rentGenerationService.generateCurrentMonth(
        userId: userId,
      );

      expect(count, equals(0));
    });
  });

  group('RentGenerationService.generateForMonth', () {
    test('generates records for a specific past month', () async {
      await seedRentConfig(
        id: 'rent_tenant-1',
        tenantId: 'tenant-1',
        collectionPath: 'grounds/g-1/rental_units/u-1/rent_payments',
      );

      final count = await rentGenerationService.generateForMonth(
        userId: userId,
        year: 2026,
        month: 1,
      );

      expect(count, equals(1));
    });
  });

  group('RentGenerationService.isCurrentMonthGenerated', () {
    test('returns false when no records exist', () async {
      final result = await rentGenerationService.isCurrentMonthGenerated();
      expect(result, isFalse);
    });

    test('returns true after generating current month', () async {
      await seedRentConfig(
        id: 'rent_tenant-1',
        tenantId: 'tenant-1',
        collectionPath: 'grounds/g-1/rental_units/u-1/rent_payments',
      );

      await rentGenerationService.generateCurrentMonth(userId: userId);

      final result = await rentGenerationService.isCurrentMonthGenerated();
      expect(result, isTrue);
    });
  });
}
