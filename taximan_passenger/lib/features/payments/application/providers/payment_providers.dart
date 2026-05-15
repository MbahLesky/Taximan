import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/payment.dart';
import '../../../booking/application/providers/repositories.dart';

/// Get a specific payment
final paymentProvider =
    FutureProvider.family<Payment?, String>((ref, paymentId) async {
  final repository = ref.watch(paymentRepositoryProvider);
  return repository.getPayment(paymentId);
});

/// Get payment by booking ID
final paymentByBookingProvider =
    FutureProvider.family<Payment?, String>((ref, bookingId) async {
  final repository = ref.watch(paymentRepositoryProvider);
  return repository.getPaymentByBooking(bookingId);
});

/// Get payment by trip ID
final paymentByTripProvider =
    FutureProvider.family<Payment?, String>((ref, tripId) async {
  final repository = ref.watch(paymentRepositoryProvider);
  return repository.getPaymentByTrip(tripId);
});

/// Get all payments for a passenger
final passengerPaymentsProvider =
    FutureProvider.family<List<Payment>, String>((ref, passengerId) async {
  final repository = ref.watch(paymentRepositoryProvider);
  return repository.getPassengerPayments(passengerId);
});

/// Stream pending payments
final pendingPaymentsStreamProvider =
    StreamProvider.family<List<Payment>, String>((ref, passengerId) {
  final repository = ref.watch(paymentRepositoryProvider);
  return repository.streamPendingPayments(passengerId);
});

/// Get payment summary
final paymentSummaryProvider =
    FutureProvider.family<Map<String, dynamic>, String>(
        (ref, passengerId) async {
  final repository = ref.watch(paymentRepositoryProvider);
  return repository.getPaymentSummary(passengerId);
});
