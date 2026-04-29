import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';

class DestinationSearchScreen extends StatelessWidget {
  const DestinationSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Destination')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const AppTextField(
            label: 'Search destination',
            hint: 'Where are you going?',
            icon: Icons.search,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Suggestions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.sm),
          ...DummyData.destinationSuggestions.map(
            (destination) => AppCard(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.location_on_outlined),
                title: Text(destination),
                subtitle: const Text('Tap to use this destination'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/pickup-time'),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Recent', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.sm),
          ...DummyData.recentDestinations.map(
            (destination) => ListTile(
              leading: const Icon(Icons.history),
              title: Text(destination),
              onTap: () => context.go('/pickup-time'),
            ),
          ),
        ],
      ),
    );
  }
}
