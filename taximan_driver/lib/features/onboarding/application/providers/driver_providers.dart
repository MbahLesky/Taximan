import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/driver_model.dart';
import '../../../auth/application/providers/auth_state_provider.dart';
import '../../data/driver_repository.dart';

final driverRepositoryProvider = Provider<DriverRepository>((ref) {
  return DriverRepository();
});

final currentDriverProvider = StreamProvider<DriverModel?>((ref) {
  final userId = ref.watch(authStateProvider).userId;
  if (userId == null || userId.isEmpty) {
    return const Stream<DriverModel?>.empty();
  }

  return ref.watch(driverRepositoryProvider).streamDriver(userId);
});

final driverDocumentsProvider = StreamProvider<List<DriverDocumentRecord>>((
  ref,
) {
  final userId = ref.watch(authStateProvider).userId;
  if (userId == null || userId.isEmpty) {
    return const Stream<List<DriverDocumentRecord>>.empty();
  }

  return ref.watch(driverRepositoryProvider).streamDriverDocuments(userId);
});
