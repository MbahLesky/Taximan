import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../shared/models/rating.dart';

class RatingRepository {
  final FirebaseFirestore _firestore;

  RatingRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _collection = 'ratings';

  /// Create a new rating
  Future<Rating> createRating(Rating rating) async {
    try {
      final docRef = _firestore.collection(_collection).doc(rating.id);
      await docRef.set(rating.toMap());
      return rating;
    } catch (e) {
      throw Exception('Failed to create rating: $e');
    }
  }

  /// Get a rating by ID
  Future<Rating?> getRating(String ratingId) async {
    try {
      final doc =
          await _firestore.collection(_collection).doc(ratingId).get();
      if (doc.exists) {
        return Rating.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch rating: $e');
    }
  }

  /// Get rating by trip ID
  Future<Rating?> getRatingByTrip(String tripId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('tripId', isEqualTo: tripId)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return Rating.fromMap(query.docs.first.data());
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch rating by trip: $e');
    }
  }

  /// Get rating by booking ID
  Future<Rating?> getRatingByBooking(String bookingId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('bookingId', isEqualTo: bookingId)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return Rating.fromMap(query.docs.first.data());
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch rating by booking: $e');
    }
  }

  /// Get all ratings given by a passenger
  Future<List<Rating>> getPassengerRatings(String passengerId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('passengerId', isEqualTo: passengerId)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs
          .map((doc) => Rating.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch passenger ratings: $e');
    }
  }

  /// Get all ratings for a driver (from this passenger's perspective)
  Future<List<Rating>> getRatingsForDriver(String driverId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('driverId', isEqualTo: driverId)
          .orderBy('createdAt', descending: true)
          .get();

      return query.docs
          .map((doc) => Rating.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch driver ratings: $e');
    }
  }

  /// Update a rating
  Future<Rating> updateRating(Rating rating) async {
    try {
      await _firestore.collection(_collection).doc(rating.id).update(
            rating.toMap(),
          );
      return rating;
    } catch (e) {
      throw Exception('Failed to update rating: $e');
    }
  }

  /// Get average rating for a driver
  Future<double> getAverageDriverRating(String driverId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('driverId', isEqualTo: driverId)
          .get();

      if (query.docs.isEmpty) {
        return 0.0;
      }

      int totalRating = 0;
      for (final doc in query.docs) {
        final rating = Rating.fromMap(doc.data());
        totalRating += rating.rating;
      }

      return totalRating / query.docs.length;
    } catch (e) {
      throw Exception('Failed to get average driver rating: $e');
    }
  }

  /// Get ratings count for a driver
  Future<int> getDriverRatingsCount(String driverId) async {
    try {
      final query = await _firestore
          .collection(_collection)
          .where('driverId', isEqualTo: driverId)
          .get();

      return query.docs.length;
    } catch (e) {
      throw Exception('Failed to get driver ratings count: $e');
    }
  }

  /// Report an issue for a trip
  Future<void> reportIssue(
    String tripId,
    String bookingId,
    String passengerId,
    String driverId,
    String issueType,
    String comment,
  ) async {
    try {
      final ratingId = _firestore.collection(_collection).doc().id;
      final rating = Rating(
        id: ratingId,
        tripId: tripId,
        bookingId: bookingId,
        passengerId: passengerId,
        driverId: driverId,
        rating: 0,
        comment: comment,
        reportIssue: true,
        issueType: issueType,
        createdAt: DateTime.now(),
      );

      await createRating(rating);
    } catch (e) {
      throw Exception('Failed to report issue: $e');
    }
  }
}
