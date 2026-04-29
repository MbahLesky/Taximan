import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/bottom_nav_shell.dart';

class DriverTripHistoryScreen extends StatelessWidget {
  const DriverTripHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavShell(
      currentIndex: 2,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Text('Trip history', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: AppSpacing.md),
            ...DummyData.completedTrips.map(
              (trip) => AppCard(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.local_taxi),
                  title: Text('${trip['passenger']} to ${trip['destination']}'),
                  subtitle: Text('${trip['date']} - ${trip['status']}'),
                  trailing: Text(
                    trip['fare'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primaryDark),
                  ),
                  onTap: () => context.go('/trip-details'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
