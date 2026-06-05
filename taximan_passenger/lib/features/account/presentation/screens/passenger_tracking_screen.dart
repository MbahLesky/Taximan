import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/bottom_nav_shell.dart';
import '../../../auth/application/providers/auth_state_provider.dart';
import '../../../booking/application/providers/booking_state_provider.dart';
import '../../../location/application/providers/location_state_provider.dart';
import '../../../location/presentation/widgets/live_map_view.dart';
import '../../../trip/application/providers/trip_providers.dart';
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
    final authState = ref.watch(authStateProvider);
    final passengerId = authState.userId ?? '';
    final activeTripsState = passengerId.isNotEmpty
        ? ref.watch(passengerActiveTripsProvider(passengerId))
        : const AsyncValue.data([]);

    return BottomNavShell(
      currentIndex: 2,
      title: 'Tracking',
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Stack(
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
                  onTap: (_) => context.push('/tracking/map'),
                ),
                Positioned(
                  right: AppSpacing.sm,
                  top: AppSpacing.sm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'Tap to open full screen',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
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
                  activeTripsState.when(
                    data: (trips) {
                      if (trips.isEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (TripStatus.active.contains(booking.status))
                              ListTile(
                                title: Text('Trip: ${booking.id.isEmpty ? 'current' : booking.id}'),
                                subtitle: Text('Status: ${booking.status}'),
                                trailing: AppButton(
                                  label: 'View',
                                  icon: Icons.map,
                                  onPressed: () => context.push('/tracking/map'),
                                ),
                              )
                            else
                              const ListTile(
                                title: Text('No live trips to track'),
                                subtitle: Text('Only active trips are shown here.'),
                              ),
                          ],
                        );
                      }

                      return Column(
                        children: trips.map(
                          (trip) {
                            return ListTile(
                              title: Text('Trip: ${trip.id}'),
                              subtitle: Text(
                                'Status: ${trip.status}\n${trip.pickup.displayName} → ${trip.destinationLocation.displayName}',
                              ),
                              trailing: AppButton(
                                label: 'View',
                                icon: Icons.map,
                                onPressed: () => context.push('/tracking/map/${trip.id}'),
                              ),
                            );
                          },
                        ).toList(),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => ListTile(
                      title: const Text('Unable to load live trips'),
                      subtitle: Text(error.toString()),
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

// Timeline widget removed; tracking screen now lists live trips and opens full map.
