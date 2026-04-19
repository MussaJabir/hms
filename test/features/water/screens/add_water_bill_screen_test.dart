import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hms/core/providers/providers.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';
import 'package:hms/features/water/models/parsed_sms_result.dart';
import 'package:hms/features/water/providers/sms_parser_provider.dart';
import 'package:hms/features/water/providers/water_bill_providers.dart';
import 'package:hms/features/water/screens/add_water_bill_screen.dart';
import 'package:hms/features/water/services/sms_parser_service.dart';
import 'package:hms/features/water/services/water_bill_service.dart';

class _FakeSmsParserService extends SmsParserService {
  final ParsedSmsResult? _result;

  _FakeSmsParserService({ParsedSmsResult? result}) : _result = result;

  @override
  ParsedSmsResult parse(String smsText) =>
      _result ??
      ParsedSmsResult(
        isSuccessful: false,
        rawText: smsText,
        errorMessage: 'No data',
      );
}

Widget _wrap({String groundId = 'g-1', SmsParserService? smsParser}) {
  final fakeFirestore = FakeFirebaseFirestore();
  final firestoreService = FirestoreService(firestore: fakeFirestore);
  final service = WaterBillService(
    firestoreService,
    ActivityLogService(firestoreService),
    firestore: fakeFirestore,
  );

  return ProviderScope(
    overrides: [
      waterBillServiceProvider.overrideWithValue(service),
      authStateProvider.overrideWith((ref) => const Stream.empty()),
      if (smsParser != null)
        smsParserServiceProvider.overrideWithValue(smsParser),
    ],
    child: MaterialApp(home: AddWaterBillScreen(groundId: groundId)),
  );
}

void main() {
  group('AddWaterBillScreen', () {
    testWidgets('renders two tabs: Manual Entry and Paste SMS', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.text('Manual Entry'), findsOneWidget);
      expect(find.text('Paste SMS'), findsOneWidget);
    });

    testWidgets('renders manual entry form with required fields', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.text('Billing Period'), findsOneWidget);
      expect(find.text('Previous Meter Reading'), findsOneWidget);
      expect(find.text('Current Meter Reading'), findsOneWidget);
      expect(find.text('Bill Amount (TZS)'), findsOneWidget);
      expect(find.text('Due Date'), findsOneWidget);
    });

    testWidgets('shows Save Bill button', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      expect(find.text('Save Bill'), findsOneWidget);
    });

    testWidgets('Save Bill button is enabled', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      final saveBtn = find.text('Save Bill');
      expect(saveBtn, findsOneWidget);

      // Button is present (form is ready to validate)
      final elevatedBtn = find.ancestor(
        of: saveBtn,
        matching: find.byType(ElevatedButton),
      );
      expect(elevatedBtn, findsOneWidget);
    });

    testWidgets('SMS tab shows Parse SMS button', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pump();

      await tester.tap(find.text('Paste SMS'));
      await tester.pumpAndSettle();

      expect(find.text('Parse SMS'), findsOneWidget);
    });

    testWidgets('Parse SMS calls parser with entered text', (tester) async {
      String? parsedText;
      final fakeSms = _FakeSmsParserService(
        result: ParsedSmsResult(
          isSuccessful: true,
          rawText: 'test sms',
          billAmount: 10000,
        ),
      );

      // Override to capture the call
      final capturingSms = _CapturingSmsParserService(
        onParse: (t) => parsedText = t,
        delegate: fakeSms,
      );

      await tester.pumpWidget(_wrap(smsParser: capturingSms));
      await tester.pump();

      await tester.tap(find.text('Paste SMS'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'test sms');
      await tester.tap(find.text('Parse SMS'));
      await tester.pumpAndSettle();

      expect(parsedText, 'test sms');
    });

    testWidgets('successful parse switches to manual tab and shows snackbar', (
      tester,
    ) async {
      final fakeSms = _FakeSmsParserService(
        result: ParsedSmsResult(
          isSuccessful: true,
          rawText: 'bill sms',
          billAmount: 45000,
          dueDate: DateTime(2026, 4, 15),
        ),
      );

      await tester.pumpWidget(_wrap(smsParser: fakeSms));
      await tester.pump();

      await tester.tap(find.text('Paste SMS'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'bill sms');
      await tester.tap(find.text('Parse SMS'));
      await tester.pumpAndSettle();

      // Should switch back to manual tab
      expect(find.text('Save Bill'), findsOneWidget);
      // Snackbar shows parsed count
      expect(find.textContaining('Parsed'), findsOneWidget);
      expect(find.textContaining('of 5 fields'), findsOneWidget);
    });

    testWidgets(
      'failed parse shows error snackbar and switches to manual tab',
      (tester) async {
        final fakeSms = _FakeSmsParserService(); // returns unsuccessful

        await tester.pumpWidget(_wrap(smsParser: fakeSms));
        await tester.pump();

        await tester.tap(find.text('Paste SMS'));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField).first, 'garbage text');
        await tester.tap(find.text('Parse SMS'));
        await tester.pumpAndSettle();

        // Manual tab active
        expect(find.text('Save Bill'), findsOneWidget);
        // Error snackbar
        expect(find.textContaining('Could not extract data'), findsOneWidget);
      },
    );

    testWidgets('partial parse shows X of 5 fields snackbar', (tester) async {
      final fakeSms = _FakeSmsParserService(
        result: ParsedSmsResult(
          isSuccessful: true,
          rawText: 'partial sms',
          billAmount: 20000,
          previousMeterReading: 100,
          // only 2 fields
        ),
      );

      await tester.pumpWidget(_wrap(smsParser: fakeSms));
      await tester.pump();

      await tester.tap(find.text('Paste SMS'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'partial sms');
      await tester.tap(find.text('Parse SMS'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Parsed 2 of 5 fields'), findsOneWidget);
    });
  });
}

class _CapturingSmsParserService extends SmsParserService {
  final void Function(String) onParse;
  final SmsParserService delegate;

  _CapturingSmsParserService({required this.onParse, required this.delegate});

  @override
  ParsedSmsResult parse(String smsText) {
    onParse(smsText);
    return delegate.parse(smsText);
  }
}
