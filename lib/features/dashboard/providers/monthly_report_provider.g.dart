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
    r'2774b86b554e55fb58b9347d9960aadfd5c93368';

/// Returns the report for [period] ("yyyy-MM"). Defaults to current month.

@ProviderFor(monthlyReport)
final monthlyReportProvider = MonthlyReportFamily._();

/// Returns the report for [period] ("yyyy-MM"). Defaults to current month.

final class MonthlyReportProvider
    extends $FunctionalProvider<MonthlyReport, MonthlyReport, MonthlyReport>
    with $Provider<MonthlyReport> {
  /// Returns the report for [period] ("yyyy-MM"). Defaults to current month.
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
  $ProviderElement<MonthlyReport> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MonthlyReport create(Ref ref) {
    final argument = this.argument as String?;
    return monthlyReport(ref, period: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MonthlyReport value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MonthlyReport>(value),
    );
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

String _$monthlyReportHash() => r'aa40d42b4c8f5a4ea7ecbceb189e2119c40fdc01';

/// Returns the report for [period] ("yyyy-MM"). Defaults to current month.

final class MonthlyReportFamily extends $Family
    with $FunctionalFamilyOverride<MonthlyReport, String?> {
  MonthlyReportFamily._()
    : super(
        retry: null,
        name: r'monthlyReportProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Returns the report for [period] ("yyyy-MM"). Defaults to current month.

  MonthlyReportProvider call({String? period}) =>
      MonthlyReportProvider._(argument: period, from: this);

  @override
  String toString() => r'monthlyReportProvider';
}
