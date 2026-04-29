import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

class RideSummaryScreen extends StatefulWidget {
  const RideSummaryScreen({super.key});

  @override
  State<RideSummaryScreen> createState() => _RideSummaryScreenState();
}

class _RideSummaryScreenState extends State<RideSummaryScreen> {
  bool rideSharing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ride summary')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const AppCard(
            child: Column(
              children: [
                _SummaryRow(icon: Icons.my_location, label: 'Pickup', value: DummyData.pickupLocation),
                Divider(height: 24),
                _SummaryRow(icon: Icons.location_on, label: 'Destination', value: DummyData.destination),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              children: const [
                _MetricRow(label: 'Distance', value: DummyData.distance),
                _MetricRow(label: 'ETA', value: DummyData.eta),
                _MetricRow(label: 'Estimated fare', value: DummyData.estimatedFare, highlighted: true),
                _MetricRow(label: 'Payment', value: DummyData.paymentMethod),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: rideSharing,
              activeColor: AppColors.primaryDark,
              title: const Text('Ride sharing'),
              subtitle: const Text('Share this trip with another passenger when available.'),
              onChanged: (value) => setState(() => rideSharing = value),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'Confirm ride', onPressed: () => context.go('/searching-driver')),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: AppColors.textSecondary)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value, this.highlighted = false});

  final String label;
  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: AppColors.textSecondary))),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: highlighted ? AppColors.primaryDark : AppColors.textPrimary,
              fontSize: highlighted ? 18 : 15,
            ),
          ),
        ],
      ),
    );
  }
}
