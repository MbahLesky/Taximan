import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/driver.dart';
import '../../../../shared/models/vehicle.dart';

class DriverState {
  const DriverState({
    required this.driver,
    this.isOnline = false,
    this.isBusy = false,
    this.errorMessage,
  });

  final Driver driver;
  final bool isOnline;
  final bool isBusy;
  final String? errorMessage;

  String get statusLabel {
    if (isBusy) {
      return 'Busy';
    }
    return isOnline ? 'Available' : 'Offline';
  }

  DriverState copyWith({
    Driver? driver,
    bool? isOnline,
    bool? isBusy,
    String? errorMessage,
  }) {
    return DriverState(
      driver: driver ?? this.driver,
      isOnline: isOnline ?? this.isOnline,
      isBusy: isBusy ?? this.isBusy,
      errorMessage: errorMessage,
    );
  }
}

class DriverController extends StateNotifier<DriverState> {
  DriverController()
      : super(
          const DriverState(
            driver: Driver(
              id: 'driver-001',
              fullName: 'Samuel Fotso',
              email: 'samuel.fotso@example.com',
              phone: '+237 6 91 24 77 05',
              city: 'Yaounde',
              rating: 4.9,
              verificationStatus: 'Pending verification',
              vehicle: Vehicle(
                type: 'Taxi',
                model: 'Toyota Corolla',
                plateNumber: 'LT 4821 AB',
                color: 'Yellow',
                capacity: 4,
              ),
            ),
          ),
        );

  void toggleAvailability() {
    state = state.copyWith(isOnline: !state.isOnline, isBusy: false);
  }

  void setBusy(bool value) {
    state = state.copyWith(isBusy: value, isOnline: true);
  }
}

final driverStateProvider = StateNotifierProvider<DriverController, DriverState>(
  (ref) => DriverController(),
);
