import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taximan_driver/shared/models/model_helpers.dart';

import '../../../../shared/models/trip.dart';
import '../../../core/constants/ride_statuses.dart';

class TripRepository {
  TripRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Stream<List<Trip>> streamDriverTrips(String driverId) {
    return _firestore
        .collection('trips')
        .where('driverId', isEqualTo: driverId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Trip.fromMap({...doc.data(), 'id': doc.id}))
              .toList();
        });
  }

  Stream<Trip?> streamActiveTrip(String driverId) {
    return _firestore
        .collection('trips')
        .where('driverId', isEqualTo: driverId)
        .where('status', whereIn: [
          TripStatus.driverArriving,
          TripStatus.arrived,
          TripStatus.inProgress,
        ])
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) {
            return null;
          }
          return Trip.fromMap({...snapshot.docs.first.data(), 'id': snapshot.docs.first.id});
        });
  }

  Future<Trip?> getTrip(String tripId) async {
    final doc = await _firestore.collection('trips').doc(tripId).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return Trip.fromMap({...doc.data()!, 'id': doc.id});
  }

  Stream<List<Trip>> streamCompletedTrips(String driverId) {
    return _firestore
        .collection('trips')
        .where('driverId', isEqualTo: driverId)
        .where('status', isEqualTo: TripStatus.completed)
        .orderBy('completedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Trip.fromMap({...doc.data(), 'id': doc.id}))
              .toList();
        });
  }

  Future<void> updateTripStatus(String tripId, String status) async {
    await _firestore.collection('trips').doc(tripId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> startTrip(String tripId) async {
    final tripRef = _firestore.collection('trips').doc(tripId);
    final bookingRef = _firestore.collection('bookings').doc();
    await _firestore.runTransaction((transaction) async {
      final tripSnapshot = await transaction.get(tripRef);
      final tripData = tripSnapshot.data();
      if (tripData == null) {
        throw Exception('Trip no longer exists.');
      }
      final bookingId = tripData['bookingId'] as String?;
      if (bookingId != null && bookingId.isNotEmpty) {
        transaction.update(_firestore.collection('bookings').doc(bookingId), {
          'status': BookingStatus.inProgress,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      transaction.update(tripRef, {
        'status': TripStatus.inProgress,
        'startedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> completeTrip(String tripId, int finalFare) async {
    final tripRef = _firestore.collection('trips').doc(tripId);
    await _firestore.runTransaction((transaction) async {
      final tripSnapshot = await transaction.get(tripRef);
      final tripData = tripSnapshot.data();
      if (tripData == null) {
        throw Exception('Trip no longer exists.');
      }
      final bookingId = tripData['bookingId'] as String?;
      if (bookingId != null && bookingId.isNotEmpty) {
        transaction.update(_firestore.collection('bookings').doc(bookingId), {
          'status': BookingStatus.completed,
          'finalFare': finalFare,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      transaction.update(tripRef, {
        'status': TripStatus.completed,
        'finalFare': finalFare,
        'completedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<EarningsSummary> fetchEarningsSummary(String driverId) async {
    final snapshot = await _firestore
        .collection('trips')
        .where('driverId', isEqualTo: driverId)
        .where('status', isEqualTo: TripStatus.completed)
        .get();

    final completedTrips = snapshot.docs.length;
    var total = 0;
    var today = 0;
    var week = 0;
    final now = DateTime.now();
    for (final doc in snapshot.docs) {
      final data = doc.data();
      final fare = (data['finalFare'] as num?)?.toInt() ?? (data['fare'] as num?)?.toInt() ?? 0;
      final completedAt = readDateTime(data['completedAt']);
      total += fare;
      if (completedAt != null) {
        final diff = now.difference(completedAt);
        if (diff.inDays == 0) {
          today += fare;
        }
        if (diff.inDays < 7) {
          week += fare;
        }
      }
    }
    return EarningsSummary(
      today: today,
      week: week,
      total: total,
      completedTrips: completedTrips,
    );
  }
}

class EarningsSummary {
  EarningsSummary({
    required this.today,
    required this.week,
    required this.total,
    required this.completedTrips,
  });

  final int today;
  final int week;
  final int total;
  final int completedTrips;
}
