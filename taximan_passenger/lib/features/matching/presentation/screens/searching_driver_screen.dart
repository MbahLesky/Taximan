import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

class SearchingDriverScreen extends StatelessWidget {
  const SearchingDriverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finding driver')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: 124,
              height: 124,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Padding(
                padding: EdgeInsets.all(34),
                child: CircularProgressIndicator(color: AppColors.primaryDark),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Searching for nearby drivers',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'We are sending your request to available taxis around your pickup point.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const Spacer(),
            AppCard(
              child: Column(
                children: [
                  AppButton(
                    label: 'Show fare proposal',
                    variant: AppButtonVariant.secondary,
                    onPressed: () => context.go('/fare-proposal'),
                  ),
                  const SizedBox(height: AppSpacing.compact),
                  AppButton(
                    label: 'Cancel search',
                    variant: AppButtonVariant.danger,
                    onPressed: () => context.go('/home'),
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
