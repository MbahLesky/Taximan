import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/models/trip.dart';

class TripRepository {
  final FirebaseFirestore _firestore;

  TripRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _collection = 'trips';

  /// Create a new trip
  Future<Trip> createTrip(Trip trip) async {
    try {
      final docRef = _firestore.collection(_collection).doc(trip.id);
      await docRef.set(trip.toMap());
      return trip;
    } catch (e) {
      throw Exception('Failed to create trip: $e');
    }
  }

  /// Get a trip by ID
  Future<Trip?> getTrip(String tripId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(tripId).get();
      if (doc.exists) {
        return Trip.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch trip: $e');
    }
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
          .map((doc) => Trip.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch passenger trips: $e');
    }
  }

  /// Update a trip
  Future<Trip> updateTrip(Trip trip) async {
    try {
      final updatedTrip = trip.copyWith(
        updatedAt: DateTime.now(),
      );
      await _firestore.collection(_collection).doc(trip.id).update(
            updatedTrip.toMap(),
          );
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
      await _firestore.collection(_collection).doc(tripId).update({
        'status': 'in_progress',
        'startedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to start trip: $e');
    }
  }

  /// Complete a trip
  Future<void> completeTrip(String tripId, int finalFare) async {
    try {
      await _firestore.collection(_collection).doc(tripId).update({
        'status': 'completed',
        'finalFare': finalFare,
        'completedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to complete trip: $e');
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
        .where('status',
            whereIn: ['accepted', 'en_route', 'arrived', 'in_progress'])
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return Trip.fromMap(snapshot.docs.first.data());
      }
      return null;
    });
  }

  /// Get recent trips for dashboard
  Future<List<Trip>> getRecentTrips(String passengerId, {int limit = 10}) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('passengerId', isEqualTo: passengerId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return query.docs
          .map((doc) => Trip.fromMap(doc.data()))
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
          .map((doc) => Trip.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch trips with pending ratings: $e');
    }
  }
}
