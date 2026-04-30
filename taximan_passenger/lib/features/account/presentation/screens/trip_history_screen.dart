import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/bottom_nav_shell.dart';

class TripHistoryScreen extends StatelessWidget {
  const TripHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavShell(
      currentIndex: 1,
      title: 'Trip history',
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            if (DummyData.tripHistory.isEmpty)
              AppEmptyState(
                icon: Icons.history,
                title: 'No trips yet',
                message: 'Your completed rides will appear here.',
                actionLabel: 'Book a ride',
                onAction: () => context.go('/home'),
              )
            else
              ...DummyData.tripHistory.map(
                (trip) => AppCard(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.local_taxi),
                    title: Text('${trip['pickup']} to ${trip['destination']}'),
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
