import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../auth/application/providers/auth_state_provider.dart';
import '../../../booking/application/providers/booking_state_provider.dart';
import '../../../trip/application/providers/trip_providers.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/bottom_nav_shell.dart';

class TripHistoryScreen extends ConsumerWidget {
  const TripHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void startNewTrip() {
      ref.read(bookingStateProvider.notifier).startNewTrip();
      context.push('/pickup');
    }

    final passengerId = ref.watch(authStateProvider).userId;
    final trips = passengerId == null
        ? null
        : ref.watch(recentTripsProvider(passengerId)).valueOrNull;

    return BottomNavShell(
      currentIndex: 1,
      title: 'Trips and Bookings',
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.add_road_outlined,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Book a new trip',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            const Text(
                              'Start with pickup, destination, time, and fare estimate.',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton.icon(
                    onPressed: startNewTrip,
                    icon: const Icon(Icons.local_taxi_outlined),
                    label: const Text('New trip'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Trip history',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.sm),
            if ((trips ?? const []).isEmpty)
              AppEmptyState(
                icon: Icons.history,
                title: 'No trips yet',
                message: 'Your completed rides will appear here.',
                actionLabel: 'Book a ride',
                onAction: startNewTrip,
              )
            else
              ...trips!.map(
                (trip) => AppCard(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.local_taxi),
                    title: Text(
                      '${trip.pickupLocation} to ${trip.destination}',
                    ),
                    subtitle: Text('${trip.date} - ${trip.status}'),
                    trailing: Text(
                      trip.formattedFinalFare,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    onTap: () => context.push('/trip-details'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
