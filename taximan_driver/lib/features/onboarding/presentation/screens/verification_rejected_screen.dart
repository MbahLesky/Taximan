import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

class VerificationRejectedScreen extends StatelessWidget {
  const VerificationRejectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            const AppCard(child: Text(DummyData.rejectionReason)),
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
