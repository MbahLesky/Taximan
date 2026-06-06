import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/models/driver.dart';
import '../../../../shared/models/rating.dart';
import '../../../../shared/utils/app_toast.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../auth/application/providers/auth_state_provider.dart';
import '../../../booking/application/providers/repositories.dart';
import '../../application/providers/driver_providers.dart';

class DriverListItem extends ConsumerWidget {
  const DriverListItem({
    super.key,
    required this.driver,
    required this.onViewDetails,
    this.onSelect,
    this.canSelect = false,
    this.isSelected = false,
  });

  final Driver driver;
  final VoidCallback onViewDetails;
  final VoidCallback? onSelect;
  final bool canSelect;
  final bool isSelected;

  String get _locationLabel {
    if (driver.currentLocation != null) {
      return driver.currentLocation!.city.isNotEmpty
          ? driver.currentLocation!.city
          : driver.currentLocation!.address;
    }

    if (driver.availabilityStatus.toLowerCase() != 'online' ||
        !driver.isAvailable) {
      final lastSeen = driver.currentLocation?.updatedAt ?? driver.updatedAt;
      return lastSeen != null
          ? 'Last seen ${_formatLastSeen(lastSeen)}'
          : 'Offline';
    }

    return 'Location unavailable';
  }

  String _formatLastSeen(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    }
    if (difference.inDays == 1) {
      return '1 day ago';
    }
    if (difference.inHours >= 1) {
      return '${difference.inHours} hours ago';
    }
    if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minutes ago';
    }
    return 'just now';
  }

  Color get _onlineColor {
    return driver.availabilityStatus.toLowerCase() == 'online'
        ? AppColors.success
        : AppColors.warning;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primaryLight,
              foregroundImage: driver.profilePhotoUrl != null
                  ? NetworkImage(driver.profilePhotoUrl!)
                  : null,
              child: driver.profilePhotoUrl == null
                  ? Text(
                      driver.fullName.isEmpty
                          ? '?'
                          : driver.fullName.characters.first.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryDark,
                      ),
                    )
                  : null,
            ),
            title: Text(
              driver.fullName.isEmpty ? 'Unknown driver' : driver.fullName,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_locationLabel),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${driver.vehicle.model} • ${driver.vehicle.plateNumber}',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // _TagChip(
                //   label: driver.isAvailable ? 'Available Today' : 'Not available',
                //   color: _availabilityColor,
                // ),
                // const SizedBox(height: AppSpacing.xs),
                _TagChip(
                  label: driver.availabilityStatus.capitalize(),
                  color: _onlineColor,
                ),
              ],
            ),
          ),
          const Divider(height: 24),
          Row(
            children: [
              TextButton(
                onPressed: onViewDetails,
                child: const Text('Details'),
              ),
              if (canSelect) ...[
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onSelect,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? AppColors.primaryDark
                          : AppColors.primary,
                    ),
                    child: Text(
                      isSelected ? 'Selected' : 'Select',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      visualDensity: VisualDensity.compact,
      backgroundColor: color.withOpacity(0.12),
      label: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

String _detailsLocationLabelForDriver(Driver driver) {
  if (driver.currentLocation != null) {
    return driver.currentLocation!.city.isNotEmpty
        ? driver.currentLocation!.city
        : driver.currentLocation!.address;
  }

  final lastSeen = driver.currentLocation?.updatedAt ?? driver.updatedAt;
  return lastSeen != null
      ? 'Last seen ${_formatLastSeenForDriver(lastSeen)}'
      : 'Location not available';
}

String _formatLastSeenForDriver(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);
  if (difference.inDays >= 2) {
    return '${difference.inDays} days ago';
  }
  if (difference.inDays == 1) {
    return '1 day ago';
  }
  if (difference.inHours >= 1) {
    return '${difference.inHours} hours ago';
  }
  if (difference.inMinutes >= 1) {
    return '${difference.inMinutes} minutes ago';
  }
  return 'just now';
}

Future<void> showDriverDetailsModal(BuildContext context, Driver driver) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Consumer(
        builder: (context, ref, child) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 4,
                      width: 64,
                      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Center(
                      child: CircleAvatar(
                        radius: 42,
                        backgroundColor: AppColors.primaryLight,
                        foregroundImage: driver.profilePhotoUrl != null
                            ? NetworkImage(driver.profilePhotoUrl!)
                            : null,
                        child: driver.profilePhotoUrl == null
                            ? Text(
                                driver.fullName.isEmpty
                                    ? '?'
                                    : driver.fullName.characters.first
                                          .toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primaryDark,
                                ),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Center(
                      child: Text(
                        driver.fullName.isEmpty
                            ? 'Driver details'
                            : driver.fullName,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Center(
                      child: Text(
                        _detailsLocationLabelForDriver(driver),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        _TagChip(
                          label: driver.isAvailable
                              ? 'Available Today'
                              : 'Not available',
                          color: driver.isAvailable
                              ? AppColors.success
                              : AppColors.error,
                        ),
                        _TagChip(
                          label: driver.availabilityStatus.capitalize(),
                          color:
                              driver.availabilityStatus.toLowerCase() ==
                                  'online'
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                        _TagChip(
                          label: '${driver.rating.toStringAsFixed(1)} ★',
                          color: AppColors.primaryDark,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _DriverDetailRow(
                      label: 'Vehicle',
                      value:
                          '${driver.vehicle.model.isNotEmpty ? driver.vehicle.model : driver.vehicle.type} • ${driver.vehicle.plateNumber}',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _DriverDetailRow(
                      label: 'City',
                      value:
                          driver.currentLocation?.city ??
                          (driver.availabilityStatus.toLowerCase() !=
                                      'online' ||
                                  !driver.isAvailable
                              ? 'Offline'
                              : 'Unknown'),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _DriverDetailRow(
                      label: 'Address',
                      value:
                          driver.currentLocation?.address ??
                          (driver.availabilityStatus.toLowerCase() !=
                                      'online' ||
                                  !driver.isAvailable
                              ? _detailsLocationLabelForDriver(driver)
                              : 'Unknown'),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _DriverDetailRow(
                      label: 'Rating count',
                      value: '${driver.ratingCount}',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _showDriverRatingModal(context, driver, ref),
                        icon: const Icon(Icons.star_border),
                        label: const Text('Rate driver'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Future<void> _showDriverRatingModal(
  BuildContext context,
  Driver driver,
  WidgetRef ref,
) async {
  var selectedRating = 5;
  var isSubmitting = false;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.lg,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Rate ${driver.fullName}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'How would you rate your experience with this driver?',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final rating = index + 1;
                    return IconButton(
                      onPressed: () => setState(() => selectedRating = rating),
                      icon: Icon(
                        rating <= selectedRating
                            ? Icons.star
                            : Icons.star_border,
                        color: AppColors.warning,
                        size: 36,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          setState(() => isSubmitting = true);
                          try {
                            final passengerId =
                                ref.read(authStateProvider).userId ?? '';
                            if (passengerId.isEmpty) {
                              throw Exception('Passenger not signed in.');
                            }

                            final rating = Rating(
                              id: '',
                              tripId: '',
                              bookingId: '',
                              passengerId: passengerId,
                              driverId: driver.id,
                              rating: selectedRating,
                              comment: '',
                              reportIssue: false,
                              issueType: null,
                              createdAt: DateTime.now(),
                            );

                            await ref
                                .read(ratingRepositoryProvider)
                                .createRating(rating);

                            // Update driver's aggregated rating atomically
                            final driverRef = FirebaseFirestore.instance
                                .collection('drivers')
                                .doc(driver.id);
                            await FirebaseFirestore.instance.runTransaction((
                              tx,
                            ) async {
                              final snap = await tx.get(driverRef);
                              final data = snap.exists
                                  ? (snap.data() as Map<String, dynamic>)
                                  : <String, dynamic>{};
                              final int currentCount =
                                  data['ratingCount'] is int
                                  ? data['ratingCount'] as int
                                  : (data['ratingCount'] is num
                                        ? (data['ratingCount'] as num).toInt()
                                        : 0);
                              final double currentAvg =
                                  data['ratingAverage'] is num
                                  ? (data['ratingAverage'] as num).toDouble()
                                  : 0.0;
                              final newCount = currentCount + 1;
                              final newAvg =
                                  ((currentAvg * currentCount) +
                                      selectedRating) /
                                  newCount;
                              tx.set(driverRef, {
                                'ratingCount': newCount,
                                'ratingAverage': newAvg,
                                'updatedAt': FieldValue.serverTimestamp(),
                              }, SetOptions(merge: true));
                            });

                            // Invalidate relevant providers so UI reflects change immediately
                            try {
                              ref.invalidate(driverStreamProvider(driver.id));
                              ref.invalidate(allDriversStreamProvider);
                            } catch (_) {}

                            if (context.mounted) {
                              Navigator.of(context).pop();
                              AppToast.success(
                                context,
                                title: 'Thanks for rating',
                                description:
                                    'You rated ${driver.fullName} $selectedRating stars.',
                              );
                            }
                          } catch (error) {
                            if (context.mounted) {
                              AppToast.error(
                                context,
                                title: 'Could not submit rating',
                                description: error.toString(),
                              );
                            }
                          } finally {
                            if (context.mounted) {
                              setState(() => isSubmitting = false);
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Submit rating'),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

class _DriverDetailRow extends StatelessWidget {
  const _DriverDetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 96,
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

extension on String {
  String capitalize() {
    if (isEmpty) return this;
    return substring(0, 1).toUpperCase() + substring(1);
  }
}
