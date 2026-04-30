import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../application/providers/booking_state_provider.dart';

class RideSummaryScreen extends ConsumerStatefulWidget {
  const RideSummaryScreen({super.key});

  @override
  ConsumerState<RideSummaryScreen> createState() => _RideSummaryScreenState();
}

class _RideSummaryScreenState extends ConsumerState<RideSummaryScreen> {
  bool rideSharing = false;

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingStateProvider);
    final booking = bookingState.booking;

    return Scaffold(
      appBar: AppBar(title: const Text('Ride summary')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            child: Column(
              children: [
                _RouteRow(
                  pickup: booking.pickupLocation,
                  destination: booking.destination,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Estimated fare', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  booking.formattedFare,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const Divider(height: 32),
                Row(
                  children: [
                    Expanded(child: _MetricTile(icon: Icons.route, label: 'Distance', value: booking.distance)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: _MetricTile(icon: Icons.timer_outlined, label: 'ETA', value: booking.eta)),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                _MetricRow(label: 'Payment', value: booking.paymentMethod),
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
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(AppSpacing.md),
        child: AppButton(
          label: 'Confirm Ride',
          isLoading: bookingState.isLoading,
          onPressed: bookingState.canConfirmRide
              ? () {
                  ref.read(bookingStateProvider.notifier).markSearching();
                  context.push('/searching-driver');
                }
              : null,
        ),
      ),
    );
  }
}

class _RouteRow extends StatelessWidget {
  const _RouteRow({required this.pickup, required this.destination});

  final String pickup;
  final String destination;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const Icon(Icons.my_location, size: 20, color: AppColors.info),
            Container(width: 2, height: 34, color: AppColors.border),
            const Icon(Icons.location_on, size: 22, color: AppColors.error),
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

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryDark),
          const SizedBox(height: AppSpacing.sm),
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: AppColors.textSecondary))),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
