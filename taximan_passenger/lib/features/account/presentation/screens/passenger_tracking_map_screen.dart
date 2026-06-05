import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/models/app_location.dart';
import '../../../../shared/models/trip.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../location/application/providers/location_state_provider.dart';
import '../../../location/presentation/widgets/live_map_view.dart';
import '../../../trip/application/providers/trip_providers.dart';

class PassengerTrackingMapScreen extends ConsumerStatefulWidget {
  const PassengerTrackingMapScreen({super.key, this.tripId});

  final String? tripId;

  @override
  ConsumerState<PassengerTrackingMapScreen> createState() =>
      _PassengerTrackingMapScreenState();
}

class _PassengerTrackingMapScreenState
    extends ConsumerState<PassengerTrackingMapScreen> {
  bool _requestedLocation = false;

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationStateProvider);
    final bool hasTripId = widget.tripId != null && widget.tripId!.isNotEmpty;
    final AsyncValue<Trip?>? tripState =
        hasTripId ? ref.watch(tripStreamProvider(widget.tripId!)) : null;
    final Trip? trip = tripState?.valueOrNull;
    final bool isTripLoading = tripState?.isLoading == true;

    if (!_requestedLocation && !locationState.currentLocation.hasCoordinates) {
      _requestedLocation = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(locationStateProvider.notifier).requestCurrentLocation();
      });
    }

    final AppLocation? pickup = trip?.pickup;
    final AppLocation? destination = trip?.destinationLocation;
    final String driverId = trip?.driverId ?? '';

    final assignedDriverLocation = driverId.isEmpty
        ? null
        : ref.watch(assignedDriverLocationProvider(driverId)).valueOrNull;

    final String? message = !hasTripId
        ? 'No trip selected. Please choose a live trip to track.'
        : tripState?.when(
            data: (data) => data == null
                ? 'Trip not found or no longer active.'
                : null,
            loading: () => null,
            error: (error, _) =>
                'Unable to load tracking details: ${error.toString()}',
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live tracking'),
        leading: BackButton(onPressed: () => Navigator.of(context).pop()),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            LiveMapView(
              height: double.infinity,
              currentLocation: locationState.currentLocation.hasCoordinates
                  ? locationState.currentLocation
                  : null,
              pickup: pickup,
              destination: destination,
              assignedDriverLocation: assignedDriverLocation,
              permissionStatus: locationState.permissionStatus,
              isLoading: isTripLoading,
              errorMessage: message,
              myLocationEnabled: locationState.hasLocationPermission,
              onCurrentLocationPressed: () =>
                  ref.read(locationStateProvider.notifier).requestCurrentLocation(),
            ),
            if (message != null)
              Positioned(
                left: AppSpacing.md,
                right: AppSpacing.md,
                top: AppSpacing.md,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            if (isTripLoading)
              const Positioned.fill(
                child: ColoredBox(
                  color: Colors.black26,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.md,
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Close',
                      icon: Icons.arrow_back,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
