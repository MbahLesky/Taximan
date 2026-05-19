import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../application/providers/payment_state_provider.dart';

class PaymentConfirmationScreen extends ConsumerWidget {
  const PaymentConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fare = ref.watch(paymentStateProvider).activePayment?.formattedAmount;

    return Scaffold(
      appBar: AppBar(title: const Text('Payment confirmation')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              const Spacer(),
              const Icon(Icons.verified, size: 104, color: AppColors.success),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Payment confirmed',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                fare ?? 'Payment recorded',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              AppButton(
                label: 'Continue to rating',
                icon: Icons.star_outline,
                onPressed: () => context.push('/rating'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
