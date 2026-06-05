import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/models/trip.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';

class DriverTripDetailsScreen extends StatelessWidget {
  const DriverTripDetailsScreen({super.key, this.trip});

  final Trip? trip;

  @override
  Widget build(BuildContext context) {
    if (trip == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Trip details')),
        body: const Center(
          child: AppEmptyState(
            icon: Icons.error_outline,
            title: 'Trip not found',
            message: 'Select a trip from history to see details.',
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Trip details')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            child: Column(
              children: [
                _DetailsLine(label: 'Passenger', value: trip!.passengerName),
                _DetailsLine(label: 'Pickup', value: trip!.pickup.address),
                _DetailsLine(label: 'Destination', value: trip!.destinationLocation.address),
                _DetailsLine(label: 'Fare', value: trip!.formattedFare),
                _DetailsLine(label: 'Payment method', value: trip!.paymentMethod),
                _DetailsLine(label: 'Trip status', value: trip!.status),
                _DetailsLine(label: 'Date', value: trip!.date),
                if (trip!.completedAt != null) ...[
                  _DetailsLine(
                    label: 'Completed',
                    value: trip!.completedAt!.toLocal().toString(),
                  ),
                ],
                const Divider(height: 28),
                _DetailsLine(label: 'Distance', value: trip!.distance),
                _DetailsLine(label: 'Duration', value: trip!.duration),
                _DetailsLine(label: 'Payment status', value: trip!.paymentStatus),
              ],
            ),
          ),
        ],
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
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
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
