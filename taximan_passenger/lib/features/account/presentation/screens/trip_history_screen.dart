import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/models/booking.dart';
import '../../../../shared/models/trip.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/bottom_nav_shell.dart';
import '../../../auth/application/providers/auth_state_provider.dart';
import '../../../booking/application/providers/booking_providers.dart';
import '../../../booking/application/providers/booking_state_provider.dart';
import '../../../trip/application/providers/trip_providers.dart';

class TripHistoryScreen extends ConsumerWidget {
  const TripHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void startNewTrip() {
      ref.read(bookingStateProvider.notifier).startNewTrip();
      context.push('/pickup');
    }

    final passengerId = ref.watch(authStateProvider).userId;

    if (passengerId == null) {
      return BottomNavShell(
        currentIndex: 1,
        title: 'Trips and Bookings',
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AppEmptyState(
              icon: Icons.lock_outline,
              title: 'Sign in required',
              message: 'Your bookings and trips will appear after sign in.',
              actionLabel: 'Go home',
              onAction: () => context.go('/home'),
            ),
          ),
        ),
      );
    }

    final bookings = ref.watch(passengerBookingsProvider(passengerId));
    final trips = ref.watch(passengerTripsProvider(passengerId));

    return BottomNavShell(
      currentIndex: 1,
      title: 'Trips and Bookings',
      child: DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: _NewTripCard(onStartNewTrip: startNewTrip),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: TabBar(
                  tabs: [
                    Tab(text: 'Bookings'),
                    Tab(text: 'Trips'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _BookingsTab(
                      bookings: bookings,
                      onStartNewTrip: startNewTrip,
                    ),
                    _TripsTab(trips: trips, onStartNewTrip: startNewTrip),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewTripCard extends StatelessWidget {
  const _NewTripCard({required this.onStartNewTrip});

  final VoidCallback onStartNewTrip;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                const Text(
                  'Create a booking request and review driver proposals.',
                ),
              ],
            ),
          ),
          IconButton.filled(
            tooltip: 'New trip',
            onPressed: onStartNewTrip,
            icon: const Icon(Icons.local_taxi_outlined),
          ),
        ],
      ),
    );
  }
}

class _BookingsTab extends StatelessWidget {
  const _BookingsTab({required this.bookings, required this.onStartNewTrip});

  final AsyncValue<List<Booking>> bookings;
  final VoidCallback onStartNewTrip;

  @override
  Widget build(BuildContext context) {
    return bookings.when(
      data: (items) {
        if (items.isEmpty) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              AppEmptyState(
                icon: Icons.book_online_outlined,
                title: 'No bookings yet',
                message:
                    'Booking requests and pending fare approvals will appear here.',
                actionLabel: 'Book a ride',
                onAction: onStartNewTrip,
              ),
            ],
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final booking = items[index];
            return AppCard(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.book_online),
                title: Text(
                  booking.destination,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.pickupLocation,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        _StatusChip(label: booking.status),
                        _StatusChip(label: _formatPickupTime(booking)),
                      ],
                    ),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/booking/${booking.id}'),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorState(
        icon: Icons.error_outline,
        title: 'Could not load bookings',
        message: '$error',
      ),
    );
  }
}

class _TripsTab extends StatelessWidget {
  const _TripsTab({required this.trips, required this.onStartNewTrip});

  final AsyncValue<List<Trip>> trips;
  final VoidCallback onStartNewTrip;

  @override
  Widget build(BuildContext context) {
    return trips.when(
      data: (items) {
        if (items.isEmpty) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              AppEmptyState(
                icon: Icons.alt_route,
                title: 'No trips yet',
                message:
                    'Approved, active, and completed trips from the trips collection will appear here.',
                actionLabel: 'Book a ride',
                onAction: onStartNewTrip,
              ),
            ],
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final trip = items[index];
            return AppCard(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.local_taxi),
                title: Text(
                  trip.destination,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.pickupLocation,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        _StatusChip(label: trip.status),
                        if (trip.date.isNotEmpty) _StatusChip(label: trip.date),
                      ],
                    ),
                  ],
                ),
                trailing: Text(
                  trip.formattedFinalFare,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                  ),
                ),
                onTap: () => context.push('/trip/${trip.id}'),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorState(
        icon: Icons.error_outline,
        title: 'Could not load trips',
        message: '$error',
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      side: const BorderSide(color: AppColors.border),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [AppEmptyState(icon: icon, title: title, message: message)],
    );
  }
}

String _formatPickupTime(Booking booking) {
  if (booking.pickupTimeType == 'now') {
    return 'Now';
  }
  final value = booking.scheduledPickupTime;
  if (value == null) {
    return 'Scheduled';
  }
  return '${value.day}/${value.month} '
      '${value.hour.toString().padLeft(2, '0')}:'
      '${value.minute.toString().padLeft(2, '0')}';
}
