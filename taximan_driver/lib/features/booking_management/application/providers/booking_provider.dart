import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/booking.dart';
import '../../../../shared/models/fare_proposal.dart';
import '../../../../shared/models/trip.dart';
import '../../../auth/application/providers/auth_state_provider.dart';
import '../../../onboarding/application/providers/driver_providers.dart';
import '../../data/booking_repository.dart';

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepository();
});

final availableBookingsStreamProvider = StreamProvider<List<Booking>>((ref) {
  final driverId = ref.watch(authStateProvider).userId;
  if (driverId == null || driverId.isEmpty) {
    return const Stream<List<Booking>>.empty();
  }
  final driver = ref.watch(currentDriverProvider).valueOrNull;
  if (driver == null ||
      driver.verificationStatus.toLowerCase() != 'approved' ||
      !driver.isAvailable) {
    return const Stream<List<Booking>>.empty();
  }

  return ref.watch(bookingRepositoryProvider).streamAvailableBookings(driverId);
});

final driverProposalsStreamProvider = StreamProvider<List<FareProposal>>((ref) {
  final driverId = ref.watch(authStateProvider).userId;
  if (driverId == null || driverId.isEmpty) {
    return const Stream<List<FareProposal>>.empty();
  }
  return ref.watch(bookingRepositoryProvider).streamDriverProposals(driverId);
});

final bookingActionsProvider = Provider<BookingActions>((ref) {
  return BookingActions(ref);
});

class BookingActions {
  BookingActions(this._ref);

  final Ref _ref;

  Future<Trip> accept(Booking booking) async {
    final driverId = _driverId;
    final tripId = await _repository.acceptBooking(
      bookingId: booking.id,
      driverId: driverId,
      vehicleId: _vehicleId,
    );

    final tripData = await _repository.getTripDataById(tripId);
    if (tripData == null) {
      throw Exception('Could not load created trip.');
    }
    return Trip.fromMap(tripData);
  }

  Future<void> decline(Booking booking) async {
    await _repository.declineBooking(
      bookingId: booking.id,
      driverId: _driverId,
    );
  }

  Future<void> proposeFare({
    required Booking booking,
    required int amount,
    String message = '',
  }) async {
    await _repository.proposeFare(
      booking: booking,
      driverId: _driverId,
      proposedFare: amount,
      vehicleId: _vehicleId,
      message: message,
    );
  }

  BookingRepository get _repository => _ref.read(bookingRepositoryProvider);

  String get _driverId {
    final driverId = _ref.read(authStateProvider).userId;
    if (driverId == null || driverId.isEmpty) {
      throw Exception('Sign in before responding to booking requests.');
    }
    return driverId;
  }

  String? get _vehicleId {
    return _ref.read(currentDriverProvider).valueOrNull?.vehicleId;
  }
}
