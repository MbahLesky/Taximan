import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

class TripInProgressScreen extends StatelessWidget {
  const TripInProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trip in progress')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: Icon(Icons.route, size: 86, color: AppColors.primaryDark),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Chip(
                    avatar: Icon(Icons.directions_car, size: 18),
                    label: Text('Trip active'),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.location_on),
                    title: Text('Destination'),
                    subtitle: Text(DummyData.destination),
                  ),
                  const Text('Estimated remaining time: ${DummyData.remainingTime}'),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: 'End trip placeholder',
                    variant: AppButtonVariant.secondary,
                    onPressed: null,
                  ),
                  const SizedBox(height: AppSpacing.compact),
                  AppButton(label: 'Simulate trip completed', onPressed: () => context.go('/payment')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
