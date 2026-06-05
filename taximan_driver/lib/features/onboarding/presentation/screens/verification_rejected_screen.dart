import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../application/providers/driver_providers.dart';

class VerificationRejectedScreen extends ConsumerWidget {
  const VerificationRejectedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driver = ref.watch(currentDriverProvider).valueOrNull;
    final rejectionReason =
        driver?.rejectionReason ?? 'Some documents need to be updated.';

    return Scaffold(
      appBar: AppBar(title: const Text('Verification rejected')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            const Spacer(),
            const Icon(Icons.error_outline, size: 94, color: AppColors.error),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Update required',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(child: Text(rejectionReason)),
            const Spacer(),
            AppButton(
              label: 'Update documents',
              onPressed: () => context.push('/document-upload'),
            ),
          ],
        ),
      ),
    );
  }
}
