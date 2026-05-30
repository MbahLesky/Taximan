import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../application/providers/booking_providers.dart';
import '../../../../shared/widgets/app_card.dart';

class BookingDetailsScreen extends ConsumerWidget {
  const BookingDetailsScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (bookingId.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Booking ID is missing.')),
      );
    }

    final bookingState = ref.watch(bookingStreamProvider(bookingId));

    return bookingState.when(
      data: (booking) {
        if (booking == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Booking details')),
            body: const Center(child: Text('Booking not found.')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Booking details')),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${booking.pickupLocation} → ${booking.destination}',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Chip(
                          label: Text(
                            booking.status,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          booking.paymentMethod,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _DetailItem(
                            label: 'Estimated fare',
                            value: booking.formattedFare,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _DetailItem(
                            label: 'Distance',
                            value: booking.distance,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _DetailItem(
                            label: 'ETA',
                            value: booking.eta.isEmpty ? 'TBD' : booking.eta,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _DetailItem(
                            label: 'Passengers',
                            value: '${booking.passengerCount}',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pickup & destination',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _DetailsLine(
                      label: 'Pickup',
                      value: booking.pickupLocation,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _DetailsLine(
                      label: 'Destination',
                      value: booking.destination,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _DetailsLine(
                      label: 'Pickup time',
                      value: booking.pickupTimeType == 'now'
                          ? 'Now'
                          : booking.scheduledPickupTime == null
                          ? 'Scheduled'
                          : _formatDateTime(booking.scheduledPickupTime!),
                    ),
                    if (booking.additionalInfo.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      _DetailsLine(
                        label: 'Notes',
                        value: booking.additionalInfo,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Driver & payment',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _DetailsLine(
                      label: 'Driver',
                      value: booking.preferredDriverName ?? 'Unassigned',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _DetailsLine(
                      label: 'Payment status',
                      value: booking.paymentStatus,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _DetailsLine(
                      label: 'Final fare',
                      value: booking.formattedFinalFare,
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
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Booking details')),
        body: Center(child: Text('Failed to load booking: $error')),
      ),
    );
  }

  String _formatDateTime(DateTime value) {
    return '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')} ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  }
}

class _DetailsLine extends StatelessWidget {
  const _DetailsLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.xs),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}
