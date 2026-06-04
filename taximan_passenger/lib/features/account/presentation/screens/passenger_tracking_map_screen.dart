import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../booking/application/providers/booking_state_provider.dart';
import '../../../location/application/providers/location_state_provider.dart';
import '../../../location/presentation/widgets/live_map_view.dart';
import '../../../trip/application/providers/trip_providers.dart';

class PassengerTrackingMapScreen extends ConsumerWidget {
  const PassengerTrackingMapScreen({super.key, this.tripId});

  final String? tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingStateProvider).booking;
    final locationState = ref.watch(locationStateProvider);
    final tripState = tripId != null ? ref.watch(tripStreamProvider(tripId!)) : null;
    final trip = tripState?.valueOrNull ?? booking;
    final driverId = trip.driverId.isNotEmpty ? trip.driverId : booking.driverId ?? '';

    final assignedDriverLocation = driverId.isEmpty
        ? null
        : ref.watch(assignedDriverLocationProvider(driverId)).valueOrNull;

    final errorMessage = tripState?.when(
      data: (_) => null,
      loading: () => null,
      error: (error, _) => 'Unable to load tracking details: ${error.toString()}',
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
              pickup: trip.pickup,
              destination: trip.destinationLocation,
              assignedDriverLocation: assignedDriverLocation,
              permissionStatus: locationState.permissionStatus,
              isLoading: false,
              errorMessage: errorMessage,
              myLocationEnabled: locationState.hasLocationPermission,
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
