import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/ride_statuses.dart';
import '../../../../shared/models/driver.dart';
import '../../../../shared/models/trip.dart';

class TripState {
  const TripState({
    this.assignedDriver,
    this.activeTrip,
    this.status = TripStatus.driverArriving,
    this.isLoading = false,
    this.errorMessage,
  });

  final Driver? assignedDriver;
  final Trip? activeTrip;
  final String status;
  final bool isLoading;
  final String? errorMessage;

  TripState copyWith({
    Driver? assignedDriver,
    Trip? activeTrip,
    String? status,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TripState(
      assignedDriver: assignedDriver ?? this.assignedDriver,
      activeTrip: activeTrip ?? this.activeTrip,
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class TripController extends StateNotifier<TripState> {
  TripController()
    : super(
        const TripState(
          assignedDriver: Driver(
            id: 'driver-001',
            fullName: 'Jean Talla',
            rating: 4.8,
            vehicle: 'Toyota Corolla',
            plateNumber: 'LT 4821 AB',
            arrivalEta: '6 min',
          ),
          activeTrip: Trip(
            id: 'trip-demo-001',
            pickupLocation: 'Mvan Carrefour, Yaounde',
            destination: 'Bonamoussadi, Douala',
            fare: 4500,
            distance: '14.8 km',
            duration: '18 min',
            status: TripStatus.driverArriving,
            date: 'Apr 30, 2026',
          ),
        ),
      );

  void setStatus(String status) {
    state = state.copyWith(
      status: status,
      activeTrip: state.activeTrip?.copyWith(
        status: status,
        updatedAt: DateTime.now(),
      ),
    );
  }

  void setDriverArriving() {
    setStatus(TripStatus.driverArriving);
  }

  void markDriverArrived() {
    setStatus(TripStatus.arrived);
  }

  void startTrip() {
    state = state.copyWith(
      status: TripStatus.inProgress,
      activeTrip: state.activeTrip?.copyWith(
        status: TripStatus.inProgress,
        startedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  void completeTrip({int? finalFare, int? actualDurationMinutes}) {
    state = state.copyWith(
      status: TripStatus.completed,
      activeTrip: state.activeTrip?.copyWith(
        status: TripStatus.completed,
        finalFare: finalFare,
        actualDurationMinutes: actualDurationMinutes,
        completedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }

  void cancelTrip() {
    state = state.copyWith(
      status: TripStatus.cancelled,
      activeTrip: state.activeTrip?.copyWith(
        status: TripStatus.cancelled,
        cancelledAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }
}

final tripStateProvider = StateNotifierProvider<TripController, TripState>(
  (ref) => TripController(),
);
