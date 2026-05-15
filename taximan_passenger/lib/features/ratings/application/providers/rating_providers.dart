import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/rating.dart';
import '../../../booking/application/providers/repositories.dart';

/// Get a specific rating
final ratingProvider =
    FutureProvider.family<Rating?, String>((ref, ratingId) async {
  final repository = ref.watch(ratingRepositoryProvider);
  return repository.getRating(ratingId);
});

/// Get rating by trip ID
final ratingByTripProvider =
    FutureProvider.family<Rating?, String>((ref, tripId) async {
  final repository = ref.watch(ratingRepositoryProvider);
  return repository.getRatingByTrip(tripId);
});

/// Get rating by booking ID
final ratingByBookingProvider =
    FutureProvider.family<Rating?, String>((ref, bookingId) async {
  final repository = ref.watch(ratingRepositoryProvider);
  return repository.getRatingByBooking(bookingId);
});

/// Get all ratings given by a passenger
final passengerRatingsProvider =
    FutureProvider.family<List<Rating>, String>((ref, passengerId) async {
  final repository = ref.watch(ratingRepositoryProvider);
  return repository.getPassengerRatings(passengerId);
});

/// Get ratings for a driver
final driverRatingsProvider =
    FutureProvider.family<List<Rating>, String>((ref, driverId) async {
  final repository = ref.watch(ratingRepositoryProvider);
  return repository.getRatingsForDriver(driverId);
});

/// Get average rating for a driver
final driverAverageRatingProvider =
    FutureProvider.family<double, String>((ref, driverId) async {
  final repository = ref.watch(ratingRepositoryProvider);
  return repository.getAverageDriverRating(driverId);
});

/// Get ratings count for a driver
final driverRatingsCountProvider =
    FutureProvider.family<int, String>((ref, driverId) async {
  final repository = ref.watch(ratingRepositoryProvider);
  return repository.getDriverRatingsCount(driverId);
});
