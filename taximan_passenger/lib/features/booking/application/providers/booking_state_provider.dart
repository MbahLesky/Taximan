import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/ride_statuses.dart';
import '../../../../shared/data/bamenda_locations.dart';
import '../../../../shared/models/booking.dart';
import '../../../../shared/models/app_location.dart';

const _unsetDestination = '';

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
      booking.pickupLocation.isNotEmpty &&
      booking.destination.isNotEmpty &&
      booking.destination != _unsetDestination &&
      booking.pickup.hasCoordinates &&
      booking.destinationLocation.hasCoordinates &&
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
        BookingState(
          booking: Booking(
            id: '',
            pickupLocation: defaultPassengerLocation.fullAddress,
            destination: _unsetDestination,
            estimatedFare: 0,
            distance: '',
            eta: '',
            paymentMethod: 'Cash',
            status: BookingStatus.draft,
            pickupLocationDetails: defaultPassengerLocation,
          ),
          recentDestinations: [],
        ),
      );

  void startNewRide() {
    state = state.copyWith(
      booking: Booking(
        id: '',
        pickupLocation: defaultPassengerLocation.fullAddress,
        destination: _unsetDestination,
        estimatedFare: 0,
        distance: '',
        eta: '',
        paymentMethod: 'Cash',
        status: BookingStatus.draft,
        pickupLocationDetails: defaultPassengerLocation,
      ),
      isLoading: false,
    );
  }

  void setPickup(String pickupLocation) {
    final matchedLocation = _findLocation(pickupLocation);
    if (matchedLocation == null) {
      setError('Choose one of the supported Bamenda pickup locations.');
      return;
    }
    setPickupLocation(matchedLocation);
  }

  void setPickupLocation(AppLocation location) {
    state = state.copyWith(
      booking: _withRouteEstimate(
        state.booking.copyWith(
          pickupLocation: location.fullAddress,
          pickupLocationDetails: location.copyWith(updatedAt: DateTime.now()),
          updatedAt: DateTime.now(),
        ),
      ),
      errorMessage: null,
    );
  }

  void setDestinationLocation(AppLocation location) {
    final updatedRecent = [
      location.fullAddress,
      ...state.recentDestinations.where((item) => item != location.fullAddress),
    ].take(4).toList();

    state = state.copyWith(
      booking: _withRouteEstimate(
        state.booking.copyWith(
          destination: location.fullAddress,
          destinationLocationDetails: location.copyWith(
            updatedAt: DateTime.now(),
          ),
          status: BookingStatus.draft,
          updatedAt: DateTime.now(),
        ),
      ),
      recentDestinations: updatedRecent,
      errorMessage: null,
    );
  }

  void setDestination(String destination) {
    final matchedLocation = _findLocation(destination);
    if (matchedLocation != null) {
      setDestinationLocation(matchedLocation);
      return;
    }
    setError('Choose one of the supported Bamenda destination locations.');
  }

  void setPickupTime({
    required String pickupTimeType,
    DateTime? scheduledPickupTime,
  }) {
    state = state.copyWith(
      booking: state.booking.copyWith(
        pickupTimeType: pickupTimeType,
        scheduledPickupTime: scheduledPickupTime,
        clearScheduledPickupTime: pickupTimeType == 'now',
        updatedAt: DateTime.now(),
      ),
    );
  }

  void setRideDetails({
    required bool isRideSharing,
    required int passengerCount,
    required bool hasLuggage,
    required int luggageCount,
    required String paymentMethod,
    required int proposedFareAmount,
    required String additionalInfo,
  }) {
    state = state.copyWith(
      booking: state.booking.copyWith(
        isRideSharing: isRideSharing,
        passengerCount: passengerCount,
        hasLuggage: hasLuggage,
        luggageCount: hasLuggage ? luggageCount : 0,
        paymentMethod: paymentMethod,
        proposedFareAmount: proposedFareAmount,
        estimatedFare: proposedFareAmount > 0
            ? proposedFareAmount
            : state.booking.estimatedFare,
        additionalInfo: additionalInfo,
        updatedAt: DateTime.now(),
      ),
    );
  }

  void setDestinationFromBooking(Booking booking) {
    setDestination(booking.destination);
    state = state.copyWith(
      booking: state.booking.copyWith(
        estimatedFare: booking.estimatedFare,
        distance: booking.distance,
        eta: booking.eta,
        paymentMethod: booking.paymentMethod,
      ),
    );
  }

  void setPreferredDriver({String? driverId, String? driverName}) {
    state = state.copyWith(
      booking: state.booking.copyWith(
        preferredDriverId: driverId,
        preferredDriverName: driverName,
        updatedAt: DateTime.now(),
      ),
    );
  }

  void clearPreferredDriver() {
    state = state.copyWith(
      booking: state.booking.copyWith(
        preferredDriverId: '',
        preferredDriverName: '',
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

/// This method is used to set the booking details in the state, typically after a booking has been created or updated. It updates the booking information and sets the loading state to false, indicating that the booking data is now available and any loading process has completed.
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

  Booking _withRouteEstimate(Booking booking) {
    final pickup = booking.pickup;
    final destination = booking.destinationLocation;
    if (!pickup.hasCoordinates || !destination.hasCoordinates) {
      return booking.copyWith(distance: '', eta: '');
    }

    final distanceKm = _distanceInKm(pickup, destination);
    final durationMinutes = math.max(5, (distanceKm / 22 * 60).round());
    final estimatedFare = math.max(500, (500 + distanceKm * 220).round());

    return booking.copyWith(
      distance: '${distanceKm.toStringAsFixed(1)} km',
      eta: '$durationMinutes min',
      distanceKm: distanceKm,
      estimatedDurationMinutes: durationMinutes,
      estimatedFare: booking.proposedFareAmount > 0
          ? booking.proposedFareAmount
          : estimatedFare,
    );
  }

  AppLocation? _findLocation(String value) {
    final query = value.trim().toLowerCase();
    if (query.isEmpty) {
      return null;
    }
    for (final location in bamendaLocations) {
      if (location.name?.toLowerCase() == query ||
          location.fullAddress.toLowerCase() == query) {
        return location;
      }
    }
    return null;
  }

  double _distanceInKm(AppLocation pickup, AppLocation destination) {
    const earthRadiusKm = 6371;
    final lat1 = _toRadians(pickup.latitude!);
    final lat2 = _toRadians(destination.latitude!);
    final deltaLat = _toRadians(destination.latitude! - pickup.latitude!);
    final deltaLng = _toRadians(destination.longitude! - pickup.longitude!);
    final a =
        math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(deltaLng / 2) *
            math.sin(deltaLng / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _toRadians(double degrees) => degrees * math.pi / 180;
}

final bookingStateProvider =
    StateNotifierProvider<BookingController, BookingState>(
      (ref) => BookingController(),
    );
