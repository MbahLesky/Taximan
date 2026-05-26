import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../application/providers/booking_state_provider.dart';

class PickupTimeScreen extends ConsumerWidget {
  const PickupTimeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booking = ref.watch(bookingStateProvider).booking;
    final controller = ref.read(bookingStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Pickup time')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.flash_on, color: AppColors.warning),
              title: const Text('Ride now'),
              subtitle: const Text('Driver search starts right away.'),
              trailing: booking.pickupTimeType == 'now'
                  ? const Icon(Icons.check_circle, color: AppColors.success)
                  : null,
              onTap: () => controller.setPickupTime(pickupTimeType: 'now'),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.schedule),
                  title: const Text('Schedule ride'),
                  subtitle: const Text('Select a later pickup time.'),
                  trailing: booking.pickupTimeType == 'scheduled'
                      ? const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                        )
                      : null,
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    ActionChip(
                      label: const Text('In 30 minutes'),
                      onPressed: () => controller.setPickupTime(
                        pickupTimeType: 'scheduled',
                        scheduledPickupTime: DateTime.now().add(
                          const Duration(minutes: 30),
                        ),
                      ),
                    ),
                    ActionChip(
                      label: const Text('In 1 hour'),
                      onPressed: () => controller.setPickupTime(
                        pickupTimeType: 'scheduled',
                        scheduledPickupTime: DateTime.now().add(
                          const Duration(hours: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const AppCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.notifications_active_outlined),
                  title: Text('Pickup reminder'),
                  subtitle: Text(
                    'We will notify you when a scheduled driver is being assigned.',
                  ),
                ),
                Divider(height: 1),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.shield_outlined),
                  title: Text('Flexible cancellation'),
                  subtitle: Text('Cancel any time before the trip starts.'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Continue to summary',
            icon: Icons.receipt_long_outlined,
            onPressed: () => context.push('/ride-summary'),
          ),
        ],
      ),
    );
  }
}
