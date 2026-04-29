import 'package:flutter/material.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_card.dart';

class TripDetailsScreen extends StatelessWidget {
  const TripDetailsScreen({super.key});

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
                _DetailsLine(label: 'Pickup', value: DummyData.pickupLocation),
                _DetailsLine(label: 'Destination', value: DummyData.destination),
                _DetailsLine(label: 'Driver', value: DummyData.driverName),
                _DetailsLine(label: 'Fare', value: DummyData.estimatedFare),
                _DetailsLine(label: 'Payment method', value: DummyData.paymentMethod),
                _DetailsLine(label: 'Trip status', value: 'Completed'),
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
          Expanded(child: Text(label)),
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
