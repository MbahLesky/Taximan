import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/data/bamenda_locations.dart';
import '../../../../shared/models/app_location.dart';
import '../../../../shared/models/driver_location.dart';

class LiveMapView extends StatefulWidget {
  const LiveMapView({
    super.key,
    this.height,
    this.currentLocation,
    this.pickup,
    this.destination,
    this.pinnedLocation,
    this.driverLocations = const [],
    this.assignedDriverLocation,
    this.permissionStatus = 'unknown',
    this.isLoading = false,
    this.errorMessage,
    this.showDriverEmptyState = false,
    this.showRoute = true,
    this.myLocationEnabled = false,
    this.onTap,
    this.onCurrentLocationPressed,
    this.onExpandPressed,
    this.showExpandButton = true,
    this.borderRadius = 24,
  });

  final double? height;
  final AppLocation? currentLocation;
  final AppLocation? pickup;
  final AppLocation? destination;
  final AppLocation? pinnedLocation;
  final List<DriverLocation> driverLocations;
  final DriverLocation? assignedDriverLocation;
  final String permissionStatus;
  final bool isLoading;
  final String? errorMessage;
  final bool showDriverEmptyState;
  final bool showRoute;
  final bool myLocationEnabled;
  final ValueChanged<LatLng>? onTap;
  final VoidCallback? onCurrentLocationPressed;
  final VoidCallback? onExpandPressed;
  final bool showExpandButton;
  final double borderRadius;

  @override
  State<LiveMapView> createState() => _LiveMapViewState();
}

class _LiveMapViewState extends State<LiveMapView> {
  GoogleMapController? _controller;
  String _lastCameraKey = '';

