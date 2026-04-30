import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../trip/application/providers/trip_state_provider.dart';

class IncomingRideRequestScreen extends ConsumerWidget {
  const IncomingRideRequestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trip = ref.watch(tripStateProvider).activeTrip;

    return Scaffold(
      appBar: AppBar(title: const Text('Incoming request')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            child: Column(
              children: [
                const Chip(label: Text('Countdown 25s')),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(trip.passengerName),
                  subtitle: const Text('Passenger rating 4.7'),
                ),
                const Divider(height: 28),
                _RouteBlock(pickup: trip.pickupLocation, destination: trip.destination),
                const Divider(height: 28),
                _RequestLine(icon: Icons.route, label: 'Distance', value: trip.distance),
                _RequestLine(icon: Icons.timer_outlined, label: 'ETA', value: trip.eta),
                _RequestLine(icon: Icons.payments_outlined, label: 'Fare', value: trip.formattedFare, highlighted: true),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Accept',
            icon: Icons.check_circle_outline,
            onPressed: () => context.push('/navigate-to-pickup'),
          ),
          const SizedBox(height: AppSpacing.compact),
          AppButton(
            label: 'Propose Fare',
            icon: Icons.edit,
            variant: AppButtonVariant.secondary,
            onPressed: () => context.push('/fare-proposal'),
          ),
          const SizedBox(height: AppSpacing.compact),
          AppButton(
            label: 'Reject',
            icon: Icons.close,
            variant: AppButtonVariant.danger,
            onPressed: () => context.push('/request-timeout'),
          ),
        ],
      ),
    );
  }
}

class _RouteBlock extends StatelessWidget {
  const _RouteBlock({required this.pickup, required this.destination});

  final String pickup;
  final String destination;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const Icon(Icons.my_location, color: AppColors.info),
            Container(width: 2, height: 34, color: AppColors.border),
            const Icon(Icons.location_on, color: AppColors.error),
          ],
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Pickup', style: TextStyle(color: AppColors.textSecondary)),
              Text(pickup, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: AppSpacing.md),
              const Text('Destination', style: TextStyle(color: AppColors.textSecondary)),
              Text(destination, style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ],
    );
  }
}

class _RequestLine extends StatelessWidget {
  const _RequestLine({required this.icon, required this.label, required this.value, this.highlighted = false});

  final IconData icon;
  final String label;
  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primaryDark),
      title: Text(label, style: const TextStyle(color: AppColors.textSecondary)),
      subtitle: Text(
        value,
        style: TextStyle(
          fontWeight: FontWeight.w900,
          color: highlighted ? AppColors.primaryDark : AppColors.textPrimary,
          fontSize: highlighted ? 18 : null,
        ),
      ),
    );
  }
}
