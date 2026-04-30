import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';

class VehicleDetailsScreen extends StatelessWidget {
  const VehicleDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vehicle details')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const AppTextField(label: 'Vehicle type', hint: DummyData.vehicleType, icon: Icons.local_taxi),
          const SizedBox(height: AppSpacing.md),
          const AppTextField(label: 'Make and model', hint: DummyData.vehicleModel, icon: Icons.directions_car),
          const SizedBox(height: AppSpacing.md),
          const AppTextField(label: 'Plate number', hint: DummyData.vehiclePlate, icon: Icons.pin),
          const SizedBox(height: AppSpacing.md),
          const AppTextField(label: 'Vehicle color', hint: DummyData.vehicleColor, icon: Icons.palette_outlined),
          const SizedBox(height: AppSpacing.md),
          const AppTextField(label: 'Capacity', hint: DummyData.vehicleCapacity, icon: Icons.groups_outlined),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'Continue', onPressed: () => context.push('/document-upload')),
        ],
      ),
    );
  }
}
