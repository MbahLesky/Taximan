import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/models/payment.dart';
import '../../../../shared/utils/app_toast.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../auth/application/providers/auth_state_provider.dart';
import '../../../booking/application/providers/booking_state_provider.dart';
import '../../../booking/application/providers/repositories.dart';
import '../../../trip/application/providers/trip_state_provider.dart';
import '../../application/providers/payment_state_provider.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensurePayment());
  }

  Future<void> _ensurePayment() async {
    final paymentState = ref.read(paymentStateProvider);
    if (paymentState.activePayment != null || paymentState.isLoading) {
      return;
    }

    final booking = ref.read(bookingStateProvider).booking;
    final activeTrip = ref.read(tripStateProvider).activeTrip;
    final trip = activeTrip?.bookingId == booking.id ? activeTrip : null;
    final passengerId =
        ref.read(authStateProvider).userId ?? booking.passengerId;
    final driverId = booking.driverId ?? trip?.driverId;
    final amount = trip?.finalFare ?? booking.finalFare ?? booking.estimatedFare;

    if (booking.id.isEmpty || passengerId.isEmpty || driverId == null) {
      ref
          .read(paymentStateProvider.notifier)
          .markFailed('Payment is not ready for this trip yet.');
      return;
    }

    ref.read(paymentStateProvider.notifier).setLoading(true);
    try {
      final payment = await ref.read(paymentRepositoryProvider).createPayment(
            Payment(
              id: '',
              bookingId: booking.id,
              tripId: trip?.id ?? '',
              passengerId: passengerId,
              driverId: driverId,
              amount: amount,
              method: paymentState.selectedMethod,
              createdAt: DateTime.now(),
            ),
          );
      ref.read(paymentStateProvider.notifier).createPayment(payment);
    } catch (e) {
      ref
          .read(paymentStateProvider.notifier)
          .markFailed('Could not prepare payment. Try again.');
    }
  }

  Future<void> _confirmPayment(BuildContext context) async {
    await _ensurePayment();
    final paymentState = ref.read(paymentStateProvider);
    final payment = paymentState.activePayment;
    if (payment == null) {
      return;
    }

    if (paymentState.selectedMethod == 'cash') {
      final confirmed = await _requestPaymentPin(context);
      if (!confirmed) {
        return;
      }
    }

    ref.read(paymentStateProvider.notifier).setLoading(true);
    try {
      await ref
          .read(paymentRepositoryProvider)
          .confirmPayment(payment.id, 'passenger');
      ref.read(paymentStateProvider.notifier).confirmPayment();
      if (context.mounted) {
        AppToast.success(
          context,
          title: 'Payment confirmed',
          description: 'Your receipt has been saved to trip history.',
        );
        context.push('/payment-confirmation');
      }
    } catch (e) {
      ref
          .read(paymentStateProvider.notifier)
          .markFailed('Could not confirm payment. Try again.');
    }
  }

  Future<bool> _requestPaymentPin(BuildContext context) async {
    final pinController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter payment PIN'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter the payment PIN to complete your trip payment.'),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                decoration: const InputDecoration(
                  hintText: 'Payment PIN',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final pin = pinController.text.trim();
                if (pin.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a PIN.')),
                  );
                  return;
                }
                Navigator.of(context).pop(true);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
    return result == true;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(paymentStateProvider, (_, next) {
      if (next.activePayment == null &&
          !next.isLoading &&
          next.errorMessage == null) {
        _ensurePayment();
      }
    });
    ref.listen(paymentStateProvider, (previous, next) {
      final message = next.errorMessage;
      if (message != null && message != previous?.errorMessage) {
        AppToast.error(context, title: 'Payment error', description: message);
      }
    });

    final paymentState = ref.watch(paymentStateProvider);
    final payment = paymentState.activePayment;
    final fare = payment?.formattedAmount ?? '0 FCFA';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
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
            onPressed: paymentState.activePayment == null
                ? null
                : () => _confirmPayment(context),
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
