import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/bottom_nav_shell.dart';
import '../../application/providers/earnings_provider.dart';

class EarningsScreen extends ConsumerWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final earnings = ref.watch(earningsProvider);

    return BottomNavShell(
      currentIndex: 1,
      title: 'Earnings',
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            if (earnings.completedTrips == 0)
              const AppEmptyState(
                icon: Icons.payments_outlined,
                title: 'No earnings yet',
                message: 'Completed cash trips will update this page.',
              )
            else ...[
              _EarningCard(
                label: 'Today',
                value: earnings.todayFormatted,
                icon: Icons.today,
              ),
              const SizedBox(height: AppSpacing.sm),
              _EarningCard(
                label: 'This week',
                value: earnings.weekFormatted,
                icon: Icons.date_range,
              ),
              const SizedBox(height: AppSpacing.sm),
              _EarningCard(
                label: 'Total earnings',
                value: earnings.totalFormatted,
                icon: Icons.account_balance_wallet_outlined,
              ),
              const SizedBox(height: AppSpacing.sm),
              _EarningCard(
                label: 'Completed trips',
                value: '${earnings.completedTrips}',
                icon: Icons.route,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EarningCard extends StatelessWidget {
  const _EarningCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, color: AppColors.primaryDark),
        title: Text(label),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}
