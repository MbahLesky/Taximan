import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/ride_statuses.dart';
import '../../../shared/models/trip.dart';

class TripRepository {
  final FirebaseFirestore _firestore;

  TripRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _collection = 'trips';

  /// Create a new trip
  Future<Trip> createTrip(Trip trip) async {
    try {
      final docRef = trip.id.isEmpty
          ? _firestore.collection(_collection).doc()
          : _firestore.collection(_collection).doc(trip.id);
      final tripToCreate = trip.copyWith(
        id: docRef.id,
        createdAt: trip.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await docRef.set(tripToCreate.toMap());
      return tripToCreate;
    } catch (e) {
      throw Exception('Failed to create trip: $e');
    }
  }

  /// Get a trip by ID
  Future<Trip?> getTrip(String tripId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(tripId).get();
      if (doc.exists) {
        return Trip.fromMap({
          ...(doc.data() as Map<String, dynamic>),
          'id': doc.id,
        });
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch trip: $e');
    }
  }

  /// Stream a trip by ID
  Stream<Trip?> streamTrip(String tripId) {
    return _firestore.collection(_collection).doc(tripId).snapshots().map((
      doc,
    ) {
      if (!doc.exists) {
        return null;
      }
      return Trip.fromMap({
        ...(doc.data() as Map<String, dynamic>),
        'id': doc.id,
      });
    });
  }

  /// Get all trips for a passenger
  Future<List<Trip>> getPassengerTrips(String passengerId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('passengerId', isEqualTo: passengerId)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs
          .map((doc) => Trip.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch passenger trips: $e');
    }
  }

  /// Update a trip
  Future<Trip> updateTrip(Trip trip) async {
    try {
      final updatedTrip = trip.copyWith(updatedAt: DateTime.now());
      await _firestore
          .collection(_collection)
          .doc(trip.id)
          .update(updatedTrip.toMap());
      return updatedTrip;
    } catch (e) {
      throw Exception('Failed to update trip: $e');
    }
  }

  /// Update trip status
  Future<void> updateTripStatus(String tripId, String status) async {
    try {
      await _firestore.collection(_collection).doc(tripId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update trip status: $e');
    }
  }

  /// Start a trip
  Future<void> startTrip(String tripId) async {
    try {
      final tripRef = _firestore.collection(_collection).doc(tripId);
      final notificationRef = _firestore.collection('notifications').doc();

      await _firestore.runTransaction((transaction) async {
        final tripSnapshot = await transaction.get(tripRef);
        final tripData = tripSnapshot.data();
        if (tripData == null) {
          throw Exception('Trip no longer exists.');
        }

        final bookingId = tripData['bookingId'] as String?;
        DocumentReference<Map<String, dynamic>>? bookingRef;
        DocumentSnapshot<Map<String, dynamic>>? bookingSnapshot;
        if (bookingId != null && bookingId.isNotEmpty) {
          bookingRef = _firestore.collection('bookings').doc(bookingId);
          bookingSnapshot = await transaction.get(bookingRef);
        }

        transaction.update(tripRef, {
          'status': TripStatus.inProgress,
          'startedAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        if (bookingRef != null && bookingSnapshot?.exists == true) {
          transaction.update(bookingRef, {
            'status': BookingStatus.inProgress,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }

        final passengerId = tripData['passengerId'] as String?;
        if (passengerId != null && passengerId.isNotEmpty) {
          transaction.set(notificationRef, {
            'id': notificationRef.id,
            'userId': passengerId,
            'userRole': 'passenger',
            'title': 'Trip started',
            'body': 'Your trip has just begun.',
            'type': 'trip_started',
            'isRead': false,
            'relatedId': tripId,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      });
    } catch (e) {
      throw Exception('Failed to start trip: $e');
    }
  }

  /// Complete a trip
  Future<void> completeTrip(String tripId, int finalFare) async {
    try {
      final tripRef = _firestore.collection(_collection).doc(tripId);

      await _firestore.runTransaction((transaction) async {
        final tripSnapshot = await transaction.get(tripRef);
        final tripData = tripSnapshot.data();
        if (tripData == null) {
          throw Exception('Trip no longer exists.');
        }

        final bookingId = tripData['bookingId'] as String?;
        DocumentReference<Map<String, dynamic>>? bookingRef;
        DocumentSnapshot<Map<String, dynamic>>? bookingSnapshot;
        if (bookingId != null && bookingId.isNotEmpty) {
          bookingRef = _firestore.collection('bookings').doc(bookingId);
          bookingSnapshot = await transaction.get(bookingRef);
        }

        transaction.update(tripRef, {
          'status': TripStatus.completed,
          'finalFare': finalFare,
          'completedAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        if (bookingRef != null && bookingSnapshot?.exists == true) {
          transaction.update(bookingRef, {
            'status': BookingStatus.completed,
            'finalFare': finalFare,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      });
    } catch (e) {
      throw Exception('Failed to complete trip: $e');
    }
  }

  /// Delete a trip record
  Future<void> deleteTrip(String tripId) async {
    try {
      await _firestore.collection(_collection).doc(tripId).delete();
    } catch (e) {
      throw Exception('Failed to delete trip: $e');
    }
  }

  /// Cancel a trip
  Future<void> cancelTrip(String tripId) async {
    try {
      await _firestore.collection(_collection).doc(tripId).update({
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to cancel trip: $e');
    }
  }

  /// Stream of active trip for a passenger
  Stream<Trip?> streamActiveTrip(String passengerId) {
    return _firestore
        .collection(_collection)
        .where('passengerId', isEqualTo: passengerId)
        .where('status', whereIn: TripStatus.active)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            final doc = snapshot.docs.first;
            return Trip.fromMap({...doc.data(), 'id': doc.id});
          }
          return null;
        });
  }

  /// Stream of the nearest pre-trip ride for a passenger.
  Stream<Trip?> streamUpcomingTrip(String passengerId) {
    return _firestore
        .collection(_collection)
        .where('passengerId', isEqualTo: passengerId)
        .where('status', whereIn: TripStatus.active)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            final doc = snapshot.docs.first;
            return Trip.fromMap({...doc.data(), 'id': doc.id});
          }
          return null;
        });
  }

  /// Get recent trips for dashboard
  Future<List<Trip>> getRecentTrips(
    String passengerId, {
    int limit = 3,
  }) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('passengerId', isEqualTo: passengerId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return query.docs
          .map((doc) => Trip.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch recent trips: $e');
    }
  }

  /// Get completed trips with ratings pending
  Future<List<Trip>> getTripsWithPendingRatings(String passengerId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('passengerId', isEqualTo: passengerId)
          .where('status', isEqualTo: 'completed')
          .orderBy('completedAt', descending: true)
          .get();

      return query.docs
          .map((doc) => Trip.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch trips with pending ratings: $e');
    }
  }
}
