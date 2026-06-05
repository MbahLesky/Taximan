import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../booking/application/providers/booking_state_provider.dart';
import '../../../matching/application/providers/driver_providers.dart';

class DriverArrivedScreen extends ConsumerWidget {
  const DriverArrivedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingStateProvider).booking;
    final driverId = booking.driverId ?? '';
    final driver = driverId.isEmpty
        ? null
        : ref.watch(driverStreamProvider(driverId)).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver arrived'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            const Spacer(),
            const Icon(Icons.check_circle, size: 96, color: AppColors.success),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Your driver has arrived',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.my_location),
                    title: const Text('Pickup point'),
                    subtitle: Text(booking.pickupLocation),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.local_taxi),
                    title: Text(driver?.vehicle ?? 'Vehicle pending'),
                    subtitle: Text(driver?.plateNumber ?? 'Plate pending'),
                    trailing:
                        const Icon(Icons.verified, color: AppColors.success),
                  ),
                ],
              ),
            ),
            const Spacer(),
            AppButton(
              label: 'Start tracking trip',
              icon: Icons.route_outlined,
              onPressed: () => context.push('/trip-in-progress'),
            ),
          ],
        ),
      ),
    );
  }
}
