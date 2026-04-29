import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/bottom_nav_shell.dart';

class DriverDashboardScreen extends StatefulWidget {
  const DriverDashboardScreen({super.key});

  @override
  State<DriverDashboardScreen> createState() => _DriverDashboardScreenState();
}

class _DriverDashboardScreenState extends State<DriverDashboardScreen> {
  bool online = false;

  @override
  Widget build(BuildContext context) {
    return BottomNavShell(
      currentIndex: 0,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello, ${DummyData.driverName}', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        'Driver dashboard',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                Switch(value: online, activeColor: AppColors.primaryDark, onChanged: (value) => setState(() => online = value)),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Row(
                children: [
                  Icon(online ? Icons.radio_button_checked : Icons.radio_button_off, color: online ? AppColors.success : AppColors.textSecondary),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: Text(online ? 'Online and ready for requests' : DummyData.availabilityStatus)),
                  AppButton(
                    label: online ? 'Online' : 'Go Online',
                    fullWidth: false,
                    onPressed: () => setState(() => online = !online),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const AppCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.verified_user_outlined, color: AppColors.warning),
                title: Text(DummyData.verificationStatus),
                subtitle: Text('Approval is required before live operations.'),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: const [
                Expanded(child: _MetricCard(title: 'Today', value: DummyData.todayEarnings, icon: Icons.payments_outlined)),
                SizedBox(width: AppSpacing.sm),
                Expanded(child: _MetricCard(title: 'Trips', value: DummyData.completedTripsCount, icon: Icons.route)),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(child: Icon(Icons.map_outlined, size: 82, color: AppColors.primaryDark)),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _QuickAction(label: 'Schedule', icon: Icons.schedule, onTap: () => context.go('/availability-schedule')),
                _QuickAction(label: 'Demo request', icon: Icons.notifications_active_outlined, onTap: () => context.go('/incoming-request')),
                _QuickAction(label: 'Documents', icon: Icons.folder_copy_outlined, onTap: () => context.go('/document-status')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.title, required this.value, required this.icon});

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryDark),
          const SizedBox(height: AppSpacing.sm),
          Text(title, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
    );
  }
}
