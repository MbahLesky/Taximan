import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../booking/application/providers/booking_state_provider.dart';
import '../../../matching/application/providers/driver_providers.dart';

class TripDetailsScreen extends ConsumerWidget {
  const TripDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingStateProvider).booking;
    final driverId = booking.driverId ?? '';
    final driver = driverId.isEmpty
        ? null
        : ref.watch(driverProvider(driverId)).valueOrNull;

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
              child: Icon(Icons.route, size: 64, color: AppColors.primaryDark),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              children: [
                _DetailsLine(label: 'Pickup', value: booking.pickupLocation),
                _DetailsLine(
                  label: 'Destination',
                  value: booking.destination,
                ),
                _DetailsLine(
                  label: 'Driver',
                  value: driver?.fullName ?? 'Driver pending',
                ),
                _DetailsLine(
                  label: 'Fare',
                  value: booking.formattedFinalFare,
                ),
                _DetailsLine(
                  label: 'Payment method',
                  value: booking.paymentMethod,
                ),
                _DetailsLine(label: 'Trip status', value: booking.status),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const AppCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.receipt_long_outlined),
                  title: Text('Receipt'),
                  subtitle: Text('Cash payment confirmed'),
                  trailing: Icon(Icons.check_circle, color: AppColors.success),
                ),
                Divider(height: 1),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.star, color: AppColors.warning),
                  title: Text('Rating'),
                  subtitle: Text('Driver rated 5 stars'),
                ),
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
