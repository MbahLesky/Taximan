import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/models/payment.dart';

class PaymentRepository {
  final FirebaseFirestore _firestore;

  PaymentRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _collection = 'payments';

  /// Create a new payment record
  Future<Payment> createPayment(Payment payment) async {
    try {
      final docRef = _firestore.collection(_collection).doc(payment.id);
      await docRef.set(payment.toMap());
      return payment;
    } catch (e) {
      throw Exception('Failed to create payment: $e');
    }
  }

  /// Get a payment by ID
  Future<Payment?> getPayment(String paymentId) async {
    try {
      final doc =
          await _firestore.collection(_collection).doc(paymentId).get();
      if (doc.exists) {
        return Payment.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch payment: $e');
    }
  }

  /// Get payment by booking ID
  Future<Payment?> getPaymentByBooking(String bookingId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('bookingId', isEqualTo: bookingId)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return Payment.fromMap(query.docs.first.data());
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch payment by booking: $e');
    }
  }

  /// Get payment by trip ID
  Future<Payment?> getPaymentByTrip(String tripId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('tripId', isEqualTo: tripId)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return Payment.fromMap(query.docs.first.data());
    }     return null;
    } catch (e) {
      throw Exception('Failed to fetch payment by trip: $e');
    }
  }

  /// Get all payments for a passenger
  Future<List<Payment>> getPassengerPayments(String passengerId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('passengerId', isEqualTo: passengerId)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs
          .map((doc) => Payment.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch passenger payments: $e');
    }
  }

  /// Update payment status
  Future<void> updatePaymentStatus(String paymentId, String status) async {
    try {
      await _firestore.collection(_collection).doc(paymentId).update({
        'status': status,
      });
    } catch (e) {
      throw Exception('Failed to update payment status: $e');
    }
  }

  /// Mark payment as confirmed
  Future<void> confirmPayment(String paymentId, String confirmedBy) async {
    try {
      await _firestore.collection(_collection).doc(paymentId).update({
        'status': 'paid',
        'confirmedBy': confirmedBy,
        'confirmedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to confirm payment: $e');
    }
  }

  /// Stream of pending payments for a passenger
  Stream<List<Payment>> streamPendingPayments(String passengerId) {
    return _firestore
        .collection(_collection)
        .where('passengerId', isEqualTo: passengerId)
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Payment.fromMap(doc.data()))
          .toList();
    });
  }

  /// Get payment summary for a passenger (total paid, pending, etc.)
  Future<Map<String, dynamic>> getPaymentSummary(String passengerId) async {
    try {
      final allPayments = await getPassengerPayments(passengerId);

      int totalPaid = 0;
      int totalPending = 0;

      for (final payment in allPayments) {
        if (payment.isPaid) {
          totalPaid += payment.amount;
        } else if (payment.status == 'pending') {
          totalPending += payment.amount;
        }
      }

      return {
        'totalPaid': totalPaid,
        'totalPending': totalPending,
        'totalTransactions': allPayments.length,
      };
    } catch (e) {
      throw Exception('Failed to get payment summary: $e');
    }
  }
}
