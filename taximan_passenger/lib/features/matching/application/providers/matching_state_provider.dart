import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/driver.dart';
import '../../../../shared/models/fare_proposal.dart';

class MatchingState {
  const MatchingState({
    this.status = 'idle',
    this.availableDrivers = const [],
    this.selectedDriver,
    this.fareProposal,
    this.isLoading = false,
    this.errorMessage,
  });

  final String status;
  final List<Driver> availableDrivers;
  final Driver? selectedDriver;
  final FareProposal? fareProposal;
  final bool isLoading;
  final String? errorMessage;

  MatchingState copyWith({
    String? status,
    List<Driver>? availableDrivers,
    Driver? selectedDriver,
    FareProposal? fareProposal,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MatchingState(
      status: status ?? this.status,
      availableDrivers: availableDrivers ?? this.availableDrivers,
      selectedDriver: selectedDriver ?? this.selectedDriver,
      fareProposal: fareProposal ?? this.fareProposal,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class MatchingController extends StateNotifier<MatchingState> {
  MatchingController()
    : super(
        const MatchingState(
          availableDrivers: [
            Driver(
              id: 'driver-001',
              fullName: 'Jean Talla',
              rating: 4.8,
              vehicle: 'Toyota Corolla',
              plateNumber: 'LT 4821 AB',
              arrivalEta: '6 min',
              ratingCount: 128,
            ),
            Driver(
              id: 'driver-002',
              fullName: 'Aline Mbarga',
              rating: 4.9,
              vehicle: 'Hyundai Accent',
              plateNumber: 'CE 9472 LT',
              arrivalEta: '8 min',
              ratingCount: 96,
            ),
          ],
        ),
      );

  void startSearching() {
    state = state.copyWith(status: 'searching', isLoading: true);
  }

  void showFareProposal(FareProposal proposal) {
    state = state.copyWith(
      status: 'proposal',
      fareProposal: proposal,
      isLoading: false,
    );
  }

  void acceptProposal() {
    state = state.copyWith(
      status: 'accepted',
      selectedDriver: state.availableDrivers.isEmpty
          ? null
          : state.availableDrivers.first,
      fareProposal: state.fareProposal?.copyWith(
        status: 'accepted',
        respondedAt: DateTime.now(),
      ),
      isLoading: false,
    );
  }

  void rejectProposal() {
    state = state.copyWith(
      status: 'searching',
      fareProposal: state.fareProposal?.copyWith(
        status: 'rejected',
        respondedAt: DateTime.now(),
      ),
      isLoading: true,
    );
  }

  void assignDriver(Driver driver) {
    state = state.copyWith(
      status: 'accepted',
      selectedDriver: driver,
      isLoading: false,
    );
  }

  void cancelSearch() {
    state = state.copyWith(status: 'cancelled', isLoading: false);
  }
}

final matchingStateProvider =
    StateNotifierProvider<MatchingController, MatchingState>(
      (ref) => MatchingController(),
    );
