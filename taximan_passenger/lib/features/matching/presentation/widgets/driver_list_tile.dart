import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/models/driver.dart';
import '../../../../shared/widgets/app_card.dart';

class DriverListItem extends StatelessWidget {
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
    return 'Location unavailable';
  }

  Color get _availabilityColor {
    if (!driver.isAvailable) {
      return AppColors.error;
    }
    return AppColors.success;
  }

  Color get _onlineColor {
    return driver.availabilityStatus.toLowerCase() == 'online'
        ? AppColors.success
        : AppColors.warning;
  }

  @override
  Widget build(BuildContext context) {
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
                  '${driver.vehicle} • ${driver.plateNumber}',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _TagChip(
                  label: driver.isAvailable ? 'Available Today' : 'Not available',
                  color: _availabilityColor,
                ),
                const SizedBox(height: AppSpacing.xs),
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
                      backgroundColor: isSelected ? AppColors.primaryDark : AppColors.primary,
                    ),
                    child: Text(isSelected ? 'Selected' : 'Select'),
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
  const _TagChip({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Chip(
      visualDensity: VisualDensity.compact,
      backgroundColor: color.withOpacity(0.12),
      label: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

Future<void> showDriverDetailsModal(BuildContext context, Driver driver) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
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
                            driver.fullName.isEmpty ? '?' : driver.fullName.characters.first.toUpperCase(),
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
                    driver.fullName.isEmpty ? 'Driver details' : driver.fullName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Center(
                  child: Text(
                    driver.currentLocation?.city ?? driver.currentLocation?.address ?? 'Location not available',
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
                      label: driver.isAvailable ? 'Available Today' : 'Not available',
                      color: driver.isAvailable ? AppColors.success : AppColors.error,
                    ),
                    _TagChip(
                      label: driver.availabilityStatus.capitalize(),
                      color: driver.availabilityStatus.toLowerCase() == 'online'
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
                  value: '${driver.vehicle} • ${driver.plateNumber}',
                ),
                const SizedBox(height: AppSpacing.sm),
                _DriverDetailRow(
                  label: 'City',
                  value: driver.currentLocation?.city ?? 'Unknown',
                ),
                const SizedBox(height: AppSpacing.sm),
                _DriverDetailRow(
                  label: 'Address',
                  value: driver.currentLocation?.address ?? 'Unknown',
                ),
                const SizedBox(height: AppSpacing.sm),
                _DriverDetailRow(
                  label: 'Rating count',
                  value: '${driver.ratingCount}',
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _DriverDetailRow extends StatelessWidget {
  const _DriverDetailRow({
    required this.label,
    required this.value,
  });

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
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
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
