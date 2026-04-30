import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

class TripStartScreen extends StatelessWidget {
  const TripStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Start trip')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const AppCard(
            child: Column(
              children: [
                ListTile(contentPadding: EdgeInsets.zero, leading: Icon(Icons.person), title: Text('Passenger'), subtitle: Text(DummyData.passengerName)),
                ListTile(contentPadding: EdgeInsets.zero, leading: Icon(Icons.location_on), title: Text('Destination'), subtitle: Text(DummyData.incomingDestination)),
                ListTile(contentPadding: EdgeInsets.zero, leading: Icon(Icons.payments_outlined), title: Text('Fare'), subtitle: Text(DummyData.estimatedFare)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(label: 'Start trip', onPressed: () => context.push('/trip-in-progress')),
        ],
      ),
    );
  }
}
