import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../booking/application/providers/booking_state_provider.dart';
import '../../../location/application/providers/location_state_provider.dart';
import '../../../location/presentation/widgets/live_map_view.dart';

class PassengerTrackingMapScreen extends ConsumerWidget {
  const PassengerTrackingMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingStateProvider).booking;
    final driverId = booking.driverId ?? '';
    final locationState = ref.watch(locationStateProvider);

    final assignedDriverLocation = driverId.isEmpty
        ? null
        : ref.watch(assignedDriverLocationProvider(driverId)).valueOrNull;

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
              pickup: booking.pickup,
              destination: booking.destinationLocation,
              assignedDriverLocation: assignedDriverLocation,
              permissionStatus: locationState.permissionStatus,
              isLoading: false,
              errorMessage: null,
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
