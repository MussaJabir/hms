import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/rent/services/rent_income_link_service.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late RentIncomeLinkService service;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
    service = RentIncomeLinkService(firestoreService);
  });

  group('RentIncomeLinkService.createIncomeFromRentPayment', () {
    test('creates income document with correct fields', () async {
      await service.createIncomeFromRentPayment(
        groundId: 'g-1',
        tenantId: 'tenant-1',
        tenantName: 'John Doe',
        unitName: 'u-1',
        rentRecordId: 'record-1',
        amount: 300000,
        userId: 'user-1',
      );

      final docs = await fakeFirestore.collection('incomes').get();
      expect(docs.docs.length, equals(1));

      final data = docs.docs.first.data();
      expect(data['source'], equals('rent'));
      expect(data['description'], equals('Rent from John Doe — u-1'));
      expect(data['amount'], equals(300000.0));
      expect(data['groundId'], equals('g-1'));
      expect(data['linkedTenantId'], equals('tenant-1'));
      expect(data['linkedRentRecordId'], equals('record-1'));
      expect(data['date'], isA<String>());
    });

    test('stores date in YYYY-MM-DD format', () async {
      await service.createIncomeFromRentPayment(
        groundId: 'g-1',
        tenantId: 'tenant-1',
        tenantName: 'Jane',
        unitName: 'u-2',
        rentRecordId: 'record-2',
        amount: 150000,
        userId: 'user-1',
      );

      final docs = await fakeFirestore.collection('incomes').get();
      final data = docs.docs.first.data();
      final date = data['date'] as String;

      // Should match YYYY-MM-DD
      expect(RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date), isTrue);
    });

    test('each call creates a separate document', () async {
      await service.createIncomeFromRentPayment(
        groundId: 'g-1',
        tenantId: 'tenant-1',
        tenantName: 'Alice',
        unitName: 'u-1',
        rentRecordId: 'rec-1',
        amount: 300000,
        userId: 'user-1',
      );
      await service.createIncomeFromRentPayment(
        groundId: 'g-1',
        tenantId: 'tenant-2',
        tenantName: 'Bob',
        unitName: 'u-2',
        rentRecordId: 'rec-2',
        amount: 250000,
        userId: 'user-1',
      );

      final docs = await fakeFirestore.collection('incomes').get();
      expect(docs.docs.length, equals(2));
    });
  });
}
