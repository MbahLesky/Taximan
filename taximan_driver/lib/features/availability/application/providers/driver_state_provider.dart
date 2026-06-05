import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/application/providers/auth_state_provider.dart';
import '../../../onboarding/application/providers/driver_providers.dart';
import '../../data/driver_availability_repository.dart';

final driverAvailabilityRepositoryProvider =
    Provider<DriverAvailabilityRepository>((ref) {
      return DriverAvailabilityRepository();
    });

final driverAvailabilityActionsProvider = Provider<DriverAvailabilityActions>((
  ref,
) {
  return DriverAvailabilityActions(ref);
});

class DriverAvailabilityActions {
  DriverAvailabilityActions(this._ref);

  final Ref _ref;

  Future<void> toggleAvailability() async {
    final driver = _ref.read(currentDriverProvider).valueOrNull;
    final driverId = _driverId;
    final shouldGoOnline = !(driver?.isAvailable ?? false);
    await _repository.setOnline(driverId: driverId, isOnline: shouldGoOnline);
  }

  Future<void> setBusy(bool value) async {
    await _repository.setBusy(driverId: _driverId, isBusy: value);
  }

  Future<void> saveSchedule(List<AvailabilityScheduleEntry> schedule) async {
    await _repository.saveSchedule(driverId: _driverId, schedule: schedule);
  }

  DriverAvailabilityRepository get _repository {
    return _ref.read(driverAvailabilityRepositoryProvider);
  }

  String get _driverId {
    final driverId = _ref.read(authStateProvider).userId;
    if (driverId == null || driverId.isEmpty) {
      throw Exception('Sign in before updating availability.');
    }
    return driverId;
  }
}