  @override
  void didUpdateWidget(covariant LiveMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _fitCameraToVisiblePoints();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final markers = _markers();
    final points = _visiblePoints(markers);
    final initialTarget = points.isEmpty ? _defaultTarget : points.first;
    final hasDriverPins =
        widget.assignedDriverLocation != null ||
        widget.driverLocations.isNotEmpty;
    final content = Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: initialTarget,
              zoom: points.length > 1 ? 12 : 14,
            ),
            markers: markers,
            polylines: _polylines(),
            myLocationEnabled: widget.myLocationEnabled,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
            onMapCreated: (controller) {
              _controller = controller;
              _fitCameraToVisiblePoints();
            },
            onTap: widget.onTap,
            gestureRecognizers: {
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
          ),
          if (widget.onCurrentLocationPressed != null)
            Positioned(
              right: AppSpacing.sm,
              bottom: AppSpacing.sm,
              child: IconButton.filled(
                tooltip: 'Use current location',
                onPressed: widget.onCurrentLocationPressed,
                icon: const Icon(Icons.gps_fixed),
              ),
            ),
          if (widget.showExpandButton)
            Positioned(
              right: AppSpacing.sm,
              bottom: widget.onCurrentLocationPressed == null
                  ? AppSpacing.sm
                  : AppSpacing.sm + 52,
              child: IconButton.filledTonal(
                tooltip: 'Open full map',
                style: IconButton.styleFrom(
                  fixedSize: const Size.square(44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.primaryDark,
                ),
                onPressed: _openExpandedMap,
                icon: const Icon(Icons.open_in_full),
              ),
            ),
          Positioned(
            left: AppSpacing.sm,
            top: AppSpacing.sm,
            child: _MapStatusPill(
              icon: widget.permissionStatus == 'granted'
                  ? Icons.sensors
                  : Icons.location_disabled_outlined,
              label: widget.permissionStatus == 'granted'
                  ? 'Location active'
                  : 'Location limited',
              color: widget.permissionStatus == 'granted'
                  ? AppColors.success
                  : AppColors.warning,
            ),
          ),
          if (widget.showDriverEmptyState && !hasDriverPins)
            const Positioned(
              left: AppSpacing.sm,
              right: AppSpacing.sm,
              bottom: AppSpacing.sm,
              child: _MapNotice(
                icon: Icons.local_taxi_outlined,
                message: 'No online drivers nearby yet.',
              ),
            ),
          if (widget.permissionStatus == 'denied' ||
              widget.permissionStatus == 'deniedForever' ||
              widget.permissionStatus == 'serviceDisabled')
            Positioned.fill(
              child: _MapOverlay(
                icon: Icons.location_off_outlined,
                message: widget.permissionStatus == 'serviceDisabled'
                    ? 'Turn on device location services.'
                    : 'Location permission is needed for live pickup.',
              ),
            ),
          if (widget.errorMessage != null)
            Positioned(
              left: AppSpacing.sm,
              right: AppSpacing.sm,
              top: 54,
              child: _MapNotice(
                icon: Icons.info_outline,
                message: widget.errorMessage!,
              ),
            ),
          if (widget.isLoading)
            const Positioned.fill(
              child: _MapOverlay(
                icon: Icons.my_location,
                message: 'Finding your location...',
                isLoading: true,
              ),
            ),
        ],
      ),
    );

    if (widget.height == null) {
      return SizedBox.expand(child: content);
    }
    return content;
  }

  Set<Marker> _markers() {
    final markers = <Marker>{};

    void addLocationMarker({
      required String id,
      required AppLocation? location,
      required String title,
      required double hue,
    }) {
      if (location?.hasCoordinates != true) {
        return;
      }
      markers.add(
        Marker(
          markerId: MarkerId(id),
          position: LatLng(location!.latitude!, location.longitude!),
          infoWindow: InfoWindow(title: title, snippet: location.displayName),
          icon: BitmapDescriptor.defaultMarkerWithHue(hue),
        ),
      );
    }

    addLocationMarker(
      id: 'current_location',
      location: widget.currentLocation,
      title: 'You',
      hue: BitmapDescriptor.hueAzure,
    );
    addLocationMarker(
      id: 'pickup',
      location: widget.pickup,
      title: 'Pickup',
      hue: BitmapDescriptor.hueBlue,
    );
    addLocationMarker(
      id: 'destination',
      location: widget.destination,
      title: 'Destination',
      hue: BitmapDescriptor.hueRed,
    );
    addLocationMarker(
      id: 'pinned_location',
      location: widget.pinnedLocation,
      title: 'Selected point',
      hue: BitmapDescriptor.hueViolet,
    );

    final assignedDriverId = widget.assignedDriverLocation?.driverId;
    for (final location in widget.driverLocations) {
      if (location.driverId == assignedDriverId) {
        continue;
      }
      markers.add(
        Marker(
          markerId: MarkerId('driver_${location.driverId}'),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: const InfoWindow(title: 'Online driver'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            location.isAvailable
                ? BitmapDescriptor.hueYellow
                : BitmapDescriptor.hueOrange,
          ),
          rotation: location.heading,
          flat: true,
        ),
      );
    }

    final assigned = widget.assignedDriverLocation;
    if (assigned != null) {
      markers.add(
        Marker(
          markerId: MarkerId('assigned_driver_${assigned.driverId}'),
          position: LatLng(assigned.latitude, assigned.longitude),
          infoWindow: const InfoWindow(title: 'Assigned driver'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          rotation: assigned.heading,
          flat: true,
        ),
      );
    }

    return markers;
  }

  Set<Polyline> _polylines() {
    if (!widget.showRoute) {
      return const <Polyline>{};
    }

    final polylines = <Polyline>{};
    final pickup = _latLngFromLocation(widget.pickup);
    final destination = _latLngFromLocation(widget.destination);
    final assignedDriver = _latLngFromDriver(widget.assignedDriverLocation);

    if (pickup != null && destination != null) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('ride_route'),
          points: [pickup, destination],
          color: AppColors.primaryDark,
          width: 5,
        ),
      );
    }

    if (assignedDriver != null && pickup != null) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('driver_to_pickup'),
          points: [assignedDriver, pickup],
          color: AppColors.success,
          width: 4,
          patterns: [PatternItem.dash(24), PatternItem.gap(12)],
        ),
      );
    }

    return polylines;
  }

  List<LatLng> _visiblePoints(Set<Marker> markers) {
    return markers.map((marker) => marker.position).toList();
  }

  Future<void> _fitCameraToVisiblePoints() async {
    final controller = _controller;
    if (controller == null || !mounted) {
      return;
    }
    final points = _visiblePoints(_markers());
    if (points.isEmpty) {
      return;
    }

    final cameraKey = points
        .map(
          (point) =>
              '${point.latitude.toStringAsFixed(5)},${point.longitude.toStringAsFixed(5)}',
        )
        .join('|');
    if (cameraKey == _lastCameraKey) {
      return;
    }
    _lastCameraKey = cameraKey;

    await Future<void>.delayed(const Duration(milliseconds: 120));
    if (!mounted) {
      return;
    }

    try {
      if (points.length == 1) {
        await controller.animateCamera(
          CameraUpdate.newLatLngZoom(points.first, 14),
        );
        return;
      }
      await controller.animateCamera(
        CameraUpdate.newLatLngBounds(_boundsFor(points), 64),
      );
    } catch (_) {
      // The map can reject bounds before it has measured itself; the next
      // rebuild/update will retry with the same points.
      _lastCameraKey = '';
    }
  }

  LatLngBounds _boundsFor(List<LatLng> points) {
    var south = points.first.latitude;
    var north = points.first.latitude;
    var west = points.first.longitude;
    var east = points.first.longitude;

    for (final point in points.skip(1)) {
      south = math.min(south, point.latitude);
      north = math.max(north, point.latitude);
      west = math.min(west, point.longitude);
      east = math.max(east, point.longitude);
    }

    return LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );
  }

  LatLng? _latLngFromLocation(AppLocation? location) {
    if (location?.hasCoordinates != true) {
      return null;
    }
    return LatLng(location!.latitude!, location.longitude!);
  }

  LatLng? _latLngFromDriver(DriverLocation? location) {
    if (location == null) {
      return null;
    }
    return LatLng(location.latitude, location.longitude);
  }

  LatLng get _defaultTarget {
    final fallback = defaultPassengerLocation;
    return LatLng(fallback.latitude!, fallback.longitude!);
  }

  void _openExpandedMap() {
    final customHandler = widget.onExpandPressed;
    if (customHandler != null) {
      customHandler();
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LiveMapPage(
          currentLocation: widget.currentLocation,
          pickup: widget.pickup,
          destination: widget.destination,
          pinnedLocation: widget.pinnedLocation,
          driverLocations: widget.driverLocations,
          assignedDriverLocation: widget.assignedDriverLocation,
          permissionStatus: widget.permissionStatus,
          isLoading: widget.isLoading,
          errorMessage: widget.errorMessage,
          showDriverEmptyState: widget.showDriverEmptyState,
          showRoute: widget.showRoute,
          myLocationEnabled: widget.myLocationEnabled,
          onTap: widget.onTap,
          onCurrentLocationPressed: widget.onCurrentLocationPressed,
        ),
      ),
    );
  }
}

