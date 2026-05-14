import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../application/providers/payment_state_provider.dart';

class PaymentScreen extends ConsumerWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentState = ref.watch(paymentStateProvider);
    final payment = paymentState.activePayment;
    final fare = payment?.formattedAmount ?? '0 FCFA';

    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trip fare',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  fare,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Divider(height: 32),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.payments_outlined),
                  title: const Text('Cash'),
                  subtitle: const Text('Pay the driver directly.'),
                  trailing: paymentState.selectedMethod == 'cash'
                      ? const Icon(Icons.check_circle, color: AppColors.success)
                      : null,
                  onTap: () => ref
                      .read(paymentStateProvider.notifier)
                      .selectMethod('cash'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.account_balance_wallet_outlined),
                  title: const Text('Escrow'),
                  subtitle: const Text(
                    'Reserve funds in-app when payment integration is enabled.',
                  ),
                  trailing: paymentState.selectedMethod == 'escrow'
                      ? const Icon(Icons.check_circle, color: AppColors.success)
                      : null,
                  onTap: () => ref
                      .read(paymentStateProvider.notifier)
                      .selectMethod('escrow'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              children: [
                _PaymentLine(label: 'Trip fare', value: fare),
                _PaymentLine(
                  label: 'Payment status',
                  value: payment?.status ?? 'pending',
                ),
                const _PaymentLine(
                  label: 'Receipt',
                  value: 'Saved to trip history',
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Confirm payment',
            icon: Icons.verified_outlined,
            isLoading: paymentState.isLoading,
            onPressed: () {
              ref.read(paymentStateProvider.notifier).confirmPayment();
              context.push('/payment-confirmation');
            },
          ),
        ],
      ),
    );
  }
}

class _PaymentLine extends StatelessWidget {
  const _PaymentLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
