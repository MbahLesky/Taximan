import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/bottom_nav_shell.dart';

class PassengerProfileScreen extends StatelessWidget {
  const PassengerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavShell(
      currentIndex: 2,
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
                    child: Icon(Icons.person, size: 46, color: AppColors.primaryDark),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(DummyData.passengerName, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: AppSpacing.xl),
                  const _ProfileLine(icon: Icons.phone_outlined, label: 'Phone', value: DummyData.passengerPhone),
                  const _ProfileLine(icon: Icons.email_outlined, label: 'Email', value: DummyData.passengerEmail),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: 'Edit profile placeholder',
                    variant: AppButtonVariant.secondary,
                    onPressed: () {},
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
  const _ProfileLine({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label, style: const TextStyle(color: AppColors.textSecondary)),
      subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}
