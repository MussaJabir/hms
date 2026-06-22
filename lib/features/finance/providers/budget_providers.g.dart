// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(budgetService)
final budgetServiceProvider = BudgetServiceProvider._();

final class BudgetServiceProvider
    extends $FunctionalProvider<BudgetService, BudgetService, BudgetService>
    with $Provider<BudgetService> {
  BudgetServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetServiceHash();

  @$internal
  @override
  $ProviderElement<BudgetService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BudgetService create(Ref ref) {
    return budgetService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BudgetService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BudgetService>(value),
    );
  }
}

String _$budgetServiceHash() => r'36f23e32f0951f16d66a9e1ccecb3eabbe3ab535';

@ProviderFor(budgetNotificationService)
final budgetNotificationServiceProvider = BudgetNotificationServiceProvider._();

final class BudgetNotificationServiceProvider
    extends
        $FunctionalProvider<
          AsyncValue<BudgetNotificationService>,
          BudgetNotificationService,
          FutureOr<BudgetNotificationService>
        >
    with
        $FutureModifier<BudgetNotificationService>,
        $FutureProvider<BudgetNotificationService> {
  BudgetNotificationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetNotificationServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetNotificationServiceHash();

  @$internal
  @override
  $FutureProviderElement<BudgetNotificationService> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<BudgetNotificationService> create(Ref ref) {
    return budgetNotificationService(ref);
  }
}

String _$budgetNotificationServiceHash() =>
    r'd80274947ef019d4827237a15da7b8ca53639294';

/// Streams budgets for the current month, ordered by category.

@ProviderFor(currentMonthBudgets)
final currentMonthBudgetsProvider = CurrentMonthBudgetsProvider._();

/// Streams budgets for the current month, ordered by category.

final class CurrentMonthBudgetsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Budget>>,
          List<Budget>,
          Stream<List<Budget>>
        >
    with $FutureModifier<List<Budget>>, $StreamProvider<List<Budget>> {
  /// Streams budgets for the current month, ordered by category.
  CurrentMonthBudgetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentMonthBudgetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentMonthBudgetsHash();

  @$internal
  @override
  $StreamProviderElement<List<Budget>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Budget>> create(Ref ref) {
    return currentMonthBudgets(ref);
  }
}

String _$currentMonthBudgetsHash() =>
    r'774690130d9449fcff05f293a868f9efec41e582';

/// The budget for a category in a given "yyyy-MM" period, or null.

@ProviderFor(budgetForCategory)
final budgetForCategoryProvider = BudgetForCategoryFamily._();

/// The budget for a category in a given "yyyy-MM" period, or null.

