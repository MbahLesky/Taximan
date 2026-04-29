import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';

class RatingScreen extends StatelessWidget {
  const RatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate your driver')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            const Spacer(),
            AppCard(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 34,
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(Icons.person, color: AppColors.primaryDark, size: 36),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(DummyData.driverName, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => const Icon(Icons.star, size: 38, color: AppColors.warning),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            AppButton(label: 'Continue', onPressed: () => context.go('/feedback')),
          ],
        ),
      ),
    );
  }
}
