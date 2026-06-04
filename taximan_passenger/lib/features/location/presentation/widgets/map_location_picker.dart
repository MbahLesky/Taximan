import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/data/bamenda_locations.dart';
import '../../../../shared/models/app_location.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../application/providers/location_state_provider.dart';
import 'live_map_view.dart';

class MapLocationPickerSheet extends ConsumerStatefulWidget {
  const MapLocationPickerSheet({
    required this.title,
    super.key,
    this.initialLocation,
    this.pickup,
    this.destination,
  });

  final String title;
  final AppLocation? initialLocation;
  final AppLocation? pickup;
  final AppLocation? destination;

  @override
  ConsumerState<MapLocationPickerSheet> createState() =>
      _MapLocationPickerSheetState();
}

class _MapLocationPickerSheetState
    extends ConsumerState<MapLocationPickerSheet> {
  AppLocation? _selectedLocation;
  bool _isResolving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation?.hasCoordinates == true
        ? widget.initialLocation
        : null;
    Future.microtask(() {
      ref.read(locationStateProvider.notifier).refreshPermissionStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationStateProvider);
    final selectedLocation = _selectedLocation;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.md,
        ),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: LiveMapView(
                currentLocation: locationState.currentLocation.hasCoordinates
                    ? locationState.currentLocation
                    : null,
                pickup: widget.pickup,
                destination: widget.destination,
                pinnedLocation: selectedLocation,
                permissionStatus: locationState.permissionStatus,
                isLoading: _isResolving || locationState.isLoading,
                errorMessage: _errorMessage ?? locationState.errorMessage,
                onTap: _selectPoint,
                onCurrentLocationPressed: _useCurrentLocation,
                myLocationEnabled: locationState.hasLocationPermission,
                borderRadius: 18,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _SelectedLocationPanel(
              location: selectedLocation,
              isResolving: _isResolving,
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final location = bamendaLocations[index];
                  return ActionChip(
                    avatar: const Icon(Icons.place_outlined, size: 18),
                    label: Text(location.displayName),
                    onPressed: () => setState(() {
                      _selectedLocation = location.copyWith(
                        source: 'preset',
                        updatedAt: DateTime.now(),
                      );
                      _errorMessage = null;
                    }),
                  );
                },
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.xs),
                itemCount: bamendaLocations.length,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Use current',
                    icon: Icons.gps_fixed,
                    variant: AppButtonVariant.secondary,
                    isLoading: locationState.isLoading,
                    onPressed: _useCurrentLocation,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppButton(
                    label: 'Confirm pin',
                    icon: Icons.check,
                    onPressed: selectedLocation == null || _isResolving
                        ? null
                        : () => Navigator.of(context).pop(selectedLocation),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectPoint(LatLng point) async {
    setState(() {
      _isResolving = true;
      _errorMessage = null;
      _selectedLocation = AppLocation(
        name: 'Pinned location',
        address:
            'Pinned location (${point.latitude.toStringAsFixed(5)}, '
            '${point.longitude.toStringAsFixed(5)})',
        latitude: point.latitude,
        longitude: point.longitude,
        source: 'map_pin',
        updatedAt: DateTime.now(),
      );
    });

    try {
      final location = await ref
          .read(locationRepositoryProvider)
          .reverseGeocode(
            point.latitude,
            point.longitude,
            source: 'map_pin',
            fallbackName: 'Pinned location',
          );
      if (!mounted) {
        return;
      }
      setState(() {
        _selectedLocation = location;
        _isResolving = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isResolving = false;
        _errorMessage = 'Could not name this pin. Coordinates are still saved.';
      });
    }
  }

  Future<void> _useCurrentLocation() async {
    final location = await ref
        .read(locationStateProvider.notifier)
        .requestCurrentLocation();
    if (!mounted || location == null) {
      return;
    }
    setState(() {
      _selectedLocation = location.copyWith(source: 'gps');
      _errorMessage = null;
    });
  }
}

class _SelectedLocationPanel extends StatelessWidget {
  const _SelectedLocationPanel({
    required this.location,
    required this.isResolving,
  });

  final AppLocation? location;
  final bool isResolving;

  @override
  Widget build(BuildContext context) {
    final selectedLocation = location;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            selectedLocation == null ? Icons.touch_app : Icons.place,
            color: selectedLocation == null
                ? AppColors.textSecondary
                : AppColors.primaryDark,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedLocation == null
                      ? 'Tap the map to choose a point'
                      : selectedLocation.displayName,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  selectedLocation?.fullAddress ??
                      'You can also use your current GPS location.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          if (isResolving)
            const Padding(
              padding: EdgeInsets.only(left: AppSpacing.sm, top: 2),
              child: SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
    );
  }
}
