import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../application/onboarding_flow.dart';
import '../../application/providers/driver_providers.dart';

class VerificationPendingScreen extends ConsumerWidget {
  const VerificationPendingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDriver = ref.watch(currentDriverProvider).valueOrNull;
    final status = currentDriver?.verificationStatus ?? 'pending';

    return Scaffold(
      appBar: AppBar(title: const Text('Verification pending')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              const Spacer(),
              const Icon(
                Icons.hourglass_top,
                size: 94,
                color: AppColors.warning,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                _statusTitle(status),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const AppCard(
                child: Text(
                  'Your documents need approval before you can go online and receive ride requests.',
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              AppButton(
                label: 'View document status',
                onPressed: () => context.go('/document-status'),
              ),
              const SizedBox(height: AppSpacing.compact),
              AppButton(
                label: 'Refresh status',
                variant: AppButtonVariant.secondary,
                onPressed: currentDriver == null
                    ? null
                    : () => context.go(nextDriverRoute(currentDriver)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _statusTitle(String status) {
  return switch (status.toLowerCase()) {
    'approved' => 'Verification approved',
    'rejected' => 'Verification rejected',
    _ => 'Verification pending',
  };
}
