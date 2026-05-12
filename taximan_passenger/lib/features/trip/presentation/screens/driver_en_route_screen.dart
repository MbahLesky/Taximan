import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

class DriverEnRouteScreen extends StatelessWidget {
  const DriverEnRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Driver en route')),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.alt_route,
                      size: 80,
                      color: AppColors.primaryDark,
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Chip(
                      backgroundColor: AppColors.surface,
                      side: BorderSide(color: AppColors.border),
                      avatar: Icon(
                        Icons.sensors,
                        size: 18,
                        color: AppColors.success,
                      ),
                      label: Text('Live driver location'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Driver is moving toward pickup',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Text('ETA ${DummyData.eta}'),
                  const Divider(height: 28),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Text(DummyData.driverName),
                    subtitle: Text(
                      '${DummyData.vehicleName} - ${DummyData.vehiclePlate}',
                    ),
                    trailing: Icon(Icons.call_outlined),
                  ),
                  const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.my_location),
                    title: Text('Pickup point'),
                    subtitle: Text(DummyData.pickupLocation),
                  ),
                  AppButton(
                    label: 'Simulate driver arrived',
                    onPressed: () => context.push('/driver-arrived'),
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
