import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taximan_driver/features/availability/presentation/screens/driver_dashboard_screen.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/models/trip.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/bottom_nav_shell.dart';
import '../../application/providers/trip_providers.dart';

class DriverTrackingScreen extends ConsumerWidget {
  const DriverTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(driverTrackableTripsProvider);
    final trips = tripsAsync.valueOrNull ?? const <Trip>[];
    final previewTrip = trips.isEmpty ? null : trips.first;

    return BottomNavShell(
      currentIndex: 2,
      title: 'Tracking',
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            DriverDashboardMiniMap(activeTrip: previewTrip),
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
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  tripsAsync.when(
                    data: (items) {
                      if (items.isEmpty) {
                        return const AppEmptyState(
                          icon: Icons.route,
                          title: 'No trips to track',
                          message:
                              'Trips you accept will appear here until they are completed.',
                        );
                      }

                      return Column(
                        children: items
                            .map(
                              (trip) => _DriverTrackableTripTile(
                                trip: trip,
                                onTap: () =>
                                    context.push('/trip-map', extra: trip),
                              ),
                            )
                            .toList(),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) => AppEmptyState(
                      icon: Icons.error_outline,
                      title: 'Could not load trips',
                      message: error.toString(),
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

class _DriverTrackableTripTile extends StatelessWidget {
  const _DriverTrackableTripTile({required this.trip, required this.onTap});

  final Trip trip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.local_taxi, color: AppColors.primaryDark),
      title: Text(
        trip.passengerName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${trip.pickup.displayName} to ${trip.destinationLocation.displayName}\n'
        'Status: ${trip.status}',
      ),
      trailing: const Icon(Icons.open_in_full),
      onTap: onTap,
    );
  }
}
