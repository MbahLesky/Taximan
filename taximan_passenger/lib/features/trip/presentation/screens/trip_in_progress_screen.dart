import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../booking/application/providers/booking_state_provider.dart';
import '../../../location/application/providers/location_state_provider.dart';
import '../../../location/presentation/widgets/live_map_view.dart';

class TripInProgressScreen extends ConsumerWidget {
  const TripInProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingStateProvider).booking;
    final driverId = booking.driverId ?? '';
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
        title: const Text('Trip in progress'),
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
                  const Chip(
                    avatar: Icon(Icons.directions_car, size: 18),
                    label: Text('Trip active'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.location_on),
                    title: const Text('Destination'),
                    subtitle: Text(booking.destination),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: const LinearProgressIndicator(
                      value: .56,
                      minHeight: 8,
                      backgroundColor: AppColors.border,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      const Expanded(child: Text('Estimated remaining time')),
                      Text(
                        booking.eta.isEmpty ? 'Pending' : booking.eta,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: 'Share trip status',
                    icon: Icons.ios_share_outlined,
                    variant: AppButtonVariant.secondary,
                    onPressed: () {},
                  ),
                  const SizedBox(height: AppSpacing.compact),
                  AppButton(
                    label: 'Continue to payment',
                    onPressed: () => context.push('/payment'),
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
