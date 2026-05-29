import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/booking.dart';
import 'repositories.dart';

/// Get recent bookings for a passenger
final recentBookingsProvider =
    FutureProvider.family<List<Booking>, String>((ref, passengerId) async {
  final repository = ref.watch(bookingRepositoryProvider);
  return repository.getRecentBookings(passengerId);
});

/// Get a specific booking
final bookingProvider =
    FutureProvider.family<Booking?, String>((ref, bookingId) async {
  final repository = ref.watch(bookingRepositoryProvider);
  return repository.getBooking(bookingId);
});

/// Stream a specific booking
final bookingStreamProvider =
    StreamProvider.family<Booking?, String>((ref, bookingId) {
  final repository = ref.watch(bookingRepositoryProvider);
  return repository.streamBooking(bookingId);
});

/// Stream active bookings
final activeBookingsStreamProvider =
    StreamProvider.family<List<Booking>, String>((ref, passengerId) {
  final repository = ref.watch(bookingRepositoryProvider);
  return repository.streamActiveBookings(passengerId);
});

/// Get the nearest upcoming booking for a passenger
final upcomingBookingProvider =
    FutureProvider.family<Booking?, String>((ref, passengerId) async {
  final repository = ref.watch(bookingRepositoryProvider);
  return repository.getUpcomingBooking(passengerId);
});

/// Get all bookings for a passenger
final passengerBookingsProvider =
    FutureProvider.family<List<Booking>, String>((ref, passengerId) async {
  final repository = ref.watch(bookingRepositoryProvider);
  return repository.getPassengerBookings(passengerId);
});
