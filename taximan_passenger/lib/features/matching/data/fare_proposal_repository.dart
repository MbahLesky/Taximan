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
      return FareProposal.fromMap(snapshot.docs.first.data());
    });
  }

  Future<void> acceptProposal(FareProposal proposal) async {
    final proposalRef = _firestore.collection(_collection).doc(proposal.id);
    final bookingRef = _firestore.collection('bookings').doc(proposal.bookingId);

    await _firestore.runTransaction((transaction) async {
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
    });
  }

  Future<void> rejectProposal(FareProposal proposal) async {
    final proposalRef = _firestore.collection(_collection).doc(proposal.id);
    final bookingRef = _firestore.collection('bookings').doc(proposal.bookingId);

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
}
