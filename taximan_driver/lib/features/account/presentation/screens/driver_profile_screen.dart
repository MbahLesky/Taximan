import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/bottom_nav_shell.dart';
import '../../../onboarding/application/providers/driver_providers.dart';

class DriverProfileScreen extends ConsumerWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driver = ref.watch(currentDriverProvider).valueOrNull;
    final photoUrl = driver?.profilePhotoUrl;

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
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: AppColors.primaryLight,
                    backgroundImage: photoUrl == null || photoUrl.isEmpty
                        ? null
                        : NetworkImage(photoUrl),
                    child: photoUrl == null || photoUrl.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 46,
                            color: AppColors.primaryDark,
                          )
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    driver?.fullName.isNotEmpty == true
                        ? driver!.fullName
                        : 'Driver profile',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Rating ${(driver?.ratingAverage ?? 0).toStringAsFixed(1)}',
                  ),
                  const Divider(height: 28),
                  _ProfileLine(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: driver?.phone ?? '',
                  ),
                  _ProfileLine(
                    icon: Icons.email_outlined,
                    label: 'Email',
                    value: driver?.email ?? '',
                  ),
                  AppButton(
                    label: 'Update documents',
                    variant: AppButtonVariant.secondary,
                    onPressed: () => context.go('/document-upload'),
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
