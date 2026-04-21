// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_report_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(monthlyReportService)
final monthlyReportServiceProvider = MonthlyReportServiceProvider._();

final class MonthlyReportServiceProvider
    extends
        $FunctionalProvider<
          MonthlyReportService,
          MonthlyReportService,
          MonthlyReportService
        >
    with $Provider<MonthlyReportService> {
  MonthlyReportServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monthlyReportServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monthlyReportServiceHash();

  @$internal
  @override
  $ProviderElement<MonthlyReportService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MonthlyReportService create(Ref ref) {
    return monthlyReportService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MonthlyReportService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MonthlyReportService>(value),
    );
  }
}

String _$monthlyReportServiceHash() =>
    r'83e9b02cd2a5a08bdfc09b95ee4c509011045425';

/// Returns the report for [period] ("yyyy-MM"). Defaults to current month.
/// Reacts to the selected ground via [currentGroundProvider].

@ProviderFor(monthlyReport)
final monthlyReportProvider = MonthlyReportFamily._();

/// Returns the report for [period] ("yyyy-MM"). Defaults to current month.
/// Reacts to the selected ground via [currentGroundProvider].

final class MonthlyReportProvider
    extends
        $FunctionalProvider<
          AsyncValue<MonthlyReport>,
          MonthlyReport,
          FutureOr<MonthlyReport>
        >
    with $FutureModifier<MonthlyReport>, $FutureProvider<MonthlyReport> {
  /// Returns the report for [period] ("yyyy-MM"). Defaults to current month.
  /// Reacts to the selected ground via [currentGroundProvider].
  MonthlyReportProvider._({
    required MonthlyReportFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'monthlyReportProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$monthlyReportHash();

  @override
  String toString() {
    return r'monthlyReportProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<MonthlyReport> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MonthlyReport> create(Ref ref) {
    final argument = this.argument as String?;
    return monthlyReport(ref, period: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyReportProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$monthlyReportHash() => r'6ad786670490e594acf7b86615e196d6d7170cc6';

/// Returns the report for [period] ("yyyy-MM"). Defaults to current month.
/// Reacts to the selected ground via [currentGroundProvider].

final class MonthlyReportFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<MonthlyReport>, String?> {
  MonthlyReportFamily._()
    : super(
        retry: null,
        name: r'monthlyReportProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Returns the report for [period] ("yyyy-MM"). Defaults to current month.
  /// Reacts to the selected ground via [currentGroundProvider].

  MonthlyReportProvider call({String? period}) =>
      MonthlyReportProvider._(argument: period, from: this);

  @override
  String toString() => r'monthlyReportProvider';
}
