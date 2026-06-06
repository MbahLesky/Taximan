import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/trip.dart';
import '../../data/trip_repository.dart';
import '../../../auth/application/providers/auth_state_provider.dart';

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  return TripRepository();
});

final driverTripsStreamProvider = StreamProvider<List<Trip>>((ref) {
  final driverId = ref.watch(authStateProvider).userId;
  if (driverId == null || driverId.isEmpty) {
    return const Stream<List<Trip>>.empty();
  }
  return ref.watch(tripRepositoryProvider).streamDriverTrips(driverId);
});

final driverActiveTripProvider = StreamProvider<Trip?>((ref) {
  final driverId = ref.watch(authStateProvider).userId;
  if (driverId == null || driverId.isEmpty) {
    return const Stream<Trip?>.empty();
  }
  return ref.watch(tripRepositoryProvider).streamActiveTrip(driverId);
});

final driverTrackableTripsProvider = StreamProvider<List<Trip>>((ref) {
  final driverId = ref.watch(authStateProvider).userId;
  if (driverId == null || driverId.isEmpty) {
    return const Stream<List<Trip>>.empty();
  }
  return ref.watch(tripRepositoryProvider).streamTrackableTrips(driverId);
});

final driverCompletedTripsProvider = StreamProvider<List<Trip>>((ref) {
  final driverId = ref.watch(authStateProvider).userId;
  if (driverId == null || driverId.isEmpty) {
    return const Stream<List<Trip>>.empty();
  }
  return ref.watch(tripRepositoryProvider).streamCompletedTrips(driverId);
});

final driverEarningsProvider = FutureProvider<EarningsSummary>((ref) async {
  final driverId = ref.watch(authStateProvider).userId;
  if (driverId == null || driverId.isEmpty) {
    return EarningsSummary(today: 0, week: 0, total: 0, completedTrips: 0);
  }
  return ref.watch(tripRepositoryProvider).fetchEarningsSummary(driverId);
});

final selectedTripProvider = StateProvider<Trip?>((ref) => null);

final tripActionsProvider = Provider<TripActions>((ref) {
  return TripActions(ref);
});

class TripActions {
  TripActions(this._ref);

  final Ref _ref;

  TripRepository get _repository => _ref.read(tripRepositoryProvider);

  String get _driverId {
    final driverId = _ref.read(authStateProvider).userId;
    if (driverId == null || driverId.isEmpty) {
      throw Exception('Sign in before managing trips.');
    }
    return driverId;
  }

  Future<void> startTrip(String tripId) async {
    await _repository.startTrip(tripId);
  }

  Future<void> completeTrip(String tripId, int finalFare) async {
    await _repository.completeTrip(tripId, finalFare);
  }

  Future<void> updateStatus(String tripId, String status) async {
    await _repository.updateTripStatus(tripId, status);
  }
}
