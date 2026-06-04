import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/models/booking.dart';
import '../../../../shared/models/trip.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/bottom_nav_shell.dart';
import '../../../account/application/providers/user_provider.dart';
import '../../../auth/application/providers/auth_state_provider.dart';
import '../../../location/application/providers/location_state_provider.dart';
import '../../../location/presentation/widgets/live_map_view.dart';
import '../../../matching/application/providers/driver_providers.dart';
import '../../../trip/application/providers/trip_providers.dart';
import '../../application/providers/booking_providers.dart';
import '../../application/providers/booking_state_provider.dart';

class PassengerHomeScreen extends ConsumerStatefulWidget {
  const PassengerHomeScreen({super.key});

  @override
  ConsumerState<PassengerHomeScreen> createState() =>
      _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends ConsumerState<PassengerHomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(locationStateProvider.notifier).startLiveUpdates();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).valueOrNull;
    final passengerId = ref.watch(authStateProvider).userId;
    final availableDriverCount = ref.watch(availableDriverCountProvider);
    final upcomingTrip = passengerId == null
        ? null
        : ref.watch(upcomingTripStreamProvider(passengerId)).valueOrNull;
    final recentBookings = passengerId == null
        ? const <Booking>[]
        : ref.watch(recentBookingsProvider(passengerId)).valueOrNull ??
              const <Booking>[];
    final recentTrips = passengerId == null
        ? const <Trip>[]
        : ref.watch(recentTripsProvider(passengerId)).valueOrNull ??
              const <Trip>[];
    final bookingState = ref.watch(bookingStateProvider);
    final booking = bookingState.booking;
    final locationState = ref.watch(locationStateProvider);
    final onlineDrivers =
        ref.watch(onlineDriverLocationsProvider).valueOrNull ?? const [];
    final firstName = currentUser?.fullName.split(' ').first;

    return BottomNavShell(
      currentIndex: 0,
      title: 'Home Dashboard',
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstName == null || firstName.isEmpty
                            ? 'Good morning'
                            : 'Good morning, $firstName',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Plan your ride',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: () => context.go('/profile'),
                  icon: const Icon(Icons.person_outline),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (upcomingTrip != null) ...[
              AppCard(
                color: AppColors.primary,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.schedule,
                    color: AppColors.primaryDark,
                    size: 30,
                  ),
                  title: Text(
                    'Upcoming trip',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  subtitle: Text(
                    [
                      '${upcomingTrip.pickupLocation} -> ${upcomingTrip.destination}',
                      _formatTripPickupTime(upcomingTrip),
                    ].where((value) => value.isNotEmpty).join('\n'),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.primaryDark),
                  ),
                  trailing: Text(
                    upcomingTrip.status,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  onTap: () => context.push('/trip/${upcomingTrip.id}'),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            AppCard(
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.local_taxi,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ready when you are',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        availableDriverCount.when(
                          data: (count) => Text(
                            '$count online drivers available',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          loading: () => const Text(
                            'Checking driver availability...',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                          error: (_, _) => const Text(
                            'Driver availability unavailable',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/saved-drivers'),
                    child: const Text('View'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: _LocationTile(
                icon: Icons.my_location,
                title: 'Current Location',
                value: booking.pickupLocation.isEmpty
                    ? 'Set pickup location'
                    : booking.pickupLocation,
                onTap: () => context.push('/pickup'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            LiveMapView(
              height: 210,
              currentLocation: locationState.currentLocation.hasCoordinates
                  ? locationState.currentLocation
                  : null,
              pickup: booking.pickup,
              destination: booking.destinationLocation.address.isEmpty
                  ? null
                  : booking.destinationLocation,
              driverLocations: onlineDrivers,
              permissionStatus: locationState.permissionStatus,
              isLoading: locationState.isLoading,
              errorMessage: locationState.errorMessage,
              showDriverEmptyState: true,
              myLocationEnabled: locationState.hasLocationPermission,
              onCurrentLocationPressed: () async {
                final location = await ref
                    .read(locationStateProvider.notifier)
                    .requestCurrentLocation();
                if (location != null) {
                  ref
                      .read(bookingStateProvider.notifier)
                      .setPickupLocation(location);
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LocationTile(
                    icon: Icons.search,
                    title: 'Where are you going?',
                    value: booking.destination.isEmpty
                        ? 'Select destination'
                        : booking.destination,
                    onTap: () => context.push('/pickup'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: booking.destination.isEmpty
                        ? 'Book a ride'
                        : 'Continue booking',
                    icon: Icons.arrow_forward,
                    onPressed: () => context.push('/pickup'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SectionHeader(
              title: 'Recent bookings',
              onViewAll: () => context.go('/trips'),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (recentBookings.isEmpty)
              AppCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.book_online_outlined),
                  title: const Text('No recent bookings yet'),
                  subtitle: const Text(
                    'Booking requests and pending approvals will appear here.',
                  ),
                  onTap: () => context.push('/pickup'),
                ),
              )
            else
              ...recentBookings.map(
                (recentBooking) => AppCard(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.book_online),
                    title: Text(
                      recentBooking.destination,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${recentBooking.pickupLocation}\n${recentBooking.status}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      recentBooking.formattedFinalFare,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    onTap: () => context.push('/booking/${recentBooking.id}'),
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            _SectionHeader(
              title: 'Recent trips',
              onViewAll: () => context.go('/trips'),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (recentTrips.isEmpty)
              AppCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.alt_route_outlined),
                  title: const Text('No recent trips yet'),
                  subtitle: const Text(
                    'Approved, active, and completed trips will appear here.',
                  ),
                  onTap: () => context.push('/pickup'),
                ),
              )
            else
              ...recentTrips.map(
                (recentTrip) => AppCard(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.local_taxi),
                    title: Text(
                      recentTrip.destination,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${recentTrip.pickupLocation}\n${recentTrip.status}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      recentTrip.formattedFinalFare,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    onTap: () => context.push('/trip/${recentTrip.id}'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

String _formatTripPickupTime(Trip trip) {
  final value = trip.scheduledPickupTime;
  if (value == null) {
    return trip.date.isEmpty ? '' : trip.date;
  }
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year} at $hour:$minute';
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onViewAll});

  final String title;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        TextButton(onPressed: onViewAll, child: const Text('View all')),
      ],
    );
  }
}

class _LocationTile extends StatelessWidget {
  const _LocationTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
