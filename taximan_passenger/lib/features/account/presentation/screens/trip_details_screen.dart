import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/ride_statuses.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/models/booking.dart';
import '../../../../shared/models/trip.dart';
import '../../../../shared/utils/app_toast.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../booking/application/providers/booking_providers.dart';
import '../../../booking/application/providers/booking_state_provider.dart';
import '../../../booking/application/providers/repositories.dart';
import '../../../matching/application/providers/driver_providers.dart';
import '../../../trip/application/providers/trip_providers.dart';
import '../../../trip/application/providers/trip_state_provider.dart';

class TripDetailsScreen extends ConsumerStatefulWidget {
  const TripDetailsScreen({super.key, required this.tripId});

  final String tripId;

  @override
  ConsumerState<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends ConsumerState<TripDetailsScreen> {
  bool _isStarting = false;
  bool _isCompleting = false;
  bool _isDeleting = false;
  bool _isTracking = false;

  Future<void> _startTrip(Trip trip) async {
    setState(() => _isStarting = true);
    try {
      await ref.read(tripRepositoryProvider).startTrip(trip.id);
      ref.read(tripStateProvider.notifier).setActiveTrip(
            trip.copyWith(
              status: TripStatus.inProgress,
              startedAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
      _invalidatePassengerLists(trip.passengerId);

      if (mounted) {
        AppToast.success(
          context,
          title: 'Trip started',
          description: 'The trip is now in progress.',
        );
      }
    } catch (e) {
      if (mounted) {
        AppToast.error(
          context,
          title: 'Could not start trip',
          description: 'Check your connection and try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isStarting = false);
      }
    }
  }

  Future<void> _markCompleted(Trip trip) async {
    setState(() => _isCompleting = true);
    try {
      await ref
          .read(tripRepositoryProvider)
          .completeTrip(trip.id, trip.finalFare ?? trip.fare);
      _invalidatePassengerLists(trip.passengerId);

      if (mounted) {
        AppToast.success(
          context,
          title: 'Trip completed',
          description: 'The trip has been marked as completed.',
        );
      }
    } catch (e) {
      if (mounted) {
        AppToast.error(
          context,
          title: 'Could not complete trip',
          description: 'Check your connection and try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCompleting = false);
      }
    }
  }

  Future<void> _deleteTrip(Trip trip) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete trip?'),
        content: const Text(
          'This removes the trip record from the trips collection.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    setState(() => _isDeleting = true);
    try {
      await ref.read(tripRepositoryProvider).deleteTrip(trip.id);
      _invalidatePassengerLists(trip.passengerId);

      if (!mounted) {
        return;
      }
      AppToast.success(
        context,
        title: 'Trip deleted',
        description: 'The trip record has been removed.',
      );
      context.go('/trips');
    } catch (e) {
      if (mounted) {
        AppToast.error(
          context,
          title: 'Could not delete trip',
          description: 'Check your connection and try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }

  Future<void> _trackTrip(Trip trip) async {
    setState(() => _isTracking = true);
    try {
      ref.read(tripStateProvider.notifier).setActiveTrip(trip);
      final booking = trip.bookingId.isEmpty
          ? null
          : await ref
                .read(bookingRepositoryProvider)
                .getBooking(trip.bookingId);
      ref
          .read(bookingStateProvider.notifier)
          .setBooking(booking ?? _bookingFromTrip(trip));

      if (mounted) {
        context.push('/tracking');
      }
    } catch (e) {
      if (mounted) {
        AppToast.error(
          context,
          title: 'Could not open tracking',
          description: 'Check your connection and try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isTracking = false);
      }
    }
  }

  void _invalidatePassengerLists(String passengerId) {
    if (passengerId.isEmpty) {
      return;
    }
    ref.invalidate(passengerTripsProvider(passengerId));
    ref.invalidate(recentTripsProvider(passengerId));
    ref.invalidate(passengerBookingsProvider(passengerId));
    ref.invalidate(recentBookingsProvider(passengerId));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tripId.isEmpty) {
      return const Scaffold(body: Center(child: Text('Trip ID is missing.')));
    }

    final tripState = ref.watch(tripStreamProvider(widget.tripId));

    return tripState.when(
      data: (trip) {
        if (trip == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Trip details')),
            body: const Center(child: Text('Trip not found.')),
          );
        }

        final driver = trip.driverId.isEmpty
            ? null
            : ref.watch(driverProvider(trip.driverId)).valueOrNull;
        final isFinished =
            trip.status == TripStatus.completed ||
            trip.status == TripStatus.cancelled;
        final canStart = !isFinished && trip.status != TripStatus.inProgress;

        return Scaffold(
          appBar: AppBar(title: const Text('Trip details')),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Center(
                  child: Icon(
                    Icons.route,
                    size: 64,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${trip.pickupLocation} -> ${trip.destination}',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Chip(label: Text(trip.status)),
                    const SizedBox(height: AppSpacing.md),
                    _DetailsLine(label: 'Pickup', value: trip.pickupLocation),
                    _DetailsLine(label: 'Destination', value: trip.destination),
                    _DetailsLine(
                      label: 'Driver',
                      value:
                          driver?.fullName ??
                          (trip.driverId.isEmpty ? 'Unassigned' : 'Loading'),
                    ),
                    _DetailsLine(label: 'Fare', value: trip.formattedFinalFare),
                    _DetailsLine(
                      label: 'Payment method',
                      value: trip.paymentMethod,
                    ),
                    _DetailsLine(
                      label: 'Payment status',
                      value: trip.paymentStatus,
                    ),
                    if (trip.distance.isNotEmpty)
                      _DetailsLine(label: 'Distance', value: trip.distance),
                    if (trip.duration.isNotEmpty)
                      _DetailsLine(label: 'Duration', value: trip.duration),
                    if (_formatScheduledPickupTime(trip).isNotEmpty)
                      _DetailsLine(
                        label: 'Scheduled pickup',
                        value: _formatScheduledPickupTime(trip),
                      ),
                    if (trip.scheduledPickupTime == null &&
                        trip.date.isNotEmpty)
                      _DetailsLine(label: 'Date Created', value: trip.date),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Actions',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: 'Track trip',
                      icon: Icons.near_me_outlined,
                      variant: AppButtonVariant.secondary,
                      isLoading: _isTracking,
                      onPressed:
                          isFinished || _isDeleting || _isCompleting || _isStarting
                          ? null
                          : () => _trackTrip(trip),
                    ),
                    const SizedBox(height: AppSpacing.compact),
                    AppButton(
                      label: 'Start trip',
                      icon: Icons.play_arrow_outlined,
                      isLoading: _isStarting,
                      onPressed:
                          canStart &&
                              !_isDeleting &&
                              !_isTracking &&
                              !_isCompleting
                          ? () => _startTrip(trip)
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.compact),
                    AppButton(
                      label: 'Mark as completed',
                      icon: Icons.check_circle_outline,
                      isLoading: _isCompleting,
                      onPressed:
                          isFinished || _isDeleting || _isTracking || _isStarting
                          ? null
                          : () => _markCompleted(trip),
                    ),
                    const SizedBox(height: AppSpacing.compact),
                    AppButton(
                      label: 'Delete trip',
                      icon: Icons.delete_outline,
                      variant: AppButtonVariant.danger,
                      isLoading: _isDeleting,
                      onPressed: _isCompleting || _isTracking || _isStarting
                          ? null
                          : () => _deleteTrip(trip),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text('Trip details')),
        body: Center(child: Text('Failed to load trip: $error')),
      ),
    );
  }
}

class _DetailsLine extends StatelessWidget {
  const _DetailsLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

Booking _bookingFromTrip(Trip trip) {
  return Booking(
    id: trip.bookingId,
    pickupLocation: trip.pickupLocation,
    destination: trip.destination,
    estimatedFare: trip.fare,
    distance: trip.distance,
    eta: trip.duration,
    paymentMethod: trip.paymentMethod,
    status: trip.status,
    passengerId: trip.passengerId,
    driverId: trip.driverId,
    vehicleId: trip.vehicleId,
    pickupTimeType: trip.scheduledPickupTime == null ? 'now' : 'scheduled',
    scheduledPickupTime: trip.scheduledPickupTime,
    finalFare: trip.finalFare,
    paymentStatus: trip.paymentStatus,
  );
}

String _formatScheduledPickupTime(Trip trip) {

  print("Trip: ${trip.toMap()}");
  print("\n\n\n==================\nFormatting scheduled pickup time for trip ${trip.id}: ${trip.scheduledPickupTime}\n\n\n");

  final value = trip.scheduledPickupTime;
  if (value == null) {
    return '';
  }
  return '${value.day.toString().padLeft(2, '0')}/'
      '${value.month.toString().padLeft(2, '0')}/'
      '${value.year} '
      '${value.hour.toString().padLeft(2, '0')}:'
      '${value.minute.toString().padLeft(2, '0')}';
}
