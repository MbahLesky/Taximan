import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../application/providers/booking_state_provider.dart';

class DestinationSearchScreen extends ConsumerStatefulWidget {
  const DestinationSearchScreen({super.key});

  @override
  ConsumerState<DestinationSearchScreen> createState() =>
      _DestinationSearchScreenState();
}

class _DestinationSearchScreenState
    extends ConsumerState<DestinationSearchScreen> {
  late bool _rideSharing;
  late bool _hasLuggage;
  late int _passengerCount;
  late int _luggageCount;
  late String _paymentMethod;
  late final TextEditingController _fareController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final booking = ref.read(bookingStateProvider).booking;
    _rideSharing = booking.isRideSharing;
    _hasLuggage = booking.hasLuggage;
    _passengerCount = booking.passengerCount;
    _luggageCount = booking.luggageCount == 0 ? 1 : booking.luggageCount;
    _paymentMethod = booking.paymentMethod;
    _fareController = TextEditingController(
      text: booking.proposedFareAmount == 0
          ? booking.estimatedFare.toString()
          : booking.proposedFareAmount.toString(),
    );
    _notesController = TextEditingController(text: booking.additionalInfo);
  }

  @override
  void dispose() {
    _fareController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _continue() {
    final proposedFare = int.tryParse(_fareController.text.trim()) ?? 0;
    ref
        .read(bookingStateProvider.notifier)
        .setRideDetails(
          isRideSharing: _rideSharing,
          passengerCount: _passengerCount,
          hasLuggage: _hasLuggage,
          luggageCount: _luggageCount,
          paymentMethod: _paymentMethod,
          proposedFareAmount: proposedFare,
          additionalInfo: _notesController.text.trim(),
        );
    context.push('/pickup-time');
  }

  @override
  Widget build(BuildContext context) {
    final booking = ref.watch(bookingStateProvider).booking;

    return Scaffold(
      appBar: AppBar(title: const Text('Ride details')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trip preferences',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _rideSharing,
                  activeColor: AppColors.primaryDark,
                  title: const Text('Allow ride sharing'),
                  subtitle: const Text(
                    'Share the trip when another passenger fits the route.',
                  ),
                  onChanged: (value) => setState(() => _rideSharing = value),
                ),
                const Divider(height: 24),
                _StepperRow(
                  label: 'Passengers',
                  value: _passengerCount,
                  min: 1,
                  max: 6,
                  onChanged: (value) => setState(() => _passengerCount = value),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _hasLuggage,
                  activeColor: AppColors.primaryDark,
                  title: const Text('Luggage included'),
                  onChanged: (value) => setState(() => _hasLuggage = value),
                ),
                if (_hasLuggage)
                  _StepperRow(
                    label: 'Luggage pieces',
                    value: _luggageCount,
                    min: 1,
                    max: 8,
                    onChanged: (value) => setState(() => _luggageCount = value),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fare and payment',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'Cash',
                      icon: Icon(Icons.payments_outlined),
                      label: Text('Cash'),
                    ),
                    ButtonSegment(
                      value: 'Escrow',
                      icon: Icon(Icons.account_balance_wallet_outlined),
                      label: Text('Escrow'),
                    ),
                  ],
                  selected: {_paymentMethod},
                  onSelectionChanged: (selection) {
                    setState(() => _paymentMethod = selection.first);
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _fareController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Proposed amount of pay',
                    hintText: booking.estimatedFare > 0
                        ? booking.estimatedFare.toString()
                        : 'Enter amount',
                    prefixIcon: const Icon(Icons.sell_outlined),
                    suffixText: 'FCFA',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: AppTextField(
              label: 'Additional information',
              hint: 'Gate code, landmark, special instructions...',
              icon: Icons.notes_outlined,
              maxLines: 4,
              controller: _notesController,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Continue to drivers',
            icon: Icons.arrow_forward,
            onPressed: _continue,
          ),
        ],
      ),
    );
  }
}

class _StepperRow extends StatelessWidget {
  const _StepperRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          IconButton.filledTonal(
            tooltip: 'Decrease',
            onPressed: value <= min ? null : () => onChanged(value - 1),
            icon: const Icon(Icons.remove),
          ),
          SizedBox(
            width: 44,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          IconButton.filledTonal(
            tooltip: 'Increase',
            onPressed: value >= max ? null : () => onChanged(value + 1),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
