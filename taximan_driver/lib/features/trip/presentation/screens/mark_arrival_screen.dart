import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

class MarkArrivalScreen extends StatelessWidget {
  const MarkArrivalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm arrival')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            const Spacer(),
            const Icon(Icons.check_circle_outline, size: 96, color: AppColors.success),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'You are at pickup',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.md),
            const AppCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.my_location),
                title: Text('Passenger pickup location'),
                subtitle: Text(DummyData.incomingPickup),
              ),
            ),
            const Spacer(),
            AppButton(label: 'Confirm arrival', onPressed: () => context.go('/trip-start')),
          ],
        ),
      ),
    );
  }
}
