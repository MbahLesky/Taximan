import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../matching/application/providers/driver_providers.dart';
import '../../../matching/presentation/widgets/driver_list_tile.dart';
import '../../../booking/application/providers/booking_state_provider.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/bottom_nav_shell.dart';

class PassengerDriversScreen extends ConsumerWidget {
  const PassengerDriversScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drivers = ref.watch(allDriversStreamProvider);

    return BottomNavShell(
      currentIndex: 4,
      title: 'Drivers',
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            AppCard(
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.verified_user_outlined,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nearby trusted drivers',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        const Text(
                          'Drivers shown here are available around your pickup area.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ...drivers.when(
              data: (items) {
                if (items.isEmpty) {
                  return [
                    const AppCard(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(Icons.person_search_outlined),
                        title: Text('No drivers found'),
                        subtitle: Text('Try again later.'),
                      ),
                    ),
                  ];
                }
                return items.map((driver) {
                  return DriverListItem(
                    driver: driver,
                    onViewDetails: () => showDriverDetailsModal(context, driver),
                  );
                }).toList();
              },
              loading: () => [
                const AppCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircularProgressIndicator(),
                    title: Text('Loading drivers'),
                  ),
                ),
              ],
              error: (e, s) {
                print("\n\n\nError in driver subtitle: $e\n$s\n\n\n");
                return [
                const AppCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.error_outline),
                    title: Text('Could not load drivers'),
                  ),
                ),
              ];
              },
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Book a new ride',
              icon: Icons.add_location_alt_outlined,
              onPressed: () {
                ref.read(bookingStateProvider.notifier).startNewRide();
                context.push('/pickup');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DriverStatusChip extends StatelessWidget {
  const _DriverStatusChip({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(
      visualDensity: VisualDensity.compact,
      backgroundColor: AppColors.primaryLight,
      side: BorderSide.none,
      label: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }
}

class _DriverMetric extends StatelessWidget {
  const _DriverMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.compact),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryDark),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
