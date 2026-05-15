import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/booking_repository.dart';
import '../../../trip/data/trip_repository.dart';
import '../../../payments/data/payment_repository.dart';
import '../../../ratings/data/rating_repository.dart';

/// Booking Repository Provider
final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepository();
});

/// Trip Repository Provider
final tripRepositoryProvider = Provider<TripRepository>((ref) {
  return TripRepository();
});

/// Payment Repository Provider
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository();
});

/// Rating Repository Provider
final ratingRepositoryProvider = Provider<RatingRepository>((ref) {
  return RatingRepository();
});
