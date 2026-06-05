import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/trip.dart';

class DriverTripState {
  const DriverTripState({
    required this.activeTrip,
    this.status = 'incoming',
    this.errorMessage,
  });

  final Trip activeTrip;
  final String status;
  final String? errorMessage;

  DriverTripState copyWith({
    Trip? activeTrip,
    String? status,
    String? errorMessage,
  }) {
    return DriverTripState(
      activeTrip: activeTrip ?? this.activeTrip,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class DriverTripController extends StateNotifier<DriverTripState> {
  DriverTripController()
    : super(
        const DriverTripState(
          activeTrip: Trip(
            id: 'driver-trip-demo-001',
            passengerName: 'Mireille Ngono',
            pickupLocation: 'Mvan Carrefour, Yaounde',
            destination: 'Bastos Roundabout',
            fare: 3000,
            distance: '8.4 km',
            duration: '16 min',
            status: 'incoming',
            date: '',
          ),
        ),
      );

  void setStatus(String status) {
    state = state.copyWith(status: status);
  }
}

final tripStateProvider =
    StateNotifierProvider<DriverTripController, DriverTripState>(
      (ref) => DriverTripController(),
    );
