import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/trip.dart';
import '../../../booking/application/providers/repositories.dart';

/// Get recent trips for a passenger
final recentTripsProvider = FutureProvider.family<List<Trip>, String>((
  ref,
  passengerId,
) async {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.getRecentTrips(passengerId);
});

/// Get a specific trip
final tripProvider = FutureProvider.family<Trip?, String>((ref, tripId) async {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.getTrip(tripId);
});

/// Stream a specific trip
final tripStreamProvider = StreamProvider.family<Trip?, String>((ref, tripId) {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.streamTrip(tripId);
});

/// Stream active trip for a passenger
final activeTripsStreamProvider = StreamProvider.family<Trip?, String>((
  ref,
  passengerId,
) {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.streamActiveTrip(passengerId);
});

/// Stream upcoming trip for a passenger
final upcomingTripStreamProvider = StreamProvider.family<Trip?, String>((
  ref,
  passengerId,
) {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.streamUpcomingTrip(passengerId);
});

/// Get all trips for a passenger
final passengerTripsProvider = FutureProvider.family<List<Trip>, String>((
  ref,
  passengerId,
) async {
  final repository = ref.watch(tripRepositoryProvider);
  return repository.getPassengerTrips(passengerId);
});

/// Get trips with pending ratings
final tripsWithPendingRatingsProvider =
    FutureProvider.family<List<Trip>, String>((ref, passengerId) async {
      final repository = ref.watch(tripRepositoryProvider);
      return repository.getTripsWithPendingRatings(passengerId);
    });
