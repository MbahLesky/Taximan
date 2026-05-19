import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/ride_statuses.dart';
import '../../../../shared/models/booking.dart';

const _defaultPickupLocation = 'Mvan Carrefour, Yaounde';
const _unsetDestination = 'Select destination';

class BookingState {
  const BookingState({
    required this.booking,
    required this.recentDestinations,
    this.isLoading = false,
    this.errorMessage,
  });

  final Booking booking;
  final List<String> recentDestinations;
  final bool isLoading;
  final String? errorMessage;

  bool get canConfirmRide =>
      booking.destination.isNotEmpty &&
      booking.destination != _unsetDestination &&
      !isLoading;

  BookingState copyWith({
    Booking? booking,
    List<String>? recentDestinations,
    bool? isLoading,
    String? errorMessage,
  }) {
    return BookingState(
      booking: booking ?? this.booking,
      recentDestinations: recentDestinations ?? this.recentDestinations,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class BookingController extends StateNotifier<BookingState> {
  BookingController()
    : super(
        const BookingState(
          booking: Booking(
            id: '',
            pickupLocation: _defaultPickupLocation,
            destination: _unsetDestination,
            estimatedFare: 0,
            distance: '--',
            eta: '--',
            paymentMethod: 'Cash',
            status: BookingStatus.draft,
          ),
          recentDestinations: [
            'Bastos Roundabout',
            'Douala Grand Mall',
            'Marche Central, Yaounde',
          ],
        ),
      );

  void startNewTrip() {
    state = state.copyWith(
      booking: const Booking(
        id: '',
        pickupLocation: _defaultPickupLocation,
        destination: _unsetDestination,
        estimatedFare: 0,
        distance: '--',
        eta: '--',
        paymentMethod: 'Cash',
        status: BookingStatus.draft,
      ),
      isLoading: false,
    );
  }

  void setPickup(String pickupLocation) {
    state = state.copyWith(
      booking: state.booking.copyWith(
        pickupLocation: pickupLocation,
        updatedAt: DateTime.now(),
      ),
    );
  }

  void setDestination(String destination) {
    final updatedRecent = [
      destination,
      ...state.recentDestinations.where((item) => item != destination),
    ].take(4).toList();

    state = state.copyWith(
      booking: state.booking.copyWith(
        destination: destination,
        estimatedFare: destination.contains('Douala') ? 4500 : 2800,
        distance: destination.contains('Douala') ? '14.8 km' : '8.4 km',
        eta: destination.contains('Douala') ? '18 min' : '12 min',
        status: BookingStatus.draft,
        updatedAt: DateTime.now(),
      ),
      recentDestinations: updatedRecent,
    );
  }

  void setPickupTime({
    required String pickupTimeType,
    DateTime? scheduledPickupTime,
  }) {
    state = state.copyWith(
      booking: state.booking.copyWith(
        pickupTimeType: pickupTimeType,
        scheduledPickupTime: scheduledPickupTime,
        updatedAt: DateTime.now(),
      ),
    );
  }

  void setRideSharing(bool isRideSharing) {
    state = state.copyWith(
      booking: state.booking.copyWith(
        isRideSharing: isRideSharing,
        updatedAt: DateTime.now(),
      ),
    );
  }

  void setPaymentMethod(String paymentMethod) {
    state = state.copyWith(
      booking: state.booking.copyWith(
        paymentMethod: paymentMethod,
        updatedAt: DateTime.now(),
      ),
    );
  }

  void markSearching() {
    state = state.copyWith(
      booking: state.booking.copyWith(
        status: BookingStatus.searching,
        updatedAt: DateTime.now(),
      ),
      isLoading: true,
    );
  }

  void setBooking(Booking booking) {
    state = state.copyWith(booking: booking, isLoading: false);
  }

  void setDriverAssigned({
    required String driverId,
    required String vehicleId,
    int? finalFare,
  }) {
    state = state.copyWith(
      booking: state.booking.copyWith(
        driverId: driverId,
        vehicleId: vehicleId,
        finalFare: finalFare,
        status: BookingStatus.accepted,
        acceptedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      isLoading: false,
    );
  }

  void cancelBooking(String reason) {
    state = state.copyWith(
      booking: state.booking.copyWith(
        status: BookingStatus.cancelled,
        cancelledAt: DateTime.now(),
        cancellationReason: reason,
        updatedAt: DateTime.now(),
      ),
      isLoading: false,
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void setError(String message) {
    state = state.copyWith(isLoading: false, errorMessage: message);
  }
}

final bookingStateProvider =
    StateNotifierProvider<BookingController, BookingState>(
      (ref) => BookingController(),
    );
