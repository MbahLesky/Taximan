import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../application/providers/rating_state_provider.dart';

class RatingScreen extends ConsumerWidget {
  const RatingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratingState = ref.watch(ratingStateProvider);

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
                    child: Icon(
                      Icons.person,
                      color: AppColors.primaryDark,
                      size: 36,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    DummyData.driverName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => IconButton(
                        tooltip: 'Rate ${index + 1}',
                        onPressed: () => ref
                            .read(ratingStateProvider.notifier)
                            .selectRating(index + 1),
                        icon: Icon(
                          index < ratingState.selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          size: 38,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: const [
                      Chip(label: Text('Safe ride')),
                      Chip(label: Text('On time')),
                      Chip(label: Text('Clean car')),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            AppButton(
              label: 'Continue',
              icon: Icons.rate_review_outlined,
              isLoading: ratingState.isSubmitting,
              onPressed: () {
                ref
                    .read(ratingStateProvider.notifier)
                    .submit(
                      tripId: 'trip-demo-001',
                      bookingId: 'booking-demo-001',
                      passengerId: 'passenger-001',
                      driverId: 'driver-001',
                    );
                context.push('/feedback');
              },
            ),
          ],
        ),
      ),
    );
  }
}
