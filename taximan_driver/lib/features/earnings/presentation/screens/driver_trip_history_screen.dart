import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/bottom_nav_shell.dart';
import '../../../trip/application/providers/trip_providers.dart';

class DriverTripHistoryScreen extends ConsumerWidget {
  const DriverTripHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final completedTrips = ref.watch(driverCompletedTripsProvider);

    return BottomNavShell(
      currentIndex: 2,
      title: 'Trip history',
      child: SafeArea(
        child: completedTrips.when(
          data: (trips) {
            if (trips.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: AppEmptyState(
                  icon: Icons.history,
                  title: 'No trips yet',
                  message: 'Accepted and completed trips will appear here.',
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                return AppCard(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.local_taxi),
                    title: Text('${trip.passengerName} to ${trip.destinationLocation.address}'),
                    subtitle: Text('${trip.date} • ${trip.status}'),
                    trailing: Text(
                      trip.formattedFare,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    onTap: () => context.push('/trip-details', extra: trip),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AppEmptyState(
              icon: Icons.error_outline,
              title: 'Could not load trips',
              message: error.toString(),
            ),
          ),
        ),
      ),
    );
  }
}
