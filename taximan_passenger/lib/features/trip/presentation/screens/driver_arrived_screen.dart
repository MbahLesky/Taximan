import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

class DriverArrivedScreen extends StatelessWidget {
  const DriverArrivedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver arrived')),
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
            const AppCard(
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.my_location),
                    title: Text('Pickup point'),
                    subtitle: Text(DummyData.pickupLocation),
                  ),
                  Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.local_taxi),
                    title: Text(DummyData.vehicleName),
                    subtitle: Text(DummyData.vehiclePlate),
                    trailing: Icon(Icons.verified, color: AppColors.success),
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
