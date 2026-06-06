import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/models/booking.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../application/providers/booking_provider.dart';

class BookingRequestCard extends ConsumerWidget {
  const BookingRequestCard({required this.booking, super.key});

  final Booking booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(child: Icon(Icons.person)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.passengerName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      booking.paymentMethod,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Text(
                booking.formattedFare,
                style: const TextStyle(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const Divider(height: 28),
          _RouteBlock(
            pickup: booking.pickupLocation,
            destination: booking.destination,
          ),
          const Divider(height: 28),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _DetailChip(icon: Icons.route, label: booking.distance),
              _DetailChip(icon: Icons.timer_outlined, label: booking.eta),
              _DetailChip(
                icon: Icons.groups_outlined,
                label: '${booking.passengerCount} passenger(s)',
              ),
              _DetailChip(
                icon: Icons.luggage_outlined,
                label: '${booking.luggageCount} luggage',
              ),
              _DetailChip(
                icon: Icons.share,
                label: booking.isRideSharing ? 'Shared ride' : 'Private ride',
              ),
            ],
          ),
          if (booking.additionalInfo.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              booking.additionalInfo,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Accept',
            icon: Icons.check_circle_outline,
            onPressed: () => _accept(context, ref),
          ),
          const SizedBox(height: AppSpacing.compact),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Propose Fee',
                  icon: Icons.edit,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => _proposeFee(context, ref),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppButton(
                  label: 'Decline',
                  icon: Icons.close,
                  variant: AppButtonVariant.danger,
                  onPressed: () => _decline(context, ref),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _accept(BuildContext context, WidgetRef ref) async {
    try {
      final trip = await ref.read(bookingActionsProvider).accept(booking);
      if (context.mounted) {
        context.push('/trip-details', extra: trip);
      }
    } catch (e) {
      if (context.mounted) {
        _showMessage(context, e.toString());
      }
    }
  }

  Future<void> _decline(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(bookingActionsProvider).decline(booking);
      if (context.mounted) {
        _showMessage(context, 'Request declined.');
      }
    } catch (e) {
      if (context.mounted) {
        _showMessage(context, e.toString());
      }
    }
  }

  Future<void> _proposeFee(BuildContext context, WidgetRef ref) async {
    final amount = await showDialog<int>(
      context: context,
      builder: (context) =>
          _ProposeFeeDialog(initialFare: booking.estimatedFare),
    );
    if (amount == null) {
      return;
    }
    if (!context.mounted) {
      return;
    }

    try {
      await ref
          .read(bookingActionsProvider)
          .proposeFare(booking: booking, amount: amount);
      if (context.mounted) {
        _showMessage(context, 'Fare proposal sent.');
      }
    } catch (e) {
      if (context.mounted) {
        _showMessage(context, e.toString());
      }
    }
  }

  void _showMessage(BuildContext context, String message) {
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _RouteBlock extends StatelessWidget {
  const _RouteBlock({required this.pickup, required this.destination});

  final String pickup;
  final String destination;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const Icon(Icons.my_location, color: AppColors.info),
            Container(width: 2, height: 34, color: AppColors.border),
            const Icon(Icons.location_on, color: AppColors.error),
          ],
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pickup',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              Text(pickup, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Destination',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              Text(
                destination,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: AppColors.primaryDark),
      label: Text(label.isEmpty ? 'Pending' : label),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _ProposeFeeDialog extends StatefulWidget {
  const _ProposeFeeDialog({required this.initialFare});

  final int initialFare;

  @override
  State<_ProposeFeeDialog> createState() => _ProposeFeeDialogState();
}

class _ProposeFeeDialogState extends State<_ProposeFeeDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialFare.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Propose Fee'),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: 'Amount',
          suffixText: 'FCFA',
          errorText: _errorText,
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Send')),
      ],
    );
  }

  void _submit() {
    final amount = int.tryParse(_controller.text.trim());
    if (amount == null || amount <= 0) {
      setState(() => _errorText = 'Enter a valid amount.');
      return;
    }
    Navigator.of(context).pop(amount);
  }
}
