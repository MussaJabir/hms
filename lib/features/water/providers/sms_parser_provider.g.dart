// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_parser_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(smsParserService)
final smsParserServiceProvider = SmsParserServiceProvider._();

final class SmsParserServiceProvider
    extends
        $FunctionalProvider<
          SmsParserService,
          SmsParserService,
          SmsParserService
        >
    with $Provider<SmsParserService> {
  SmsParserServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'smsParserServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$smsParserServiceHash();

  @$internal
  @override
  $ProviderElement<SmsParserService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SmsParserService create(Ref ref) {
    return smsParserService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SmsParserService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SmsParserService>(value),
    );
  }
}

String _$smsParserServiceHash() => r'b5792af517ff89c99e28ed149a61ba5b226df30b';
