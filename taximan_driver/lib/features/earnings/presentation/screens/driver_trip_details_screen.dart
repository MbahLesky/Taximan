import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/models/app_location.dart';
import '../../../../shared/models/trip.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_button.dart';

class DriverTripDetailsScreen extends StatelessWidget {
  const DriverTripDetailsScreen({super.key, this.trip});

  final Trip? trip;

  @override
  Widget build(BuildContext context) {
    if (trip == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Trip details')),
        body: const Center(
          child: AppEmptyState(
            icon: Icons.error_outline,
            title: 'Trip not found',
            message: 'Select a trip from history to see details.',
          ),
        ),
      );
    }

    final pickupLocation = _latLngFromLocation(trip!.pickup);
    final destinationLocation = _latLngFromLocation(trip!.destinationLocation);
    final markers = <Marker>{
      if (pickupLocation != null)
        Marker(
          markerId: const MarkerId('pickup'),
          position: pickupLocation,
          infoWindow: InfoWindow(title: 'Pickup', snippet: trip!.pickup.address),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      if (destinationLocation != null)
        Marker(
          markerId: const MarkerId('destination'),
          position: destinationLocation,
          infoWindow: InfoWindow(title: 'Destination', snippet: trip!.destinationLocation.address),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
    };
    final polylines = pickupLocation != null && destinationLocation != null
        ? {
            Polyline(
              polylineId: const PolylineId('trip_route'),
              points: [pickupLocation, destinationLocation],
              color: AppColors.primaryDark,
              width: 4,
            )
          }
        : <Polyline>{};
    final initialCamera = pickupLocation ?? destinationLocation;

    return Scaffold(
      appBar: AppBar(title: const Text('Trip details')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (initialCamera != null) ...[
                  SizedBox(
                    height: 220,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: initialCamera,
                          zoom: 13,
                        ),
                        markers: markers,
                        polylines: polylines,
                        zoomControlsEnabled: false,
                        myLocationEnabled: false,
                        myLocationButtonEnabled: false,
                      ),
                    ),
                  ),
                ] else ...[
                  SizedBox(
                    height: 220,
                    child: Center(
                      child: Text(
                        'No trip map data available',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'Open full page map',
                  icon: Icons.open_in_full,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => context.push('/trip-map', extra: trip),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  trip!.passengerName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Passenger',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const Divider(height: 28),
                _DetailsLine(label: 'Pickup', value: trip!.pickup.address),
                _DetailsLine(label: 'Destination', value: trip!.destinationLocation.address),
                _DetailsLine(label: 'Fare', value: trip!.formattedFare),
                _DetailsLine(label: 'Distance', value: trip!.distance),
                _DetailsLine(label: 'Duration', value: trip!.duration),
                _DetailsLine(label: 'Payment method', value: trip!.paymentMethod),
                _DetailsLine(label: 'Status', value: trip!.status),
                _DetailsLine(label: 'Scheduled', value: trip!.date),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Actions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'Start trip',
                  icon: Icons.play_arrow,
                  onPressed: () => context.push('/trip-start'),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'Track trip',
                  icon: Icons.navigation,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => context.push('/trip-map', extra: trip),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'Cancel trip',
                  icon: Icons.cancel_outlined,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => _confirmCancel(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmCancel(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancel trip'),
          content: const Text('Are you sure you want to cancel this trip? This will not delete the trip.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Trip has been canceled.')),
                );
              },
              child: const Text('Yes, cancel'),
            ),
          ],
        );
      },
    );
  }
}

class _DetailsLine extends StatelessWidget {
  const _DetailsLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

LatLng? _latLngFromLocation(AppLocation location) {
  if (location.latitude == null || location.longitude == null) {
    return null;
  }
  return LatLng(location.latitude!, location.longitude!);
}
