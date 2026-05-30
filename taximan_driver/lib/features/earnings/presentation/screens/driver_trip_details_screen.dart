import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_card.dart';

class DriverTripDetailsScreen extends StatelessWidget {
  const DriverTripDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trip details')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: const [
          AppCard(
            child: Column(
              children: [
                _DetailsLine(
                  label: 'Passenger',
                  value: DummyData.passengerName,
                ),
                _DetailsLine(label: 'Pickup', value: DummyData.incomingPickup),
                _DetailsLine(
                  label: 'Destination',
                  value: DummyData.incomingDestination,
                ),
                _DetailsLine(label: 'Fare', value: DummyData.estimatedFare),
                _DetailsLine(
                  label: 'Payment method',
                  value: DummyData.paymentMethod,
                ),
                _DetailsLine(label: 'Trip status', value: 'Completed'),
                Divider(height: 28),
                _DetailsLine(label: 'Commission', value: DummyData.commission),
                _DetailsLine(label: 'Net earning', value: DummyData.netEarning),
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
