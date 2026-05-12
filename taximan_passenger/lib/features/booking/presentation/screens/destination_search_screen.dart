import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../application/providers/booking_state_provider.dart';

class DestinationSearchScreen extends ConsumerWidget {
  const DestinationSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingStateProvider);

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
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Row(
              children: [
                const Icon(Icons.route, color: AppColors.primaryDark),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Choose a destination to calculate distance, ETA, and fare before requesting a driver.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Suggestions',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...DummyData.destinationSuggestions.map(
            (destination) => AppCard(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.location_on_outlined),
                title: Text(destination),
                subtitle: const Text('Tap to preview route and pickup time'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  ref
                      .read(bookingStateProvider.notifier)
                      .setDestination(destination);
                  context.push('/pickup-time');
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Recent',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...bookingState.recentDestinations.map(
            (destination) => AppCard(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.history),
                title: Text(destination),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ref
                      .read(bookingStateProvider.notifier)
                      .setDestination(destination);
                  context.push('/pickup-time');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
