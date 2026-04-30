import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';

class DriverPersonalInfoScreen extends StatelessWidget {
  const DriverPersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal information')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const AppTextField(label: 'Full name', icon: Icons.badge_outlined),
          const SizedBox(height: AppSpacing.md),
          const AppTextField(label: 'City or location', icon: Icons.location_city_outlined),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'Continue', onPressed: () => context.push('/vehicle-details')),
        ],
      ),
    );
  }
}
