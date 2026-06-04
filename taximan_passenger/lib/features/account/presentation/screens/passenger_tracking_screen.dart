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
import '../../../matching/application/providers/driver_providers.dart';

class PassengerTrackingScreen extends ConsumerWidget {
  const PassengerTrackingScreen({super.key});

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
                          'Current trip status',
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
                  _TimelineStep(
                    icon: Icons.check_circle,
                    title: 'Ride accepted',
                    subtitle:
                        '${driver?.fullName ?? 'Your driver'} confirmed your request.',
                    active: true,
                  ),
                  _TimelineStep(
                    icon: Icons.local_taxi,
                    title: 'Driver on the way',
                    subtitle: booking.eta.isEmpty
                        ? 'ETA pending to your pickup point.'
                        : 'ETA ${booking.eta} to your pickup point.',
                    active: true,
                  ),
                  const _TimelineStep(
                    icon: Icons.flag_outlined,
                    title: 'Pickup pending',
                    subtitle: 'You will be notified when the driver arrives.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.primaryLight,
                      child: Icon(Icons.person, color: AppColors.primaryDark),
                    ),
                    title: Text(driver?.fullName ?? 'Driver assigned'),
                    subtitle: Text(
                      [driver?.vehicle, driver?.plateNumber]
                          .whereType<String>()
                          .where((value) => value.isNotEmpty)
                          .join(' - '),
                    ),
                    trailing: const Icon(Icons.star, color: AppColors.warning),
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Open live trip',
                          icon: Icons.map_outlined,
                          onPressed: () => context.push('/driver-en-route'),
                        ),
                      ),
                    ],
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

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.active = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: active ? AppColors.success : AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
