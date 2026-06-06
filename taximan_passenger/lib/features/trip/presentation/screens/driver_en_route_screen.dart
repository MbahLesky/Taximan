import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../booking/application/providers/booking_state_provider.dart';
import '../../../location/application/providers/location_state_provider.dart';
import '../../../location/presentation/widgets/live_map_view.dart';
import '../../../matching/application/providers/driver_providers.dart';

class DriverEnRouteScreen extends ConsumerWidget {
  const DriverEnRouteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingStateProvider).booking;
    final driverId = booking.driverId ?? '';
    final driver = driverId.isEmpty
        ? null
        : ref.watch(driverStreamProvider(driverId)).valueOrNull;
    if (driverId.isNotEmpty) {
      ref.listen(assignedDriverLocationProvider(driverId), (previous, next) {
        final location = next.valueOrNull;
        if (location != null) {
          ref
              .read(locationStateProvider.notifier)
              .updateAssignedDriverLocation(location);
        }
      });
    }
    final locationState = ref.watch(locationStateProvider);
    final assignedDriverLocation = driverId.isEmpty
        ? null
        : ref.watch(assignedDriverLocationProvider(driverId)).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver en route'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: LiveMapView(
                currentLocation: locationState.currentLocation.hasCoordinates
                    ? locationState.currentLocation
                    : null,
                pickup: booking.pickup,
                destination: booking.destinationLocation,
                assignedDriverLocation: assignedDriverLocation,
                permissionStatus: locationState.permissionStatus,
                isLoading:
                    driverId.isNotEmpty &&
                    ref
                        .watch(assignedDriverLocationProvider(driverId))
                        .isLoading,
                errorMessage: driverId.isEmpty
                    ? 'A driver has not been assigned yet.'
                    : null,
                myLocationEnabled: locationState.hasLocationPermission,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Driver is moving toward pickup',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    booking.eta.isEmpty ? 'ETA pending' : 'ETA ${booking.eta}',
                  ),
                  const Divider(height: 28),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(driver?.fullName ?? 'Driver assigned'),
                    subtitle: Text(
                      [driver?.vehicle.model, driver?.vehicle.plateNumber]
                          .whereType<String>()
                          .where((value) => value.isNotEmpty)
                          .join(' - '),
                    ),
                    trailing: const Icon(Icons.call_outlined),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.my_location),
                    title: const Text('Pickup point'),
                    subtitle: Text(booking.pickupLocation),
                  ),
                  AppButton(
                    label: 'Driver arrived',
                    onPressed: () => context.push('/driver-arrived'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
