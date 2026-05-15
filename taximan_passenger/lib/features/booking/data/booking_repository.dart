import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/models/booking.dart';

class BookingRepository {
  final FirebaseFirestore _firestore;

  BookingRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _collection = 'bookings';

  /// Create a new booking
  Future<Booking> createBooking(Booking booking) async {
    try {
      final docRef = _firestore.collection(_collection).doc(booking.id);
      await docRef.set(booking.toMap());
      return booking;
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  /// Get a booking by ID
  Future<Booking?> getBooking(String bookingId) async {
    try {
      final doc =
          await _firestore.collection(_collection).doc(bookingId).get();
      if (doc.exists) {
        return Booking.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch booking: $e');
    }
  }

  /// Get all bookings for a passenger
  Future<List<Booking>> getPassengerBookings(String passengerId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('passengerId', isEqualTo: passengerId)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs
          .map((doc) => Booking.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch passenger bookings: $e');
    }
  }

  /// Update a booking
  Future<Booking> updateBooking(Booking booking) async {
    try {
      final updatedBooking = booking.copyWith(
        updatedAt: DateTime.now(),
      );
      await _firestore.collection(_collection).doc(booking.id).update(
            updatedBooking.toMap(),
          );
      return updatedBooking;
    } catch (e) {
      throw Exception('Failed to update booking: $e');
    }
  }

  /// Update booking status
  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await _firestore.collection(_collection).doc(bookingId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update booking status: $e');
    }
  }

  /// Assign a driver to a booking
  Future<void> assignDriver(
    String bookingId,
    String driverId,
    String vehicleId,
  ) async {
    try {
      await _firestore.collection(_collection).doc(bookingId).update({
        'driverId': driverId,
        'vehicleId': vehicleId,
        'status': 'assigned',
        'acceptedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to assign driver: $e');
    }
  }

  /// Cancel a booking
  Future<void> cancelBooking(String bookingId, String reason) async {
    try {
      await _firestore.collection(_collection).doc(bookingId).update({
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
        'cancellationReason': reason,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }

  /// Stream of active bookings for a passenger
  Stream<List<Booking>> streamActiveBookings(String passengerId) {
    return _firestore
        .collection(_collection)
        .where('passengerId', isEqualTo: passengerId)
        .where('status',
            whereIn: ['draft', 'searching', 'proposed', 'assigned', 'in_progress'])
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Booking.fromMap(doc.data()))
          .toList();
    });
  }

  /// Get recent bookings for dashboard
  Future<List<Booking>> getRecentBookings(String passengerId,
      {int limit = 5}) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('passengerId', isEqualTo: passengerId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return query.docs
          .map((doc) => Booking.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch recent bookings: $e');
    }
  }
}
