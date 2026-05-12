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
                height: 240,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: const [
                    Positioned(
                      top: 36,
                      left: 28,
                      child: Icon(
                        Icons.location_on,
                        size: 56,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    Positioned(
                      right: 34,
                      bottom: 44,
                      child: Icon(
                        Icons.local_taxi,
                        size: 92,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'Your ride, from doorstep to destination.',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Request nearby taxis, preview your fare, and follow every step of the trip with a simple passenger experience.',
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