final class BudgetForCategoryProvider
    extends $FunctionalProvider<AsyncValue<Budget?>, Budget?, FutureOr<Budget?>>
    with $FutureModifier<Budget?>, $FutureProvider<Budget?> {
  /// The budget for a category in a given "yyyy-MM" period, or null.
  BudgetForCategoryProvider._({
    required BudgetForCategoryFamily super.from,
    required (String, String) super.argument,
  }) : super(
         retry: null,
         name: r'budgetForCategoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$budgetForCategoryHash();

  @override
  String toString() {
    return r'budgetForCategoryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Budget?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Budget?> create(Ref ref) {
    final argument = this.argument as (String, String);
    return budgetForCategory(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is BudgetForCategoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$budgetForCategoryHash() => r'b5303f5f240aa91a21745aa174eace57075c360f';

/// The budget for a category in a given "yyyy-MM" period, or null.

final class BudgetForCategoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Budget?>, (String, String)> {
  BudgetForCategoryFamily._()
    : super(
        retry: null,
        name: r'budgetForCategoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The budget for a category in a given "yyyy-MM" period, or null.

  BudgetForCategoryProvider call(String category, String period) =>
      BudgetForCategoryProvider._(argument: (category, period), from: this);

  @override
  String toString() => r'budgetForCategoryProvider';
}

/// Budgets near or over their limit for the current month.

@ProviderFor(warningBudgets)
final warningBudgetsProvider = WarningBudgetsProvider._();

/// Budgets near or over their limit for the current month.

final class WarningBudgetsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Budget>>,
          List<Budget>,
          FutureOr<List<Budget>>
        >
    with $FutureModifier<List<Budget>>, $FutureProvider<List<Budget>> {
  /// Budgets near or over their limit for the current month.
  WarningBudgetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'warningBudgetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$warningBudgetsHash();

  @$internal
  @override
  $FutureProviderElement<List<Budget>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Budget>> create(Ref ref) {
    return warningBudgets(ref);
  }
}

String _$warningBudgetsHash() => r'71002ab9cfc3a0aafcc2955f498b72c90044e49f';

/// Budgets over their limit for the current month.

@ProviderFor(overBudgets)
final overBudgetsProvider = OverBudgetsProvider._();

/// Budgets over their limit for the current month.

final class OverBudgetsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Budget>>,
          List<Budget>,
          FutureOr<List<Budget>>
        >
    with $FutureModifier<List<Budget>>, $FutureProvider<List<Budget>> {
  /// Budgets over their limit for the current month.
  OverBudgetsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overBudgetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overBudgetsHash();

  @$internal
  @override
  $FutureProviderElement<List<Budget>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Budget>> create(Ref ref) {
    return overBudgets(ref);
  }
}

String _$overBudgetsHash() => r'73164b5ada58932751b19c9dac235757a229a4b0';

/// Overall budget compliance score (0–100) for the current month.

@ProviderFor(budgetComplianceScore)
final budgetComplianceScoreProvider = BudgetComplianceScoreProvider._();

/// Overall budget compliance score (0–100) for the current month.

final class BudgetComplianceScoreProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  /// Overall budget compliance score (0–100) for the current month.
  BudgetComplianceScoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetComplianceScoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetComplianceScoreHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return budgetComplianceScore(ref);
  }
}

String _$budgetComplianceScoreHash() =>
    r'9b73a63c24ac9b26059860c3add08fc1f82c7350';

/// Total budget limit for a given "yyyy-MM" period.

@ProviderFor(totalBudgetLimit)
final totalBudgetLimitProvider = TotalBudgetLimitFamily._();

/// Total budget limit for a given "yyyy-MM" period.

final class TotalBudgetLimitProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  /// Total budget limit for a given "yyyy-MM" period.
  TotalBudgetLimitProvider._({
    required TotalBudgetLimitFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'totalBudgetLimitProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$totalBudgetLimitHash();

  @override
  String toString() {
    return r'totalBudgetLimitProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    final argument = this.argument as String;
    return totalBudgetLimit(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TotalBudgetLimitProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$totalBudgetLimitHash() => r'04f5aa2d8b282b5e9fb2cc3bc0b8f9adb5be1100';

/// Total budget limit for a given "yyyy-MM" period.

final class TotalBudgetLimitFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<double>, String> {
  TotalBudgetLimitFamily._()
    : super(
        retry: null,
        name: r'totalBudgetLimitProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Total budget limit for a given "yyyy-MM" period.

  TotalBudgetLimitProvider call(String period) =>
      TotalBudgetLimitProvider._(argument: period, from: this);

  @override
  String toString() => r'totalBudgetLimitProvider';
}

/// Total recorded spending across all budgets for a given "yyyy-MM" period.

@ProviderFor(totalBudgetSpent)
final totalBudgetSpentProvider = TotalBudgetSpentFamily._();

/// Total recorded spending across all budgets for a given "yyyy-MM" period.

final class TotalBudgetSpentProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  /// Total recorded spending across all budgets for a given "yyyy-MM" period.
  TotalBudgetSpentProvider._({
    required TotalBudgetSpentFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'totalBudgetSpentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$totalBudgetSpentHash();

  @override
  String toString() {
    return r'totalBudgetSpentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    final argument = this.argument as String;
    return totalBudgetSpent(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TotalBudgetSpentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$totalBudgetSpentHash() => r'bd18ed0eaf450323605cbba467035e5e39adbd93';

/// Total recorded spending across all budgets for a given "yyyy-MM" period.

final class TotalBudgetSpentFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<double>, String> {
  TotalBudgetSpentFamily._()
    : super(
        retry: null,
        name: r'totalBudgetSpentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Total recorded spending across all budgets for a given "yyyy-MM" period.

  TotalBudgetSpentProvider call(String period) =>
      TotalBudgetSpentProvider._(argument: period, from: this);

  @override
  String toString() => r'totalBudgetSpentProvider';
}
