import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';

class PickupLocationScreen extends StatelessWidget {
  const PickupLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pickup location')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const AppCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.my_location),
              title: Text('Current pickup'),
              subtitle: Text(DummyData.pickupLocation),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const AppTextField(
            label: 'Edit pickup point',
            hint: 'Enter street, quarter, or landmark',
            icon: Icons.edit_location_alt_outlined,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'Confirm pickup', onPressed: () => context.go('/destination')),
        ],
      ),
    );
  }
}
