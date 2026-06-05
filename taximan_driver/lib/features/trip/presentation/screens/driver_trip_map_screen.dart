import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taximan_driver/shared/models/app_location.dart';

import '../../../../core/utils/app_spacing.dart';
import '../../../../shared/models/trip.dart';
import '../../../../core/constants/app_colors.dart';

class DriverTripMapScreen extends StatefulWidget {
  const DriverTripMapScreen({
    super.key,
    this.trip,
  });

  final Trip? trip;

  @override
  State<DriverTripMapScreen> createState() => _DriverTripMapScreenState();
}

class _DriverTripMapScreenState extends State<DriverTripMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Future<Position>? _currentLocationFuture;

  @override
  void initState() {
    super.initState();
    _currentLocationFuture = _determinePosition();
  }

  Future<Position> _determinePosition() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Location services are disabled.');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied.');
    }
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.trip == null ? 'Driver map' : 'Trip map')),
      body: FutureBuilder<Position>(
        future: _currentLocationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Center(
                child: Text(
                  snapshot.error.toString(),
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            );
          }

          final position = snapshot.data!;
          final current = LatLng(position.latitude, position.longitude);
          final markers = <Marker>{
            Marker(
              markerId: const MarkerId('current_location'),
              position: current,
              infoWindow: const InfoWindow(title: 'You'),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            ),
          };
          final polylines = <Polyline>{};
          final tripod = widget.trip;
          if (tripod != null) {
            final pickup = _latLngFromLocation(tripod.pickup);
            final destination = _latLngFromLocation(tripod.destinationLocation);
            if (pickup != null) {
              markers.add(
                Marker(
                  markerId: const MarkerId('pickup'),
                  position: pickup,
                  infoWindow: InfoWindow(title: 'Pickup', snippet: tripod.pickup.address),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                ),
              );
            }
            if (destination != null) {
              markers.add(
                Marker(
                  markerId: const MarkerId('destination'),
                  position: destination,
                  infoWindow: InfoWindow(title: 'Destination', snippet: tripod.destinationLocation.address),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                ),
              );
            }
            if (pickup != null && destination != null) {
              polylines.add(
                Polyline(
                  polylineId: const PolylineId('trip_route'),
                  points: [pickup, destination],
                  color: AppColors.primaryDark,
                  width: 5,
                ),
              );
            }
          }

          final initialCamera = CameraPosition(target: current, zoom: 14);
          return Column(
            children: [
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: initialCamera,
                  markers: markers,
                  polylines: polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  onMapCreated: (controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (tripod != null) ...[
                      Text('Trip status: ${tripod.status}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.sm),
                      Text('Pickup: ${tripod.pickup.address}'),
                      const SizedBox(height: AppSpacing.xs),
                      Text('Destination: ${tripod.destinationLocation.address}'),
                      const SizedBox(height: AppSpacing.xs),
                      Text('Passenger: ${tripod.passengerName}'),
                      const SizedBox(height: AppSpacing.sm),
                    ],
                    Text('Current location: ${current.latitude.toStringAsFixed(5)}, ${current.longitude.toStringAsFixed(5)}'),
                    const SizedBox(height: AppSpacing.md),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  LatLng? _latLngFromLocation(AppLocation location) {
    if (location.latitude == null || location.longitude == null) {
      return null;
    }
    return LatLng(location.latitude!, location.longitude!);
  }
}
