import 'package:hms/core/models/app_config.dart';
import 'package:hms/core/services/activity_log_service.dart';
import 'package:hms/core/services/firestore_service.dart';

class TariffService {
  TariffService(this._firestoreService, this._activityLogService);

  final FirestoreService _firestoreService;
  final ActivityLogService _activityLogService;

  static const String _collection = 'app_config';
  static const String configDocId = 'tanesco_config';

  // ---------------------------------------------------------------------------
  // Default tariffs
  // ---------------------------------------------------------------------------

  /// Default TANESCO domestic D1 rates (editable by Super Admin).
  List<TanescoTier> getDefaultTariffs() => const [
    TanescoTier(minUnits: 0, maxUnits: 75, ratePerUnit: 100),
    TanescoTier(minUnits: 76, maxUnits: 200, ratePerUnit: 292),
    TanescoTier(minUnits: 201, maxUnits: double.infinity, ratePerUnit: 356),
  ];

  // ---------------------------------------------------------------------------
  // Read
  // ---------------------------------------------------------------------------

  /// Returns the current tariff tiers from Firestore.
  /// Returns an empty list when no config has been saved yet.
  Future<List<TanescoTier>> getCurrentTariffs() async {
    final doc = await _firestoreService.get(
      collectionPath: _collection,
      documentId: configDocId,
    );
    return doc != null ? _parseTiers(doc) : [];
  }

  /// Streams the tariff tiers in real time.
  Stream<List<TanescoTier>> streamTariffs() {
    return _firestoreService
        .streamDocument(collectionPath: _collection, documentId: configDocId)
        .map((doc) => doc != null ? _parseTiers(doc) : <TanescoTier>[]);
  }

  // ---------------------------------------------------------------------------
  // Write (Super Admin only — enforced at UI level)
  // ---------------------------------------------------------------------------

  /// Saves tariff tiers to Firestore and logs the action.
  Future<void> updateTariffs({
    required List<TanescoTier> tiers,
    required String userId,
  }) async {
    await _firestoreService.set(
      collectionPath: _collection,
      documentId: configDocId,
      data: {'tiers': tiers.map(_tierToMap).toList()},
      userId: userId,
    );
    await _activityLogService.log(
      userId: userId,
      action: 'update',
      module: 'electricity',
      description:
          'Updated TANESCO tariff configuration (${tiers.length} tiers)',
      documentId: configDocId,
      collectionPath: _collection,
    );
  }

  // ---------------------------------------------------------------------------
  // Cost calculation
  // ---------------------------------------------------------------------------

  /// Calculates the estimated cost for [unitsConsumed] using current tiers.
  /// Falls back to [getDefaultTariffs] when no tiers have been saved.
  Future<double> calculateCost(double unitsConsumed) async {
    var tiers = await getCurrentTariffs();
    if (tiers.isEmpty) tiers = getDefaultTariffs();
    return calculateCostWithTiers(unitsConsumed: unitsConsumed, tiers: tiers);
  }

  /// Synchronously calculates the estimated cost for [unitsConsumed] using
  /// the given [tiers].  Tiers are applied in order, each covering units
  /// from its [TanescoTier.minUnits] up to its [TanescoTier.maxUnits].
  ///
  /// Example — tiers [0-75: 100, 76-200: 292, 201+: 356], 150 units:
  ///   Tier 1 →  75 units × 100 =  7,500
  ///   Tier 2 →  75 units × 292 = 21,900
  ///   Total                     = 29,400
  double calculateCostWithTiers({
    required double unitsConsumed,
    required List<TanescoTier> tiers,
  }) {
    if (unitsConsumed <= 0 || tiers.isEmpty) return 0;

    double totalCost = 0;
    double remaining = unitsConsumed;
    double cumulativeLimit = 0;

    for (final tier in tiers) {
      if (remaining <= 0) break;

      final tierMax = tier.maxUnits;
      final double tierCapacity;
      if (tierMax == double.infinity) {
        tierCapacity = remaining;
      } else {
        tierCapacity = (tierMax - cumulativeLimit).clamp(0.0, remaining);
      }

      totalCost += tierCapacity * tier.ratePerUnit;
      remaining -= tierCapacity;
      if (tierMax != double.infinity) cumulativeLimit = tierMax;
    }

    return totalCost;
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Parses a Firestore document into a list of [TanescoTier].
  /// Uses [null] → [double.infinity] for the top tier.
  List<TanescoTier> _parseTiers(Map<String, dynamic> doc) {
    final tiersRaw = doc['tiers'];
    if (tiersRaw == null || tiersRaw is! List) return [];
    // tiersRaw is List after the guard above.
    return tiersRaw.map((t) {
      final m = Map<String, dynamic>.from(t as Map);
      return TanescoTier(
        minUnits: (m['minUnits'] as num).toDouble(),
        maxUnits: m['maxUnits'] == null
            ? double.infinity
            : (m['maxUnits'] as num).toDouble(),
        ratePerUnit: (m['ratePerUnit'] as num).toDouble(),
      );
    }).toList();
  }

  /// Serialises a [TanescoTier] to a Firestore-safe map.
  /// [double.infinity] → [null] for the top tier.
  Map<String, dynamic> _tierToMap(TanescoTier tier) => {
    'minUnits': tier.minUnits,
    'maxUnits': tier.maxUnits == double.infinity ? null : tier.maxUnits,
    'ratePerUnit': tier.ratePerUnit,
  };
}
