import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/ride_statuses.dart';
import '../../../shared/models/booking.dart';
import '../../../shared/models/fare_proposal.dart';

class BookingRepository {
  BookingRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Stream<List<Booking>> streamAvailableBookings(String driverId) {
    return _firestore
        .collection('bookings')
        .where('status', isEqualTo: BookingStatus.searching)
        .snapshots()
        .map((snapshot) {
          final bookings = snapshot.docs
              .where((doc) => _isVisibleToDriver(doc.data(), driverId))
              .map((doc) => Booking.fromMap({...doc.data(), 'id': doc.id}))
              .toList();

          bookings.sort((a, b) {
            final aCreated =
                a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bCreated =
                b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            return bCreated.compareTo(aCreated);
          });

          return bookings;
        });
  }

  Future<void> acceptBooking({
    required String bookingId,
    required String driverId,
    String? vehicleId,
  }) async {
    final bookingRef = _firestore.collection('bookings').doc(bookingId);
    final tripRef = _firestore.collection('trips').doc();
    final notificationRef = _firestore.collection('notifications').doc();

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(bookingRef);
      final data = snapshot.data();
      if (data == null) {
        throw Exception('Booking request no longer exists.');
      }
      if (data['status'] != BookingStatus.searching ||
          (data['driverId'] as String?)?.isNotEmpty == true) {
        throw Exception('This booking has already been handled.');
      }

      transaction.update(bookingRef, {
        'driverId': driverId,
        'vehicleId': vehicleId,
        'status': BookingStatus.accepted,
        'acceptedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      transaction.set(tripRef, {
        'id': tripRef.id,
        'bookingId': bookingId,
        'passengerId': data['passengerId'],
        'driverId': driverId,
        'vehicleId': vehicleId,
        'pickupLocation': data['pickupLocation'],
        'destinationLocation': data['destinationLocation'],
        'scheduledPickupTime': data['scheduledPickupTime'],
        'status': TripStatus.driverArriving,
        'distanceKm': data['distanceKm'],
        'estimatedDurationMinutes': data['estimatedDurationMinutes'],
        'estimatedFare': data['estimatedFare'],
        'finalFare': data['finalFare'] ?? data['estimatedFare'],
        'paymentMethod': data['paymentMethod'],
        'paymentStatus': data['paymentStatus'] ?? 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      transaction.set(notificationRef, {
        'id': notificationRef.id,
        'userId': data['passengerId'],
        'userRole': 'passenger',
        'title': 'Ride approved',
        'body': 'A driver has accepted your ride request.',
        'type': 'ride_approved',
        'isRead': false,
        'relatedId': tripRef.id,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> declineBooking({
    required String bookingId,
    required String driverId,
  }) {
    return _firestore.collection('bookings').doc(bookingId).set({
      'declinedDriverIds': FieldValue.arrayUnion([driverId]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> proposeFare({
    required Booking booking,
    required String driverId,
    required int proposedFare,
    String? vehicleId,
    String message = '',
  }) async {
    final proposalRef = _firestore.collection('fare_proposals').doc();
    final bookingRef = _firestore.collection('bookings').doc(booking.id);
    final notificationRef = _firestore.collection('notifications').doc();

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(bookingRef);
      final data = snapshot.data();
      if (data == null) {
        throw Exception('Booking request no longer exists.');
      }
      if (data['status'] != BookingStatus.searching) {
        throw Exception('This booking is no longer accepting proposals.');
      }

      transaction.set(proposalRef, {
        'id': proposalRef.id,
        'bookingId': booking.id,
        'driverId': driverId,
        'vehicleId': vehicleId,
        'originalFare': booking.estimatedFare,
        'proposedFare': proposedFare,
        'message': message.trim(),
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'respondedAt': null,
      });
      transaction.update(bookingRef, {
        'status': BookingStatus.proposal,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      transaction.set(notificationRef, {
        'id': notificationRef.id,
        'userId': data['passengerId'],
        'userRole': 'passenger',
        'title': 'New fare proposal',
        'body': message.trim().isEmpty
            ? 'A driver proposed $proposedFare FCFA for your ride.'
            : message.trim(),
        'type': 'fare_proposal',
        'isRead': false,
        'relatedId': booking.id,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Stream<List<FareProposal>> streamDriverProposals(String driverId) {
    return _firestore
        .collection('fare_proposals')
        .where('driverId', isEqualTo: driverId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => FareProposal.fromMap({...doc.data(), 'id': doc.id}))
              .toList();
        });
  }

  Future<FareProposal?> getProposal(String proposalId) async {
    final doc = await _firestore.collection('fare_proposals').doc(proposalId).get();
    if (!doc.exists) return null;
    return FareProposal.fromMap({...doc.data() as Map<String, dynamic>, 'id': doc.id});
  }
}

bool _isVisibleToDriver(Map<String, dynamic> data, String driverId) {
  final bookingDriverId = data['driverId'] as String?;
  final preferredDriverId = data['preferredDriverId'] as String?;
  final declinedDriverIds =
      (data['declinedDriverIds'] as List<dynamic>? ?? const [])
          .map((value) => value.toString())
          .toSet();

  if (bookingDriverId != null && bookingDriverId.isNotEmpty) {
    return bookingDriverId == driverId;
  }
  if (preferredDriverId != null &&
      preferredDriverId.isNotEmpty &&
      preferredDriverId != driverId) {
    return false;
  }
  return !declinedDriverIds.contains(driverId);
}
