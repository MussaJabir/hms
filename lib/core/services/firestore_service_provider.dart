import 'package:hms/core/services/firestore_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_service_provider.g.dart';

@riverpod
FirestoreService firestoreService(Ref ref) {
  return FirestoreService();
}
