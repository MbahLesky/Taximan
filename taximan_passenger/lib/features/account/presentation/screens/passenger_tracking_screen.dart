import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/bottom_nav_shell.dart';
import '../../../booking/application/providers/booking_state_provider.dart';
import '../../../location/application/providers/location_state_provider.dart';
import '../../../location/presentation/widgets/live_map_view.dart';
import '../../../../core/constants/ride_statuses.dart';

class PassengerTrackingScreen extends ConsumerWidget {
  const PassengerTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingStateProvider).booking;
    final driverId = booking.driverId ?? '';
    if (driverId.isNotEmpty) {
      ref.listen(assignedDriverLocationProvider(driverId), (previous, next) {
        final location = next.valueOrNull;
        if (location != null) {
          ref.read(locationStateProvider.notifier).updateAssignedDriverLocation(location);
        }
      });
    }
    final locationState = ref.watch(locationStateProvider);
    final assignedDriverLocation = driverId.isEmpty
        ? null
        : ref.watch(assignedDriverLocationProvider(driverId)).valueOrNull;

    // Only show list of live trips (driver_arriving, arrived, in_progress)
    return BottomNavShell(
      currentIndex: 2,
      title: 'Tracking',
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            LiveMapView(
              height: 220,
              currentLocation: locationState.currentLocation.hasCoordinates
                  ? locationState.currentLocation
                  : null,
              pickup: booking.pickup,
              destination: booking.destinationLocation,
              assignedDriverLocation: assignedDriverLocation,
              permissionStatus: locationState.permissionStatus,
              isLoading:
                  driverId.isNotEmpty &&
                  ref.watch(assignedDriverLocationProvider(driverId)).isLoading,
              errorMessage: driverId.isEmpty
                  ? 'A driver has not been assigned yet.'
                  : null,
              myLocationEnabled: locationState.hasLocationPermission,
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.near_me, color: AppColors.primaryDark),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Live trips',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      const Chip(
                        visualDensity: VisualDensity.compact,
                        backgroundColor: AppColors.primaryLight,
                        side: BorderSide.none,
                        label: Text('Live'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // If current booking is in a live trip state, show it as selectable
                  if (TripStatus.active.contains(booking.status)) ...[
                    ListTile(
                      title: Text('Trip: ${booking.id.isEmpty ? 'current' : booking.id}'),
                      subtitle: Text('Status: ${booking.status}'),
                      trailing: AppButton(
                        label: 'View',
                        icon: Icons.map,
                        onPressed: () => context.push('/tracking/map'),
                      ),
                    ),
                  ] else ...[
                    const ListTile(
                      title: Text('No live trips to track'),
                      subtitle: Text('Only active trips are shown here.'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Timeline widget removed; tracking screen now lists live trips and opens full map.
