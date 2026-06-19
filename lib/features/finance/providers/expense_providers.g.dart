// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(expenseService)
final expenseServiceProvider = ExpenseServiceProvider._();

final class ExpenseServiceProvider
    extends $FunctionalProvider<ExpenseService, ExpenseService, ExpenseService>
    with $Provider<ExpenseService> {
  ExpenseServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expenseServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expenseServiceHash();

  @$internal
  @override
  $ProviderElement<ExpenseService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ExpenseService create(Ref ref) {
    return expenseService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExpenseService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExpenseService>(value),
    );
  }
}

String _$expenseServiceHash() => r'add36064fd2fe6200a5e976db7f77f15884b4a98';

/// Streams every expense entry, newest first.

@ProviderFor(allExpenses)
final allExpensesProvider = AllExpensesProvider._();

/// Streams every expense entry, newest first.

final class AllExpensesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Expense>>,
          List<Expense>,
          Stream<List<Expense>>
        >
    with $FutureModifier<List<Expense>>, $StreamProvider<List<Expense>> {
  /// Streams every expense entry, newest first.
  AllExpensesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allExpensesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allExpensesHash();

  @$internal
  @override
  $StreamProviderElement<List<Expense>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Expense>> create(Ref ref) {
    return allExpenses(ref);
  }
}

String _$allExpensesHash() => r'5d1dc4e7f0d4b4616bb7ccb650c9a8d5323925e0';

/// Streams expenses for the current calendar month.

@ProviderFor(currentMonthExpenses)
final currentMonthExpensesProvider = CurrentMonthExpensesProvider._();

/// Streams expenses for the current calendar month.

final class CurrentMonthExpensesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Expense>>,
          List<Expense>,
          Stream<List<Expense>>
        >
    with $FutureModifier<List<Expense>>, $StreamProvider<List<Expense>> {
  /// Streams expenses for the current calendar month.
  CurrentMonthExpensesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentMonthExpensesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentMonthExpensesHash();

  @$internal
  @override
  $StreamProviderElement<List<Expense>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Expense>> create(Ref ref) {
    return currentMonthExpenses(ref);
  }
}

String _$currentMonthExpensesHash() =>
    r'4cf7e9e1443041576522d014363f3a5b2f32d7da';

/// Total expenses for the current month, scoped to the selected ground.

@ProviderFor(currentMonthExpenseTotal)
final currentMonthExpenseTotalProvider = CurrentMonthExpenseTotalProvider._();

/// Total expenses for the current month, scoped to the selected ground.

final class CurrentMonthExpenseTotalProvider
    extends $FunctionalProvider<AsyncValue<double>, double, FutureOr<double>>
    with $FutureModifier<double>, $FutureProvider<double> {
  /// Total expenses for the current month, scoped to the selected ground.
  CurrentMonthExpenseTotalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentMonthExpenseTotalProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentMonthExpenseTotalHash();

  @$internal
  @override
  $FutureProviderElement<double> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double> create(Ref ref) {
    return currentMonthExpenseTotal(ref);
  }
}

String _$currentMonthExpenseTotalHash() =>
    r'd2d56b9011b4ea4c43dabb2fe15262ac773dcb4b';

/// Expenses grouped by category value for a given "yyyy-MM" period, scoped to
/// the selected ground.

@ProviderFor(expensesByCategory)
final expensesByCategoryProvider = ExpensesByCategoryFamily._();

/// Expenses grouped by category value for a given "yyyy-MM" period, scoped to
/// the selected ground.

final class ExpensesByCategoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, double>>,
          Map<String, double>,
          FutureOr<Map<String, double>>
        >
    with
        $FutureModifier<Map<String, double>>,
        $FutureProvider<Map<String, double>> {
  /// Expenses grouped by category value for a given "yyyy-MM" period, scoped to
  /// the selected ground.
  ExpensesByCategoryProvider._({
    required ExpensesByCategoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'expensesByCategoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$expensesByCategoryHash();

  @override
  String toString() {
    return r'expensesByCategoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, double>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, double>> create(Ref ref) {
    final argument = this.argument as String;
    return expensesByCategory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ExpensesByCategoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$expensesByCategoryHash() =>
    r'9d2ab2a8eb5b67e78124d2cc6f34178ef75d4d55';

/// Expenses grouped by category value for a given "yyyy-MM" period, scoped to
/// the selected ground.

final class ExpensesByCategoryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Map<String, double>>, String> {
  ExpensesByCategoryFamily._()
    : super(
        retry: null,
        name: r'expensesByCategoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Expenses grouped by category value for a given "yyyy-MM" period, scoped to
  /// the selected ground.

  ExpensesByCategoryProvider call(String period) =>
      ExpensesByCategoryProvider._(argument: period, from: this);

  @override
  String toString() => r'expensesByCategoryProvider';
}

/// Top 5 expense categories for a given "yyyy-MM" period, scoped to the
/// selected ground.

@ProviderFor(topExpenseCategories)
final topExpenseCategoriesProvider = TopExpenseCategoriesFamily._();

/// Top 5 expense categories for a given "yyyy-MM" period, scoped to the
/// selected ground.

final class TopExpenseCategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MapEntry<String, double>>>,
          List<MapEntry<String, double>>,
          FutureOr<List<MapEntry<String, double>>>
        >
    with
        $FutureModifier<List<MapEntry<String, double>>>,
        $FutureProvider<List<MapEntry<String, double>>> {
  /// Top 5 expense categories for a given "yyyy-MM" period, scoped to the
  /// selected ground.
  TopExpenseCategoriesProvider._({
    required TopExpenseCategoriesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'topExpenseCategoriesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$topExpenseCategoriesHash();

  @override
  String toString() {
    return r'topExpenseCategoriesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<MapEntry<String, double>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MapEntry<String, double>>> create(Ref ref) {
    final argument = this.argument as String;
    return topExpenseCategories(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TopExpenseCategoriesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$topExpenseCategoriesHash() =>
    r'525440e69e282954210db5db17145c06592817fc';

/// Top 5 expense categories for a given "yyyy-MM" period, scoped to the
/// selected ground.

final class TopExpenseCategoriesFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<MapEntry<String, double>>>,
          String
        > {
  TopExpenseCategoriesFamily._()
    : super(
        retry: null,
        name: r'topExpenseCategoriesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Top 5 expense categories for a given "yyyy-MM" period, scoped to the
  /// selected ground.

  TopExpenseCategoriesProvider call(String period) =>
      TopExpenseCategoriesProvider._(argument: period, from: this);

  @override
  String toString() => r'topExpenseCategoriesProvider';
}
