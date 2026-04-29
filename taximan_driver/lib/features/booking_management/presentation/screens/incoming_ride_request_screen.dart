import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

class IncomingRideRequestScreen extends StatelessWidget {
  const IncomingRideRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Incoming request')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            child: Column(
              children: [
                const Chip(label: Text('Countdown 25s')),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text(DummyData.passengerName),
                  subtitle: Text('Passenger rating ${DummyData.passengerRating}'),
                ),
                const Divider(height: 28),
                const _RequestLine(icon: Icons.my_location, label: 'Pickup', value: DummyData.incomingPickup),
                const _RequestLine(icon: Icons.location_on, label: 'Destination', value: DummyData.incomingDestination),
                const _RequestLine(icon: Icons.route, label: 'Distance', value: DummyData.tripDistance),
                const _RequestLine(icon: Icons.timer_outlined, label: 'ETA', value: DummyData.tripEta),
                const _RequestLine(icon: Icons.payments_outlined, label: 'Estimated fare', value: DummyData.estimatedFare),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'Accept request', onPressed: () => context.go('/navigate-to-pickup')),
          const SizedBox(height: AppSpacing.compact),
          AppButton(
            label: 'Propose fare',
            variant: AppButtonVariant.secondary,
            onPressed: () => context.go('/fare-proposal'),
          ),
          const SizedBox(height: AppSpacing.compact),
          AppButton(
            label: 'Reject request',
            variant: AppButtonVariant.danger,
            onPressed: () => context.go('/request-timeout'),
          ),
        ],
      ),
    );
  }
}

class _RequestLine extends StatelessWidget {
  const _RequestLine({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primaryDark),
      title: Text(label, style: const TextStyle(color: AppColors.textSecondary)),
      subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}
