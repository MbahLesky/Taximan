import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Container(
                width: double.infinity,
                height: 236,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Stack(
                  children: [
                    Positioned(
                      left: 28,
                      bottom: 42,
                      child: Icon(
                        Icons.local_taxi,
                        size: 96,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    Positioned(
                      right: 32,
                      top: 36,
                      child: Icon(
                        Icons.payments_outlined,
                        size: 66,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Earn with Taximan on your schedule.',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Receive ride requests, manage availability, and track trips from one focused driver dashboard.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const Spacer(),
              AppButton(
                label: 'Get Started',
                onPressed: () => context.push('/register'),
              ),
              const SizedBox(height: AppSpacing.compact),
              AppButton(
                label: 'Login',
                variant: AppButtonVariant.secondary,
                onPressed: () => context.push('/login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
