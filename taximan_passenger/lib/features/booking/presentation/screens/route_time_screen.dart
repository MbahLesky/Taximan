import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/data/bamenda_locations.dart';
import '../../../../shared/models/app_location.dart';
import '../../../../shared/utils/app_toast.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../location/application/providers/location_state_provider.dart';
import '../../../location/presentation/widgets/live_map_view.dart';
import '../../../location/presentation/widgets/map_location_picker.dart';
import '../../application/providers/booking_state_provider.dart';

class RouteTimeScreen extends ConsumerStatefulWidget {
  const RouteTimeScreen({super.key});

  @override
  ConsumerState<RouteTimeScreen> createState() => _RouteTimeScreenState();
}

class _RouteTimeScreenState extends ConsumerState<RouteTimeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(locationStateProvider.notifier).startLiveUpdates();
    });
  }

  Future<void> _pickSchedule(
    BuildContext context,
    WidgetRef ref,
    DateTime? currentValue,
  ) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: currentValue ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );
    if (date == null || !context.mounted) {
      return;
    }
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentValue ?? now),
    );
    if (time == null) {
      return;
    }
    ref
        .read(bookingStateProvider.notifier)
        .setPickupTime(
          pickupTimeType: 'scheduled',
          scheduledPickupTime: DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(bookingStateProvider, (previous, next) {
      final message = next.errorMessage;
      if (message != null && message != previous?.errorMessage) {
        AppToast.error(
          context,
          title: 'Location unavailable',
          description: message,
        );
      }
    });

    final booking = ref.watch(bookingStateProvider).booking;
    final locationState = ref.watch(locationStateProvider);
    final controller = ref.read(bookingStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Plan route')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _MapPreview(
            currentLocation: locationState.currentLocation,
            pickup: booking.pickup,
            destination: booking.destinationLocation,
            permissionStatus: locationState.permissionStatus,
            isLoading: locationState.isLoading,
            errorMessage: locationState.errorMessage,
            onCurrentLocationPressed: () async {
              final location = await ref
                  .read(locationStateProvider.notifier)
                  .requestCurrentLocation();
              if (location != null) {
                controller.setPickupLocation(location);
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ride route',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                _LocationSelector(
                  label: 'Pickup',
                  icon: Icons.my_location,
                  selectedLocation: booking.pickup,
                  onSelected: controller.setPickupLocation,
                  pickup: booking.pickup,
                  destination: booking.destinationLocation,
                ),
                const Divider(height: 28),
                _LocationSelector(
                  label: 'Destination',
                  icon: Icons.location_on_outlined,
                  selectedLocation: booking.destinationLocation.address.isEmpty
                      ? null
                      : booking.destinationLocation,
                  onSelected: controller.setDestinationLocation,
                  pickup: booking.pickup,
                  destination: booking.destinationLocation,
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
                  'Pickup time',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'now',
                      icon: Icon(Icons.flash_on),
                      label: Text('Now'),
                    ),
                    ButtonSegment(
                      value: 'scheduled',
                      icon: Icon(Icons.schedule),
                      label: Text('Later'),
                    ),
                  ],
                  selected: {booking.pickupTimeType},
                  onSelectionChanged: (selection) {
                    final value = selection.first;
                    if (value == 'now') {
                      controller.setPickupTime(pickupTimeType: 'now');
                      return;
                    }
                    _pickSchedule(context, ref, booking.scheduledPickupTime);
                  },
                ),
                if (booking.pickupTimeType == 'scheduled') ...[
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton.icon(
                    onPressed: () => _pickSchedule(
                      context,
                      ref,
                      booking.scheduledPickupTime,
                    ),
                    icon: const Icon(Icons.event),
                    label: Text(
                      booking.scheduledPickupTime == null
                          ? 'Choose date and time'
                          : _formatDateTime(booking.scheduledPickupTime!),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: 'Continue to ride details',
            icon: Icons.arrow_forward,
            onPressed: ref.watch(bookingStateProvider).canConfirmRide
                ? () => context.push('/ride-details')
                : null,
          ),
        ],
      ),
    );
  }
}

class _LocationSelector extends StatelessWidget {
  const _LocationSelector({
    required this.label,
    required this.icon,
    required this.selectedLocation,
    required this.onSelected,
    required this.pickup,
    required this.destination,
  });

