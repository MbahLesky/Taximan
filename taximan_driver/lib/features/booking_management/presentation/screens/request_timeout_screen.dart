import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';

class RequestTimeoutScreen extends StatelessWidget {
  const RequestTimeoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              const Spacer(),
              const Icon(Icons.timer_off_outlined, size: 96, color: AppColors.warning),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Request expired',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text('This demo request is no longer available.', textAlign: TextAlign.center),
              const Spacer(),
              AppButton(label: 'Return to dashboard', onPressed: () => context.go('/dashboard')),
            ],
          ),
        ),
      ),
    );
  }
}
