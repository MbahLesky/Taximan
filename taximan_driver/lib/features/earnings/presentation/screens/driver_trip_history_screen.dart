import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/models/fare_proposal.dart';
import '../../../../shared/models/trip.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/bottom_nav_shell.dart';
import '../../../booking_management/application/providers/booking_provider.dart';
import '../../../trip/application/providers/trip_providers.dart';

class DriverTripHistoryScreen extends ConsumerStatefulWidget {
  const DriverTripHistoryScreen({super.key});

  @override
  ConsumerState<DriverTripHistoryScreen> createState() =>
      _DriverTripHistoryScreenState();
}

class _DriverTripHistoryScreenState extends ConsumerState<DriverTripHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allTrips = ref.watch(driverTripsStreamProvider);
    final proposals = ref.watch(driverProposalsStreamProvider);

    return BottomNavShell(
      currentIndex: 2,
      title: 'Trips',
      child: SafeArea(
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: AppColors.primaryDark,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primaryDark,
              tabs: const [
                Tab(text: 'All Trips'),
                Tab(text: 'Proposals'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTripsTab(allTrips),
                  _buildProposalsTab(proposals),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripsTab(AsyncValue<List<Trip>> tripsAsync) {
    return tripsAsync.when(
      data: (trips) {
        if (trips.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: AppEmptyState(
              icon: Icons.history,
              title: 'No trips yet',
              message: 'Accepted trips will appear here.',
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: trips.length,
          itemBuilder: (context, index) {
            final trip = trips[index];
            return AppCard(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                leading: const Icon(Icons.local_taxi),
                title: Text(
                  '${trip.passengerName} to ${trip.destinationLocation.address}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: Text(
                        trip.date,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _StatusTag(status: trip.status),
                  ],
                ),
                trailing: Text(
                  trip.formattedFare,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                  ),
                ),
                onTap: () => context.push('/trip-details', extra: trip),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: AppEmptyState(
          icon: Icons.error_outline,
          title: 'Could not load trips',
          message: error.toString(),
        ),
      ),
    );
  }

  Widget _buildProposalsTab(AsyncValue<List<FareProposal>> proposalsAsync) {
    return proposalsAsync.when(
      data: (proposals) {
        if (proposals.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: AppEmptyState(
              icon: Icons.local_offer,
              title: 'No proposals yet',
              message: 'Fare proposals you make will appear here.',
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: proposals.length,
          itemBuilder: (context, index) {
            final proposal = proposals[index];
            final isAccepted = proposal.status == 'accepted';
            final isRejected = proposal.status == 'rejected';

            return AppCard(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                leading: Icon(
                  Icons.local_offer,
                  color: isAccepted
                      ? Colors.green
                      : isRejected
                          ? Colors.red
                          : AppColors.primaryDark,
                ),
                title: Text(
                  proposal.message.isNotEmpty
                      ? proposal.message
                      : 'Fare proposal',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${proposal.formattedOriginalFare} → ${proposal.formattedProposedFare}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _ProposalStatusTag(status: proposal.status),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      proposal.formattedProposedFare,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: proposal.proposedFare > proposal.originalFare
                            ? Colors.green
                            : proposal.proposedFare < proposal.originalFare
                                ? Colors.red
                                : AppColors.primaryDark,
                      ),
                    ),
                    Text(
                      proposal.fareAdjustment,
                      style: TextStyle(
                        fontSize: 12,
                        color: proposal.proposedFare > proposal.originalFare
                            ? Colors.green
                            : proposal.proposedFare < proposal.originalFare
                                ? Colors.red
                                : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: AppEmptyState(
          icon: Icons.error_outline,
          title: 'Could not load proposals',
          message: error.toString(),
        ),
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  const _StatusTag({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String displayText;

    switch (status.toLowerCase()) {
      case 'driverarriving':
      case 'driver_arriving':
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade900;
        displayText = 'Arriving';
        break;
      case 'arrived':
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade900;
        displayText = 'Arrived';
        break;
      case 'inprogress':
      case 'in_progress':
        backgroundColor = Colors.purple.shade100;
        textColor = Colors.purple.shade900;
        displayText = 'In Progress';
        break;
      case 'completed':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade900;
        displayText = 'Completed';
        break;
      case 'cancelled':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade900;
        displayText = 'Cancelled';
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade900;
        displayText = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ProposalStatusTag extends StatelessWidget {
  const _ProposalStatusTag({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String displayText;

    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = Colors.amber.shade100;
        textColor = Colors.amber.shade900;
        displayText = 'Pending';
        break;
      case 'accepted':
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade900;
        displayText = 'Accepted';
        break;
      case 'rejected':
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade900;
        displayText = 'Rejected';
        break;
      default:
        backgroundColor = Colors.grey.shade100;
        textColor = Colors.grey.shade900;
        displayText = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
