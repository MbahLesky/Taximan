import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../earnings/application/providers/earnings_provider.dart';
import '../../application/providers/driver_state_provider.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/bottom_nav_shell.dart';

class DriverDashboardScreen extends ConsumerWidget {
  const DriverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driverState = ref.watch(driverStateProvider);
    final earnings = ref.watch(earningsProvider);
    final driver = driverState.driver;
    final online = driverState.isOnline;

    return BottomNavShell(
      currentIndex: 0,
      title: 'Dashboard',
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
                      Text('Good morning, ${driver.fullName.split(' ').first}', style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        'Driver dashboard',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(label: driverState.statusLabel, online: online),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        online ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: online ? AppColors.success : AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          online ? 'ONLINE - available for requests' : 'OFFLINE - not receiving requests',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: online ? 'Go Offline' : 'Go Online',
                    icon: online ? Icons.power_settings_new : Icons.bolt,
                    variant: online ? AppButtonVariant.secondary : AppButtonVariant.primary,
                    onPressed: () => ref.read(driverStateProvider.notifier).toggleAvailability(),
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
              children: [
                Expanded(child: _MetricCard(title: 'Today', value: earnings.todayFormatted, icon: Icons.payments_outlined)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _MetricCard(title: 'Trips', value: '${earnings.completedTrips}', icon: Icons.route)),
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
                _QuickAction(label: 'Schedule', icon: Icons.schedule, onTap: () => context.push('/availability-schedule')),
                _QuickAction(label: 'Demo request', icon: Icons.notifications_active_outlined, onTap: () => context.push('/incoming-request')),
                _QuickAction(label: 'Documents', icon: Icons.folder_copy_outlined, onTap: () => context.push('/document-status')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.online});

  final String label;
  final bool online;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: online ? AppColors.primaryLight : AppColors.border,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: online ? AppColors.primaryDark : AppColors.textSecondary,
          fontWeight: FontWeight.w900,
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
