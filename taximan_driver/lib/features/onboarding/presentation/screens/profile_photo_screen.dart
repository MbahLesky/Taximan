import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

class ProfilePhotoScreen extends StatelessWidget {
  const ProfilePhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile photo')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            const Spacer(),
            AppCard(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 58,
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(Icons.person, size: 64, color: AppColors.primaryDark),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: 'Upload or change photo',
                    variant: AppButtonVariant.secondary,
                    icon: Icons.photo_camera_outlined,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const Spacer(),
            AppButton(label: 'Continue', onPressed: () => context.push('/verification-pending')),
          ],
        ),
      ),
    );
  }
}