  final String label;
  final IconData icon;
  final AppLocation? selectedLocation;
  final ValueChanged<AppLocation> onSelected;
  final AppLocation pickup;
  final AppLocation destination;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: AppSpacing.xs),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primaryDark),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                selectedLocation?.fullAddress ?? 'Select a location',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Autocomplete<AppLocation>(
          displayStringForOption: (location) => location.fullAddress,
          optionsBuilder: (value) {
            final query = value.text.trim().toLowerCase();
            final container = ProviderScope.containerOf(context);
            final locationState = container.read(locationStateProvider);
            final bookingState = container.read(bookingStateProvider);

            // Start with current GPS location (if available) and the preset Bamenda locations.
            final suggestions = <AppLocation>[];
            if (locationState.currentLocation.hasCoordinates) {
              suggestions.add(locationState.currentLocation);
            }

            // Include any recent destinations that match known presets (ensures coords).
            for (final addr in bookingState.recentDestinations) {
              final match = bamendaLocations.firstWhere(
                (l) => l.fullAddress.toLowerCase() == addr.toLowerCase(),
                orElse: () => AppLocation(address: ''),
              );
              if (match.address.isNotEmpty) suggestions.add(match);
            }

            // Use preset Bamenda locations as fallbacks; all presets include coordinates.
            final pool = [...suggestions, ...bamendaLocations];

            // If the user typed coordinates like "5.95,10.14", parse and return that location.
            final coordMatch = RegExp(r"(-?\d+\.?\d*)[, ]+(-?\d+\.?\d*)");
            final coordResult = coordMatch.firstMatch(value.text);
            if (coordResult != null) {
              final lat = double.tryParse(coordResult.group(1)!);
              final lng = double.tryParse(coordResult.group(2)!);
              if (lat != null && lng != null) {
                return [
                  AppLocation(
                    name: 'Coordinates',
                    address: 'Pinned (${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)})',
                    latitude: lat,
                    longitude: lng,
                    source: 'typed_coordinates',
                  )
                ];
              }
            }

            if (query.isEmpty) {
              // Deduplicate by address
              final seen = <String>{};
              return pool.where((p) {
                final key = p.fullAddress.toLowerCase();
                if (key.isEmpty || seen.contains(key)) return false;
                seen.add(key);
                return p.hasCoordinates;
              }).toList();
            }

            return pool.where((location) {
              final addr = location.fullAddress.toLowerCase();
              final name = location.name?.toLowerCase() ?? '';
              return (addr.contains(query) || name.contains(query)) && location.hasCoordinates;
            });
          },
          onSelected: onSelected,
          fieldViewBuilder:
              (context, textController, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: textController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Type to search places',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      tooltip: 'Use current location',
                      icon: const Icon(Icons.gps_fixed),
                      onPressed: () => _useCurrentLocation(context),
                    ),
                  ),
                );
              },
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            ActionChip(
              avatar: const Icon(Icons.my_location, size: 18),
              label: const Text('Current location'),
              onPressed: () => _useCurrentLocation(context),
            ),
            ActionChip(
              avatar: const Icon(Icons.map_outlined, size: 18),
              label: const Text('Pin on map'),
              onPressed: () => _showMapPicker(context),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _useCurrentLocation(BuildContext context) async {
    final container = ProviderScope.containerOf(context);
    final location = await container
        .read(locationStateProvider.notifier)
        .requestCurrentLocation();
    if (location != null) {
      onSelected(location);
    }
  }

  Future<void> _showMapPicker(BuildContext context) async {
    final selected = await showModalBottomSheet<AppLocation>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.9,
          child: MapLocationPickerSheet(
            title: 'Pin $label',
            initialLocation: selectedLocation,
            pickup: pickup,
            destination: destination.address.isEmpty ? null : destination,
          ),
        );
      },
    );
    if (selected != null) {
      onSelected(selected.copyWith(source: 'map_pin'));
    }
  }
}

class _MapPreview extends StatelessWidget {
  const _MapPreview({
    this.currentLocation,
    this.pickup,
    this.destination,
    this.permissionStatus = 'unknown',
    this.isLoading = false,
    this.errorMessage,
    this.onCurrentLocationPressed,
  });

  final AppLocation? currentLocation;
  final AppLocation? pickup;
  final AppLocation? destination;
  final String permissionStatus;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onCurrentLocationPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LiveMapView(
          height: 180,
          currentLocation: currentLocation?.hasCoordinates == true
              ? currentLocation
              : null,
          pickup: pickup,
          destination: destination?.address.isNotEmpty == true
              ? destination
              : null,
          permissionStatus: permissionStatus,
          isLoading: isLoading,
          errorMessage: errorMessage,
          onCurrentLocationPressed: onCurrentLocationPressed,
          myLocationEnabled: permissionStatus == 'granted',
          borderRadius: 16,
        ),
        Positioned(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: AppSpacing.md,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                child: Text(
                  destination?.address.isNotEmpty == true
                      ? '${pickup?.displayName ?? 'Pickup'} to '
                            '${destination!.displayName}'
                      : 'Bamenda service area',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String _formatDateTime(DateTime value) {
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '${value.day}/${value.month}/${value.year} at $hour:$minute';
}