class LiveMapPage extends StatelessWidget {
  const LiveMapPage({
    super.key,
    this.currentLocation,
    this.pickup,
    this.destination,
    this.pinnedLocation,
    this.driverLocations = const [],
    this.assignedDriverLocation,
    this.permissionStatus = 'unknown',
    this.isLoading = false,
    this.errorMessage,
    this.showDriverEmptyState = false,
    this.showRoute = true,
    this.myLocationEnabled = false,
    this.onTap,
    this.onCurrentLocationPressed,
    this.title = 'Live map',
  });

  final AppLocation? currentLocation;
  final AppLocation? pickup;
  final AppLocation? destination;
  final AppLocation? pinnedLocation;
  final List<DriverLocation> driverLocations;
  final DriverLocation? assignedDriverLocation;
  final String permissionStatus;
  final bool isLoading;
  final String? errorMessage;
  final bool showDriverEmptyState;
  final bool showRoute;
  final bool myLocationEnabled;
  final ValueChanged<LatLng>? onTap;
  final VoidCallback? onCurrentLocationPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: LiveMapView(
          currentLocation: currentLocation,
          pickup: pickup,
          destination: destination,
          pinnedLocation: pinnedLocation,
          driverLocations: driverLocations,
          assignedDriverLocation: assignedDriverLocation,
          permissionStatus: permissionStatus,
          isLoading: isLoading,
          errorMessage: errorMessage,
          showDriverEmptyState: showDriverEmptyState,
          showRoute: showRoute,
          myLocationEnabled: myLocationEnabled,
          onTap: onTap,
          onCurrentLocationPressed: onCurrentLocationPressed,
          showExpandButton: false,
          borderRadius: 0,
        ),
      ),
    );
  }
}

class _MapStatusPill extends StatelessWidget {
  const _MapStatusPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.compact,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _MapNotice extends StatelessWidget {
  const _MapNotice({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapOverlay extends StatelessWidget {
  const _MapOverlay({
    required this.icon,
    required this.message,
    this.isLoading = false,
  });

  final IconData icon;
  final String message;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface.withValues(alpha: 0.86),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                const SizedBox.square(
                  dimension: 28,
                  child: CircularProgressIndicator(strokeWidth: 3),
                )
              else
                Icon(icon, color: AppColors.textSecondary, size: 34),
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
