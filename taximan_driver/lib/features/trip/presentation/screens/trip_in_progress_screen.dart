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
                child: Icon(
                  Icons.route,
                  size: 86,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AppCard(
              child: Column(
                children: [
                  const Chip(label: Text('Trip active')),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.location_on),
                    title: Text('Destination'),
                    subtitle: Text(DummyData.incomingDestination),
                  ),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.timer_outlined),
                    title: Text('Remaining time'),
                    subtitle: Text(DummyData.remainingTime),
                  ),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.payments_outlined),
                    title: Text('Fare'),
                    subtitle: Text(DummyData.estimatedFare),
                  ),
                  AppButton(
                    label: 'End trip',
                    onPressed: () => context.push('/trip-completed'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
