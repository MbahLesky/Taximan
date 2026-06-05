import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/utils/app_toast.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../auth/application/providers/auth_state_provider.dart';
import '../../../booking/application/providers/booking_state_provider.dart';
import '../../../booking/application/providers/repositories.dart';
import '../../../trip/application/providers/trip_state_provider.dart';
import '../../application/providers/rating_state_provider.dart';

class RatingScreen extends ConsumerWidget {
  const RatingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(ratingStateProvider, (previous, next) {
      final message = next.errorMessage;
      if (message != null && message != previous?.errorMessage) {
        AppToast.error(context, title: 'Rating error', description: message);
      }
    });

    final ratingState = ref.watch(ratingStateProvider);
    final booking = ref.watch(bookingStateProvider).booking;
    final tripState = ref.watch(tripStateProvider);
    final activeTrip = tripState.activeTrip;
    final trip = activeTrip?.bookingId == booking.id ? activeTrip : null;
    final driver = tripState.assignedDriver;
    final passengerId =
        ref.watch(authStateProvider).userId ?? booking.passengerId;
    final driverId = booking.driverId ?? trip?.driverId ?? driver?.id ?? '';
    final canSubmit = passengerId.isNotEmpty &&
        driverId.isNotEmpty &&
        booking.id.isNotEmpty &&
        !ratingState.isSubmitting;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate your driver'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
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
                    driver?.fullName ?? 'Your driver',
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
              onPressed: canSubmit
                  ? () async {
                      final controller =
                          ref.read(ratingStateProvider.notifier);
                      final rating = controller.submit(
                        tripId: trip?.id ?? '',
                        bookingId: booking.id,
                        passengerId: passengerId,
                        driverId: driverId,
                      );
                      try {
                        final saved = await ref
                            .read(ratingRepositoryProvider)
                            .createRating(rating);
                        controller.setSubmitted(saved);
                        if (context.mounted) {
                          AppToast.success(
                            context,
                            title: 'Rating submitted',
                            description: 'Thanks for helping improve Taximan.',
                          );
                          context.push('/feedback');
                          controller.reset();
                        }
                      } catch (e) {
                        controller.setError(
                          'Could not submit rating. Try again.',
                        );
                      }
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
