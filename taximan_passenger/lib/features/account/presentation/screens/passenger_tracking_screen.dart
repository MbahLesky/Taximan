import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/models/driver_location.dart';
import '../../../../shared/models/trip.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/bottom_nav_shell.dart';
import '../../../auth/application/providers/auth_state_provider.dart';
import '../../../location/application/providers/location_state_provider.dart';
import '../../../location/presentation/widgets/live_map_view.dart';
import '../../../trip/application/providers/trip_providers.dart';

class PassengerTrackingScreen extends ConsumerStatefulWidget {
  const PassengerTrackingScreen({super.key});

  @override
  ConsumerState<PassengerTrackingScreen> createState() =>
      _PassengerTrackingScreenState();
}

class _PassengerTrackingScreenState
    extends ConsumerState<PassengerTrackingScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(locationStateProvider.notifier).startLiveUpdates();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationStateProvider);
    final authState = ref.watch(authStateProvider);
    final passengerId = authState.userId ?? '';
    final trackableTripsState = passengerId.isNotEmpty
        ? ref.watch(passengerTrackableTripsProvider(passengerId))
        : const AsyncValue<List<Trip>>.data([]);
    final trackableTrips = trackableTripsState.valueOrNull ?? const <Trip>[];
    final previewTrip = trackableTrips.isEmpty ? null : trackableTrips.first;
    final driverId = previewTrip?.driverId ?? '';
    final AsyncValue<DriverLocation?> assignedDriverState = driverId.isEmpty
        ? const AsyncValue<DriverLocation?>.data(null)
        : ref.watch(assignedDriverLocationProvider(driverId));
    final previewMapPath = previewTrip == null
        ? '/tracking/map'
        : '/tracking/map/${previewTrip.id}';

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
                  pickup: previewTrip?.pickup,
                  destination: previewTrip?.destinationLocation,
                  assignedDriverLocation: assignedDriverState.valueOrNull,
                  permissionStatus: locationState.permissionStatus,
                  isLoading:
                      trackableTripsState.isLoading ||
                      assignedDriverState.isLoading,
                  errorMessage: passengerId.isEmpty
                      ? 'Sign in to view your trips.'
                      : previewTrip == null
                          ? 'No active or upcoming trips to track yet.'
                          : null,
                  myLocationEnabled: locationState.hasLocationPermission,
                  onTap: (_) => context.push(previewMapPath),
                  onExpandPressed: () => context.push(previewMapPath),
                  onCurrentLocationPressed: () => ref
                      .read(locationStateProvider.notifier)
                      .requestCurrentLocation(),
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
                          'Active and upcoming trips',
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
                  trackableTripsState.when(
                    data: (trips) {
                      if (trips.isEmpty) {
                        return const ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('No trips to track'),
                          subtitle: Text(
                            'Active and upcoming trips will appear here.',
                          ),
                        );
                      }

                      return Column(
                        children: trips
                            .map(
                              (trip) => _TrackableTripTile(
                                trip: trip,
                                onPressed: () => context.push(
                                  '/tracking/map/${trip.id}',
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Unable to load trips'),
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

class _TrackableTripTile extends StatelessWidget {
  const _TrackableTripTile({required this.trip, required this.onPressed});

  final Trip trip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.route, color: AppColors.primaryDark),
      title: Text(
        trip.destinationLocation.displayName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${trip.pickup.displayName} to ${trip.destinationLocation.displayName}\n'
        'Status: ${trip.status}',
      ),
      trailing: AppButton(
        label: 'View',
        icon: Icons.map,
        fullWidth: false,
        onPressed: onPressed,
      ),
      onTap: onPressed,
    );
  }
}
