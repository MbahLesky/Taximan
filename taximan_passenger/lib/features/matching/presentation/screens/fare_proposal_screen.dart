import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/utils/app_toast.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../booking/application/providers/booking_state_provider.dart';
import '../../application/providers/driver_providers.dart';
import '../../application/providers/fare_proposal_providers.dart';
import '../../application/providers/matching_state_provider.dart';

class FareProposalScreen extends ConsumerStatefulWidget {
  const FareProposalScreen({super.key});

  @override
  ConsumerState<FareProposalScreen> createState() => _FareProposalScreenState();
}

class _FareProposalScreenState extends ConsumerState<FareProposalScreen> {
  bool _isResponding = false;

  Future<void> _acceptProposal() async {
    final proposal = ref.read(matchingStateProvider).fareProposal;
    if (proposal == null) {
      return;
    }
    setState(() => _isResponding = true);
    try {
      await ref.read(fareProposalRepositoryProvider).acceptProposal(proposal);
      ref.read(bookingStateProvider.notifier).setDriverAssigned(
            driverId: proposal.driverId,
            vehicleId: proposal.vehicleId,
            finalFare: proposal.proposedFare,
          );
      ref.read(matchingStateProvider.notifier).acceptProposal();
      if (mounted) {
        AppToast.success(
          context,
          title: 'Proposal accepted',
          description: 'The driver has been assigned to your ride.',
        );
        context.push('/driver-assigned');
      }
    } catch (e) {
      if (mounted) {
        AppToast.error(
          context,
          title: 'Could not accept proposal',
          description: 'Check your connection and try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isResponding = false);
      }
    }
  }

  Future<void> _rejectProposal() async {
    final proposal = ref.read(matchingStateProvider).fareProposal;
    if (proposal == null) {
      return;
    }
    setState(() => _isResponding = true);
    try {
      await ref.read(fareProposalRepositoryProvider).rejectProposal(proposal);
      ref.read(matchingStateProvider.notifier).rejectProposal();
      if (mounted) {
        AppToast.success(
          context,
          title: 'Proposal rejected',
          description: 'We will keep searching for another driver.',
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        AppToast.error(
          context,
          title: 'Could not reject proposal',
          description: 'Check your connection and try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isResponding = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final proposal = ref.watch(matchingStateProvider).fareProposal;
    final driver = proposal == null
        ? null
        : ref.watch(driverProvider(proposal.driverId)).valueOrNull;
    final booking = ref.watch(bookingStateProvider).booking;

    return Scaffold(
      appBar: AppBar(title: const Text('Fare proposal')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(driver?.fullName ?? 'Driver proposal'),
                  subtitle: Text(
                    driver == null
                        ? 'Loading driver details'
                        : 'Driver rating ${driver.rating.toStringAsFixed(1)}',
                  ),
                ),
                const Divider(height: 28),
                _FareLine(
                  label: 'Original fare',
                  value: booking.estimatedFare > 0
                      ? booking.formattedFare
                      : 'Pending',
                ),
                _FareLine(
                  label: 'Proposed fare',
                  value: proposal?.formattedProposedFare ?? 'No proposal',
                  highlighted: true,
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    proposal?.message ??
                        'Waiting for a fare proposal from a driver.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Accept proposal',
            isLoading: _isResponding,
            onPressed: _acceptProposal,
          ),
          const SizedBox(height: AppSpacing.compact),
          AppButton(
            label: 'Reject and keep searching',
            variant: AppButtonVariant.secondary,
            onPressed: _isResponding ? null : _rejectProposal,
          ),
        ],
      ),
    );
  }
}

class _FareLine extends StatelessWidget {
  const _FareLine({
    required this.label,
    required this.value,
    this.highlighted = false,
  });

  final String label;
  final String value;
  final bool highlighted;

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
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: highlighted
                  ? AppColors.primaryDark
                  : AppColors.textPrimary,
              fontSize: highlighted ? 20 : 16,
            ),
          ),
        ],
      ),
    );
  }
}
