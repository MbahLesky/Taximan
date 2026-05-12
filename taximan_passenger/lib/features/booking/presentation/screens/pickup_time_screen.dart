import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

class PickupTimeScreen extends StatelessWidget {
  const PickupTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pickup time')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const AppCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.flash_on, color: AppColors.warning),
              title: Text('Ride now'),
              subtitle: Text('Driver search starts right away.'),
              trailing: Icon(Icons.check_circle, color: AppColors.success),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.schedule),
                  title: Text('Schedule ride'),
                  subtitle: Text('Prototype selector for a later pickup.'),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: const [
                    Chip(label: Text('Today 4:30 PM')),
                    Chip(label: Text('Today 6:00 PM')),
                    Chip(label: Text('Tomorrow 8:00 AM')),
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
