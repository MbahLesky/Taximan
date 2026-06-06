import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/driver.dart';
import '../../data/driver_repository.dart';

final driverRepositoryProvider = Provider<DriverRepository>((ref) {
  return DriverRepository();
});

final driverProvider = FutureProvider.family<Driver?, String>((ref, driverId) {
  return ref.watch(driverRepositoryProvider).getDriver(driverId);
});

final driverStreamProvider =
    StreamProvider.family<Driver?, String>((ref, driverId) {
  return ref.watch(driverRepositoryProvider).streamDriver(driverId);
});

final availableDriverCountProvider = FutureProvider<int>((ref) {
  return ref.watch(driverRepositoryProvider).getAvailableDriverCount();
});

final availableDriversProvider = FutureProvider<List<Driver>>((ref) {
  return ref.watch(driverRepositoryProvider).getAvailableDrivers();
});

final allDriversStreamProvider = StreamProvider<List<Driver>>((ref) {
  return ref.watch(driverRepositoryProvider).streamAllDrivers();
});
