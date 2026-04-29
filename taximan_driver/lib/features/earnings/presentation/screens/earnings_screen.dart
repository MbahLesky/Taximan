import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/bottom_nav_shell.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavShell(
      currentIndex: 1,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Text('Earnings', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: AppSpacing.md),
            const _EarningCard(label: 'Today', value: DummyData.todayEarnings, icon: Icons.today),
            const SizedBox(height: AppSpacing.sm),
            const _EarningCard(label: 'This week', value: DummyData.weeklyEarnings, icon: Icons.date_range),
            const SizedBox(height: AppSpacing.sm),
            const _EarningCard(label: 'Total earnings', value: DummyData.totalEarnings, icon: Icons.account_balance_wallet_outlined),
            const SizedBox(height: AppSpacing.sm),
            const _EarningCard(label: 'Completed trips', value: DummyData.completedTripsCount, icon: Icons.route),
          ],
        ),
      ),
    );
  }
}

class _EarningCard extends StatelessWidget {
  const _EarningCard({required this.label, required this.value, required this.icon});

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
        trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
      ),
    );
  }
}
