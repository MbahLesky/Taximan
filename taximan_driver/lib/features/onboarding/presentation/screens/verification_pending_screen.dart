import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

class VerificationPendingScreen extends StatelessWidget {
  const VerificationPendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verification pending')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              const Spacer(),
              const Icon(Icons.hourglass_top, size: 94, color: AppColors.warning),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Verification pending',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSpacing.md),
              const AppCard(
                child: Text(
                  'Your documents need approval before you can go online and receive ride requests.',
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              AppButton(label: 'View document status', onPressed: () => context.go('/document-status')),
              const SizedBox(height: AppSpacing.compact),
              AppButton(
                label: 'Open demo dashboard',
                variant: AppButtonVariant.secondary,
                onPressed: () => context.go('/dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
