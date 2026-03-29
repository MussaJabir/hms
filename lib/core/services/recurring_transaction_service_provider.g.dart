// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_transaction_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recurringTransactionService)
final recurringTransactionServiceProvider =
    RecurringTransactionServiceProvider._();

final class RecurringTransactionServiceProvider
    extends
        $FunctionalProvider<
          RecurringTransactionService,
          RecurringTransactionService,
          RecurringTransactionService
        >
    with $Provider<RecurringTransactionService> {
  RecurringTransactionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recurringTransactionServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recurringTransactionServiceHash();

  @$internal
  @override
  $ProviderElement<RecurringTransactionService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecurringTransactionService create(Ref ref) {
    return recurringTransactionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecurringTransactionService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecurringTransactionService>(value),
    );
  }
}

String _$recurringTransactionServiceHash() =>
    r'ab209be89fe9e7153d538f65c76359e69e31dfbd';
