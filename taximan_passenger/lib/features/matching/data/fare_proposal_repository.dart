import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/ride_statuses.dart';
import '../../../shared/models/fare_proposal.dart';

class FareProposalRepository {
  FareProposalRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String _collection = 'fare_proposals';

  Stream<FareProposal?> streamPendingProposal(String bookingId) {
    return _firestore
        .collection(_collection)
        .where('bookingId', isEqualTo: bookingId)
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) {
            return null;
          }
          final doc = snapshot.docs.first;
          return FareProposal.fromMap({...doc.data(), 'id': doc.id});
        });
  }

  Stream<List<FareProposal>> streamBookingProposals(String bookingId) {
    return _firestore
        .collection(_collection)
        .where('bookingId', isEqualTo: bookingId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => FareProposal.fromMap({...doc.data(), 'id': doc.id}))
              .toList();
        });
  }

  Future<String> acceptProposal(FareProposal proposal) async {
    final proposalRef = _firestore.collection(_collection).doc(proposal.id);
    final bookingRef = _firestore
        .collection('bookings')
        .doc(proposal.bookingId);
    final tripRef = _firestore.collection('trips').doc();

    await _firestore.runTransaction((transaction) async {
      final proposalSnapshot = await transaction.get(proposalRef);
      final proposalData = proposalSnapshot.data();
      if (proposalData == null) {
        throw Exception('Fare proposal no longer exists.');
      }
      if (proposalData['status'] != 'pending') {
        throw Exception('This proposal has already been handled.');
      }

      final bookingSnapshot = await transaction.get(bookingRef);
      final bookingData = bookingSnapshot.data();
      if (bookingData == null) {
        throw Exception('Booking no longer exists.');
      }
      final bookingDriverId = bookingData['driverId'] as String?;
      if (bookingDriverId != null && bookingDriverId.isNotEmpty) {
        throw Exception('This booking already has a driver.');
      }

      transaction.update(proposalRef, {
        'status': 'accepted',
        'respondedAt': FieldValue.serverTimestamp(),
      });
      transaction.update(bookingRef, {
        'driverId': proposal.driverId,
        'vehicleId': proposal.vehicleId,
        'finalFare': proposal.proposedFare,
        'status': BookingStatus.accepted,
        'acceptedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      transaction.set(tripRef, {
        'id': tripRef.id,
        'bookingId': proposal.bookingId,
        'passengerId': bookingData['passengerId'],
        'driverId': proposal.driverId,
        'vehicleId': proposal.vehicleId,
        'pickupLocation': bookingData['pickupLocation'],
        'pickupLocationText': bookingData['pickupLocationText'],
        'destinationLocation': bookingData['destinationLocation'],
        'destination': bookingData['destination'],
        'status': TripStatus.driverArriving,
        'distance': bookingData['distance'],
        'eta': bookingData['eta'],
        'distanceKm': bookingData['distanceKm'],
        'estimatedDurationMinutes': bookingData['estimatedDurationMinutes'],
        'estimatedFare': bookingData['estimatedFare'],
        'fare': bookingData['estimatedFare'],
        'finalFare': proposal.proposedFare,
        'paymentMethod': bookingData['paymentMethod'],
        'paymentStatus': bookingData['paymentStatus'] ?? 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });

    await _rejectOtherPendingProposals(proposal);
    return tripRef.id;
  }

  Future<void> rejectProposal(FareProposal proposal) async {
    final proposalRef = _firestore.collection(_collection).doc(proposal.id);
    final bookingRef = _firestore
        .collection('bookings')
        .doc(proposal.bookingId);

    await _firestore.runTransaction((transaction) async {
      transaction.update(proposalRef, {
        'status': 'rejected',
        'respondedAt': FieldValue.serverTimestamp(),
      });
      transaction.update(bookingRef, {
        'status': BookingStatus.searching,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> _rejectOtherPendingProposals(
    FareProposal acceptedProposal,
  ) async {
    final query = await _firestore
        .collection(_collection)
        .where('bookingId', isEqualTo: acceptedProposal.bookingId)
        .where('status', isEqualTo: 'pending')
        .get();

    if (query.docs.isEmpty) {
      return;
    }

    final batch = _firestore.batch();
    for (final doc in query.docs) {
      if (doc.id == acceptedProposal.id) {
        continue;
      }
      batch.update(doc.reference, {
        'status': 'rejected',
        'respondedAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }
}
