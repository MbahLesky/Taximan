import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/bottom_nav_shell.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavShell(
      currentIndex: 3,
      title: 'Profile',
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            AppCard(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 42,
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(
                      Icons.person,
                      size: 46,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    DummyData.driverName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text('Rating ${DummyData.driverRating}'),
                  const Divider(height: 28),
                  const _ProfileLine(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: DummyData.driverPhone,
                  ),
                  const _ProfileLine(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: DummyData.driverEmail,
                  ),
                  AppButton(
                    label: 'Edit profile placeholder',
                    variant: AppButtonVariant.secondary,
                    onPressed: () {},
                  ),
                  const SizedBox(height: AppSpacing.compact),
                  AppButton(
                    label: 'Vehicle information',
                    variant: AppButtonVariant.secondary,
                    onPressed: () => context.go('/vehicle-information'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileLine extends StatelessWidget {
  const _ProfileLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(
        label,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
