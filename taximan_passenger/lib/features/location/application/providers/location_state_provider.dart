import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/app_location.dart';
import '../../../../shared/models/driver_location.dart';

class LocationState {
  const LocationState({
    required this.currentLocation,
    this.assignedDriverLocation,
    this.permissionStatus = 'granted',
    this.isLoading = false,
    this.errorMessage,
  });

  final AppLocation currentLocation;
  final DriverLocation? assignedDriverLocation;
  final String permissionStatus;
  final bool isLoading;
  final String? errorMessage;

  LocationState copyWith({
    AppLocation? currentLocation,
    DriverLocation? assignedDriverLocation,
    String? permissionStatus,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LocationState(
      currentLocation: currentLocation ?? this.currentLocation,
      assignedDriverLocation:
          assignedDriverLocation ?? this.assignedDriverLocation,
      permissionStatus: permissionStatus ?? this.permissionStatus,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class LocationController extends StateNotifier<LocationState> {
  LocationController()
    : super(
        const LocationState(
          currentLocation: AppLocation(address: ''),
        ),
      );

  void updateCurrentLocation(AppLocation location) {
    state = state.copyWith(
      currentLocation: location.copyWith(updatedAt: DateTime.now()),
      errorMessage: null,
    );
  }

  void updateAssignedDriverLocation(DriverLocation location) {
    state = state.copyWith(
      assignedDriverLocation: location.copyWith(updatedAt: DateTime.now()),
      errorMessage: null,
    );
  }

  void setPermissionStatus(String status) {
    state = state.copyWith(permissionStatus: status);
  }

  void setError(String message) {
    state = state.copyWith(isLoading: false, errorMessage: message);
  }
}

final locationStateProvider =
    StateNotifierProvider<LocationController, LocationState>(
      (ref) => LocationController(),
    );
