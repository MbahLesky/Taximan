import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/fare_proposal.dart';
import '../../data/fare_proposal_repository.dart';

final fareProposalRepositoryProvider = Provider<FareProposalRepository>((ref) {
  return FareProposalRepository();
});

final pendingFareProposalProvider =
    StreamProvider.family<FareProposal?, String>((ref, bookingId) {
      final repository = ref.watch(fareProposalRepositoryProvider);
      return repository.streamPendingProposal(bookingId);
    });

final bookingFareProposalsProvider =
    StreamProvider.family<List<FareProposal>, String>((ref, bookingId) {
      final repository = ref.watch(fareProposalRepositoryProvider);
      return repository.streamBookingProposals(bookingId);
    });
