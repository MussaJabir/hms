import 'package:hms/features/dashboard/models/health_score.dart';
import 'package:hms/features/dashboard/services/health_score_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'health_score_provider.g.dart';

@riverpod
HealthScoreService healthScoreService(Ref ref) {
  return const HealthScoreService();
}

@riverpod
HealthScore healthScore(Ref ref) {
  return ref.watch(healthScoreServiceProvider).calculateScore();
}
