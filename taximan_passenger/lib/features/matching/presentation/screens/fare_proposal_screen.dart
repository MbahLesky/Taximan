import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/dummy/dummy_data.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../application/providers/matching_state_provider.dart';

class FareProposalScreen extends ConsumerWidget {
  const FareProposalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proposal = ref.watch(matchingStateProvider).fareProposal;

    return Scaffold(
      appBar: AppBar(title: const Text('Fare proposal')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text(DummyData.driverName),
                  subtitle: Text('Driver rating ${DummyData.driverRating}'),
                ),
                const Divider(height: 28),
                const _FareLine(
                  label: 'Original fare',
                  value: DummyData.estimatedFare,
                ),
                _FareLine(
                  label: 'Proposed fare',
                  value:
                      proposal?.formattedProposedFare ?? DummyData.proposedFare,
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
                  child: Text(proposal?.message ?? DummyData.driverNote),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Accept proposal',
            onPressed: () {
              ref.read(matchingStateProvider.notifier).acceptProposal();
              context.push('/driver-assigned');
            },
          ),
          const SizedBox(height: AppSpacing.compact),
          AppButton(
            label: 'Reject and keep searching',
            variant: AppButtonVariant.secondary,
            onPressed: () {
              ref.read(matchingStateProvider.notifier).rejectProposal();
              context.pop();
            },
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
