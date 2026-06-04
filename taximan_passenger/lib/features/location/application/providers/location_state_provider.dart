import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/app_location.dart';
import '../../../../shared/models/driver_location.dart';
import '../../data/location_repository.dart';

class LocationState {
  const LocationState({
    required this.currentLocation,
    this.assignedDriverLocation,
    this.permissionStatus = 'unknown',
    this.isLoading = false,
    this.isLiveTracking = false,
    this.errorMessage,
  });

  final AppLocation currentLocation;
  final DriverLocation? assignedDriverLocation;
  final String permissionStatus;
  final bool isLoading;
  final bool isLiveTracking;
  final String? errorMessage;

  bool get hasLocationPermission => permissionStatus == 'granted';
  bool get isPermissionDenied =>
      permissionStatus == 'denied' || permissionStatus == 'deniedForever';
  bool get isLocationServiceDisabled => permissionStatus == 'serviceDisabled';

  LocationState copyWith({
    AppLocation? currentLocation,
    DriverLocation? assignedDriverLocation,
    String? permissionStatus,
    bool? isLoading,
    bool? isLiveTracking,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LocationState(
      currentLocation: currentLocation ?? this.currentLocation,
      assignedDriverLocation:
          assignedDriverLocation ?? this.assignedDriverLocation,
      permissionStatus: permissionStatus ?? this.permissionStatus,
      isLoading: isLoading ?? this.isLoading,
      isLiveTracking: isLiveTracking ?? this.isLiveTracking,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class LocationController extends StateNotifier<LocationState> {
  LocationController(this._repository)
    : super(const LocationState(currentLocation: AppLocation(address: '')));

  final LocationRepository _repository;
  StreamSubscription<AppLocation>? _deviceLocationSubscription;

  Future<AppLocation?> requestCurrentLocation() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final location = await _repository.getCurrentLocation();
      state = state.copyWith(
        currentLocation: location,
        permissionStatus: 'granted',
        isLoading: false,
        clearError: true,
      );
      return location;
    } on LocationAccessException catch (e) {
      state = state.copyWith(
        permissionStatus: e.permissionStatus,
        isLoading: false,
        errorMessage: e.message,
      );
      return null;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Could not detect your current location.',
      );
      return null;
    }
  }

  Future<void> startLiveUpdates() async {
    if (_deviceLocationSubscription != null) {
      return;
    }

    try {
      final permissionStatus = await _repository.ensureLocationAccess();
      state = state.copyWith(
        permissionStatus: permissionStatus,
        isLiveTracking: true,
        clearError: true,
      );
      _deviceLocationSubscription = _repository.streamDeviceLocation().listen(
        updateCurrentLocation,
        onError: (_) {
          state = state.copyWith(
            isLiveTracking: false,
            errorMessage: 'Live location updates are unavailable.',
          );
        },
      );
    } on LocationAccessException catch (e) {
      state = state.copyWith(
        permissionStatus: e.permissionStatus,
        isLiveTracking: false,
        errorMessage: e.message,
      );
    } catch (_) {
      state = state.copyWith(
        isLiveTracking: false,
        errorMessage: 'Live location updates are unavailable.',
      );
    }
  }

  Future<void> refreshPermissionStatus() async {
    final status = await _repository.checkPermissionStatus();
    state = state.copyWith(permissionStatus: status);
  }

  Future<void> stopLiveUpdates() async {
    await _deviceLocationSubscription?.cancel();
    _deviceLocationSubscription = null;
    state = state.copyWith(isLiveTracking: false);
  }

  void updateCurrentLocation(AppLocation location) {
    state = state.copyWith(
      currentLocation: location.copyWith(updatedAt: DateTime.now()),
      permissionStatus: 'granted',
      clearError: true,
    );
  }

  void updateAssignedDriverLocation(DriverLocation location) {
    state = state.copyWith(
      assignedDriverLocation: location.copyWith(updatedAt: DateTime.now()),
      clearError: true,
    );
  }

  void setPermissionStatus(String status) {
    state = state.copyWith(permissionStatus: status);
  }

  void setError(String message) {
    state = state.copyWith(isLoading: false, errorMessage: message);
  }

  @override
  void dispose() {
    _deviceLocationSubscription?.cancel();
    super.dispose();
  }
}

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepository();
});

final locationStateProvider =
    StateNotifierProvider<LocationController, LocationState>(
      (ref) => LocationController(ref.watch(locationRepositoryProvider)),
    );

final onlineDriverLocationsProvider = StreamProvider<List<DriverLocation>>((
  ref,
) {
  return ref.watch(locationRepositoryProvider).streamOnlineDriverLocations();
});

final assignedDriverLocationProvider =
    StreamProvider.family<DriverLocation?, String>((ref, driverId) {
      return ref
          .watch(locationRepositoryProvider)
          .streamAssignedDriverLocation(driverId);
    });
